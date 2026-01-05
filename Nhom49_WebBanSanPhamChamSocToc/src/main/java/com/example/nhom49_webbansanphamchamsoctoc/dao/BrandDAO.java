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
                    WHERE brand_id = :id
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Brand.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<Brand> findAll() {
        String sql = "SELECT * FROM brands ORDER BY brand_name";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Brand.class)
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
                        .execute()
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
        String sql = "DELETE FROM brands WHERE brand_id = :id";

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );

        return rows > 0;
    }
}
