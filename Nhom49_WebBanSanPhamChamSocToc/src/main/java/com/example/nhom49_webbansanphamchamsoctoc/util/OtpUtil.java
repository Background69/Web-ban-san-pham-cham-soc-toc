package com.example.nhom49_webbansanphamchamsoctoc.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.IOException;
import java.io.InputStream;
import java.security.SecureRandom;
import java.util.Properties;

public class OtpUtil {
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final String PROPERTIES_FILE = "mail.properties";

    private static final Properties properties = new Properties();


    static {
        try (InputStream inputStream = OtpUtil.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (inputStream == null) {
                throw new RuntimeException("Cannot load " + PROPERTIES_FILE);
            }
            properties.load(inputStream);
        } catch (IOException e) {
            throw new RuntimeException("Cannot load " + PROPERTIES_FILE, e);
        }
    }

    private static String otpGenerate(int len) {
        String numbers = "0123456789";
        StringBuilder sb = new StringBuilder(len);

        for (int i = 0; i < len; i++) {
            sb.append(numbers.charAt(RANDOM.nextInt(numbers.length())));
        }

        return sb.toString();
    }

    public static String sendOtpToMail(String email) {
        String otp = otpGenerate(6);
        String senderEmail = getSenderEmail();
        String senderPassword = getSenderPassword();

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipient(
                    Message.RecipientType.TO,
                    new InternetAddress(email)
            );

            message.setSubject("Mã xác nhận OTP ");
            message.setText("Mã OTP của bạn là: " + otp);

            Transport.send(message);

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
        return otp;
    }

    private static String getSenderEmail() {
        return envOrProp("EMAIL", "mail.username", "default@gmail.com");
    }

    private static String getSenderPassword() {
        return envOrProp("MAIL_PASSWORD", "mail.password", "");
    }

    private static String envOrProp(String envKey, String propKey, String defaultVal) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) {
            return envVal;
        }

        String propVal = properties.getProperty(propKey);
        if (propVal != null && !propVal.trim().isEmpty()) {
            return propVal;
        }

        return defaultVal;
    }
}
