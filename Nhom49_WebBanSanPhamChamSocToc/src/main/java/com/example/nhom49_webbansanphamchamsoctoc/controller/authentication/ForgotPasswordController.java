package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.EmailService;
import com.example.nhom49_webbansanphamchamsoctoc.util.TokenUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/auth/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    private static final int RESET_TOKEN_EXPIRY_MINUTES = 30;

    private final UserDAO userDAO = new UserDAO();
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        emailService = new EmailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/authentication/forgot-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");

        String commonMsg = "Nếu email tồn tại trong hệ thống, chúng tôi đã gửi link đặt lại mật khẩu.";

        User user = userDAO.findByEmail(email);
        if (user == null) {
            request.setAttribute("message", commonMsg);
            request.getRequestDispatcher("/authentication/forgot-password.jsp")
                    .forward(request, response);
            return;
        }

        String rawToken = UUID.randomUUID().toString();
        String tokenHash = TokenUtil.hashToken(rawToken);
        Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(RESET_TOKEN_EXPIRY_MINUTES));

        userDAO.saveResetToken(user.getUserId(), tokenHash, expiry);

        String resetLink = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort()
                + request.getContextPath()
                + "/reset-password?token=" + rawToken;

        boolean sent = emailService.sendPasswordResetEmail(email, resetLink);

        if (sent) {
            request.setAttribute("message", "Đã gửi link đặt lại mật khẩu. Vui lòng kiểm tra Email.");
        } else {
            request.setAttribute("error", "Không gửi được email. Kiểm tra cấu hình Gmail App Password / log Tomcat.");
        }

        request.getRequestDispatcher("/authentication/forgot-password.jsp")
                .forward(request, response);
    }
}
