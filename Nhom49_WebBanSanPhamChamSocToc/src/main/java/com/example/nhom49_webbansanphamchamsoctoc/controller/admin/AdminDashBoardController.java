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
import java.util.List;

/**
 * Servlet hiển thị Admin Dashboard
 * GET /admin: Dashboard với thống kê
 */
@WebServlet(name = "AdminDashBoardController", urlPatterns = { "/admin/dashboard", "/admin/dashboard-data"})
public class AdminDashBoardController extends HttpServlet {
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
        String path = request.getServletPath();
        //ajax
        if ("/admin/dashboard-data".equals(path)) {
            handleAjax(request, response);
            return;
        }
        try {
            // Thống kê
            request.setAttribute("totalProducts", productDAO.countAll());
            request.setAttribute("totalUsers", userDAO.countAll());
            request.setAttribute("totalOrders", orderDAO.countOrders());
            request.setAttribute("totalRevenue", orderDAO.totalRevenue());

            // Đơn hàng gần nhất (CHỈ SET 1 LẦN)
            request.setAttribute("recentOrders", orderDAO.findRecentOrder(5));
            request.getRequestDispatcher("/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("dashboardError", "Không tải được dữ liệu");
        }
    }

    private void handleAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String type = request.getParameter("type");
        if (type == null) type = "week";
        List<Integer> revenueData;
        String revenueLabels;
        switch (type) {
            case "month":
                revenueData = orderDAO.getRevenueByMonth();
                revenueLabels = "[\"T1\",\"T2\",\"T3\",\"T4\",\"T5\",\"T6\",\"T7\",\"T8\",\"T9\",\"T10\",\"T11\",\"T12\"]";
                break;
            case "year":
                revenueData = orderDAO.getRevenueByYear();
                revenueLabels = "[\"2022\",\"2023\",\"2024\",\"2025\",\"2026\"]";
                break;
            default:
                revenueData = orderDAO.getRevenueByWeek();
                revenueLabels = "[\"Thứ 2\",\"Thứ 3\",\"Thứ 4\",\"Thứ 5\",\"Thứ 6\",\"Thứ 7\",\"Chủ Nhật\"]";
        }
        List<Integer> statusData = orderDAO.getOrderStatusStats();
        String statusLabels = "[\"Hoàn thành\",\"Đã huỷ\",\"Chờ xử lý\"]";
        response.setContentType("application/json;charset=UTF-8");
        String json = "{ \"labels\":" + revenueLabels + ", \"values\":" + revenueData.toString() + "," + "\"statusLabels\":" + statusLabels + "," + "\"statusValues\":" + statusData.toString() + "}";
        response.getWriter().write(json);
    }
}