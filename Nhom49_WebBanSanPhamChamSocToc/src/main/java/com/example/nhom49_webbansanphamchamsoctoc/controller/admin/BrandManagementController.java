package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.example.nhom49_webbansanphamchamsoctoc.util.CloudinaryConfig;
import com.cloudinary.utils.ObjectUtils;

import java.io.IOException;
import java.util.Map;

@MultipartConfig
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
        // logoUrl will be set after possible upload
        brand.setOrigin(request.getParameter("origin"));
        brand.setShortDescription(request.getParameter("shortDescription"));
        brand.setFullDescription(request.getParameter("fullDescription"));

        if (brand.getBrandName() == null || brand.getBrandName().trim().isEmpty()) {
            request.setAttribute("branderror", "Tên thương hiệu không được để trống");
            request.setAttribute("brand", brand);
            request.getRequestDispatcher("/admin/brand/form.jsp").forward(request, response);
            return;
        }

        try {
            boolean isAdd = (idStr == null || idStr.isEmpty());
            int brandId = -1;

            if (isAdd) {
                // insert without logo first to obtain id
                brandId = brandDAO.insert(brand);
                if (brandId > 0) {
                    brand.setBrandId(brandId);
                } else {
                    throw new RuntimeException("Failed to insert brand");
                }
            } else {
                brandId = Integer.parseInt(idStr);
                brand.setBrandId(brandId);

                Brand oldBrand = brandDAO.findById(brandId);
                if (oldBrand != null) {
                    brand.setLogoUrl(oldBrand.getLogoUrl());
                }

                brandDAO.update(brand);
            }

            // Handle uploaded logo file if present
            Part logoPart = null;
            try {
                logoPart = request.getPart("logo");
            } catch (IllegalStateException | ServletException ignored) {
                // Not multipart or no file; ignore
            }

            if (logoPart != null && logoPart.getSize() > 0) {
                String contentType = logoPart.getContentType();
                if (!isAllowedImageType(contentType)) {
                    throw new IOException("Unsupported image type: " + contentType);
                }

                byte[] fileBytes = logoPart.getInputStream().readAllBytes();
                String publicId = "brand-" + (brand.getBrandSlug() != null && !brand.getBrandSlug().isBlank() ? brand.getBrandSlug() : brandId) + "-" + java.util.UUID.randomUUID();

                Map<?, ?> result = CloudinaryConfig.getInstance()
                        .uploader()
                        .upload(
                                fileBytes,
                                com.cloudinary.utils.ObjectUtils.asMap(
                                        "folder", "brands",
                                        "public_id", publicId,
                                        "overwrite", false,
                                        "invalidate", true,
                                        "resource_type", "image"
                                )
                        );

                String secureUrl = (String) result.get("secure_url");
                if (secureUrl == null || secureUrl.isBlank()) {
                    throw new IOException("Không lấy được URL logo từ Cloudinary");
                }

                brand.setLogoUrl(secureUrl);
                brandDAO.update(brand);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("branderror", "Không thể lưu thương hiệu");
            request.setAttribute("brand", brand);
            request.getRequestDispatcher("/admin/brand/form.jsp").forward(request, response);
            return;

        }

        response.sendRedirect(request.getContextPath() + "/admin/brands");
    }

    private boolean isAllowedImageType(String contentType) {
        return "image/jpeg".equals(contentType)
                || "image/png".equals(contentType)
                || "image/webp".equals(contentType)
                || "image/gif".equals(contentType);
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
