package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class CloudinaryConfig {
    private static Cloudinary instance;

    public static Cloudinary getInstance() {
        if (instance == null) {
            try {
                Properties props = new Properties();
                InputStream is = CloudinaryConfig.class.getClassLoader().getResourceAsStream("cloudinary.properties");
                props.load(is);

                instance = new Cloudinary(ObjectUtils.asMap(
                        "cloud_name", props.getProperty("cloudinary.cloud.name"),
                        "api_key", props.getProperty("cloudinary.api.key"),
                        "api_secret", props.getProperty("cloudinary.api.secret")
                ));
            } catch (IOException e) {
                throw new RuntimeException("Không load được cloudinary.properties", e);
            }
        }
        return instance;
    }
}
