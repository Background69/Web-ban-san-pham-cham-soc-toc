package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String email;
    private String username;
    private String password;
    private String phone;
    private String avatar;
    private String role; // 'Admin' or 'Khach hang'
    private boolean isActive;
    private String authProvider; // LOCAL, GOOGLE
    private String resetToken;
    private Timestamp resetTokenExpiry;
    private Timestamp createdAt;
    private String googleId; // Google OAuth ID

    public User() {
    }

    public User(int userId, String email, String username, String password, String phone,
                String avatar, String role, boolean isActive, Timestamp createdAt) {
        this.userId = userId;
        this.email = email;
        this.username = username;
        this.password = password;
        this.phone = phone;
        this.avatar = avatar;
        this.role = role;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(String authProvider) {
        this.authProvider = authProvider;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Timestamp getResetTokenExpiry() {
        return resetTokenExpiry;
    }

    public void setResetTokenExpiry(Timestamp resetTokenExpiry) {
        this.resetTokenExpiry = resetTokenExpiry;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public boolean isAdmin() {
        return "Admin".equals(this.role);
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", email='" + email + '\'' +
                ", username='" + username + '\'' +
                ", phone='" + phone + '\'' +
                ", avatar='" + avatar + '\'' +
                ", role='" + role + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                ", googleId='" + googleId + '\'' +
                '}';
    }
}