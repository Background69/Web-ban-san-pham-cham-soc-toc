package com.example.nhom49_webbansanphamchamsoctoc.util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Filter để đảm bảo encoding UTF-8 cho tất cả requests và responses
 * Hỗ trợ hiển thị tiếng Việt đúng cách
 */
@WebFilter(filterName = "CharacterEncodingFilter", urlPatterns = {"/*"})
public class CharacterEncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String configEncoding = filterConfig.getInitParameter("encoding");
        if (configEncoding != null && !configEncoding.isEmpty()) {
            this.encoding = configEncoding;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);

        // Chỉ set content-type cho các request không phải static resources
        if (request instanceof HttpServletRequest) {
            String uri = ((HttpServletRequest) request).getRequestURI();
            if (!isStaticResource(uri)) {
                response.setContentType("text/html; charset=" + encoding);
            }
        }

        chain.doFilter(request, response);
    }

    /**
     * Kiểm tra xem URI có phải là static resource không
     */
    private boolean isStaticResource(String uri) {
        if (uri == null) return false;
        return uri.endsWith(".css") ||
               uri.endsWith(".js") ||
               uri.endsWith(".png") ||
               uri.endsWith(".jpg") ||
               uri.endsWith(".jpeg") ||
               uri.endsWith(".gif") ||
               uri.endsWith(".svg") ||
               uri.endsWith(".ico") ||
               uri.endsWith(".woff") ||
               uri.endsWith(".woff2") ||
               uri.endsWith(".ttf") ||
               uri.endsWith(".eot") ||
               uri.contains("/static/");
    }

    @Override
    public void destroy() {
        // Không cần cleanup
    }
}
