package com.example.nhom49_webbansanphamchamsoctoc.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Utility class để format ngày tháng và tiền tệ theo chuẩn Việt Nam
 */
public class FormatUtil {

    // Date formats
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    private static final SimpleDateFormat DATETIME_FORMAT = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    private static final SimpleDateFormat DATETIME_FULL_FORMAT = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    // Currency format cho VND (dùng dấu chấm phân cách hàng nghìn)
    private static final DecimalFormat CURRENCY_FORMAT;

    static {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        CURRENCY_FORMAT = new DecimalFormat("#,###", symbols);
    }

    /**
     * Format ngày theo định dạng dd/MM/yyyy
     */
    public static String formatDate(Date date) {
        if (date == null) return "";
        synchronized (DATE_FORMAT) {
            return DATE_FORMAT.format(date);
        }
    }

    /**
     * Format ngày giờ theo định dạng dd/MM/yyyy HH:mm
     */
    public static String formatDateTime(Date date) {
        if (date == null) return "";
        synchronized (DATETIME_FORMAT) {
            return DATETIME_FORMAT.format(date);
        }
    }

    /**
     * Format ngày giờ đầy đủ theo định dạng dd/MM/yyyy HH:mm:ss
     */
    public static String formatDateTimeFull(Date date) {
        if (date == null) return "";
        synchronized (DATETIME_FULL_FORMAT) {
            return DATETIME_FULL_FORMAT.format(date);
        }
    }

    /**
     * Format số tiền theo định dạng Việt Nam (VD: 1.000.000 đ)
     */
    public static String formatCurrency(BigDecimal amount) {
        if (amount == null) return "0 đ";
        synchronized (CURRENCY_FORMAT) {
            return CURRENCY_FORMAT.format(amount) + " đ";
        }
    }

    /**
     * Format số tiền theo định dạng Việt Nam (VD: 1.000.000 đ)
     */
    public static String formatCurrency(long amount) {
        synchronized (CURRENCY_FORMAT) {
            return CURRENCY_FORMAT.format(amount) + " đ";
        }
    }

    /**
     * Format số tiền theo định dạng Việt Nam (VD: 1.000.000 đ)
     */
    public static String formatCurrency(double amount) {
        synchronized (CURRENCY_FORMAT) {
            return CURRENCY_FORMAT.format(amount) + " đ";
        }
    }

    /**
     * Format số tiền không có đơn vị (VD: 1.000.000)
     */
    public static String formatNumber(BigDecimal amount) {
        if (amount == null) return "0";
        synchronized (CURRENCY_FORMAT) {
            return CURRENCY_FORMAT.format(amount);
        }
    }

    /**
     * Format số tiền không có đơn vị (VD: 1.000.000)
     */
    public static String formatNumber(long amount) {
        synchronized (CURRENCY_FORMAT) {
            return CURRENCY_FORMAT.format(amount);
        }
    }

}
