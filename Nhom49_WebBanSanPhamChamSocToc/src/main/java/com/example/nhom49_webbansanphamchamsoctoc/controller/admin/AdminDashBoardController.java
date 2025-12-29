package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/admin")
public class AdminDashBoardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session==null||session.getAttribute("currentUser")==null)
            {
                response.sendRedirect(request.getContextPath()+"/login");
                return;
            }
            String role = (String) session.getAttribute("role");
            if (!"admin".equals(role)){
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập");
                return;
            }
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
//            UserDAO userDAO= new UserDAOImpl();
//            int userCount = userDAO.countUsers();
//            request.setAttribute("userCount", userCount);


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}