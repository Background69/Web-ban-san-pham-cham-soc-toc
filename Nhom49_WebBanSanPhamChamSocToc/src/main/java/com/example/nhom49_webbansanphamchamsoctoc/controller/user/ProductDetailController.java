package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ReviewDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailController", value = "/product-detail")
public class ProductDetailController extends HttpServlet {

    private ProductVariantDAO productVariantDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        productVariantDAO = new ProductVariantDAO();
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productIdRaw = request.getParameter("id");

        if (productIdRaw == null) {
            response.sendRedirect(request.getContextPath() + "/Home");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Home");
            return;
        }

        List<ProductVariant> variants =
                productVariantDAO.findByProductId(productId);

        List<Review> reviews =
                reviewDAO.findByProductId(productId);

        request.setAttribute("variants", variants);
        request.setAttribute("reviews", reviews);
        request.setAttribute("productId", productId);

        request.getRequestDispatcher("/views/product-detail.jsp")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
