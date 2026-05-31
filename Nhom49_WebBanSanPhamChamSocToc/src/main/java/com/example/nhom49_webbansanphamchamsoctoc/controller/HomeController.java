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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    private ProductService productService;
    private CategoryDAO categoryDAO;
    private BrandService brandService;
    private ImageService imageService;

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
        LocalDate today = LocalDate.now();
        int year = today.getYear();

        List<Image> activeBanners = new ArrayList<>();

        Image summerBanner = imageService.findByTitle("banner-he_qyezys");
        Image thuBanner = imageService.findByTitle("banner-thu_xufr9j");
        Image xuanBanner = imageService.findByTitle("banner-xuan_vpjhkm");
        Image dongBanner = imageService.findByTitle("banner-dong_mhpvz6");
        Image trungThuBanner = imageService.findByTitle("banner-trung-thu_jvbxoj");
        Image tetBanner = imageService.findByTitle("banner-tet_iqleqr");
        Image hungVuongBanner = imageService.findByTitle("banner-hung-vuong_pgfvjs");
        Image phuNuBanner = imageService.findByTitle("banner-phu-nu_g9qm7h");
        Image nhaGiaoBanner = imageService.findByTitle("banner-nha-giao_h0amss");
        Image quocKhanhBanner = imageService.findByTitle("banner-quoc-khanh_gpk4kb");

        addBannerIfActive(activeBanners, hungVuongBanner,
                LocalDate.of(year, 4, 15),
                LocalDate.of(year, 4, 25),
                today);

        addBannerIfActive(activeBanners, quocKhanhBanner,
                LocalDate.of(year, 8, 28),
                LocalDate.of(year, 9, 3),
                today);

        addBannerIfActive(activeBanners, trungThuBanner,
                LocalDate.of(year, 9, 20),
                LocalDate.of(year, 9, 30),
                today);

        addBannerIfActive(activeBanners, phuNuBanner,
                LocalDate.of(year, 10, 10),
                LocalDate.of(year, 10, 20),
                today);

        addBannerIfActive(activeBanners, nhaGiaoBanner,
                LocalDate.of(year, 11, 15),
                LocalDate.of(year, 11, 20),
                today);

        addBannerIfActive(activeBanners, xuanBanner,
                LocalDate.of(year, 2, 1),
                LocalDate.of(year, 2, 28),
                today);

        addBannerIfActive(activeBanners, summerBanner,
                LocalDate.of(year, 6, 1),
                LocalDate.of(year, 6, 30),
                today);

        addBannerIfActive(activeBanners, thuBanner,
                LocalDate.of(year, 8, 15),
                LocalDate.of(year, 9, 30),
                today);

        addBannerIfActive(activeBanners, dongBanner,
                LocalDate.of(year, 12, 1),
                LocalDate.of(year, 12, 31),
                today);

        addBannerIfActive(activeBanners, tetBanner,
                LocalDate.of(year, 1, 20),
                LocalDate.of(year, 2, 5),
                today);

        // Nếu hôm nay không có banner lễ/mùa nào thì fallback banner mặc định
        if (activeBanners.isEmpty()) {
            addIfNotNull(activeBanners, summerBanner);
            addIfNotNull(activeBanners, thuBanner);
            addIfNotNull(activeBanners, xuanBanner);
            addIfNotNull(activeBanners, dongBanner);
        }

        request.setAttribute("activeBanners", activeBanners);
    }

    private void addBannerIfActive(List<Image> banners, Image banner, LocalDate startDate, LocalDate endDate, LocalDate today) {
        if (banner == null) return;

        boolean isActive = !today.isBefore(startDate) && !today.isAfter(endDate);

        if (isActive) banners.add(banner);

    }

    private void addIfNotNull(List<Image> banners, Image banner) {
        if (banner != null) banners.add(banner);

    }
}
