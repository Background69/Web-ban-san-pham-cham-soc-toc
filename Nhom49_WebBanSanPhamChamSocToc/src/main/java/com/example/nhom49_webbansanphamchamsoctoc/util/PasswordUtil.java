package com.example.nhom49_webbansanphamchamsoctoc.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class để hash và verify password
 * Sử dụng BCrypt để bảo mật
 */
public class PasswordUtil {

    // BCrypt work factor (cost) - càng cao càng an toàn nhưng chậm hơn
    private static final int BCRYPT_ROUNDS = 12;

    /**
     * Hash password với BCrypt
     *
     * @param password Password cần hash
     * @return Chuỗi hash BCrypt
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt(BCRYPT_ROUNDS));
    }

    /**
     * Verify password với stored hash
     *
     * @param password   Password cần verify
     * @param storedHash Hash đã lưu (BCrypt format)
     * @return true nếu password khớp, false nếu không
     */
    public static boolean verifyPassword(String password, String storedHash) {
        if (password == null || storedHash == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(password, storedHash);
        } catch (IllegalArgumentException e) {
            // Invalid hash format
            return false;
        }
    }

    /**
     * Kiểm tra độ mạnh của password
     * Password phải có ít nhất 6 ký tự
     *
     * @param password Password cần kiểm tra
     * @return true nếu password đủ mạnh
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    /**
     * Kiểm tra password có đủ mạnh không (nâng cao)
     * - Ít nhất 8 ký tự
     * - Có chữ hoa
     * - Có chữ thường
     * - Có số
     *
     * @param password Password cần kiểm tra
     * @return true nếu password đủ mạnh
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpper = true;
            if (Character.isLowerCase(c)) hasLower = true;
            if (Character.isDigit(c)) hasDigit = true;
        }

        return hasUpper && hasLower && hasDigit;
    }

    /**
     * Tạo password ngẫu nhiên
     *
     * @param length Độ dài password
     * @return Password ngẫu nhiên
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";
        StringBuilder sb = new StringBuilder();
        java.security.SecureRandom random = new java.security.SecureRandom();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
