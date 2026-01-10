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

/**
 * Gmail SMTP email helper using Jakarta Mail.
 * Reads credentials from environment variables GMAIL_USER and GMAIL_APP_PASSWORD.
 */
public class EmailService {

    private static final String DEFAULT_EMAIL_USERNAME = "your-email@gmail.com";
    private static final String DEFAULT_APP_PASSWORD = "xxxx xxxx xxxx xxxx";
    private static final String EMAIL_USERNAME = envOrDefault("GMAIL_USER", DEFAULT_EMAIL_USERNAME);
    private static final String EMAIL_PASSWORD = envOrDefault("GMAIL_APP_PASSWORD", DEFAULT_APP_PASSWORD);
    private static final String EMAIL_FROM_NAME = envOrDefault("EMAIL_FROM_NAME", "HairGlow");

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;

    private final Session session;

    public EmailService() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });
    }

    public static boolean isConfigured() {
        return !EMAIL_USERNAME.equals(DEFAULT_EMAIL_USERNAME)
                && !EMAIL_PASSWORD.equals(DEFAULT_APP_PASSWORD);
    }

    private static String envOrDefault(String key, String fallback) {
        String value = System.getenv(key);
        return (value == null || value.isBlank()) ? fallback : value;
    }

    /**
     * Local test entry point (manual).
     */
    public static void main(String[] args) {
        if (!isConfigured()) {
            System.out.println("Chua cau hinh email! Cap nhat GMAIL_USER va GMAIL_APP_PASSWORD.");
            return;
        }

        EmailService emailService = new EmailService();
        boolean sent = emailService.sendPasswordResetEmail(
                "test@example.com",
                "http://localhost:8080/forgot-password/reset?token=test123"
        );
        System.out.println("Test result: " + (sent ? "SUCCESS" : "FAILED"));
    }

    /**
     * Sends password reset email using the HTML template with placeholder {{RESET_LINK}}.
     */
    public boolean sendPasswordResetEmail(String toEmail, String resetLink) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Dat lai mat khau - HairGlow");

            String html = loadTemplate().replace("{{RESET_LINK}}", resetLink);
            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Sends verification email with a simple inline template.
     */
    public boolean sendVerificationEmail(String toEmail, String verifyLink) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, EMAIL_FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Xac minh tai khoan - HairGlow");

            String html = """
                    <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:20px;">
                      <h2 style="color:#2c5940;">Xac minh tai khoan</h2>
                      <p>Click vao nut ben duoi de kich hoat tai khoan cua ban.</p>
                      <p><a href="%s" style="background:#2c5940;color:#fff;padding:12px 20px;border-radius:8px;text-decoration:none;">Xac minh tai khoan</a></p>
                      <p>Neu nut khong hoat dong, sao chep link sau:<br>%s</p>
                      <p style="color:#64748b;font-size:12px;">Email tu dong, vui long khong tra loi.</p>
                    </div>
                    """.formatted(verifyLink, verifyLink);
            message.setContent(html, "text/html; charset=UTF-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String loadTemplate() {
        try (InputStream is = EmailService.class.getClassLoader().getResourceAsStream("email-template.html")) {
            if (is == null) {
                return "<p>Click the link to reset your password:</p><a href=\"{{RESET_LINK}}\">Reset password</a>";
            }
            return new String(is.readAllBytes(), StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "<p>Click the link to reset your password:</p><a href=\"{{RESET_LINK}}\">Reset password</a>";
        }
    }
}
