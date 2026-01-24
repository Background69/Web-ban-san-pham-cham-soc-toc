package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CategoryManagementController", value = "/CategoryManagementController")
public class CategoryManagementController extends HttpServlet {
    private CategoryDAO categoryDAO;
    public void init(){
        categoryDAO = new CategoryDAO();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);


        //Nếu chưa đăng nhập chuyển sang trang Login
        if (session==null|| session.getAttribute("currentUser")==null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        //Check có phải role Admin hay không
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())){
            response.sendError(HttpServletResponse.SC_FORBIDDEN,"Không có quyeefn truy cập");
            return;
        }
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories",categories);
        request.getRequestDispatcher("/admin/CategoryManagement.jsp")
                .forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        switch (action) {
            case "add": {
                Category category = new Category();
                category.setCategoryName(request.getParameter("name"));
                category.setCategorySlug(request.getParameter("slug"));
                categoryDAO.insert(category);
                break;
            }

            case "update": {
                int id = Integer.parseInt(request.getParameter("id"));
                Category category = categoryDAO.findById(id);
                if (category != null) {
                    category.setCategoryName(request.getParameter("name"));
                    category.setCategorySlug(request.getParameter("slug"));
                    categoryDAO.update(category);
                }
                break;
            }

            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.delete(id);
                break;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

}