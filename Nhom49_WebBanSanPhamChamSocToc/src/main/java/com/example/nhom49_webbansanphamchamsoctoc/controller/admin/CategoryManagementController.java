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

@WebServlet(urlPatterns = {
        "/admin/categories",
        "/admin/category/add",
        "/admin/category/edit",
        "/admin/category/save",
        "/admin/category/delete"
})
public class CategoryManagementController extends HttpServlet {

    private CategoryService categoryService;

    @Override
    public void init() {
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/categories".equals(path)) {
            listCategory(request, response);
            return;
        }

        if ("/admin/category/add".equals(path)) {
            request.getRequestDispatcher("/admin/category/form.jsp").forward(request, response);
            return;
        }

        if ("/admin/category/edit".equals(path)) {
            int id = parseIntSafe(request.getParameter("id"));
            if (id > 0) {
                Category c = categoryService.getCategoryById(id);
                if (c != null) {
                    request.setAttribute("category", c);
                    request.getRequestDispatcher("/admin/category/form.jsp").forward(request, response);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        if ("/admin/category/delete".equals(path)) {
            int id = parseIntSafe(request.getParameter("id"));
            if (id > 0) {
                categoryService.deleteCategory(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if (!"/admin/category/save".equals(path)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String idStr = trimOrEmpty(request.getParameter("id"));
        String name = trimOrEmpty(request.getParameter("categoryName"));
        String slug = trimOrEmpty(request.getParameter("categorySlug"));

        if (name.isEmpty() || name.length() > 100) {
            String msg = URLEncoder.encode("Tên danh mục không hợp lệ", StandardCharsets.UTF_8);
            String back = idStr.isEmpty() ? "/admin/category/add" : ("/admin/category/edit?id=" + idStr);
            response.sendRedirect(request.getContextPath() + back + "&error=" + msg);
            return;
        }

        if (slug.isEmpty() || slug.length() > 120) {
            String msg = URLEncoder.encode("Slug không hợp lệ", StandardCharsets.UTF_8);
            String back = idStr.isEmpty() ? "/admin/category/add" : ("/admin/category/edit?id=" + idStr);
            response.sendRedirect(request.getContextPath() + back + "&error=" + msg);
            return;
        }

        if (idStr.isEmpty()) {
            Category c = new Category();
            c.setCategoryName(name);
            c.setCategorySlug(slug);

            int newId = categoryService.createCategory(c);
            if (newId <= 0) {
                String msg = URLEncoder.encode("Thêm danh mục thất bại", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/admin/category/add?error=" + msg);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        int id = parseIntSafe(idStr);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        Category exist = categoryService.getCategoryById(id);
        if (exist == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        exist.setCategoryName(name);
        exist.setCategorySlug(slug);

        boolean ok = categoryService.updateCategory(exist);
        if (!ok) {
            String msg = URLEncoder.encode("Cập nhật thất bại", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/admin/category/edit?id=" + id + "&error=" + msg);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void listCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/category/list.jsp").forward(request, response);
    }

    private int parseIntSafe(String s) {
        try {
            if (s == null) return -1;
            s = s.trim();
            if (s.isEmpty()) return -1;
            return Integer.parseInt(s);
        } catch (Exception e) {
            return -1;
        }
    }

    private String trimOrEmpty(String s) {
        return s == null ? "" : s.trim();
    }
}
