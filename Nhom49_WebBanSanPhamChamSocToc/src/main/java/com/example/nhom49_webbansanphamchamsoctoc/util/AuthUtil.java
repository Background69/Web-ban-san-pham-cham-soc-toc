package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class AuthUtil {

    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("currentUser");
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }
}
