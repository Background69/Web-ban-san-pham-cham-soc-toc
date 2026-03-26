package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "StaticPageController", urlPatterns = {"/StaticPage", "/terms", "/privacy", "/about", "/faq", "/guide", "/report"})
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
