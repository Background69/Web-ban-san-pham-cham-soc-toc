package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;

/**
 * Servlet hiển thị Admin Dashboard
 * GET /admin: Dashboard với thống kê
 */
@WebServlet(name = "AdminDashBoardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashBoardController extends HttpServlet {
    //UserDAO userDAO = new UserDAO();
    //ProductDAO productDAO = new ProductDAO();
    //OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Thống kê
            request.setAttribute("totalProducts", productDAO.countAll());
            request.setAttribute("totalUsers", userDAO.findAll().size());
            request.setAttribute("totalOrders", orderDAO.findAll().size());
            request.setAttribute("pendingOrders", orderDAO.countByStatus("pending"));

            // Đơn hàng gần nhất (CHỈ SET 1 LẦN)
            request.setAttribute("recentOrders", orderDAO.findRecentOrder(5));

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("dashboardError", "Không tải được dữ liệu");
        }

        request.getRequestDispatcher("/admin/dashboard.jsp")
                .forward(request, response);
    }

}