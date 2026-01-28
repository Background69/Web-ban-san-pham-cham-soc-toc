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
        String sql = """
            SELECT
                promotion_id,
                promotion_name,
                promotion_type,
                discount_percent,
                badge_text,
                NULLIF(start_date, '0000-00-00 00:00:00') AS start_date,
                NULLIF(end_date,   '0000-00-00 00:00:00') AS end_date,
                is_active,
                NULLIF(created_at, '0000-00-00 00:00:00') AS created_at
            FROM promotions
            WHERE promotion_id = :id
            """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .map((rs, ctx) -> mapPromotion(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<Promotion> findAll() {
        String sql = """
            SELECT
                promotion_id,
                promotion_name,
                promotion_type,
                discount_percent,
                badge_text,
                NULLIF(start_date, '0000-00-00 00:00:00') AS start_date,
                NULLIF(end_date,   '0000-00-00 00:00:00') AS end_date,
                is_active,
                NULLIF(created_at, '0000-00-00 00:00:00') AS created_at
            FROM promotions
            ORDER BY promotion_id DESC
            """;

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
            (promotion_name, promotion_type, discount_percent, badge_text, start_date, end_date, is_active)
            VALUES (:name, :type, :percent, :badge, :start, :end, :active)
            """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("name", entity.getPromotionName())
                        .bind("type", entity.getPromotionType())
                        .bind("percent", entity.getDiscountPercent())
                        .bind("badge", entity.getBadgeText())
                        .bind("start", entity.getStartDate())
                        .bind("end", entity.getEndDate())
                        .bind("active", entity.isActive())
                        .execute()
        );
    }

    @Override
    public boolean update(Promotion entity) {
        String sql = """
            UPDATE promotions SET
                promotion_name = :name,
                promotion_type = :type,
                discount_percent = :percent,
                badge_text = :badge,
                start_date = :start,
                end_date = :end,
                is_active = :active
            WHERE promotion_id = :id
            """;

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("name", entity.getPromotionName())
                        .bind("type", entity.getPromotionType())
                        .bind("percent", entity.getDiscountPercent())
                        .bind("badge", entity.getBadgeText())
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
        p.setPromotionName(rs.getString("promotion_name"));
        p.setPromotionType(rs.getString("promotion_type"));
        p.setDiscountPercent((Integer) rs.getObject("discount_percent"));
        p.setBadgeText(rs.getString("badge_text"));
        p.setActive(rs.getBoolean("is_active"));

        Timestamp start = rs.getTimestamp("start_date");
        Timestamp end = rs.getTimestamp("end_date");
        Timestamp created = rs.getTimestamp("created_at");

        p.setStartDate(start != null ? start.toLocalDateTime() : null);
        p.setEndDate(end != null ? end.toLocalDateTime() : null);
        p.setCreatedAt(created);

        return p;
    }
}
