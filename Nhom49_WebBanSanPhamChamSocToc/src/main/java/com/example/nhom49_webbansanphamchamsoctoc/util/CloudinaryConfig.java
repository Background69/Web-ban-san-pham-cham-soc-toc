package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class CloudinaryConfig {

    public CloudinaryConfig() {
    }

    private static class Holder {
        private static final Cloudinary INSTANCE = createInstance();
    }

    private static Cloudinary createInstance() {
        Properties props = new Properties();

        String cloudName = firstNonBlank(
                System.getProperty("cloudinary.cloud.name"),
                System.getenv("CLOUDINARY_CLOUD_NAME")
        );
        String apiKey = firstNonBlank(
                System.getProperty("cloudinary.api.key"),
                System.getenv("CLOUDINARY_API_KEY")
        );
        String apiSecret = firstNonBlank(
                System.getProperty("cloudinary.api.secret"),
                System.getenv("CLOUDINARY_API_SECRET")
        );

        try (InputStream is = CloudinaryConfig.class
                .getClassLoader()
                .getResourceAsStream("cloudinary.properties")) {
            if (is != null) {
                props.load(is);
                cloudName = firstNonBlank(cloudName, props.getProperty("cloudinary.cloud.name"));
                apiKey = firstNonBlank(apiKey, props.getProperty("cloudinary.api.key"));
                apiSecret = firstNonBlank(apiSecret, props.getProperty("cloudinary.api.secret"));
            }
        } catch (IOException e) {
            throw new RuntimeException("Không load được cloudinary.properties", e);
        }

        if (isBlank(cloudName) || isBlank(apiKey) || isBlank(apiSecret)) {
            throw new RuntimeException("Thiếu cấu hình Cloudinary");
        }

        return new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret,
                "secure", true
        ));
    }

    public static Cloudinary getInstance() {
        return Holder.INSTANCE;
    }

    private static String firstNonBlank(String first, String second) {
        if (!isBlank(first)) {
            return first.trim();
        }
        if (!isBlank(second)) {
            return second.trim();
        }
        return null;
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
