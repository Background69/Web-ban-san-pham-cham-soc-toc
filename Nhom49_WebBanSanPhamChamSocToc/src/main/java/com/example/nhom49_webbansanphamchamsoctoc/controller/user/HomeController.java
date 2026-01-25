package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.services.BrandService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
/**
 * Lớp HomeController.
 */
public class HomeController extends HttpServlet {

    private ProductService productService;
    private CategoryDAO categoryDAO;
    private BrandService brandService;

    /**
     * Khởi tạo tài nguyên hoặc cau hinh can thiet.
     *
     * @return Không trả về giá trị.
     */
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryDAO = new CategoryDAO();
        brandService = new BrandService();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy featured products
        request.setAttribute("featuredProducts", productService.getFeaturedProducts());

        // Lấy on-sale products cho Flash Sale
        request.setAttribute("saleProducts", productService.getOnSaleProducts());

        // Lấy categories cho navigation
        request.setAttribute("categories", categoryDAO.findAll());

        // Lấy brands cho section thương hiệu
        request.setAttribute("brands", brandService.getAllBrands());

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}