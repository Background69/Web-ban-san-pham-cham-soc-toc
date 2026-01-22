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
@WebServlet(name = "AdminDashBoardController", urlPatterns = {"/admin", "/admin/"})
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

    /**
     * Khởi tạo tài nguyên hoặc cau hinh can thiet.
     *
     * @return Không trả về giá trị.
     */
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thống kê
        request.setAttribute("totalProducts", productDAO.countAll());
        request.setAttribute("totalUsers", userDAO.findAll().size());
        request.setAttribute("totalOrders", orderDAO.findAll().size());
        request.setAttribute("pendingOrders", orderDAO.findByStatus("pending").size());

        // Recent orders
        var allOrders = orderDAO.findAll();
        request.setAttribute("recentOrders", allOrders.size() > 5 ? allOrders.subList(0, 5) : allOrders);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}