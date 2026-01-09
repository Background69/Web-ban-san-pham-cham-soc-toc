package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class BrandDAO implements IDAO<Brand> {

    private final Jdbi jdbi;

    public BrandDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public Brand findById(int id) {
        String sql = """
                    SELECT * FROM brands
                    WHERE brand_id = :brandId
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .map((rs, ctx) -> mapBrand(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public Brand findBySlug(String slug) {
        String sql = "SELECT * FROM brands WHERE brand_slug = :brandSlug";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, slug)
                        .map((rs, ctx) -> mapBrand(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<Brand> findAll() {
        String sql = "SELECT * FROM brands ORDER BY brand_name";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapBrand(rs))
                        .list()
        );
    }

    @Override
    public int insert(Brand brand) {
        String sql = """
                    INSERT INTO brands
                    (brand_name, brand_slug, logo_url, origin, short_description, full_description)
                    VALUES (:brandName, :brandSlug, :logoUrl, :origin, :shortDescription, :fullDescription)
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(brand)
                        .executeAndReturnGeneratedKeys("brand_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    @Override
    public boolean update(Brand brand) {
        String sql = """
                    UPDATE brands
                    SET brand_name = :brandName,
                        brand_slug = :brandSlug,
                        logo_url = :logoUrl,
                        origin = :origin,
                        short_description = :shortDescription,
                        full_description = :fullDescription
                    WHERE brand_id = :brandId
                """;

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(brand)
                        .execute()
        );

        return rows > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM brands WHERE brand_id = :brandId";

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("brandId", id)
                        .execute()
        );

        return rows > 0;
    }

    private Brand mapBrand(java.sql.ResultSet rs) throws java.sql.SQLException {
        Brand brand = new Brand();
        brand.setBrandId(rs.getInt("brand_id"));
        brand.setBrandName(rs.getString("brand_name"));
        brand.setBrandSlug(rs.getString("brand_slug"));
        brand.setLogoUrl(rs.getString("logo_url"));
        brand.setOrigin(rs.getString("origin"));
        brand.setShortDescription(rs.getString("short_description"));
        brand.setFullDescription(rs.getString("full_description"));
        brand.setCreatedAt(rs.getTimestamp("created_at"));
        return brand;
    }

    /**
     * Lấy danh sách xuất xứ unique
     */
    public List<String> findAllOrigins() {
        String sql = "SELECT DISTINCT origin FROM brands WHERE origin IS NOT NULL AND origin != '' ORDER BY origin";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(String.class)
                        .list()
        );
    }
}
