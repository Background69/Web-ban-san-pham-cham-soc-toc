package com.example.nhom49_webbansanphamchamsoctoc.database;

import org.jdbi.v3.core.Jdbi;


public class JDBIConnector {
    static Jdbi jdbi;

    private static Jdbi createJdbi() {
        if (jdbi == null) {
//            jdbi = Jdbi.create(new DBProperties().getConnection());
            jdbi.installPlugins();
        }
        return jdbi;
    }

    public static Jdbi getInstance() {
        if (jdbi == null) {
            jdbi = createJdbi();
        }
        return jdbi;
    }

}
