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
        try (InputStream is = CloudinaryConfig.class
                .getClassLoader()
                .getResourceAsStream("cloudinary.properties")) {

            if (is == null) {
                throw new RuntimeException("Không tìm thấy cloudinary.properties trong classpath");
            }

            Properties props = new Properties();
            props.load(is);
            return new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", props.getProperty("cloudinary.cloud.name"),
                    "api_key", props.getProperty("cloudinary.api.key"),
                    "api_secret", props.getProperty("cloudinary.api.secret"),
                    "secure", true
            ));

        } catch (IOException e) {
            throw new RuntimeException("Không load được cloudinary.properties", e);
        }
    }

    public static Cloudinary getInstance() {
        return Holder.INSTANCE;
    }
}
