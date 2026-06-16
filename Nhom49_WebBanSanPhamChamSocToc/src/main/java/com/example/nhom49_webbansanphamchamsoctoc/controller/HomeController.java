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
import java.util.Collections;
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

        List<Product> featuredProducts = productService.getFeaturedProducts();
        request.setAttribute("featuredProducts", featuredProducts);

        List<Product> saleProducts = productService.getOnSaleProducts();
        request.setAttribute("saleProducts", saleProducts);

        request.setAttribute("topCategories", categoryDAO.findTopByProductCount(8));
        request.setAttribute("brands", brandService.getAllBrands());

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private void loadBanner(HttpServletRequest request) {
        List<Image> activeBanners = Collections.emptyList();
        try {
            activeBanners = imageService.findHomeBanners();
        } catch (RuntimeException exception) {
            getServletContext().log("Cannot load homepage banners from image table", exception);
        }

        request.setAttribute("activeBanners", activeBanners);
        request.setAttribute("homeBanners", activeBanners);
    }
}
