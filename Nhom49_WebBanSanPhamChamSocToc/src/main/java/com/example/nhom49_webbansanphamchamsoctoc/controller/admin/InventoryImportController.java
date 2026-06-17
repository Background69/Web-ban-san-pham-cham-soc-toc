package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.InventoryReceiptDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.InventoryReceiptDetailDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.ImportItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.InventoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/inventory")
public class InventoryImportController extends HttpServlet {

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
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("variants", inventoryService.getAllVariants());

        req.setAttribute("receipts", inventoryService.getAllReceipts());

        req.getRequestDispatcher("/admin/inventory/inventory-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String[] selected = req.getParameterValues("selected");

        if (selected == null || selected.length == 0) {
            req.getSession().setAttribute("error", "Chưa chọn sản phẩm nhập kho");
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
            return;
        }

        List<ImportItem> items = new ArrayList<>();

        BigDecimal total = BigDecimal.ZERO;

        for (String idStr : selected) {

            int id = Integer.parseInt(idStr);
            int qty = Integer.parseInt(req.getParameter("quantity_" + id));

            if (qty <= 0) continue;

            BigDecimal price = inventoryService.getVariantPrice(id);

            ImportItem item = new ImportItem();
            item.setVariantId(id);
            item.setQuantity(qty);

            items.add(item);

            total = total.add(price.multiply(BigDecimal.valueOf(qty)));
        }

        if (items.isEmpty()) {
            req.getSession().setAttribute("error", "Số lượng nhập phải lớn hơn 0");
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
            return;
        }

        int adminId = ((User) req.getSession().getAttribute("user")).getUserId();

        boolean success = inventoryService.importStock(
                adminId,
                items,
                "TOTAL=" + total
        );

        req.getSession().setAttribute(
                success ? "success" : "error",
                success ? "Nhập kho thành công" : "Nhập kho thất bại"
        );

        resp.sendRedirect(req.getContextPath() + "/admin/inventory");
    }

}

