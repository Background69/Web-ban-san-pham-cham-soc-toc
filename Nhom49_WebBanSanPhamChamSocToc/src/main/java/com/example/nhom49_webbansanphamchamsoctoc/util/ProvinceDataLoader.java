package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.example.nhom49_webbansanphamchamsoctoc.model.District;
import com.example.nhom49_webbansanphamchamsoctoc.model.Province;
import com.example.nhom49_webbansanphamchamsoctoc.model.Ward;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebListener
public class ProvinceDataLoader implements ServletContextListener {

    private static final Logger log = LoggerFactory.getLogger(ProvinceDataLoader.class);
    private static final String DATA_FILE = "/data/vn_provinces.json";

    public static final String PROVINCES_KEY = "VN_PROVINCES";

    public static final String DISTRICTS_MAP_KEY = "VN_DISTRICTS_MAP";

    public static final String WARDS_MAP_KEY = "VN_WARDS_MAP";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        log.info("Đang nạp dữ liệu hành chính Việt Nam vào RAM...");

        try (InputStream is = getClass().getClassLoader().getResourceAsStream(DATA_FILE.substring(1))) {
            if (is == null) {
                log.error("Không tìm thấy file dữ liệu: {}", DATA_FILE);
                return;
            }

            Gson gson = new Gson();
            Type listType = new TypeToken<List<Province>>() {}.getType();
            List<Province> provinces = gson.fromJson(
                    new InputStreamReader(is, StandardCharsets.UTF_8), listType
            );

            Map<String, List<District>> districtsMap = new LinkedHashMap<>();
            Map<String, List<Ward>> wardsMap = new LinkedHashMap<>();
            int totalDistricts = 0;
            int totalWards = 0;

            for (Province province : provinces) {
                List<District> districtList = new ArrayList<>();

                if (province.getDistricts() != null) {
                    for (District district : province.getDistricts()) {
                        districtList.add(district);
                        totalDistricts++;

                        List<Ward> wardList = district.getWards() != null
                                ? district.getWards()
                                : Collections.emptyList();
                        wardsMap.put(district.getCode(),
                                Collections.unmodifiableList(wardList));
                        totalWards += wardList.size();
                    }
                }

                districtsMap.put(province.getCode(),
                        districtList.isEmpty() ? Collections.emptyList() : Collections.unmodifiableList(districtList));
            }

            ctx.setAttribute(PROVINCES_KEY, Collections.unmodifiableList(provinces));
            ctx.setAttribute(DISTRICTS_MAP_KEY, Collections.unmodifiableMap(districtsMap));
            ctx.setAttribute(WARDS_MAP_KEY, Collections.unmodifiableMap(wardsMap));

            log.info("Đã nạp {} tỉnh/thành phố, {} quận/huyện, {} phường/xã vào RAM.",
                    provinces.size(), totalDistricts, totalWards);

        } catch (Exception e) {
            log.error("Lỗi khi nạp dữ liệu hành chính: {}", e.getMessage(), e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        sce.getServletContext().removeAttribute(PROVINCES_KEY);
        sce.getServletContext().removeAttribute(DISTRICTS_MAP_KEY);
        sce.getServletContext().removeAttribute(WARDS_MAP_KEY);
        log.info("Đã giải phóng dữ liệu hành chính khỏi RAM.");
    }
}
