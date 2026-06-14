package com.example.nhom49_webbansanphamchamsoctoc.services;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class EmailService {

    private static final String CONFIG_FILE = "db.properties";

    private final String EMAIL_USERNAME;
    private final String EMAIL_PASSWORD;
    private final String EMAIL_FROM_NAME;

    private final Session session;

    public EmailService() {
        Properties config = loadConfig();

        EMAIL_USERNAME = mustGet(config, "MAIL_USERNAME", "mail.username").trim();
        EMAIL_PASSWORD = mustGet(config, "MAIL_APP_PASSWORD", "mail.app_password").replaceAll("\\s+", "");
        EMAIL_FROM_NAME = envOrProp(config, "MAIL_FROM_NAME", "mail.from_name", "HairGlow").trim();

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        props.put("mail.smtp.socketFactory.port", "587");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        session.setDebug(false);
    }

    private static Properties loadConfig() {
        try (InputStream is = EmailService.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (is == null) {
                throw new RuntimeException("Không tìm thấy " + CONFIG_FILE + " trong src/main/resources");
            }
            Properties p = new Properties();
            p.load(is);
            return p;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi load " + CONFIG_FILE + ": " + e.getMessage(), e);
        }
    }

    private static String envOrProp(Properties p, String envKey, String propKey, String defaultValue) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.isBlank()) {
            return envVal;
        }
        return p.getProperty(propKey, defaultValue);
    }

    private static String mustGet(Properties p, String envKey, String propKey) {
        String value = envOrProp(p, envKey, propKey, null);
        if (value == null || value.isBlank() || value.startsWith("YOUR_")) {
            throw new RuntimeException("Thiếu cấu hình mail: biến môi trường " + envKey
                    + " hoặc key " + propKey + " trong " + CONFIG_FILE);
        }
        return value;
    }

    public boolean sendResetPasswordOtpEmail(String toEmail, String otpCode, String verifyLink, int expiryMinutes) {
        return sendOtpHtml(
                toEmail,
                "Mã OTP đặt lại mật khẩu - HairGlow",
                "Đặt lại mật khẩu",
                "Bạn vừa yêu cầu đặt lại mật khẩu cho tài khoản HairGlow.",
                "Mở trang đặt lại mật khẩu",
                otpCode,
                verifyLink,
                expiryMinutes
        );
    }

    public boolean sendRegisterOtpEmail(String toEmail, String otpCode, String verifyLink, int expiryMinutes) {
        return sendOtpHtml(
                toEmail,
                "Mã OTP xác minh tài khoản - HairGlow",
                "Xác minh tài khoản",
                "Cảm ơn bạn đã đăng ký HairGlow. Vui lòng nhập OTP để kích hoạt tài khoản.",
                "Mở trang xác minh tài khoản",
                otpCode,
                verifyLink,
                expiryMinutes
        );
    }

    private boolean sendOtpHtml(String toEmail, String subject, String title, String intro,
                                String ctaLabel, String otpCode, String verifyLink, int expiryMinutes) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME, StandardCharsets.UTF_8.name()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject(subject, StandardCharsets.UTF_8.name());

            String html = """
                        <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:20px;">
                          <h2 style="color:#2c5940;">%s</h2>
                          <p>%s</p>
                          <p>Mã OTP của bạn:</p>
                          <div style="font-size:28px;font-weight:700;letter-spacing:8px;color:#2c5940;margin:12px 0 18px 0;">%s</div>
                          <p>Mã có hiệu lực trong %d phút và chỉ được dùng 1 lần.</p>
                          <p>
                            <a href="%s" style="background:#2c5940;color:#fff;padding:12px 18px;border-radius:8px;text-decoration:none;display:inline-block;">%s</a>
                          </p>
                          <p>Nếu nút không hoạt động, hãy sao chép liên kết sau:</p>
                          <p style="word-break:break-all;">%s</p>
                          <p style="color:#64748b;font-size:12px;">Đây là email tự động, vui lòng không trả lời.</p>
                        </div>
                    """.formatted(title, intro, otpCode, expiryMinutes, verifyLink, ctaLabel, verifyLink);

            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.out.println("Lỗi gửi email");
            return false;
        }
    }

    public boolean sendFeedbackConfirmation(String toEmail, String ticketCode,
                                            String category, String title, String contentSummary) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME, StandardCharsets.UTF_8.name()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject("Xác nhận tiếp nhận phản hồi #" + ticketCode + " - HairGlow",
                    StandardCharsets.UTF_8.name());

            String summary = contentSummary;
            if (summary != null && summary.length() > 200) {
                summary = summary.substring(0, 200) + "...";
            }

            String categoryLabel = switch (category) {
                case "SYSTEM_ERROR" -> "Lỗi hệ thống";
                case "SHIPPING" -> "Vận chuyển / Giao hàng";
                case "PRODUCT_QUALITY" -> "Chất lượng sản phẩm";
                case "SHOPPING_GUIDE" -> "Hướng dẫn mua hàng";
                default -> "Khác";
            };

            String html = """
                <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:20px;background:#f6f7f3;">
                  <div style="background:#fff;border-radius:12px;padding:28px;border:1px solid #dbe3d9;">
                    <h2 style="color:#234737;margin-bottom:16px;">Đã tiếp nhận phản hồi của bạn</h2>
                    <p style="color:#637068;">Cảm ơn bạn đã liên hệ HairGlow. Chúng tôi đã nhận được phản hồi và sẽ xử lý trong thời gian sớm nhất.</p>
                    <div style="background:#f6f7f3;border-radius:8px;padding:16px;margin:16px 0;">
                      <p style="margin:4px 0;"><strong>Mã ticket:</strong> <span style="color:#234737;font-weight:700;">%s</span></p>
                      <p style="margin:4px 0;"><strong>Phân loại:</strong> %s</p>
                      <p style="margin:4px 0;"><strong>Tiêu đề:</strong> %s</p>
                      <p style="margin:4px 0;color:#637068;"><strong>Nội dung:</strong> %s</p>
                    </div>
                    <p style="color:#637068;font-size:13px;">Thời gian xử lý dự kiến: 1-2 ngày làm việc. Bạn có thể theo dõi trạng thái ticket tại trang hỗ trợ.</p>
                    <p style="color:#64748b;font-size:12px;margin-top:20px;">Đây là email tự động, vui lòng không trả lời.</p>
                  </div>
                </div>
            """.formatted(ticketCode, categoryLabel, title, summary);

            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.out.println("Lỗi gửi email xác nhận feedback: " + e.getMessage());
            return false;
        }
    }

    public boolean sendFeedbackReplyNotification(String toEmail, String ticketCode,
                                                  String adminMessage, String newStatus) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME, StandardCharsets.UTF_8.name()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject("HairGlow đã phản hồi yêu cầu hỗ trợ #" + ticketCode,
                    StandardCharsets.UTF_8.name());

            String statusLabel = switch (newStatus) {
                case "RECEIVED" -> "Đã tiếp nhận";
                case "PROCESSING" -> "Đang xử lý";
                case "RESOLVED" -> "Đã giải quyết";
                case "CLOSED" -> "Đã đóng";
                default -> newStatus;
            };

            String replySummary = adminMessage;
            if (replySummary != null && replySummary.length() > 500) {
                replySummary = replySummary.substring(0, 500) + "...";
            }

            String html = """
                <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:20px;background:#f6f7f3;">
                  <div style="background:#fff;border-radius:12px;padding:28px;border:1px solid #dbe3d9;">
                    <h2 style="color:#234737;margin-bottom:16px;">Phản hồi từ HairGlow</h2>
                    <p style="color:#637068;">Yêu cầu hỗ trợ của bạn đã được phản hồi bởi đội ngũ HairGlow.</p>
                    <div style="background:#f6f7f3;border-radius:8px;padding:16px;margin:16px 0;">
                      <p style="margin:4px 0;"><strong>Mã ticket:</strong> <span style="color:#234737;font-weight:700;">%s</span></p>
                      <p style="margin:4px 0;"><strong>Trạng thái mới:</strong> <span style="color:#89AF63;font-weight:600;">%s</span></p>
                    </div>
                    <div style="background:#fff;border:1px solid #dbe3d9;border-radius:8px;padding:16px;margin:16px 0;">
                      <p style="margin:0 0 8px 0;font-weight:600;color:#234737;">Nội dung phản hồi:</p>
                      <p style="margin:0;color:#1E2A24;line-height:1.6;">%s</p>
                    </div>
                    <p style="color:#637068;font-size:13px;">Nếu bạn cần hỗ trợ thêm, vui lòng truy cập trang hỗ trợ hoặc liên hệ hotline.</p>
                    <p style="color:#64748b;font-size:12px;margin-top:20px;">Đây là email tự động, vui lòng không trả lời.</p>
                  </div>
                </div>
            """.formatted(ticketCode, statusLabel, replySummary);

            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.out.println("Lỗi gửi email phản hồi feedback: " + e.getMessage());
            return false;
        }
    }
}
