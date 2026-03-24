package com.example.nhom49_webbansanphamchamsoctoc.services;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
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
        EMAIL_PASSWORD = getMailPassword(config).replaceAll("\\s+", "");
        EMAIL_FROM_NAME = propOrDefault(config, "mail.from_name", "HairGlow");

        String smtpHost = propOrDefault(config, "mail.smtp.host", "smtp.gmail.com");
        String smtpPort = propOrDefault(config, "mail.smtp.port", "587");
        String smtpAuth = propOrDefault(config, "mail.smtp.auth", "true");
        String smtpStartTls = propOrDefault(config, "mail.smtp.starttls.enable", "true");
        String smtpSslProtocols = propOrDefault(config, "mail.smtp.ssl.protocols", "TLSv1.2");
        String smtpSslTrust = propOrDefault(config, "mail.smtp.ssl.trust", smtpHost);
        String smtpSocketFactoryPort = propOrDefault(config, "mail.smtp.socketFactory.port", smtpPort);
        String smtpSocketFactoryClass = propOrDefault(config, "mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        boolean mailDebug = Boolean.parseBoolean(propOrDefault(config, "mail.debug", "false"));

        Properties props = new Properties();
        props.put("mail.smtp.auth", smtpAuth);
        props.put("mail.smtp.starttls.enable", smtpStartTls);
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);

        props.put("mail.smtp.ssl.protocols", smtpSslProtocols);
        props.put("mail.smtp.ssl.trust", smtpSslTrust);

        props.put("mail.smtp.socketFactory.port", smtpSocketFactoryPort);
        props.put("mail.smtp.socketFactory.class", smtpSocketFactoryClass);

        session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        session.setDebug(mailDebug);
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
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendPasswordResetOtpEmail(String toEmail, String otpCode, String resetLink, int expiryMinutes) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME, StandardCharsets.UTF_8.name()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject("Ma OTP dat lai mat khau - HairGlow", StandardCharsets.UTF_8.name());

            String html = """
                <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:20px;">
                  <h2 style="color:#2c5940;">Dat lai mat khau</h2>
                  <p>Ban vua yeu cau dat lai mat khau cho tai khoan HairGlow.</p>
                  <p>Ma OTP cua ban:</p>
                  <div style="font-size:28px;font-weight:700;letter-spacing:8px;color:#2c5940;margin:12px 0 18px 0;">%s</div>
                  <p>Ma co hieu luc trong %d phut va chi duoc dung 1 lan.</p>
                  <p>
                    <a href="%s" style="background:#2c5940;color:#fff;padding:12px 18px;border-radius:8px;text-decoration:none;display:inline-block;">
                      Mo trang dat lai mat khau
                    </a>
                  </p>
                  <p>Neu nut khong hoat dong, copy link sau:</p>
                  <p style="word-break:break-all;">%s</p>
                  <p style="color:#64748b;font-size:12px;">Email tu dong, vui long khong tra loi.</p>
                </div>
            """.formatted(otpCode, expiryMinutes, resetLink, resetLink);

            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendRegistrationOtpEmail(String toEmail, String otpCode, int expiryMinutes) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME, StandardCharsets.UTF_8.name()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject("Ma OTP xac thuc dang ky - HairGlow", StandardCharsets.UTF_8.name());

            String html = """
                <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:20px;">
                  <h2 style="color:#2c5940;">Xac thuc dang ky tai khoan</h2>
                  <p>Cam on ban da dang ky tai khoan HairGlow.</p>
                  <p>Ma OTP xac thuc cua ban:</p>
                  <div style="font-size:28px;font-weight:700;letter-spacing:8px;color:#2c5940;margin:12px 0 18px 0;">%s</div>
                  <p>Ma co hieu luc trong %d phut.</p>
                  <p>Neu ban khong thuc hien dang ky, vui long bo qua email nay.</p>
                  <p style="color:#64748b;font-size:12px;">Email tu dong, vui long khong tra loi.</p>
                </div>
            """.formatted(otpCode, expiryMinutes);

            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
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

    private static String getMailPassword(Properties p) {
        String password = p.getProperty("mail.app_password");
        if (password == null || password.isBlank()) {
            password = p.getProperty("mail.password");
        }
        if (password == null || password.isBlank()) {
            throw new RuntimeException("Thieu cau hinh: mail.app_password (hoac mail.password) trong " + CONFIG_FILE);
        }
        return password;
    }

    private static String propOrDefault(Properties p, String key, String defaultValue) {
        String value = p.getProperty(key);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        return value.trim();
    }

}
