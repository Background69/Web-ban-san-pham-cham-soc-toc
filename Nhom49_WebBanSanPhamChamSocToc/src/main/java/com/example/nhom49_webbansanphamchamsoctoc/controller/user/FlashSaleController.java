package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "FlashSaleController", urlPatterns = {"/flash-sale", "/deals"})
public class FlashSaleController extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.productService = new ProductService();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy sản phẩm đang giảm giá
        List<Product> saleProducts = productService.getOnSaleProducts();
        request.setAttribute("saleProducts", saleProducts);


        // Lấy sản phẩm flash sale (giảm giá > 30%)
        List<Product> flashSaleProducts = productService.getFlashSaleProducts();
        request.setAttribute("flashSaleProducts", flashSaleProducts);

        request.getRequestDispatcher("/user/promotion/flash-sale.jsp").forward(request, response);
    }
}