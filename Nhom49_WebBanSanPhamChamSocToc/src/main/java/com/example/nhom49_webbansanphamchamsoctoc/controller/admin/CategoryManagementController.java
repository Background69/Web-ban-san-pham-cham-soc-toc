package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/admin/category",
        "/admin/category/form",
        "/admin/category/edit",
        "/admin/category/save",
        "/admin/category/delete"
})
public class CategoryManagementController extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    // ====== CHECK LOGIN + ROLE ======
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        User user = (User) session.getAttribute("currentUser");
        if (!"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return false;
        }
        return true;
    }

    // ====== GET ======
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdmin(request, response)) return;

        String path = request.getServletPath();

        switch (path) {
            case "/admin/category":
                listCategory(request, response);
                break;

            case "/admin/category/form":
                showForm(request, response);
                break;

            case "/admin/category/edit":
                editCategory(request, response);
                break;

            case "/admin/category/delete":
                deleteCategory(request, response);
                break;
        }
    }

    // ====== POST ======
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdmin(request, response)) return;

        if ("/admin/category/save".equals(request.getServletPath())) {
            saveCategory(request, response);
        }
    }

    // ====== HANDLER METHODS ======

    private void listCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("categories", categoryDAO.findAll());
        request.getRequestDispatcher("/admin/category/list.jsp")
                .forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/admin/category/form.jsp")
                .forward(request, response);
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDAO.findById(id);

        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/category/form.jsp")
                .forward(request, response);
    }

    private void saveCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");

        Category category = new Category();
        category.setCategoryName(request.getParameter("categoryName"));
        category.setCategorySlug(request.getParameter("categorySlug"));

        if (idStr == null || idStr.isEmpty()) {
            categoryDAO.insert(category);
        } else {
            category.setCategoryId(Integer.parseInt(idStr));
            categoryDAO.update(category);
        }

        response.sendRedirect(request.getContextPath() + "/admin/category");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        categoryDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/category");
    }
}
