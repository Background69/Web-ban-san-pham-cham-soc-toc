package com.example.nhom49_webbansanphamchamsoctoc.util;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class VNPAYConfig {
    public static final String vnp_TmnCode   = "MÃ_TMNCODE_CỦA_BẠN";
    public static final String secretKey      = "MÃ_HASHSECRET_CỦA_BẠN";
    public static final String vnp_PayUrl     = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String vnp_ApiUrl     = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
    public static final String vnp_Version    = "2.1.0";
    public static final String vnp_Command    = "pay";
    public static final String vnp_OrderType  = "other";

    /**
     * Tạo Return URL động dựa trên contextPath của request
     * http://localhost:8080/Nhom49_WebBanSanPhamChamSocToc/vnpay/return
     */
    public static String getReturnUrl(String baseUrl) {
        return baseUrl + "/vnpay/return";
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
     * Tạo chuỗi hash data từ Map params (đã sort theo key)
     * Quy chuẩn VNPAY: các cặp key=value nối bằng "&", key sort A-Z
     */
    public static String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder sb = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                sb.append(fieldName).append('=');
                try {
                    sb.append(java.net.URLEncoder.encode(fieldValue, StandardCharsets.UTF_8));
                } catch (Exception e) {
                    sb.append(fieldValue);
                }
                if (itr.hasNext()) {
                    sb.append('&');
                }
            }
        }
        return sb.toString();
    }
}
