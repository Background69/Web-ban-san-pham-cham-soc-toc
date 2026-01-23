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

        EMAIL_USERNAME = mustGet(config, "mail.username").trim();
        EMAIL_PASSWORD = mustGet(config, "mail.app_password").replaceAll("\\s+", ""); // bỏ khoảng trắng
        EMAIL_FROM_NAME = config.getProperty("mail.from_name", "HairGlow").trim();

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // TLS
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // FIX quan trọng cho Tomcat 10 + Java 21 (thường thiếu là fail send)
        props.put("mail.smtp.socketFactory.port", "587");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        // debug SMTP log
        session.setDebug(true);

        // log nhanh để check config đang đọc đúng
        System.out.println("MAIL USER = " + EMAIL_USERNAME);
        System.out.println("MAIL PASS LEN = " + EMAIL_PASSWORD.length()); // phải = 16
    }

    public boolean sendPasswordResetEmail(String toEmail, String resetLink) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME, StandardCharsets.UTF_8.name()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject("Đặt lại mật khẩu - HairGlow", StandardCharsets.UTF_8.name());

            String html = """
                <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:20px;">
                  <h2 style="color:#2c5940;">Đặt lại mật khẩu</h2>
                  <p>Bạn vừa yêu cầu đặt lại mật khẩu.</p>
                  <p>
                    <a href="%s" style="background:#2c5940;color:#fff;padding:12px 18px;border-radius:8px;text-decoration:none;display:inline-block;">
                      Đặt lại mật khẩu
                    </a>
                  </p>
                  <p>Link sẽ hết hạn sau 30 phút.</p>
                  <p>Nếu nút không hoạt động, copy link sau:</p>
                  <p style="word-break:break-all;">%s</p>
                  <p style="color:#64748b;font-size:12px;">Email tự động, vui lòng không trả lời.</p>
                </div>
            """.formatted(resetLink, resetLink);

            message.setContent(html, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace(); // xem chi tiết trong Tomcat log
            return false;
        }
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

    private static String mustGet(Properties p, String key) {
        String v = p.getProperty(key);
        if (v == null || v.isBlank()) {
            throw new RuntimeException("Thiếu cấu hình: " + key + " trong " + CONFIG_FILE);
        }
        return v;
    }

    // TEST nhanh không qua web
    public static void main(String[] args) {
        EmailService s = new EmailService();
        boolean ok = s.sendPasswordResetEmail(
                "luongvanthang27112001@gmail.com",
                "https://example.com/test"
        );
        System.out.println("MAIL RESULT = " + ok);
    }
}
