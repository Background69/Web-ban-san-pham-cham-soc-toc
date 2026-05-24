package com.example.nhom49_webbansanphamchamsoctoc.controller;

import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ImageDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Image;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.BrandService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ImageService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
/**
 * Lớp HomeController.
 */
public class HomeController extends HttpServlet {

    private ProductService productService;
    private CategoryDAO categoryDAO;
    private BrandService brandService;
    private ImageService imageService;

    /**
     * Khởi tạo tài nguyên hoặc cấu hình cần thiết.
     *
     * @throws ServletException nếu có lỗi xảy ra trong quá trình khởi tạo
     */
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryDAO = new CategoryDAO();
        brandService = new BrandService();
        imageService = new ImageService(new ImageDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadBanner(request);

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

    private void loadBanner(HttpServletRequest request) {
        Image newYearBanner = imageService.findByTitle("banner-he_qyezys");
        Image thuBanner = imageService.findByTitle("banner-thu_xufr9j");
        Image xuanBanner = imageService.findByTitle("banner-xuan_vpjhkm");
        Image dongBanner = imageService.findByTitle("banner-dong_mhpvz6");
        Image trungThuBanner = imageService.findByTitle("banner-trung-thu_jvbxoj");
        Image tetBanner = imageService.findByTitle("banner-tet_iqleqr");
        Image hungVuongBanner = imageService.findByTitle("banner-hung-vuong_pgfvjs");
        Image phuNuBanner = imageService.findByTitle("banner-phu-nu_g9qm7h");
        Image nhaGiaoBanner = imageService.findByTitle("banner-nha-giao_h0amss");
        Image quocKhanhBanner = imageService.findByTitle("banner-quoc-khanh_gpk4kb");

        request.setAttribute("newYearBanner", newYearBanner);
        request.setAttribute("thuBanner", thuBanner);
        request.setAttribute("xuanBanner", xuanBanner);
        request.setAttribute("dongBanner", dongBanner);
        request.setAttribute("trungThuBanner", trungThuBanner);
        request.setAttribute("tetBanner", tetBanner);
        request.setAttribute("hungVuongBanner", hungVuongBanner);
        request.setAttribute("phuNuBanner", phuNuBanner);
        request.setAttribute("nhaGiaoBanner", nhaGiaoBanner);
        request.setAttribute("quocKhanhBanner", quocKhanhBanner);
    }
}
