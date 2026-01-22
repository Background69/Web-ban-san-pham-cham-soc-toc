package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.ShippingService;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddressController", urlPatterns = {"/profile/addresses", "/profile/addresses/*"})
public class AddressController extends HttpServlet {

    private ShippingService shippingService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.shippingService = new ShippingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/profile/addresses");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.matches("/\\d+")) {
            int addressId = Integer.parseInt(pathInfo.substring(1));
            ShippingAddress address = shippingService.getAddressById(addressId);
            if (address == null || address.getUserId() != user.getUserId()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            request.setAttribute("selectedAddress", address);
            List<ShippingAddress> addresses = shippingService.getAddressesByUser(user.getUserId());
            request.setAttribute("addresses", addresses);
            request.getRequestDispatcher("/user/address.jsp").forward(request, response);
            return;
        }

        List<ShippingAddress> addresses = shippingService.getAddressesByUser(user.getUserId());
        request.setAttribute("addresses", addresses);

        request.getRequestDispatcher("/user/address.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/save")) {
            // Thêm hoặc cập nhật địa chỉ
            saveAddress(request, response, user);
        } else if (pathInfo.equals("/set-default")) {
            // Đặt địa chỉ mặc định
            setDefaultAddress(request, response, user);
        } else if (pathInfo.equals("/delete")) {
            // Xóa địa chỉ
            deleteAddress(request, response, user);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void saveAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String provinceCode = request.getParameter("provinceCode");
        String provinceName = request.getParameter("provinceName");
        String districtCode = request.getParameter("districtCode");
        String districtName = request.getParameter("districtName");
        String wardCode = request.getParameter("wardCode");
        String wardName = request.getParameter("wardName");
        String addressLine = request.getParameter("specificAddress");
        String note = request.getParameter("note");

        ShippingAddress address = new ShippingAddress();
        address.setUserId(user.getUserId());
        address.setFullName(fullName);
        address.setPhone(phone);
        address.setEmail(email);
        address.setProvinceCode(provinceCode);
        address.setProvinceName(provinceName);
        address.setDistrictCode(districtCode);
        address.setDistrictName(districtName);
        address.setWardCode(wardCode);
        address.setWardName(wardName);
        address.setSpecificAddress(addressLine);
        address.setNote(note);
        address.setDefault(true);

        boolean success;
        ShippingAddress existingAddress = getSingleAddress(user.getUserId());
        if (existingAddress != null) {
            address.setAddressId(existingAddress.getAddressId());
            success = shippingService.updateAddress(address);
        } else {
            success = shippingService.addAddress(address);
        }

        if (success) {
            if (address.getAddressId() > 0) {
                shippingService.setDefaultAddress(user.getUserId(), address.getAddressId());
            }
            response.sendRedirect(request.getContextPath() + "/profile/addresses?success=Đã lưu địa chỉ thành công");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile/addresses?error=Không thể lưu địa chỉ");
        }
    }

    private void setDefaultAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        ShippingAddress address = getSingleAddress(user.getUserId());
        if (address != null) {
            boolean success = shippingService.setDefaultAddress(user.getUserId(), address.getAddressId());

            if (success) {
                response.sendRedirect(request.getContextPath() + "/profile/addresses?success=Đã đặt địa chỉ mặc định");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile/addresses?error=Không thể đặt địa chỉ mặc định");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profile/addresses");
        }
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String addressIdStr = request.getParameter("addressId");
        ShippingAddress address = getSingleAddress(user.getUserId());
        if (address != null && addressIdStr != null) {
            int addressId = Integer.parseInt(addressIdStr);
            if (address.getAddressId() != addressId) {
                response.sendRedirect(request.getContextPath() + "/profile/addresses");
                return;
            }
            boolean success = shippingService.deleteAddress(addressId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/profile/addresses?success=Đã xóa địa chỉ");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile/addresses?error=Không thể xóa địa chỉ");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profile/addresses");
        }
    }

    private ShippingAddress getSingleAddress(int userId) {
        ShippingAddress address = shippingService.getDefaultAddress(userId);
        if (address != null) {
            return address;
        }

        List<ShippingAddress> addresses = shippingService.getAddressesByUser(userId);
        if (addresses == null || addresses.isEmpty()) {
            return null;
        }

        ShippingAddress fallback = addresses.get(0);
        if (fallback != null) {
            shippingService.setDefaultAddress(userId, fallback.getAddressId());
            fallback.setDefault(true);
        }
        return fallback;
    }
}
