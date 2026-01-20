package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "StaticPageController", value = "/StaticPage")
public class StaticPageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String viewPath;

        switch (path) {
            case "/terms":
                viewPath = "/user/static-page/terms.jsp";
                break;
            case "/privacy":
                viewPath = "/user/static-page/privacy.jsp";
                break;
            case "/about":
                viewPath = "/user/static-page/about.jsp";
                break;
            case "/faq":
                viewPath = "/user/static-page/faq.jsp";
                break;
            case "/guide":
                viewPath = "/user/static-page/guide.jsp";
                break;
            case "/report":
                viewPath = "/user/static-page/report.jsp";
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
        }

        request.getRequestDispatcher(viewPath).forward(request, response);
    }
}