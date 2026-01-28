package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.PromotionDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Promotion;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "FlashSaleManagementController", value = "/admin/flash-sale")
public class FlashSaleManagementController extends HttpServlet {
    private PromotionDAO promotionDAO;

    @Override
    public void init() {
        promotionDAO = new PromotionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        request.setAttribute("promotions", promotionDAO.findAll());
        request.getRequestDispatcher("/admin/promotion/flash-sale.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "add" -> add(request);
                case "update" -> update(request);
                case "delete" -> delete(request);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/flash-sale");
    }

    private void add(HttpServletRequest request) {
        Promotion p = new Promotion();
        p.setPromotionName(request.getParameter("promotionName"));
        p.setPromotionType(request.getParameter("promotionType"));
        p.setBadgeText(request.getParameter("badgeText"));

        String dp = request.getParameter("discountPercent");
        p.setDiscountPercent(dp == null || dp.isBlank() ? null : Integer.parseInt(dp));

        p.setStartDate(parseDateTime(request.getParameter("startDate")));
        p.setEndDate(parseDateTime(request.getParameter("endDate")));
        p.setActive(request.getParameter("isActive") != null);

        promotionDAO.insert(p);
    }

    private void update(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("promotionId"));
        Promotion p = promotionDAO.findById(id);
        if (p == null) return;

        p.setPromotionName(request.getParameter("promotionName"));
        p.setPromotionType(request.getParameter("promotionType"));
        p.setBadgeText(request.getParameter("badgeText"));

        String dp = request.getParameter("discountPercent");
        p.setDiscountPercent(dp == null || dp.isBlank() ? null : Integer.parseInt(dp));

        p.setStartDate(parseDateTime(request.getParameter("startDate")));
        p.setEndDate(parseDateTime(request.getParameter("endDate")));
        p.setActive(request.getParameter("isActive") != null);

        promotionDAO.update(p);
    }

    private void delete(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("promotionId"));
        promotionDAO.delete(id);
    }

    private LocalDateTime parseDateTime(String s) {
        if (s == null || s.isBlank()) return null;
        return LocalDateTime.parse(s);
    }
}
