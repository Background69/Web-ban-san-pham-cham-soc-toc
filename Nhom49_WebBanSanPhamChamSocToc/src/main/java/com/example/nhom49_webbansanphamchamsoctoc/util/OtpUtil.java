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

    public static String otpGenerate(int len) {
        String numbers = "0123456789";
        StringBuilder sb = new StringBuilder(len);

        for (int i = 0; i < len; i++) {
            sb.append(numbers.charAt(RANDOM.nextInt(numbers.length())));
        }

        return sb.toString();
    }


}
