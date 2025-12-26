package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {
    public static User getCurrentUser(HttpSession session) {
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }

    public static void setCurrentUser(HttpSession session, User user) {
        if (session == null || user == null) return;

        // Tạo copy không có password để lưu vào session
        User sessionUser = new User();
        sessionUser.setUserId(user.getUserId());
        sessionUser.setEmail(user.getEmail());
        sessionUser.setUsername(user.getUsername());
        sessionUser.setPhone(user.getPhone());
        sessionUser.setAvatar(user.getAvatar());
        sessionUser.setRole(user.getRole());
        sessionUser.setActive(user.isActive());
        sessionUser.setCreatedAt(user.getCreatedAt());

        session.setAttribute("user", sessionUser);
    }
}
