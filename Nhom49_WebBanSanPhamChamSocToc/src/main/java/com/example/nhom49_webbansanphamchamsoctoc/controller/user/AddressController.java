package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ShippingAddressDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.util.AddressUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddressController", value = "/AddressController")
public class AddressController extends HttpServlet {

    private final ShippingAddressDAO addressDAO = new ShippingAddressDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = getUserIdFromSession(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        List<ShippingAddress> addresses = addressDAO.findByUserId(userId);
        ShippingAddress defaultAddress = addressDAO.findDefaultByUserId(userId);

        request.setAttribute("addresses", addresses);
        request.setAttribute("defaultAddress", defaultAddress);
        request.setAttribute("defaultFullAddress",
                AddressUtil.formatFullAddress(defaultAddress));

        request.getRequestDispatcher("/WEB-INF/views/user/address.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer userId = getUserIdFromSession(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "add";
        switch (action) {
            case "add" -> handleAddAddress(request, response, userId);
            case "select" -> handleSelectAddress(request, response, userId);
            case "setDefault" -> handleSetDefault(request, response, userId);
            case "delete" -> handleDelete(request, response, userId);
            default -> response.sendRedirect(request.getContextPath() + "/AddressController");
        }
    }

    // ===================== HANDLERS =====================

    private void handleAddAddress(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException, ServletException {

        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phonenumber");
        String email = request.getParameter("email");

        String provinceCode = request.getParameter("province");
        String districtCode = request.getParameter("district");
        String wardCode = request.getParameter("ward");

        String provinceName = request.getParameter("provinceName");
        String districtName = request.getParameter("districtName");
        String wardName = request.getParameter("wardName");

        String specificAddress = request.getParameter("specificaddress");
        String note = request.getParameter("note");

        boolean saveAddress = request.getParameter("save-address") != null;

        // Validate cơ bản
        if (!ValidationUtil.isNotEmpty(fullName)
                || !ValidationUtil.isNotEmpty(phone)
                || !ValidationUtil.isNotEmpty(email)
                || !ValidationUtil.isNotEmpty(provinceCode)
                || !ValidationUtil.isNotEmpty(districtCode)
                || !ValidationUtil.isNotEmpty(wardCode)
                || !ValidationUtil.isNotEmpty(specificAddress)) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin địa chỉ.");
            doGet(request, response);
            return;
        }

        ShippingAddress address = AddressUtil.createAddress(
                userId,
                fullName, phone, email,
                provinceCode, safe(provinceName),
                districtCode, safe(districtName),
                wardCode, safe(wardName),
                specificAddress, note
        );

        if (saveAddress) {
            ShippingAddress currentDefault = addressDAO.findDefaultByUserId(userId);
            if (currentDefault == null) {
                address.setDefault(true);
            }

            int newId = addressDAO.insert(address);

            if (newId > 0 && address.isDefault()) {
                addressDAO.setDefault(userId, newId);
                address.setAddressId(newId);
            } else if (newId > 0) {
                address.setAddressId(newId);
            }
        }

        HttpSession session = request.getSession();
        session.setAttribute("checkoutAddress", address);

        response.sendRedirect(request.getContextPath() + "/PaymentController");
    }

    private void handleSelectAddress(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {

        String addressIdStr = request.getParameter("addressId");
        if (!ValidationUtil.isNotEmpty(addressIdStr)) {
            response.sendRedirect(request.getContextPath() + "/AddressController");
            return;
        }

        int addressId = Integer.parseInt(addressIdStr);
        ShippingAddress address = addressDAO.findById(addressId);

        if (address == null || address.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/AddressController");
            return;
        }

        request.getSession().setAttribute("checkoutAddress", address);

        response.sendRedirect(request.getContextPath() + "/PaymentController");
    }

    private void handleSetDefault(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {

        String addressIdStr = request.getParameter("addressId");
        if (!ValidationUtil.isNotEmpty(addressIdStr)) {
            response.sendRedirect(request.getContextPath() + "/AddressController");
            return;
        }

        int addressId = Integer.parseInt(addressIdStr);
        ShippingAddress address = addressDAO.findById(addressId);

        if (address != null && address.getUserId() == userId) {
            addressDAO.setDefault(userId, addressId);
        }

        response.sendRedirect(request.getContextPath() + "/AddressController");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {

        String addressIdStr = request.getParameter("addressId");
        if (!ValidationUtil.isNotEmpty(addressIdStr)) {
            response.sendRedirect(request.getContextPath() + "/AddressController");
            return;
        }

        int addressId = Integer.parseInt(addressIdStr);
        ShippingAddress address = addressDAO.findById(addressId);

        if (address != null && address.getUserId() == userId) {
            boolean wasDefault = address.isDefault();
            addressDAO.delete(addressId);

            if (wasDefault) {
                List<ShippingAddress> list = addressDAO.findByUserId(userId);
                if (!list.isEmpty()) {
                    addressDAO.setDefault(userId, list.get(0).getAddressId());
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/AddressController");
    }

    // ===================== HELPERS =====================

    private Integer getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;

        Object idObj = session.getAttribute("userId");
        if (idObj instanceof Integer) return (Integer) idObj;

        Object userObj = session.getAttribute("user");
        if (userObj == null) userObj = session.getAttribute("auth");

        return null;
    }

    private String safe(String s) {
        return s == null ? "" : s;
    }
}
