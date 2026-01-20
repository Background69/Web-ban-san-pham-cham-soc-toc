package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

/**
 * Servlet hiển thị Admin Dashboard
 * GET /admin: Dashboard với thống kê
 */
@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin", "/admin/"})
public class AdminDashBoardController extends HttpServlet {
    UserDAO userDAO = new UserDAO();
    ProductDAO productDAO = new ProductDAO();
    OrderDAO orderDAO = new OrderDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        //Nếu chưa đăng nhập chuyển sang trang đăng nhập
        if (session==null|| session.getAttribute("currentUser")==null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        //Check có phải role Admin hay không
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyên truy cập");
            return;
        }

        int userCount = userDAO.countUsers();
        int productCount = productDAO.countAll();
        int orderCount = orderDAO.countOrders();
        long totalRevenue = orderDAO.totalRevenue();
        List<Order> recentOrders = orderDAO.findRecentOrder(10);
        request.setAttribute("userCount",userCount);
        request.setAttribute("productCount",productCount);
        request.setAttribute("orderCount",orderCount);
        request.setAttribute("totalRevenue",totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.getRequestDispatcher("/admin/dashboard.jsp")
                .forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}