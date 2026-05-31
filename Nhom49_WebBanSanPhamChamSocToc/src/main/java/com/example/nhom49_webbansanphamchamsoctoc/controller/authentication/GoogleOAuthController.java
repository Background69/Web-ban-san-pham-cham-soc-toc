package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.AuthenticationService;
import com.example.nhom49_webbansanphamchamsoctoc.services.GoogleOAuthService;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserService;

import com.example.nhom49_webbansanphamchamsoctoc.util.RedirectUtil;
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
    private AuthenticationService authService;
    private boolean oauthEnabled = true;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.googleOAuthService = new GoogleOAuthService();
            this.userService = new UserService();
            this.authService = new AuthenticationService();
        } catch (RuntimeException e) {
            this.oauthEnabled = false;
            log("Google OAuth disabled: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestURI = request.getRequestURI();

        if (requestURI.endsWith("/auth/google/callback") || requestURI.endsWith("/google/callback")) {
            handleCallback(request, response);
        } else if (requestURI.endsWith("/auth/google") || requestURI.endsWith("/google/login/")) {
            initiateOAuth(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void initiateOAuth(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String contextPath = request.getContextPath();
        if (!oauthEnabled) {
            response.sendRedirect(contextPath + "/auth/login?error=oauth_not_configured");
            return;
        }

        HttpSession session = request.getSession();
        String state = UUID.randomUUID().toString();
        session.setAttribute("oauth_state", state);

        String redirectAfterLogin = RedirectUtil.sanitizePath(request.getParameter("redirect"));
        if (redirectAfterLogin != null) {
            session.setAttribute("redirect_after_login", redirectAfterLogin);
        } else {
            session.removeAttribute("redirect_after_login");
        }

        String authUrl = googleOAuthService.getAuthorizationUrl(state);
        response.sendRedirect(authUrl);
    }

    private void handleCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        String contextPath = request.getContextPath();

        if (!oauthEnabled) {
            response.sendRedirect(contextPath + "/auth/login?error=oauth_not_configured");
            return;
        }

        String state = request.getParameter("state");
        String sessionState = (String) session.getAttribute("oauth_state");

        if (state == null || !state.equals(sessionState)) {
            log("State mismatch: expected=" + sessionState + ", got=" + state);
            response.sendRedirect(contextPath + "/auth/login?error=invalid_state");
            return;
        }

        session.removeAttribute("oauth_state");

        String error = request.getParameter("error");
        if (error != null) {
            log("Google OAuth error: " + error);
            response.sendRedirect(contextPath + "/auth/login?error=oauth_" + error);
            return;
        }

        String authorizationCode = request.getParameter("code");
        if (authorizationCode == null || authorizationCode.isEmpty()) {
            response.sendRedirect(contextPath + "/auth/login?error=no_code");
            return;
        }

        try {
            GoogleOAuthService.GoogleUserInfo googleUser =
                    googleOAuthService.handleCallback(authorizationCode);

            // Tìm hoặc tạo user mới từ thông tin Google
            User user = userService.findOrCreateGoogleUser(googleUser);

            if (user == null) {
                log("Không thể tạo user từ Google OAuth");
                response.sendRedirect(contextPath + "/auth/login?error=oauth_user_creation_failed");
                return;
            }

            if (!user.isActive()) {
                response.sendRedirect(contextPath + "/auth/login?error=account_inactive");
                return;
            }

            // Đăng nhập thành công
            authService.setCurrentUser(session, user);

            String redirectUrl = (String) session.getAttribute("redirect_after_login");
            session.removeAttribute("redirect_after_login");

            response.sendRedirect(
                    RedirectUtil.buildRedirectUrl(request, redirectUrl, "/")
            );

        } catch (Exception e) {
            log("Google OAuth processing error: " + e.getMessage(), e);
            response.sendRedirect(contextPath + "/auth/login?error=oauth_processing_failed");
        }
    }
}