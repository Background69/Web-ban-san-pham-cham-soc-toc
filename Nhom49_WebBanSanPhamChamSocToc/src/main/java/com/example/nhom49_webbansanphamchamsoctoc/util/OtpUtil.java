package com.example.nhom49_webbansanphamchamsoctoc.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.security.SecureRandom;
import java.util.Properties;

public class OtpUtil {

    private static final String senderEmail = "ducphamtan2098@gmail.com";
    private static final String senderPassword = "drpn xswc tknf hoag";
    private static final SecureRandom RANDOM = new SecureRandom();

    private static String otpGenerate(int len) {
        String numbers = "0123456789";
        StringBuilder sb = new StringBuilder(len);

        for (int i = 0; i < len; i++) {
            sb.append(numbers.charAt(RANDOM.nextInt(numbers.length())));
        }

        return sb.toString();
    }

    public static void sendOtpToMail(String email) {
        String otp = otpGenerate(6);

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

    }
}
