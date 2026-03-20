package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.time.LocalDateTime;

public class OtpVerification {
    private Integer otpId;
    private User user;
    private String otpCode;

    private OtpType otpType;

    private LocalDateTime otpExpiry;

    private Integer attempts = 0;

    private Boolean isVerified = false;

    private LocalDateTime createdAt = LocalDateTime.now();

    public enum OtpType {
        REGISTER,
        FORGOT_PASSWORD,
    }

    public OtpVerification() {
    }

    public OtpVerification(Integer otpId, User user, String otpCode, OtpType otpType, LocalDateTime otpExpiry, Integer attempts, Boolean isVerified, LocalDateTime createdAt) {
        this.otpId = otpId;
        this.user = user;
        this.otpCode = otpCode;
        this.otpType = otpType;
        this.otpExpiry = otpExpiry;
        this.attempts = attempts;
        this.isVerified = isVerified;
        this.createdAt = createdAt;
    }

    public Integer getOtpId() {
        return otpId;
    }

    public void setOtpId(Integer otpId) {
        this.otpId = otpId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getOtpCode() {
        return otpCode;
    }

    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }

    public OtpType getOtpType() {
        return otpType;
    }

    public void setOtpType(OtpType otpType) {
        this.otpType = otpType;
    }

    public LocalDateTime getOtpExpiry() {
        return otpExpiry;
    }

    public void setOtpExpiry(LocalDateTime otpExpiry) {
        this.otpExpiry = otpExpiry;
    }

    public Integer getAttempts() {
        return attempts;
    }

    public void setAttempts(Integer attempts) {
        this.attempts = attempts;
    }

    public Boolean getVerified() {
        return isVerified;
    }

    public void setVerified(Boolean verified) {
        isVerified = verified;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
