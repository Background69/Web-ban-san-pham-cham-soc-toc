package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.VNPAYConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "VNPAYCreatePaymentController", value = "/vnpay/create-payment")
public class VNPAYCreatePaymentController extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/checkout");
            return;
        }

        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null) {
            SessionUtil.setErrorMessage(session, "Thiếu thông tin đơn hàng để thanh toán VNPAY.");
            response.sendRedirect(request.getContextPath() + "/profile/orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            SessionUtil.setErrorMessage(session, "Mã đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/profile/orders");
            return;
        }

        // Lấy order từ DB để đảm bảo amount chính xác (chống tamper qua URL)
        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUserId().equals(user.getUserId())) {
            SessionUtil.setErrorMessage(session, "Đơn hàng không tồn tại hoặc không thuộc về bạn.");
            response.sendRedirect(request.getContextPath() + "/profile/orders");
            return;
        }

        if (!"pending_payment".equalsIgnoreCase(order.getOrderStatus())) {
            SessionUtil.setErrorMessage(session, "Đơn hàng không ở trạng thái chờ thanh toán.");
            response.sendRedirect(request.getContextPath() + "/orders/" + orderId);
            return;
        }

        long amount = order.getTotalAmount().longValue();
        String orderCode = order.getOrderCode();

        String requestBaseUrl = buildBaseUrl(request);
        String vnp_ReturnUrl = VNPAYConfig.getReturnUrl(requestBaseUrl);

        Map<String, String> vnp_Params = new TreeMap<>();

        vnp_Params.put("vnp_Version",    VNPAYConfig.vnp_Version);
        vnp_Params.put("vnp_Command",    VNPAYConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode",    VNPAYConfig.getTmnCode());
        vnp_Params.put("vnp_Amount",     String.valueOf(amount * 100)); // VNPAY yêu cầu nhân 100
        vnp_Params.put("vnp_CurrCode",   "VND");
        vnp_Params.put("vnp_TxnRef",     orderCode); // Mã tham chiếu giao dịch (unique)
        vnp_Params.put("vnp_OrderInfo",  "Thanh toan don hang " + orderCode);
        vnp_Params.put("vnp_OrderType",  VNPAYConfig.vnp_OrderType);
        vnp_Params.put("vnp_Locale",     "vn");
        vnp_Params.put("vnp_ReturnUrl",  vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr",     getClientIpAddress(request));

        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cal.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cal.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cal.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        String hashData = VNPAYConfig.hashAllFields(vnp_Params);
        String vnp_SecureHash = VNPAYConfig.hmacSHA512(VNPAYConfig.getSecretKey(), hashData);

        StringBuilder paymentUrl = new StringBuilder(VNPAYConfig.getPayUrl());
        paymentUrl.append('?');
        paymentUrl.append(hashData);
        paymentUrl.append("&vnp_SecureHash=").append(vnp_SecureHash);

        response.sendRedirect(paymentUrl.toString());
    }

    /**
     * Build base URL từ request
     * Khi chạy qua Docker + Nginx, request trực tiếp sẽ có scheme=http, host=container_name.
     * Headers X-Forwarded-* chứa thông tin đúng từ client
     */
    private String buildBaseUrl(HttpServletRequest request) {
        String scheme = request.getHeader("X-Forwarded-Proto");
        if (scheme == null || scheme.isBlank()) {
            scheme = request.getScheme();
        }

        String host = request.getHeader("X-Forwarded-Host");
        if (host == null || host.isBlank()) {
            host = request.getHeader("Host");
        }
        if (host == null || host.isBlank()) {
            host = request.getServerName();
            int port = request.getServerPort();
            if (("http".equals(scheme) && port != 80) ||
                    ("https".equals(scheme) && port != 443)) {
                host += ":" + port;
            }
        }

        return scheme + "://" + host + request.getContextPath();
    }

    /**
     * Lấy IP thực của client, chuẩn cho Docker + Nginx reverse proxy.
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");

        if (isBlankOrUnknown(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (isBlankOrUnknown(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (isBlankOrUnknown(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (isBlankOrUnknown(ip)) {
            ip = request.getRemoteAddr();
        }
        // Lấy IP đầu tiên = IP thực của client
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
            ip = "127.0.0.1";
        }
        return (ip != null && !ip.isBlank()) ? ip : "127.0.0.1";
    }

    private boolean isBlankOrUnknown(String value) {
        return value == null || value.isBlank() || "unknown".equalsIgnoreCase(value);
    }
}
