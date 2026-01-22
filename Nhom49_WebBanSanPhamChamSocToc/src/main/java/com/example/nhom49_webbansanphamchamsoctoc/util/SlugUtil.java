package com.example.nhom49_webbansanphamchamsoctoc.util;

import java.text.Normalizer;
import java.util.regex.Pattern;

/**
 * Lớp SlugUtil.
 */
public class SlugUtil {

    /**
     * Pattern cho ký tự không phải Latin.
     */
    private static final Pattern NONLATIN = Pattern.compile("[^\\w-]");

    /**
     * Pattern cho khoảng trắng.
     */
    private static final Pattern WHITESPACE = Pattern.compile("\\s+");

    /**
     * Pattern cho nhiều dấu gạch ngang liên tiếp.
     */
    private static final Pattern MULTIPLE_HYPHENS = Pattern.compile("-+");

    /**
     * Sinh slug.
     */
    public static String generateSlug(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "";
        }

        String slug = name.trim().toLowerCase();

        // Loại bỏ dấu tiếng Việt
        slug = removeVietnameseAccents(slug);

        // Chuẩn hóa Unicode và loại bỏ dấu
        slug = Normalizer.normalize(slug, Normalizer.Form.NFD);
        slug = slug.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");

        // Thay khoảng trắng bằng dấu gạch ngang
        slug = WHITESPACE.matcher(slug).replaceAll("-");

        // Loại bỏ ký tự đặc biệt (chỉ giữ chữ, số, gạch ngang)
        slug = NONLATIN.matcher(slug).replaceAll("");

        // Loại bỏ nhiều dấu gạch ngang liên tiếp
        slug = MULTIPLE_HYPHENS.matcher(slug).replaceAll("-");

        // Loại bỏ dấu gạch ngang ở đầu và cuối
        slug = slug.replaceAll("^-|-$", "");

        return slug;
    }


    /**
     * Loại bỏ dấu tiếng Việt
     * Xử lý các ký tự đặc biệt của tiếng Việt như đ, Đ
     */
    private static String removeVietnameseAccents(String str) {
        str = str.replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a");
        str = str.replaceAll("[èéẹẻẽêềếệểễ]", "e");
        str = str.replaceAll("[ìíịỉĩ]", "i");
        str = str.replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o");
        str = str.replaceAll("[ùúụủũưừứựửữ]", "u");
        str = str.replaceAll("[ỳýỵỷỹ]", "y");
        str = str.replaceAll("đ", "d");
        str = str.replaceAll("[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]", "a");
        str = str.replaceAll("[ÈÉẸẺẼÊỀẾỆỂỄ]", "e");
        str = str.replaceAll("[ÌÍỊỈĨ]", "i");
        str = str.replaceAll("[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]", "o");
        str = str.replaceAll("[ÙÚỤỦŨƯỪỨỰỬỮ]", "u");
        str = str.replaceAll("[ỲÝỴỶỸ]", "y");
        str = str.replaceAll("Đ", "d");
        return str;
    }
}
