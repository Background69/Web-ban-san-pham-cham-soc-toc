package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductManagementController", value = "/admin/products")
public class ProductManagementController extends HttpServlet {

    ProductDAO productDAO = new ProductDAO();
    ProductVariantDAO productVariantDAO = new ProductVariantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        String action = request.getParameter("action");

        // ===== DELETE =====
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        // ===== OPEN CREATE FORM =====
        if ("create".equals(action)) {
            request.getRequestDispatcher("/view/admin/products/product-form.jsp")
                    .forward(request, response);
            return;
        }

        // ===== OPEN EDIT FORM =====
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.findById(id);
            request.setAttribute("product", product);

            request.getRequestDispatcher("/view/admin/products/product-form.jsp")
                    .forward(request, response);
            return;
        }

        // ===== LIST =====
        List<Product> products = productDAO.findAll();
        request.setAttribute("products", products);

        request.getRequestDispatcher("/view/admin/products/product-list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // ===== CREATE =====
        if ("create".equals(action)) {
            Product product = productFromRequest(request);
            productDAO.insert(product);
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        // ===== EDIT =====
        if ("edit".equals(action)) {
            Product product = productFromRequest(request);
            product.setProductId(Integer.parseInt(request.getParameter("id")));
            productDAO.update(product);
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    // ===== MAP FORM → OBJECT =====
    private Product productFromRequest(HttpServletRequest request) {
        Product product = new Product();
        ProductVariant productVariant = new ProductVariant();
        product.setProductName(request.getParameter("name"));
        product.setCategoryName(request.getParameter("category"));
        return product;
    }
}
