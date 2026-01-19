package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.GoogleOAuthService;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

/**
 * Servlet xử lý Google OAuth2 authentication
 * URL patterns: /auth/google, /auth/google/callback, /google/login/, /google/callback
 */
@WebServlet(name = "GoogleOAuthServlet", urlPatterns = {
        "/auth/google", "/auth/google/callback",
        "/google/login/", "/google/callback"
})
public class GoogleOAuthController extends HttpServlet {

    private GoogleOAuthService googleOAuthService;
    private UserService userService;
    private boolean oauthEnabled = true;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.googleOAuthService = new GoogleOAuthService();
            this.userService = new UserService();
        } catch (RuntimeException e) {
            // Google OAuth chưa được cấu hình
            this.oauthEnabled = false;
            log("Google OAuth bị vô hiệu hóa: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (requestURI.endsWith("/auth/google/callback") || requestURI.endsWith("/google/callback")) {
            handleCallback(request, response);
        } else if (requestURI.endsWith("/auth/google") || requestURI.endsWith("/google/login/")) {
            initiateOAuth(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Khởi tạo luồng Google OAuth
     * GET /auth/google
     */
    private void initiateOAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String contextPath = request.getContextPath();

        // Kiểm tra OAuth đã được cấu hình chưa
        if (!oauthEnabled) {
            response.sendRedirect(contextPath + "/login?error=oauth_not_configured");
            return;
        }

        HttpSession session = request.getSession();

        // Tạo state parameter để chống CSRF
        String state = UUID.randomUUID().toString();
        session.setAttribute("oauth_state", state);

        // Lưu redirect URL nếu có
        String redirectAfterLogin = request.getParameter("redirect");
        if (redirectAfterLogin != null && !redirectAfterLogin.isEmpty()) {
            session.setAttribute("redirect_after_login", redirectAfterLogin);
        }

        // Redirect đến Google OAuth
        String authUrl = googleOAuthService.getAuthorizationUrl(state);
        response.sendRedirect(authUrl);
    }

    /**
     * Xử lý callback từ Google
     * GET /auth/google/callback
     */
    private void handleCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String contextPath = request.getContextPath();

        // Kiểm tra OAuth đã được cấu hình chưa
        if (!oauthEnabled) {
            response.sendRedirect(contextPath + "/login?error=oauth_not_configured");
            return;
        }

        // Kiểm tra state parameter (CSRF protection)
        String state = request.getParameter("state");
        String sessionState = (String) session.getAttribute("oauth_state");

        if (state == null || !state.equals(sessionState)) {
            log("State mismatch: expected=" + sessionState + ", got=" + state);
            response.sendRedirect(contextPath + "/login?error=invalid_state");
            return;
        }

        // Xóa state khỏi session
        session.removeAttribute("oauth_state");

        // Kiểm tra có error từ Google không
        String error = request.getParameter("error");
        if (error != null) {
            log("Google OAuth error: " + error);
            response.sendRedirect(contextPath + "/login?error=oauth_" + error);
            return;
        }

        // Lấy authorization code
        String authorizationCode = request.getParameter("code");
        if (authorizationCode == null || authorizationCode.isEmpty()) {
            response.sendRedirect(contextPath + "/login?error=no_code");
            return;
        }

        try {
            // Lấy thông tin user từ Google
            GoogleOAuthService.GoogleUserInfo googleUser =
                    googleOAuthService.handleCallback(authorizationCode);

            // Tìm user theo Google ID hoặc email
            User user = userService.findByGoogleId(googleUser.getGoogleId());
            if (user == null) {
                user = userService.getUserByEmail(googleUser.getEmail());
            }

            if (user != null && user.isActive()) {
                // Đăng nhập thành công
                userService.setCurrentUser(session, user);

                // Redirect đến trang được yêu cầu hoặc trang chủ
                String redirectUrl = (String) session.getAttribute("redirect_after_login");
                session.removeAttribute("redirect_after_login");

                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    response.sendRedirect(contextPath + redirectUrl);
                } else {
                    response.sendRedirect(contextPath + "/");
                }
                return;
            }

            // User chưa tồn tại: lưu thông tin vào session để hoàn tất hồ sơ
            session.setAttribute("google_email", googleUser.getEmail());
            session.setAttribute("google_id", googleUser.getGoogleId());
            session.setAttribute("google_name", googleUser.getName());
            response.sendRedirect(contextPath + "/complete-profile");

        } catch (Exception e) {
            log("Google OAuth processing error: " + e.getMessage(), e);
            response.sendRedirect(contextPath + "/login?error=oauth_processing_failed");
        }
    }
}
