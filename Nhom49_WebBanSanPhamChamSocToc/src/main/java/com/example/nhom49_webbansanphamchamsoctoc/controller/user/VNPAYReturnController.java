package com.example.nhom49_webbansanphamchamsoctoc.controller.user;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
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
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
@WebServlet(name = "VNPAYReturnController", value = "/vnpay/return")
public class VNPAYReturnController extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        Map<String, String> vnp_Params = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if (paramValue != null && !paramValue.isEmpty()) {
                vnp_Params.put(paramName, paramValue);
            }
        }

        String vnp_SecureHash = vnp_Params.remove("vnp_SecureHash");
        vnp_Params.remove("vnp_SecureHashType");

        String hashData = VNPAYConfig.hashAllFields(vnp_Params);
        String calculatedHash = VNPAYConfig.hmacSHA512(VNPAYConfig.secretKey, hashData);

        String vnp_TxnRef = vnp_Params.get("vnp_TxnRef");        // orderCode
        String vnp_ResponseCode = vnp_Params.get("vnp_ResponseCode");
        String vnp_TransactionStatus = vnp_Params.get("vnp_TransactionStatus");

        Order order = null;
        if (vnp_TxnRef != null) {
            order = orderService.getOrderByCode(vnp_TxnRef);
        }

        if (order == null) {
            SessionUtil.setErrorMessage(session, "Không tìm thấy đơn hàng liên quan đến giao dịch VNPAY.");
            response.sendRedirect(request.getContextPath() + "/profile/orders");
            return;
        }

        int orderId = order.getOrderId();

        if (calculatedHash != null && calculatedHash.equalsIgnoreCase(vnp_SecureHash)) {
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                if ("pending_payment".equals(order.getOrderStatus())) {
                    orderService.updateOrderStatus(orderId, "pending");
                }
                SessionUtil.setSuccessMessage(session,
                        "Thanh toán VNPAY thành công! Đơn hàng " + vnp_TxnRef + " đang được xử lý.");
            } else {
                String errorMsg = mapVnpayErrorCode(vnp_ResponseCode);
                SessionUtil.setErrorMessage(session,
                        "Thanh toán VNPAY không thành công: " + errorMsg +
                                ". Bạn có thể thử thanh toán lại hoặc hủy đơn hàng.");
            }
        } else {
            SessionUtil.setErrorMessage(session,
                    "Dữ liệu thanh toán không hợp lệ (chữ ký không khớp). Vui lòng liên hệ hỗ trợ.");
        }

        response.sendRedirect(request.getContextPath() + "/orders/" + orderId);
    }

    /**
     * Dịch mã lỗi VNPAY sang thông báo tiếng Việt.
     */
    private String mapVnpayErrorCode(String code) {
        if (code == null) return "Lỗi không xác định";
        switch (code) {
            case "07": return "Giao dịch bị nghi ngờ gian lận";
            case "09": return "Thẻ/Tài khoản chưa đăng ký InternetBanking";
            case "10": return "Xác thực không đúng quá 3 lần";
            case "11": return "Đã hết hạn chờ thanh toán";
            case "12": return "Thẻ/Tài khoản bị khóa";
            case "13": return "Sai mật khẩu OTP";
            case "24": return "Khách hàng đã hủy giao dịch";
            case "51": return "Tài khoản không đủ số dư";
            case "65": return "Vượt quá hạn mức giao dịch trong ngày";
            case "75": return "Ngân hàng thanh toán đang bảo trì";
            case "79": return "Nhập sai mật khẩu thanh toán quá số lần";
            case "99": return "Lỗi hệ thống. Vui lòng thử lại sau";
            default:   return "Mã lỗi: " + code;
        }
    }
}
