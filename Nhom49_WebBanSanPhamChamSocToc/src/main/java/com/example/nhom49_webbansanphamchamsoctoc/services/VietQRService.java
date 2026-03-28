package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.database.DBProperties;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VietQRService {
    private static final String VIETQR_API_URL = "https://api.vietqr.io/v2/generate";

    private final DBProperties dbProperties;
    private final HttpClient httpClient;
    private String lastError;

    public VietQRService() {
        this(new DBProperties(), HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build());
    }

    public VietQRService(DBProperties dbProperties, HttpClient httpClient) {
        this.dbProperties = dbProperties;
        this.httpClient = httpClient;
    }

    public String getLastError() {
        return lastError;
    }

    public QrGenerationResult generateQr(BigDecimal amount, String transferContent) {
        lastError = null;

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            lastError = "Số tiền không hợp lệ để tạo QR";
            return QrGenerationResult.failed(lastError);
        }

        String clientId = dbProperties.getBankTransferClientId();
        String apiKey = dbProperties.getBankTransferApiKey();
        String accountNo = dbProperties.getBankTransferAccountNo();
        String accountName = dbProperties.getBankTransferAccountName();
        String acqId = dbProperties.getBankTransferAcqId();
        String template = dbProperties.getBankTransferTemplate();

        if (isBlank(clientId) || isBlank(apiKey) || isBlank(accountNo) || isBlank(acqId)) {
            lastError = "Thiếu cấu hình VietQR (clientId, apiKey, accountNo hoặc acqId)";
            return QrGenerationResult.failed(lastError);
        }

        String normalizedTransferContent = normalizeTransferContent(transferContent);
        long roundedAmount = amount.setScale(0, RoundingMode.HALF_UP).longValue();

        String requestBody = buildRequestBody(accountNo, accountName, acqId, roundedAmount,
                normalizedTransferContent, template);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(VIETQR_API_URL))
                .timeout(Duration.ofSeconds(20))
                .header("Content-Type", "application/json")
                .header("x-client-id", clientId)
                .header("x-api-key", apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                .build();

        try {
            HttpResponse<String> response = httpClient.send(request,
                    HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            String body = response.body();

            if (response.statusCode() != 200) {
                String desc = extractJsonString(body, "desc");
                lastError = isBlank(desc)
                        ? "VietQR tra ve HTTP " + response.statusCode()
                        : desc;
                return QrGenerationResult.failed(lastError);
            }

            String code = extractJsonString(body, "code");
            if (!"00".equals(code)) {
                String desc = extractJsonString(body, "desc");
                lastError = isBlank(desc) ? "Không tạo được mã QR từ VietQR" : desc;
                return QrGenerationResult.failed(lastError);
            }

            String qrDataUrl = extractJsonString(body, "qrDataURL");
            String qrCode = extractJsonString(body, "qrCode");
            String desc = extractJsonString(body, "desc");

            if (isBlank(qrDataUrl) && isBlank(qrCode)) {
                lastError = "VietQR không trả về dữ liệu QR";
                return QrGenerationResult.failed(lastError);
            }

            return QrGenerationResult.success(qrDataUrl, qrCode, desc);
        } catch (Exception e) {
            lastError = "Không thể kết nối đến VietQR API: " + e.getMessage();
            return QrGenerationResult.failed(lastError);
        }
    }

    private String buildRequestBody(String accountNo, String accountName, String acqId,
                                    long amount, String addInfo, String template) {
        String safeAccountName = isBlank(accountName) ? "" : accountName.trim().toUpperCase();
        String safeTemplate = isBlank(template) ? "compact" : template.trim();
        String safeAcqId = acqId.trim().replaceAll("[^0-9]", "");

        return "{"
                + "\"accountNo\":\"" + escapeJson(accountNo.trim()) + "\","
                + "\"accountName\":\"" + escapeJson(safeAccountName) + "\","
                + "\"acqId\":" + safeAcqId + ","
                + "\"amount\":" + amount + ","
                + "\"addInfo\":\"" + escapeJson(addInfo) + "\","
                + "\"format\":\"text\","
                + "\"template\":\"" + escapeJson(safeTemplate) + "\""
                + "}";
    }

    private String normalizeTransferContent(String value) {
        if (isBlank(value)) {
            return "HAIRGLOW";
        }

        String sanitized = value.toUpperCase()
                .replaceAll("[^A-Z0-9 ]", " ")
                .replaceAll("\\s+", " ")
                .trim();

        if (sanitized.length() > 25) {
            sanitized = sanitized.substring(0, 25);
        }

        return sanitized.isEmpty() ? "HAIRGLOW" : sanitized;
    }

    private String extractJsonString(String json, String key) {
        if (isBlank(json) || isBlank(key)) {
            return null;
        }

        Pattern keyPattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
        Matcher matcher = keyPattern.matcher(json);
        if (!matcher.find()) {
            return null;
        }

        return unescapeJson(matcher.group(1));
    }

    private String escapeJson(String value) {
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private String unescapeJson(String value) {
        return value
                .replace("\\\"", "\"")
                .replace("\\\\", "\\")
                .replace("\\n", "\n")
                .replace("\\r", "\r");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static class QrGenerationResult {
        private final boolean success;
        private final String qrDataUrl;
        private final String qrCode;
        private final String message;

        private QrGenerationResult(boolean success, String qrDataUrl, String qrCode, String message) {
            this.success = success;
            this.qrDataUrl = qrDataUrl;
            this.qrCode = qrCode;
            this.message = message;
        }

        public static QrGenerationResult success(String qrDataUrl, String qrCode, String message) {
            return new QrGenerationResult(true, qrDataUrl, qrCode, message);
        }

        public static QrGenerationResult failed(String message) {
            return new QrGenerationResult(false, null, null, message);
        }

        public boolean isSuccess() {
            return success;
        }

        public String getQrDataUrl() {
            return qrDataUrl;
        }

        public String getQrCode() {
            return qrCode;
        }

        public String getMessage() {
            return message;
        }
    }
}
