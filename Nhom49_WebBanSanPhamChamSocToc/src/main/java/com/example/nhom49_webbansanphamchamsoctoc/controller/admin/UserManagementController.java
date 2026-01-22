package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserManagementController", value = "/UserManagementController")
public class UserManagementController extends HttpServlet {
    UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        //Nếu chưa đăng nhập chuyển sang trang Login
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        //Check có phải role Admin hay không
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyeefn truy cập");
            return;
        }
        String action = request.getParameter("action");
        //Xoá User
        if ("delete".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.delete(id);
            response.sendRedirect(request.getContextPath()+ "/admin/users");
            return;
        }
        // Sửa lại User
        if ("edit".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            User user =userDAO.findById(id);
            request.setAttribute("user", user);
            request.getRequestDispatcher("view/admin/usermanagement.jsp")
                    .forward(request, response);
        }
        List<User> users = userDAO.findAll();
        request.setAttribute("user", users);
        request.getRequestDispatcher("view/admin/users")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        //Lưu form sau khi chỉnh sửa lại profile User
        if ("update".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            User user = new User();
            user.setUserId(id);
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            userDAO.update(user);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}