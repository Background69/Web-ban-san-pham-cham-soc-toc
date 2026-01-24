package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.PromotionDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Promotion;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "FlashSaleManagementController", value = "/FlashSaleManagementController")
public class        FlashSaleManagementController extends HttpServlet {
    private PromotionDAO promotionDAO;

    public void init(){

    promotionDAO =new PromotionDAO();
}
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);


        //Nếu chưa đăng nhập chuyển sang trang Login
        if (session==null|| session.getAttribute("currentUser")==null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        //Check có phải role Admin hay không
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())){
            response.sendError(HttpServletResponse.SC_FORBIDDEN,"Không có quyeefn truy cập");
            return;
        }
        java.util.List<Promotion> promotions = promotionDAO.findAll();
        request.setAttribute("promotions", promotions);

        request.getRequestDispatcher("/admin/FlashSalePromotionManagement.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/flash-sale");
            return;
        }

        switch (action) {
            case "add":
                addPromotion(request);
                break;

            case "update":
                updatePromotion(request);
                break;

            case "delete":
                deletePromotion(request);
                break;
        }

        response.sendRedirect(request.getContextPath() + "/admin/flash-sale");
    }

    /* ================== PRIVATE METHODS ================== */

    private void addPromotion(HttpServletRequest request) {
        Promotion p = new Promotion();

        p.setDiscountPercent(Integer.parseInt(request.getParameter("discount")));
        p.setStartDate(LocalDateTime.parse(request.getParameter("start")));
        p.setEndDate(LocalDateTime.parse(request.getParameter("end")));
        p.setActive(request.getParameter("active") != null);

        promotionDAO.insert(p);
    }

    private void updatePromotion(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        Promotion p = promotionDAO.findById(id);

        if (p != null) {
            p.setDiscountPercent(Integer.parseInt(request.getParameter("discount")));
            p.setStartDate(LocalDateTime.parse(request.getParameter("start")));
            p.setEndDate(LocalDateTime.parse(request.getParameter("end")));
            p.setActive(request.getParameter("active") != null);

            promotionDAO.update(p);
        }
    }

    private void deletePromotion(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        promotionDAO.delete(id);
    }
}