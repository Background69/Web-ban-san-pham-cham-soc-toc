package com.example.nhom49_webbansanphamchamsoctoc.util;

import jakarta.servlet.http.HttpServletRequest;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;

public class RedirectUtil {
    private static final Pattern SCHEME_PATTERN = Pattern.compile("^[a-zA-Z][a-zA-Z0-9+.-]:");

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
