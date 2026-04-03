package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.services.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import static com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil.parseIntSafe;

@WebServlet(urlPatterns = {
        "/admin/category",
        "/admin/categories",
        "/admin/category/add",
        "/admin/categories/add",
        "/admin/category/edit",
        "/admin/categories/edit",
        "/admin/category/save",
        "/admin/categories/save",
        "/admin/category/delete",
        "/admin/categories/delete"
})
public class CategoryManagementController extends HttpServlet {

    private CategoryService categoryService;

    @Override
    public void init() {
        categoryService = new CategoryService();
    }

    // ===== GET =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {

            case "/admin/category":
            case "/admin/categories":
                listCategory(request, response);
                break;

            case "/admin/category/add":
            case "/admin/categories/add":
                request.getRequestDispatcher("/admin/category/form.jsp").forward(request, response);
                break;

            case "/admin/category/edit":
            case "/admin/categories/edit":
                int id = parseIntSafe(request.getParameter("id"));
                if (id > 0) {
                    Category c = categoryService.getCategoryById(id);
                    request.setAttribute("category", c);
                    request.getRequestDispatcher("/admin/category/form.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                }
                break;

            case "/admin/category/delete":
            case "/admin/categories/delete":
                int deleteId = parseIntSafe(request.getParameter("id"));
                if (deleteId > 0) {
                    categoryService.deleteCategory(deleteId);
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ===== POST =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        if ("/admin/category/save".equals(request.getServletPath())
                || "/admin/categories/save".equals(request.getServletPath())) {
            saveCategory(request, response);
        }
    }

    // ===== SAVE =====
    private void saveCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = trimOrEmpty(request.getParameter("id"));
        String name = trimOrEmpty(request.getParameter("categoryName"));
        String slug = trimOrEmpty(request.getParameter("categorySlug"));

        // VALIDATE
        if (name.isEmpty() || name.length() > 100) {
            redirectError(response, request, "Tên không hợp lệ");
            return;
        }

        if (slug.isEmpty() || slug.length() > 120) {
            redirectError(response, request, "Slug không hợp lệ");
            return;
        }

        // CREATE
        if (idStr.isEmpty()) {
            Category c = new Category();
            c.setCategoryName(name);
            c.setCategorySlug(slug);

            int newId = categoryService.createCategory(c);
            if (newId <= 0) {
                redirectError(response, request, "Thêm thất bại");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        // UPDATE
        int id = parseIntSafe(idStr);
        Category exist = categoryService.getCategoryById(id);

        if (exist == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        exist.setCategoryName(name);
        exist.setCategorySlug(slug);

        boolean ok = categoryService.updateCategory(exist);
        if (!ok) {
            redirectError(response, request, "Cập nhật thất bại");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    // ===== LIST =====
    private void listCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/category/list.jsp").forward(request, response);
    }

    // ===== UTILS =====
    private int parseIntSafe(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return -1;
        }
    }

    private String trimOrEmpty(String s) {
        return (s == null) ? "" : s.trim();
    }

    private void redirectError(HttpServletResponse response, HttpServletRequest request, String message)
            throws IOException {

        String msg = URLEncoder.encode(message, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/admin/categories/add?error=" + msg);
    }
}
