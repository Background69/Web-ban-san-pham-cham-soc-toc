package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;

/**
 * Utility class để xử lý địa chỉ
 */
public class AddressUtil {

    /**
     * Format địa chỉ đầy đủ từ ShippingAddress
     */
    public static String formatFullAddress(ShippingAddress address) {
        if (address == null) return "";

        StringBuilder sb = new StringBuilder();

        if (ValidationUtil.isNotEmpty(address.getSpecificAddress())) {
            sb.append(address.getSpecificAddress());
        }

        if (ValidationUtil.isNotEmpty(address.getWardName())) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(address.getWardName());
        }

        if (ValidationUtil.isNotEmpty(address.getDistrictName())) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(address.getDistrictName());
        }

        if (ValidationUtil.isNotEmpty(address.getProvinceName())) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(address.getProvinceName());
        }

        return sb.toString();
    }

    /**
     * Dinh dang short address.
     */
    public static String formatShortAddress(ShippingAddress address) {
        if (address == null) return "";

        StringBuilder sb = new StringBuilder();

        if (ValidationUtil.isNotEmpty(address.getDistrictName())) {
            sb.append(address.getDistrictName());
        }

        if (ValidationUtil.isNotEmpty(address.getProvinceName())) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(address.getProvinceName());
        }

        return sb.toString();
    }

    /**
     * Dinh dang recipient info.
     */
    public static String formatRecipientInfo(ShippingAddress address) {
        if (address == null) return "";

        StringBuilder sb = new StringBuilder();

        if (ValidationUtil.isNotEmpty(address.getFullName())) {
            sb.append(address.getFullName());
        }

        if (ValidationUtil.isNotEmpty(address.getPhone())) {
            if (sb.length() > 0) sb.append(" - ");
            sb.append(address.getPhone());
        }

        return sb.toString();
    }


    public static ShippingAddress createAddress(int userId, String fullName, String phone,
                                                String provinceCode, String provinceName,
                                                String districtCode, String districtName,
                                                String wardCode, String wardName,
                                                String specificAddress, String note) {
        ShippingAddress address = new ShippingAddress();
        address.setUserId(userId);
        address.setFullName(ValidationUtil.sanitize(fullName));
        address.setPhone(ValidationUtil.sanitize(phone));
        address.setProvinceCode(provinceCode);
        address.setProvinceName(provinceName);
        address.setDistrictCode(districtCode);
        address.setDistrictName(districtName);
        address.setWardCode(wardCode);
        address.setWardName(wardName);
        address.setSpecificAddress(ValidationUtil.sanitize(specificAddress));
        address.setNote(ValidationUtil.sanitize(note));
        address.setDefaultAddress(false);
        return address;
    }
}
