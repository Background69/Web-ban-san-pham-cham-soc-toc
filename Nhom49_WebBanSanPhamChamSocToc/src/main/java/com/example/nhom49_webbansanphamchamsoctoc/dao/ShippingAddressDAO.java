package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ShippingAddressDAO implements IDAO<ShippingAddress> {

    private final Jdbi jdbi;

    public ShippingAddressDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public List<ShippingAddress> findAll() {
        String sql = "SELECT * FROM shipping_addresses ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapAddress(rs))
                        .list()
        );
    }

    public List<ShippingAddress> findByUserId(int userId) {
        String sql = "SELECT * FROM shipping_addresses WHERE user_id = :userId ORDER BY is_default DESC, created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .map((rs, ctx) -> mapAddress(rs))
                        .list()
        );
    }

    public ShippingAddress findDefaultByUserId(int userId) {
        String sql = "SELECT * FROM shipping_addresses WHERE user_id = :userId AND is_default = true LIMIT 1";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .map((rs, ctx) -> mapAddress(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public ShippingAddress findById(int id) {
        String sql = "SELECT * FROM shipping_addresses WHERE address_id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .map((rs, ctx) -> mapAddress(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public ShippingAddress findByIdAndUserId(int addressId, int userId) {
        String sql = "SELECT * FROM shipping_addresses WHERE address_id = :addressId AND user_id = :userId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("addressId", addressId)
                        .bind("userId", userId)
                        .map((rs, ctx) -> mapAddress(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public int insert(ShippingAddress address) {
        String sql = "INSERT INTO shipping_addresses (user_id, full_name, phone, province_code, " +
                "province_name, district_code, district_name, ward_code, ward_name, specific_address, " +
                "note, is_default) VALUES (:userId, :fullName, :phone, :provinceCode, :provinceName, :districtCode, :districtName, :wardCode, :wardName, :specificAddress, :note, :isDefault)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", address.getUserId())
                        .bind("fullName", address.getFullName())
                        .bind("phone", address.getPhone())
                        .bind("provinceCode", address.getProvinceCode())
                        .bind("provinceName", address.getProvinceName())
                        .bind("districtCode", address.getDistrictCode())
                        .bind("districtName", address.getDistrictName())
                        .bind("wardCode", address.getWardCode())
                        .bind("wardName", address.getWardName())
                        .bind("specificAddress", address.getSpecificAddress())
                        .bind("note", address.getNote())
                        .bind("isDefault", address.isDefaultAddress())
                        .executeAndReturnGeneratedKeys("address_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    @Override
    public boolean update(ShippingAddress address) {
        String sql = "UPDATE shipping_addresses SET full_name = :fullName, phone = :phone, province_code = :provinceCode, " +
                "province_name = :provinceName, district_code = :districtCode, district_name = :districtName, ward_code = :wardCode, ward_name = :wardName, " +
                "specific_address = :specificAddress, note = :note, is_default = :isDefault WHERE address_id = :addressId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("fullName", address.getFullName())
                        .bind("phone", address.getPhone())
                        .bind("provinceCode", address.getProvinceCode())
                        .bind("provinceName", address.getProvinceName())
                        .bind("districtCode", address.getDistrictCode())
                        .bind("districtName", address.getDistrictName())
                        .bind("wardCode", address.getWardCode())
                        .bind("wardName", address.getWardName())
                        .bind("specificAddress", address.getSpecificAddress())
                        .bind("note", address.getNote())
                        .bind("isDefault", address.isDefaultAddress())
                        .bind("addressId", address.getAddressId())
                        .execute()
        );
        return rowsAffected > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM shipping_addresses WHERE address_id = :addressId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("addressId", id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    public boolean setDefault(int userId, int addressId) {
        return jdbi.inTransaction(handle -> {
            String unsetSql = "UPDATE shipping_addresses SET is_default = false WHERE user_id = :userId";
            handle.createUpdate(unsetSql)
                    .bind("userId", userId)
                    .execute();

            String setSql = "UPDATE shipping_addresses SET is_default = true WHERE address_id = :addressId AND user_id = :userId";
            int rowsAffected = handle.createUpdate(setSql)
                    .bind("addressId", addressId)
                    .bind("userId", userId)
                    .execute();
            return rowsAffected > 0;
        });
    }

    private ShippingAddress mapAddress(java.sql.ResultSet rs) throws java.sql.SQLException {
        ShippingAddress address = new ShippingAddress();
        address.setAddressId(rs.getInt("address_id"));
        address.setUserId(rs.getInt("user_id"));
        address.setFullName(rs.getString("full_name"));
        address.setPhone(rs.getString("phone"));
        address.setProvinceCode(rs.getString("province_code"));
        address.setProvinceName(rs.getString("province_name"));
        address.setDistrictCode(rs.getString("district_code"));
        address.setDistrictName(rs.getString("district_name"));
        address.setWardCode(rs.getString("ward_code"));
        address.setWardName(rs.getString("ward_name"));
        address.setSpecificAddress(rs.getString("specific_address"));
        address.setNote(rs.getString("note"));
        address.setDefaultAddress(rs.getBoolean("is_default"));
        address.setCreatedAt(rs.getTimestamp("created_at"));
        address.setUpdatedAt(rs.getTimestamp("updated_at"));
        return address;
    }
}
