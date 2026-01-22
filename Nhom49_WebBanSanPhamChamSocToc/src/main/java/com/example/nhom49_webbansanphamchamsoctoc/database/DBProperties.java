package com.example.nhom49_webbansanphamchamsoctoc.database;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DBProperties {
    private static final String PROPERTIES_FILE = "db.properties";

    private final Properties properties = new Properties();


    public DBProperties() {
        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (inputStream == null) {
                throw new RuntimeException("Cannot load " + PROPERTIES_FILE);
            }
            properties.load(inputStream);
        } catch (IOException e) {
            throw new RuntimeException("Cannot load " + PROPERTIES_FILE, e);
        }
    }

    /**
     * Lấy giá tri từ bien moi truong hoặc file properties.
     */
    private String envOrProp(String envKey, String propKey, String defaultVal) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.isBlank()) return envVal;
        return properties.getProperty(propKey, defaultVal);
    }

    public String getHost() {
        return envOrProp("DB_HOST", "db.host", "localhost");
    }

    /**
     * Lấy port.
     */
    public int getPort() {
        return Integer.parseInt(envOrProp("DB_PORT", "db.port", "3306"));
    }

    /**
     * Lấy username.
     */
    public String getUsername() {
        return envOrProp("DB_USER", "db.username", "root");
    }

    /**
     * Lấy password.
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     */
    public String getPassword() {
        return envOrProp("DB_PASS", "db.password", "");
    }

    /**
     * Lấy database name.
     */
    public String getDatabaseName() {
        return envOrProp("DB_NAME", "db.databaseName", "nhom49_webbansanphamchamsoctoc");
    }

    /**
     * Lấy url nếu được chỉ dinh.
     */
    public String getUrl() {
        String env = System.getenv("DB_URL");
        if (env != null && !env.isBlank()) return env;
        return null;
    }
}
