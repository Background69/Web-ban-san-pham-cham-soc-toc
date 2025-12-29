package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
@WebServlet(name = "LoginController", value = "/Login")
public class LoginController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/authentication/login.jsp").forward(request, response);

    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        String email = request.getParameter("email");
        String password = request.getParameter("password");


        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mật khẩu");
            request.getRequestDispatcher("/views/authentication/login.jsp").forward(request, response);

            return;
        }


        if (email.equals("admin@gmail.com") && password.equals("123456")) {


            HttpSession session = request.getSession();
            session.setAttribute("userEmail", email);


            response.sendRedirect(request.getContextPath() + "/Home");

        } else {

            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("/views/authentication/login.jsp").forward(request, response);

        }
    }
}
