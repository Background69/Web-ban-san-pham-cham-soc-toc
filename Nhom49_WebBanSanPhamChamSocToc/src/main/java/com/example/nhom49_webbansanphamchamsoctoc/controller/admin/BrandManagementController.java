package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/admin/brand",
        "/admin/brand/form",
        "/admin/brand/save",
        "/admin/brand/edit",
        "/admin/brand/delete"
})
public class BrandManagementController extends HttpServlet {

    private BrandDAO brandDAO;

    @Override
    public void init() {
        brandDAO = new BrandDAO();
    }
        // Kiểm tra xem phải là Admin hay không
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

    // ================== GET ==================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdmin(request, response)) return;

        String path = request.getServletPath();

        switch (path) {
            case "/admin/brand":
                listBrand(request, response);
                break;

            case "/admin/brand/form":
                showForm(request, response);
                break;

            case "/admin/brand/edit":
                editBrand(request, response);
                break;

            case "/admin/brand/delete":
                deleteBrand(request, response);
                break;
        }
    }

    // ================== POST ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdmin(request, response)) return;

        if ("/admin/brand/save".equals(request.getServletPath())) {
            saveBrand(request, response);
        }
    }

    // ================== METHODS ==================

    private void listBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("brands", brandDAO.findAll());
        request.getRequestDispatcher("/admin/brand/list.jsp")
                .forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/admin/brand/form.jsp")
                .forward(request, response);
    }

    private void editBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Brand brand = brandDAO.findById(id);

        request.setAttribute("brand", brand);
        request.getRequestDispatcher("/admin/brand/form.jsp")
                .forward(request, response);
    }

    private void saveBrand(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");

        Brand brand = new Brand();
        brand.setBrandName(request.getParameter("brandName"));
        brand.setBrandSlug(request.getParameter("brandSlug"));
        brand.setLogoUrl(request.getParameter("logoUrl"));
        brand.setOrigin(request.getParameter("origin"));
        brand.setShortDescription(request.getParameter("shortDescription"));
        brand.setFullDescription(request.getParameter("fullDescription"));

        if (idStr == null || idStr.isEmpty()) {
            // ADD
            brandDAO.insert(brand);
        } else {
            // UPDATE
            brand.setBrandId(Integer.parseInt(idStr));
            brandDAO.update(brand);
        }

        response.sendRedirect(request.getContextPath() + "/admin/brand");
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        brandDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/brand");
    }
}
