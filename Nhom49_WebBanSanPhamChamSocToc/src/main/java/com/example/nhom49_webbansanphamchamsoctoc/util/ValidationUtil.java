package com.example.nhom49_webbansanphamchamsoctoc.util;

import java.util.regex.Pattern;

/**
 * Utility class cho validation dữ liệu
 * Tập trung tất cả logic validation vào một nơi
 */
public class ValidationUtil {

    // Regex patterns
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10,11}$");

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9_]{3,50}$");

    // String Validation

    /**
     * Kiểm tra string có null hoặc empty không
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Kiểm tra string không null và không empty
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    /**
     * Sanitize string - loại bỏ khoảng trắng thừa
     */
    public static String sanitize(String str) {
        return str != null ? str.trim() : null;
    }

    /**
     * Validate độ dài string
     */
    public static boolean isValidLength(String str, int minLength, int maxLength) {
        if (str == null) return false;
        int length = str.trim().length();
        return length >= minLength && length <= maxLength;
    }

    //  Email Validation

    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Validate email với message lỗi
     */
    public static String validateEmail(String email) {
        if (isEmpty(email)) {
            return "Email không được để trống";
        }
        if (!isValidEmail(email)) {
            return "Email không hợp lệ";
        }
        return null; // Hợp lệ
    }

    // Phone Validation

    /**
     * Validate số điện thoại (10-11 chữ số)
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Validate phone với message lỗi (optional field)
     */
    public static String validatePhone(String phone) {
        if (isNotEmpty(phone) && !isValidPhone(phone)) {
            return "Số điện thoại không hợp lệ (10-11 chữ số)";
        }
        return null; // Hợp lệ hoặc empty
    }

    // Username Validation

    /**
     * Validate username (3-50 ký tự, chỉ chữ cái, số và _)
     */
    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    /**
     * Validate username với message lỗi
     */
    public static String validateUsername(String username) {
        if (isEmpty(username)) {
            return "Tên đăng nhập không được để trống";
        }
        if (!isValidLength(username, 3, 50)) {
            return "Tên đăng nhập phải từ 3-50 ký tự";
        }
        if (!isValidUsername(username)) {
            return "Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới";
        }
        return null; // Hợp lệ
    }

    // Password Validation

    /**
     * Validate password (ít nhất 6 ký tự)
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6 && password.length() <= 100;
    }

    /**
     * Validate password với message lỗi
     */
    public static String validatePassword(String password) {
        if (isEmpty(password)) {
            return "Mật khẩu không được để trống";
        }
        if (password.length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự";
        }
        if (password.length() > 100) {
            return "Mật khẩu không được quá 100 ký tự";
        }
        return null; // Hợp lệ
    }

    /**
     * Validate confirm password
     */
    public static String validateConfirmPassword(String password, String confirmPassword) {
        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }
        return null; // Hợp lệ
    }

    // Number Validation

    /**
     * Validate số nguyên dương
     */
    public static boolean isPositiveInteger(Integer number) {
        return number != null && number > 0;
    }

    /**
     * Validate số thực dương
     */
    public static boolean isPositiveDouble(Double number) {
        return number != null && number > 0;
    }

    /**
     * Parse integer an toàn
     */
    public static Integer parseIntSafe(String str) {
        if (isEmpty(str)) return null;
        try {
            return Integer.parseInt(str.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * Parse double an toàn
     */
    public static Double parseDoubleSafe(String str) {
        if (isEmpty(str)) return null;
        try {
            return Double.parseDouble(str.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // Address Validation

    /**
     * Validate địa chỉ giao hàng
     */
    public static String validateShippingAddress(String fullName, String phone, String specificAddress) {
        if (isEmpty(fullName)) {
            return "Họ tên không được để trống";
        }
        if (isEmpty(phone)) {
            return "Số điện thoại không được để trống";
        }
        if (!isValidPhone(phone)) {
            return "Số điện thoại không hợp lệ";
        }
        if (isEmpty(specificAddress)) {
            return "Địa chỉ cụ thể không được để trống";
        }
        return null; // Hợp lệ
    }
}
