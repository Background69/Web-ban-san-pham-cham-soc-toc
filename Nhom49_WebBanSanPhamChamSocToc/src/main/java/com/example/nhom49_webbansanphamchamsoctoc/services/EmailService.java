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
}
