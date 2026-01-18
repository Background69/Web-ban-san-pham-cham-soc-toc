package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Promotion;
import org.jdbi.v3.core.Jdbi;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class PromotionDAO implements IDAO<Promotion> {
    private final Jdbi jdbi = JDBIConnector.getInstance();
    @Override
    public Promotion findById(int id) {
        String sql = "SELECT * FROM promotion WHERE id=: id";
        return jdbi.withHandle(handle ->
                 handle.createQuery(sql)
                         .bind("id", id)
                         .map((rs, ctx)->mapPromotion(rs))
                         .findFirst()
                         .orElse(null)
        );
    }

    @Override
    public List<Promotion> findAll() {
        String sql = "SELECT * FROM promotions";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapPromotion(rs))
                        .list()
        );
    }

    @Override
    public int insert(Promotion entity) {
        String sql = """
                INSERT INTO promotions
                (discount_percent, start_date, end_date, is_active)
                VALUES (:discount, :start, :end, :active)
                """;
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("discount", entity.getDiscountPercent())
                        .bind("start", entity.getStartDate())
                        .bind("end", entity.getEndDate())
                        .bind("active", entity.isActive())
                        .execute()
        );
    }

    @Override
    public boolean update(Promotion entity) {
        String sql = """
                UPDATE promotions
                SET 
                    discount_percent = :discount,
                    start_date = :start,
                    end_date = :end,
                    is_active = :active
                WHERE promotion_id = :id
                """;
        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)

                        .bind("discount", entity.getDiscountPercent())
                        .bind("start", entity.getStartDate())
                        .bind("end", entity.getEndDate())
                        .bind("active", entity.isActive())
                        .bind("id", entity.getPromotionId())
                        .execute()
        );
        return rows > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM promotions WHERE promotion_id = :id";
        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
        return rows > 0;
    }
    private Promotion mapPromotion(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromotionId(rs.getInt("promotion_id"));
        p.setDiscountPercent(rs.getInt("discount_percent"));

        Timestamp start = rs.getTimestamp("start_date");
        Timestamp end = rs.getTimestamp("end_date");

        p.setStartDate(start != null ? start.toLocalDateTime() : null);
        p.setEndDate(end != null ? end.toLocalDateTime() : null);

        p.setActive(rs.getBoolean("is_active"));
        p.setCreatedAt(Timestamp.valueOf(rs.getTimestamp("created_at").toLocalDateTime()));

        return p;
    }

}
