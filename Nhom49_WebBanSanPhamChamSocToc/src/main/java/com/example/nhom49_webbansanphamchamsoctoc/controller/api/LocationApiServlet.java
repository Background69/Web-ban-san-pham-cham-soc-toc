package com.example.nhom49_webbansanphamchamsoctoc.controller.api;

import com.example.nhom49_webbansanphamchamsoctoc.model.District;
import com.example.nhom49_webbansanphamchamsoctoc.model.Province;
import com.example.nhom49_webbansanphamchamsoctoc.model.Ward;
import com.example.nhom49_webbansanphamchamsoctoc.util.ProvinceDataLoader;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "LocationApiServlet", urlPatterns = {"/api/provinces", "/api/districts", "/api/wards"})
public class LocationApiServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String servletPath = request.getServletPath();

        switch (servletPath) {
            case "/api/provinces":
                handleProvinces(request, response);
                break;
            case "/api/districts":
                handleDistricts(request, response);
                break;
            case "/api/wards":
                handleWards(request, response);
                break;
            default:
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Endpoint không hợp lệ");
        }
    }

    @SuppressWarnings("unchecked")
    private void handleProvinces(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Province> provinces =
                (List<Province>) getServletContext().getAttribute(ProvinceDataLoader.PROVINCES_KEY);

        if (provinces == null) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Dữ liệu chưa được nạp");
            return;
        }

        JsonArray arr = new JsonArray();
        for (Province p : provinces) {
            JsonObject obj = new JsonObject();
            obj.addProperty("code", p.getCode());
            obj.addProperty("name", p.getName());
            obj.addProperty("fullName", p.getFullName());
            arr.add(obj);
        }
        response.getWriter().write(arr.toString());
    }

    @SuppressWarnings("unchecked")
    private void handleDistricts(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String provinceCode = request.getParameter("provinceCode");

        if (provinceCode == null || provinceCode.isBlank()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số provinceCode");
            return;
        }

        Map<String, List<District>> districtsMap =
                (Map<String, List<District>>) getServletContext().getAttribute(ProvinceDataLoader.DISTRICTS_MAP_KEY);

        if (districtsMap == null) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Dữ liệu chưa được nạp");
            return;
        }

        List<District> districts = districtsMap.get(provinceCode);
        if (districts == null) {
            sendError(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tỉnh: " + provinceCode);
            return;
        }

        JsonArray arr = new JsonArray();
        for (District d : districts) {
            JsonObject obj = new JsonObject();
            obj.addProperty("code", d.getCode());
            obj.addProperty("name", d.getName());
            obj.addProperty("fullName", d.getFullName());
            arr.add(obj);
        }
        response.getWriter().write(arr.toString());
    }

    @SuppressWarnings("unchecked")
    private void handleWards(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String districtCode = request.getParameter("districtCode");

        if (districtCode == null || districtCode.isBlank()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số districtCode");
            return;
        }

        Map<String, List<Ward>> wardsMap =
                (Map<String, List<Ward>>) getServletContext().getAttribute(ProvinceDataLoader.WARDS_MAP_KEY);

        if (wardsMap == null) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Dữ liệu chưa được nạp");
            return;
        }

        List<Ward> wards = wardsMap.get(districtCode);
        if (wards == null) {
            sendError(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy quận/huyện: " + districtCode);
            return;
        }

        JsonArray arr = new JsonArray();
        for (Ward w : wards) {
            JsonObject obj = new JsonObject();
            obj.addProperty("code", w.getCode());
            obj.addProperty("name", w.getName());
            obj.addProperty("fullName", w.getFullName());
            arr.add(obj);
        }
        response.getWriter().write(arr.toString());
    }

    private void sendError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        JsonObject error = new JsonObject();
        error.addProperty("error", message);
        response.getWriter().write(error.toString());
    }
}
