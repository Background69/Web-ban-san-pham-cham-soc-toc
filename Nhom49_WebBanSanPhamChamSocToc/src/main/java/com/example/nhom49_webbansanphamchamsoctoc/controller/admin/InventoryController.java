package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.StockProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/stock")
public class InventoryController extends HttpServlet {
    private final ProductVariantDAO variantDAO = new ProductVariantDAO();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<StockProduct> stockList = variantDAO.getAllStock();

        req.setAttribute("stockList", stockList);

        req.getRequestDispatcher("/admin/inventory/stock.jsp")
                .forward(req, resp);
    }
}
