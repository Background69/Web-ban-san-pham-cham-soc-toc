package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserManagementController", value = "/admin/users")
public class UserManagementController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        // Check role
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        String action = request.getParameter("action");

        /* ===================== DELETE ===================== */
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        /* ===================== DETAIL ===================== */
        if ("detail".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.findById(id);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin/users/detail.jsp")
                    .forward(request, response);
            return;
        }

        /* ===================== LIST (default) ===================== */
        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/user/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        /* ===================== UPDATE ===================== */
        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String role = request.getParameter("role");

            User user = new User();
            user.setUserId(id);
            user.setRole(role);

            userDAO.update(user);

            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
