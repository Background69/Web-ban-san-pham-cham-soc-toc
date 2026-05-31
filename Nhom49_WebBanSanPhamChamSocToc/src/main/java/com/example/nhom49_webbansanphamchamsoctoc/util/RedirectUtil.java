package com.example.nhom49_webbansanphamchamsoctoc.util;

import jakarta.servlet.http.HttpServletRequest;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;

public class RedirectUtil {
    private static final Pattern SCHEME_PATTERN = Pattern.compile("^[a-zA-Z][a-zA-Z0-9+.-]:");

    /**
     * Validates and normalizes an internal redirect path.
     *
     * <p>Only application-relative paths starting with {@code /} are allowed.
     * External URLs, protocol-relative URLs, URL schemes, and newline characters
     * are rejected to prevent open redirect attacks.</p>
     *
     * @param redirect the redirect path to validate
     * @return the sanitized redirect path if valid; otherwise {@code null}
     */
    public static String sanitizePath(String redirect) {
        if (redirect == null) return null;

        String decoded;
        try {
            decoded = URLDecoder.decode(redirect, StandardCharsets.UTF_8).trim();
        } catch (Exception e) {
            decoded = redirect.trim();
        }

        if (decoded.isEmpty()) return null;
        if (decoded.contains("\n") || decoded.contains("\r")) return null;
        if (decoded.startsWith("//")) return null;
        if (decoded.contains("://")) return null;
        if (SCHEME_PATTERN.matcher(decoded).find()) return null;
        if (!decoded.startsWith("/")) return null;

        return decoded;
    }


    /**
     * Builds a safe redirect URL using the current application context path.
     *
     * <p>The provided redirect value is sanitized before use. Only internal paths
     * are allowed. If the redirect value is invalid, the method falls back to the
     * provided default target. If the default target is also invalid, it falls back
     * to the application root.</p>
     *
     * @param req the current HTTP request, used to get the context path
     * @param redirect the requested redirect path
     * @param defaultTarget the fallback internal path when redirect is invalid
     * @return a safe redirect URL within the current application context
     */
    public static String buildRedirectUrl(HttpServletRequest req, String redirect, String defaultTarget) {
        String contextPath = req.getContextPath();

        String sanitizedRedirect = sanitizePath(redirect);
        if (sanitizedRedirect != null) {
            if (sanitizedRedirect.startsWith(contextPath + "/") || sanitizedRedirect.equals(contextPath)) {
                return sanitizedRedirect;
            }

            return contextPath + sanitizedRedirect;
        }

        String sanitizedDefault = sanitizePath(defaultTarget);
        if (sanitizedDefault != null) {
            if (sanitizedDefault.startsWith(contextPath + "/") || sanitizedDefault.equals(contextPath)) {
                return sanitizedDefault;
            }

            return contextPath + sanitizedDefault;
        }

        return contextPath + "/";
    }
}
