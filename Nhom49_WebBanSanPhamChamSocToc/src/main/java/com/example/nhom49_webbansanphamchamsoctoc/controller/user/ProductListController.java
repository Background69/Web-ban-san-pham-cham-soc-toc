package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductListController", value = "/ProductList")
public class ProductListController extends HttpServlet {
    private static final int PAGE_SIZE = 12;


    private ProductService productService;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryDAO = new CategoryDAO();
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy parameters
        String categoryParam = request.getParameter("category");
        String brandParam = request.getParameter("brand");
        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");

        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Product> products;
        int totalPages;

        // Filter by category
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryParam);
                products = productService.getProductsByCategory(categoryId, page, PAGE_SIZE);
                totalPages = productService.getTotalPagesByCategory(categoryId, PAGE_SIZE);
                request.setAttribute("selectedCategory", categoryId);
            } catch (NumberFormatException e) {
                products = productService.getAllProducts(page, PAGE_SIZE);
                totalPages = productService.getTotalPages(PAGE_SIZE);
            }
        }
        // Filter by brand
        else if (brandParam != null && !brandParam.isEmpty()) {
            try {
                int brandId = Integer.parseInt(brandParam);
                products = productService.getProductsByBrand(brandId);
                totalPages = 1; // Brand filter không có pagination
                request.setAttribute("selectedBrand", brandId);
            } catch (NumberFormatException e) {
                products = productService.getAllProducts(page, PAGE_SIZE);
                totalPages = productService.getTotalPages(PAGE_SIZE);
            }
        }
        // Search by keyword
        else if (keyword != null && !keyword.trim().isEmpty()) {
            products = productService.searchProducts(keyword.trim());
            totalPages = 1; // Search không có pagination
            request.setAttribute("keyword", keyword);
        }
        // All products
        else {
            products = productService.getAllProducts(page, PAGE_SIZE);
            totalPages = productService.getTotalPages(PAGE_SIZE);
        }

        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", categoryDAO.findAll());
        request.setAttribute("brands", brandDAO.findAll());

        request.getRequestDispatcher("/user/product/product-list.jsp").forward(request, response);
    }
}