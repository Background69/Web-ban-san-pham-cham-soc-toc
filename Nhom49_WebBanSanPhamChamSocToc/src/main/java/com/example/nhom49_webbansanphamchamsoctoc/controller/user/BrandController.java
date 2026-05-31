package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.BrandService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BrandController", urlPatterns = {"/brands", "/brand/*"})
public class BrandController extends HttpServlet {
    private BrandService brandService;
    private ProductService productService;


    @Override
    public void init() throws ServletException {
        super.init();
        this.brandService = new BrandService();
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (requestURI.equals(contextPath + "/brands")) {
            // Hiển thị danh sách thương hiệu
            showBrandList(request, response);
        } else if (requestURI.startsWith(contextPath + "/brand/")) {
            // Hiển thị chỉ tiết thương hiệu
            showBrandDetail(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showBrandList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Brand> brands = brandService.getAllBrands();
        request.setAttribute("brands", brands);
        request.setAttribute("totalBrands", brands.size());

        // Lấy danh sách xuất xứ unique
        List<String> origins = brandService.getAllOrigins();
        request.setAttribute("origins", origins);

        request.getRequestDispatcher("/user/brand/brand-list.jsp").forward(request, response);
    }

    private void showBrandDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/brands");
            return;
        }

        String slug = pathInfo.substring(1); // Bỏ dấu "/" đầu tiên
        Brand brand = brandService.getBrandBySlug(slug);

        if (brand == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy thương hiệu");
            return;
        }

        // Lấy sản phẩm của thương hiệu với phân trang từ DB
        int page = 1;
        int pageSize = 12;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int totalProducts = productService.countProductsByBrand(brand.getBrandId());
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages > 0 && page > totalPages) {
            page = totalPages;
        }

        List<Product> products = productService.getProductsByBrand(brand.getBrandId(), page, pageSize);

        // Lấy tất cả sản phẩm brand để tính category stats
        List<Product> allBrandProducts = productService.getProductsByBrand(brand.getBrandId());
        Map<Integer, Category> categoryMap = new LinkedHashMap<>();
        Map<String, Integer> categoryStats = new LinkedHashMap<>();
        for (Product product : allBrandProducts) {
            Category category = product.getCategory();
            if (category == null) {
                continue;
            }
            categoryMap.putIfAbsent(category.getCategoryId(), category);
            categoryStats.put(category.getCategoryName(),
                    categoryStats.getOrDefault(category.getCategoryName(), 0) + 1);
        }

        request.setAttribute("brand", brand);
        request.setAttribute("products", products);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", new ArrayList<>(categoryMap.values()));
        request.setAttribute("categoryStats", categoryStats);
        request.setAttribute("paginationBaseUrl", request.getContextPath() + "/brand/" + slug);

        request.getRequestDispatcher("/user/brand/brand-detail.jsp").forward(request, response);
    }
}
