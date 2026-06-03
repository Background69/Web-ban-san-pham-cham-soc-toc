package com.example.nhom49_webbansanphamchamsoctoc.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class VNPAYConfig {

    private static final Properties props = new Properties();

    static {
        try (InputStream is = VNPAYConfig.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (is != null) props.load(is);
        } catch (IOException ignored) {
        }
    }

    /**
     * Ưu tiên: ENV → db.properties → defaultValue
     */
    private static String resolve(String envKey, String propKey, String defaultValue) {
        String env = System.getenv(envKey);
        if (env != null && !env.isBlank()) return env;
        return props.getProperty(propKey, defaultValue);
    }

    // --- Các giá trị config linh hoạt theo môi trường ---

    public static String getTmnCode() {
        return resolve("VNPAY_TMN_CODE", "vnpay.tmnCode", "MÃ_TMNCODE_CỦA_BẠN");
    }

    public static String getSecretKey() {
        return resolve("VNPAY_SECRET_KEY", "vnpay.secretKey", "MÃ_HASHSECRET_CỦA_BẠN");
    }

    public static String getPayUrl() {
        return resolve("VNPAY_PAY_URL", "vnpay.payUrl",
                "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html");
    }

    public static String getApiUrl() {
        return resolve("VNPAY_API_URL", "vnpay.apiUrl",
                "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction");
    }

    /**
     * Base URL cho VNPAY return. Ví dụ: "https://yourdomain.com"
     * Nếu rỗng → tự detect từ request (legacy / dev behavior).
     */
    public static String getReturnBaseUrl() {
        return resolve("VNPAY_RETURN_BASE_URL", "vnpay.returnBaseUrl", "");
    }

    // --- Các hằng số cố định ---
    public static final String vnp_Version = "2.1.0";
    public static final String vnp_Command = "pay";
    public static final String vnp_OrderType = "other";

    /**
     * Tạo Return URL.
     * Nếu có VNPAY_RETURN_BASE_URL cấu hình → dùng luôn (production).
     * Nếu không → dùng baseUrl detect từ request (dev/legacy).
     */
    public static String getReturnUrl(String requestBaseUrl) {
        String configuredBase = getReturnBaseUrl();
        String base = (configuredBase != null && !configuredBase.isBlank())
                ? configuredBase
                : requestBaseUrl;
        // Bỏ trailing slash nếu có
        if (base != null && base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/vnpay/return";
    }

    /**
     * Tạo HMAC-SHA512 checksum cho dữ liệu thanh toán
     */
    public static String hmacSHA512(String key, String data) {
        try {
            if (key == null || data == null) return null;
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKeySpec);
            byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Tạo chuỗi hash data từ Map params (đã sort theo key).
     * Quy chuẩn VNPAY: các cặp key=value nối bằng "&", key sort A-Z.
     * Dùng flag 'first' thay vì itr.hasNext() để tránh trailing
     * khi field cuối cùng có value null/empty.
     */
    public static String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder sb = new StringBuilder();
        boolean first = true;
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                if (!first) {
                    sb.append('&');
                }
                sb.append(fieldName).append('=');
                try {
                    sb.append(java.net.URLEncoder.encode(fieldValue, StandardCharsets.UTF_8));
                } catch (Exception e) {
                    sb.append(fieldValue);
                }
                first = false;
            }
        }
        return sb.toString();
    }
}
