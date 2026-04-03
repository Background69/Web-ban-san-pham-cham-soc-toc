package com.example.nhom49_webbansanphamchamsoctoc.util;

import java.util.regex.Pattern;

/**
 * Utility class cho validation dữ liệu
 * Tập trung tất cả logic validation vào một nơi
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10,11}$");
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9_]{3,50}$");
    private static final Pattern FULLNAME_PATTERN = Pattern.compile("^[\\p{L} ]{2,100}$");


    private ValidationUtil() {
    }

    /**
     * Kiểm tra string không null và không empty
     */
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Kiểm tra chuỗi không rỗng.
     */
    public static boolean isNotEmpty(String value) {
        return !isEmpty(value);
    }

    /**
     * Làm sạch chuỗi đầu vào (trim, loai bo khoang trang du).
     */
    public static String sanitize(String value) {
        if (value == null) return null;
        return value.trim();
    }

    /**
     * Kiểm tra email hop le.
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

    /**
     * Kiểm tra so dien thoai hop le.
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Xac thuc so dien thoai và tra ve thông báo lỗi nếu co.
     */
    public static String validatePhone(String phone) {
        if (isNotEmpty(phone) && !isValidPhone(phone)) {
            return "Số điện thoại không hợp lệ (10-11 chữ số)";
        }
        return null; // Hợp lệ hoặc empty
    }

    /**
     * Kiểm tra username hop le.
     */
    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    /**
     * Xac thuc username và tra ve thông báo lỗi nếu co.
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

    /**
     * Kiểm tra độ dài chuỗi.
     */
    private static boolean isValidLength(String value, int min, int max) {
        if (value == null) return false;
        int length = value.trim().length();
        return length >= min && length <= max;
    }

    /**
     * Kiểm tra mật khẩu hop le.
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
        if (!isValidPassword(password)) {
            return "Mật khẩu phải có ít nhất từ 6-100 ký tự";
        }
        return null;
    }

    /**
     * Validate confirm password
     */
    public static String validateConfirmPassword(String password, String confirmPassword) {
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }
        return null;
    }

    /**
     * Validate số nguyên dương
     */
    public static boolean isPositiveInteger(Integer number) {
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

    public static String validateFullName(String fullName) {
        if (isEmpty(fullName)) return "Họ tên không được để trống";
        String normalized = fullName.trim().replaceAll("\\s+", " ");
        if (normalized.length() < 10 || normalized.length() > 30) {
            return "Họ tên phải từ 10-30 ký tự";
        }
        if (!FULLNAME_PATTERN.matcher(normalized).matches()) {
            return "Họ tên chỉ được chứa chữ cái và khoảng trắng";
        }
        return null;
    }
}
