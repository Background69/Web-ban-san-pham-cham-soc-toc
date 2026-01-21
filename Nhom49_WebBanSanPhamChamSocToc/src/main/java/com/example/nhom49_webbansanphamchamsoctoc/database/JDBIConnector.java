package com.example.nhom49_webbansanphamchamsoctoc.database;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;

import java.util.logging.Level;
import java.util.logging.Logger;

public class JDBIConnector {

    private static final Logger LOGGER = Logger.getLogger(JDBIConnector.class.getName());
    private static volatile Jdbi jdbi;

    private JDBIConnector() {
    }

    /**
     * Tạo doi tuong Jdbi từ cau hinh.
     */
    private static Jdbi createJdbi() {
        DBProperties dbProps = new DBProperties();

        MysqlDataSource dataSource = new MysqlDataSource();
        String url = dbProps.getUrl();
        if (url != null) {
            dataSource.setUrl(url);
        } else {
            dataSource.setServerName(dbProps.getHost());
            dataSource.setPort(dbProps.getPort());
            dataSource.setDatabaseName(dbProps.getDatabaseName());
        }
        dataSource.setUser(dbProps.getUsername());
        dataSource.setPassword(dbProps.getPassword());

        try {
            dataSource.setUseSSL(false);
            dataSource.setAllowPublicKeyRetrieval(true);
            dataSource.setCharacterEncoding("UTF-8");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to apply MySQL data source options.", e);
        }

        Jdbi jdbiInstance = Jdbi.create(dataSource);
        jdbiInstance.installPlugins();
        return jdbiInstance;
    }

    /**
     * Lấy instance Jdbi theo singleton.
     */
    public static Jdbi getInstance() {
        if (jdbi == null) {
            synchronized (JDBIConnector.class) {
                if (jdbi == null) {
                    jdbi = createJdbi();
                }
            }
        }
        return jdbi;
    }

}
