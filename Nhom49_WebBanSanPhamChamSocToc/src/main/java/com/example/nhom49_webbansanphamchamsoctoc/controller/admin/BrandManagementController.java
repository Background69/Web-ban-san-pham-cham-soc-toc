package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/admin/brands",
        "/admin/brands/form",
        "/admin/brands/save",
        "/admin/brands/edit",
        "/admin/brands/delete"
})
public class BrandManagementController extends HttpServlet {

    private BrandDAO brandDAO;

    @Override
    public void init() {
        brandDAO = new BrandDAO();
    }
    // ================== GET ==================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/admin/brands":
                listBrand(request, response);
                break;

            case "/admin/brands/form":
                showForm(request, response);
                break;

            case "/admin/brands/edit":
                editBrand(request, response);
                break;

            case "/admin/brands/delete":
                deleteBrand(request, response);
                break;
        }
    }

    // ================== POST ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if ("/admin/brands/save".equals(request.getServletPath())) {
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

        Integer id = ValidationUtil.parseIntSafe(request.getParameter("id"));
        if (id == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
            return;
        }
        Brand brand = brandDAO.findById(id);

        request.setAttribute("brand", brand);
        request.getRequestDispatcher("/admin/brand/form.jsp")
                .forward(request, response);
    }

    private void saveBrand(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String idStr = request.getParameter("id");

        Brand brand = new Brand();
        brand.setBrandName(request.getParameter("brandName"));
        brand.setBrandSlug(request.getParameter("brandSlug"));
        brand.setLogoUrl(request.getParameter("logoUrl"));
        brand.setOrigin(request.getParameter("origin"));
        brand.setShortDescription(request.getParameter("shortDescription"));
        brand.setFullDescription(request.getParameter("fullDescription"));

        if (brand.getBrandName()==null|| brand.getBrandName().trim().isEmpty()) {
            request.setAttribute("branderror","Tên thương hiệu không được để trống");
            request.setAttribute("brand",brand);
            request.getRequestDispatcher("/admin/brand/form.jsp").forward(request,response);
            return;
        }
        try{
        if (idStr == null || idStr.isEmpty()) {
          // ADD
            brandDAO.insert(brand);
        } else {
            // UPDATE
            brand.setBrandId(Integer.parseInt(idStr));
            brandDAO.update(brand);
        }
    } catch (Exception e){
            e.printStackTrace();
            request.setAttribute("branderror", "Không thể lưu thương hiệu");
            request.setAttribute("brand", brand);
            request.getRequestDispatcher("/admin/brand/form.jsp").forward(request, response);
            return;

        }

        response.sendRedirect(request.getContextPath() + "/admin/brands");
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer id = ValidationUtil.parseIntSafe(request.getParameter("id"));
        if (id == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
            return;
        }
        brandDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/brands");
    }
}
