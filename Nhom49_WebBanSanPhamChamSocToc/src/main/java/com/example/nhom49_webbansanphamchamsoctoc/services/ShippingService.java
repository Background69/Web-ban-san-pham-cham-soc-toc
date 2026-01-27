package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ShippingAddressDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.util.AddressUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;

import java.math.BigDecimal;
import java.util.List;

/**
 * Service chuyên xử lý shipping và địa chỉ giao hàng
 */
public class ShippingService {

    // Shipping fees
    public static final BigDecimal STANDARD_SHIPPING_FEE = new BigDecimal("30000");
    public static final BigDecimal EXPRESS_SHIPPING_FEE = new BigDecimal("50000");

    private final ShippingAddressDAO addressDAO;
    private String lastError;

    public ShippingService() {
        this.addressDAO = new ShippingAddressDAO();
    }

    /**
     * Lấy thông báo lỗi cuối cùng
     */
    public String getLastError() {
        return lastError;
    }


    /**
     * Lấy danh sách địa chỉ của user
     */
    public List<ShippingAddress> getAddressesByUser(int userId) {
        return addressDAO.findByUserId(userId);
    }

    /**
     * Lấy địa chỉ mặc định của user
     */
    public ShippingAddress getDefaultAddress(int userId) {
        return addressDAO.findDefaultByUserId(userId);
    }

    /**
     * Lấy địa chỉ theo ID
     */
    public ShippingAddress getAddressById(int addressId) {
        return addressDAO.findById(addressId);
    }

    /**
     * Tạo địa chỉ mới
     *
     * @return ShippingAddress nếu thành công, null nếu thất bại
     */
    public ShippingAddress createAddress(int userId, String fullName, String phone,
                                         String email, String provinceCode, String provinceName,
                                         String districtCode, String districtName,
                                         String wardCode, String wardName,
                                         String specificAddress, String note) {
        // Validate
        String validationError = ValidationUtil.validateShippingAddress(fullName, phone, specificAddress);
        if (validationError != null) {
            lastError = validationError;
            return null;
        }

        // Tạo address
        ShippingAddress address = AddressUtil.createAddress(
                userId, fullName, phone, email,
                provinceCode, provinceName, districtCode, districtName,
                wardCode, wardName, specificAddress, note
        );

        int addressId = addressDAO.insert(address);
        if (addressId > 0) {
            address.setAddressId(addressId);
            return address;
        }

        lastError = "Có lỗi xảy ra khi thêm địa chỉ";
        return null;
    }

    /**
     * Cập nhật địa chỉ
     */
    public boolean updateAddress(ShippingAddress address) {
        if (address == null || !ValidationUtil.isPositiveInteger(address.getAddressId())) {
            lastError = "Địa chỉ không hợp lệ";
            return false;
        }

        // Validate
        String validationError = ValidationUtil.validateShippingAddress(
                address.getFullName(), address.getPhone(), address.getSpecificAddress()
        );
        if (validationError != null) {
            lastError = validationError;
            return false;
        }

        boolean success = addressDAO.update(address);
        if (!success) {
            lastError = "Có lỗi xảy ra khi cập nhật địa chỉ";
        }
        return success;
    }

    /**
     * Xóa địa chỉ
     */
    public boolean deleteAddress(int addressId) {
        if (!ValidationUtil.isPositiveInteger(addressId)) {
            lastError = "ID địa chỉ không hợp lệ";
            return false;
        }

        boolean success = addressDAO.delete(addressId);
        if (!success) {
            lastError = "Có lỗi xảy ra khi xóa địa chỉ";
        }
        return success;
    }

    /**
     * Thêm địa chỉ mới (simplified version)
     */
    public boolean addAddress(ShippingAddress address) {
        if (address == null) {
            lastError = "Địa chỉ không hợp lệ";
            return false;
        }

        // Validate
        String validationError = ValidationUtil.validateShippingAddress(
                address.getFullName(), address.getPhone(), address.getSpecificAddress()
        );
        if (validationError != null) {
            lastError = validationError;
            return false;
        }

        int addressId = addressDAO.insert(address);
        if (addressId > 0) {
            address.setAddressId(addressId);
            return true;
        }

        lastError = "Có lỗi xảy ra khi thêm địa chỉ";
        return false;
    }

    /**
     * Đặt địa chỉ mặc định
     */
    public boolean setDefaultAddress(int userId, int addressId) {
        if (!ValidationUtil.isPositiveInteger(addressId)) {
            lastError = "ID địa chỉ không hợp lệ";
            return false;
        }

        boolean success = addressDAO.setDefault(userId, addressId);
        if (!success) {
            lastError = "Có lỗi xảy ra";
        }
        return success;
    }


    /**
     * Tính phí ship theo phương thức
     */
    public BigDecimal getShippingFee(String shippingMethod) {
        if ("express".equals(shippingMethod)) {
            return EXPRESS_SHIPPING_FEE;
        }
        return STANDARD_SHIPPING_FEE;
    }

    /**
     * Lấy tên hiển thị của phương thức ship
     */
    public String getShippingMethodDisplayName(String method) {
        return switch (method) {
            case "express" -> "Giao hàng nhanh";
            default -> "Giao hàng tiêu chuẩn";
        };
    }

    /**
     * Format địa chỉ đầy đủ
     */
    public String formatFullAddress(ShippingAddress address) {
        return AddressUtil.formatFullAddress(address);
    }

    /**
     * Đếm số địa chỉ của user
     */
    public int countAddressesByUser(int userId) {
        List<ShippingAddress> addresses = addressDAO.findByUserId(userId);
        return addresses != null ? addresses.size() : 0;
    }
}
