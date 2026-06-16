package com.example.nhom49_webbansanphamchamsoctoc.util;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Set;
import java.util.logging.Logger;

/**
 * CSRF Token Filter — Bảo vệ chống Cross-Site Request Forgery.
 * Với mọi request: sinh CSRF token nếu chưa có, đặt vào session + request attribute {@code _csrf}
 * Với POST/PUT/DELETE: kiểm tra {@code _csrf} parameter hoặc header phải khớp token trong session
 * Nếu không khớp: trả 403 Forbidden hoặc log warning
 */
@WebFilter(filterName = "CsrfTokenFilter", urlPatterns = "/*")
public class CsrfTokenFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(CsrfTokenFilter.class.getName());

    /** Key lưu token trong session */
    private static final String CSRF_SESSION_KEY = "_csrf_token";

    /** Key đặt token vào request attribute (cho JSP EL: ${_csrf}) */
    private static final String CSRF_REQUEST_ATTR = "_csrf";

    /** Parameter name trong form */
    private static final String CSRF_PARAM = "_csrf";

    /** Header name cho AJAX */
    private static final String CSRF_HEADER = "X-CSRF-TOKEN";

    /** Độ dài token (bytes) — 32 bytes = 256 bit entropy */
    private static final int TOKEN_BYTE_LENGTH = 32;

    /**
     * Chế độ hoạt động:
     * - true  = ENFORCE: block request thiếu/sai token (403)
     * - false = LOG_ONLY: chỉ log warning, không block
     */
    private static final boolean ENFORCE_MODE = true;

    /** Các path được miễn kiểm tra CSRF (callback bên ngoài, API, etc.) */
    private static final Set<String> EXEMPT_PATH_PREFIXES = Set.of(
            "/api/",
            "/vnpay/",
            "/auth/google/",
            "/support/feedback"
    );

    private final SecureRandom secureRandom = new SecureRandom();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("CsrfTokenFilter initialized — mode: " + (ENFORCE_MODE ? "ENFORCE" : "LOG_ONLY"));
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        // Luôn đảm bảo token tồn tại trong session và request attribute
        String token = ensureToken(request);
        request.setAttribute(CSRF_REQUEST_ATTR, token);
        request.setAttribute("csrfToken", token);

        // Chỉ kiểm tra với mutation methods
        String method = request.getMethod().toUpperCase();
        if ("POST".equals(method) || "PUT".equals(method) || "DELETE".equals(method)) {
            if (!isExemptPath(request)) {
                if (!isValidToken(request, token)) {
                    String path = request.getRequestURI();
                    if (ENFORCE_MODE) {
                        LOGGER.warning("CSRF token invalid — BLOCKED: " + method + " " + path
                                + " | IP: " + request.getRemoteAddr());
                        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                                "Yêu cầu không hợp lệ. Vui lòng thử lại.");
                        return;
                    } else {
                        LOGGER.warning("CSRF token missing/invalid — LOG_ONLY: " + method + " " + path
                                + " | IP: " + request.getRemoteAddr());
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No-op
    }

    /**
     * Đảm bảo session có CSRF token. Nếu chưa có thì sinh mới.
     */
    private String ensureToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(CSRF_SESSION_KEY);
        if (token == null || token.isEmpty()) {
            token = generateToken();
            session.setAttribute(CSRF_SESSION_KEY, token);
        }
        return token;
    }

    /**
     * Sinh token ngẫu nhiên mạnh.
     */
    private String generateToken() {
        byte[] bytes = new byte[TOKEN_BYTE_LENGTH];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /**
     * Kiểm tra token từ request (param hoặc header) khớp với token trong session.
     */
    private boolean isValidToken(HttpServletRequest request, String expectedToken) {
        if (expectedToken == null) return false;

        // Kiểm tra parameter trước (form submit)
        String paramToken = request.getParameter(CSRF_PARAM);
        if (paramToken != null && constantTimeEquals(expectedToken, paramToken)) {
            return true;
        }

        // Kiểm tra header (AJAX)
        String headerToken = request.getHeader(CSRF_HEADER);
        return headerToken != null && constantTimeEquals(expectedToken, headerToken);
    }

    /**
     * So sánh chuỗi theo constant-time để chống timing attack.
     */
    private boolean constantTimeEquals(String a, String b) {
        if (a == null || b == null || a.length() != b.length()) {
            return false;
        }
        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= a.charAt(i) ^ b.charAt(i);
        }
        return result == 0;
    }

    /**
     * Kiểm tra path có nằm trong danh sách miễn kiểm tra CSRF hay không.
     */
    private boolean isExemptPath(HttpServletRequest request) {
        String path = request.getServletPath();
        if (path == null) return false;

        for (String prefix : EXEMPT_PATH_PREFIXES) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }
}
