package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/checkout");
            return;
        }

        String orderId   = request.getParameter("orderId");
        String amountStr = request.getParameter("amount");
        String orderCode = request.getParameter("orderCode");

        if (orderId == null || amountStr == null || orderCode == null) {
            SessionUtil.setErrorMessage(session, "Thiếu thông tin đơn hàng để thanh toán VNPAY.");
            response.sendRedirect(request.getContextPath() + "/profile/orders");
            return;
        }

        long amount;
        try {
            amount = Long.parseLong(amountStr);
        } catch (NumberFormatException e) {
            SessionUtil.setErrorMessage(session, "Số tiền thanh toán không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/orders/" + orderId);
            return;
        }

        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        String baseUrl = scheme + "://" + serverName;
        if (("http".equals(scheme) && serverPort != 80) ||
                ("https".equals(scheme) && serverPort != 443)) {
            baseUrl += ":" + serverPort;
        }
        baseUrl += contextPath;

        String vnp_ReturnUrl = VNPAYConfig.getReturnUrl(baseUrl);

        Map<String, String> vnp_Params = new TreeMap<>();

        vnp_Params.put("vnp_Version",    VNPAYConfig.vnp_Version);
        vnp_Params.put("vnp_Command",    VNPAYConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode",    VNPAYConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount",     String.valueOf(amount * 100)); // VNPAY yêu cầu nhân 100
        vnp_Params.put("vnp_CurrCode",   "VND");
        vnp_Params.put("vnp_TxnRef",     orderCode); // Mã tham chiếu giao dịch (unique)
        vnp_Params.put("vnp_OrderInfo",  "Thanh toan don hang " + orderCode);
        vnp_Params.put("vnp_OrderType",  VNPAYConfig.vnp_OrderType);
        vnp_Params.put("vnp_Locale",     "vn");
        vnp_Params.put("vnp_ReturnUrl",  vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr",     getIpAddress(request));

        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cal.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cal.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cal.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        String hashData = VNPAYConfig.hashAllFields(vnp_Params);
        String vnp_SecureHash = VNPAYConfig.hmacSHA512(VNPAYConfig.secretKey, hashData);

        StringBuilder paymentUrl = new StringBuilder(VNPAYConfig.vnp_PayUrl);
        paymentUrl.append('?');
        paymentUrl.append(hashData);
        paymentUrl.append("&vnp_SecureHash=").append(vnp_SecureHash);

        response.sendRedirect(paymentUrl.toString());
    }

    /**
     * Lấy IP address của client, hỗ trợ proxy.
     */
    private String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // Nếu có nhiều IP (qua proxy), lấy IP đầu tiên
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip != null ? ip : "127.0.0.1";
    }
}
