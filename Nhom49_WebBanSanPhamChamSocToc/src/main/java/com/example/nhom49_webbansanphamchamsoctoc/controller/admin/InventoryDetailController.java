package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.model.InventoryReceiptDetail;
import com.example.nhom49_webbansanphamchamsoctoc.services.InventoryService;
import com.example.nhom49_webbansanphamchamsoctoc.dao.InventoryReceiptDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.services.InventoryReceiptDetailDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/inventory/details")
public class InventoryDetailController extends HttpServlet {

    private InventoryService inventoryService;

    @Override
    public void init() {
        inventoryService = new InventoryService(
                new InventoryReceiptDAO(),
                new InventoryReceiptDetailDAO(),
                new ProductVariantDAO()
        );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        resp.setContentType("application/json;charset=UTF-8");

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            List<InventoryReceiptDetail> details = inventoryService.getDetailsByReceiptId(id);

            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < details.size(); i++) {
                InventoryReceiptDetail d = details.get(i);

                json.append("{")
                        .append("\"variantId\":").append(d.getProductId()).append(",")
                        .append("\"quantity\":").append(d.getQuantity()).append(",")
                        .append("\"unitCost\":").append(d.getUnitCost())
                        .append("}");

                if (i < details.size() - 1) json.append(",");
            }

            json.append("]");

            resp.getWriter().write(json.toString());

        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"Server error\"}");
        }
    }
}