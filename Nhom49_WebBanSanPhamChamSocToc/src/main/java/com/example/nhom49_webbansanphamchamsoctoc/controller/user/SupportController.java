package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "SupportController", value = "/Support")
public class SupportController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/user/support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Xử lý tìm kiếm hỗ trợ
        String query = request.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            // Tìm kiếm trỗng FAQ
            // List<FAQ> results = faqService.search(query);
            // request.setAttribute("searchResults", results);
            request.setAttribute("searchQuery", query);
        }

        request.getRequestDispatcher("/user/support.jsp").forward(request, response);
    }
}