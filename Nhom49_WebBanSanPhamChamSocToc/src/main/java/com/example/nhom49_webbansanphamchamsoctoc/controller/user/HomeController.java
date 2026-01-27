package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.BrandService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = { "/home", "" })
/**
 * Lớp HomeController.
 */
public class HomeController extends HttpServlet {

    private ProductService productService;
    private CategoryDAO categoryDAO;
    private BrandService brandService;

    /**
     * Khởi tạo tài nguyên hoặc cấu hình cần thiết.
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
        List<Product> featuredProducts = productService.getFeaturedProducts();
        request.setAttribute("featuredProducts", featuredProducts);
        // Lấy on-sale products cho Flash Sale
        List<Product> saleProducts = productService.getOnSaleProducts();
        request.setAttribute("saleProducts", saleProducts);
        // Lấy top 8 categories có nhiều sản phẩm nhất cho trang chủ
        request.setAttribute("topCategories", categoryDAO.findTopByProductCount(8));

        // Lấy brands cho section thương hiệu
        request.setAttribute("brands", brandService.getAllBrands());

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
