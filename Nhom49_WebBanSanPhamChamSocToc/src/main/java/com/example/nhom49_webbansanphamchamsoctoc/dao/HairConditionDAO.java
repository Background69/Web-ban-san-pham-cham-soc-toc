package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.HairCondition;
import org.jdbi.v3.core.Jdbi;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class HairConditionDAO implements IDAO<HairCondition> {
    private final Jdbi jdbi = JDBIConnector.getInstance();

    @Override
    public HairCondition findById(int id) {
        String sql = "SELECT * FROM hair_conditions WHERE condition_id=:id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapHairCondition(rs))
                .findFirst()
                .orElse(null));
    }

    @Override
    public List<HairCondition> findAll() {
        String sql = "SELECT condition_id, condition_name, condition_slug FROM hair_conditions";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)

                        .map((rs, ctx) -> mapHairCondition(rs))
                        .list()
        );
    }

    public Map<Integer, List<HairCondition>> findByProductIds(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return Map.of();
        }
        String sql = "SELECT phc.product_id, hc.condition_id, hc.condition_name, hc.condition_slug " +
                "FROM product_hair_conditions phc " +
                "JOIN hair_conditions hc ON hc.condition_id = phc.condition_id " +
                "WHERE phc.product_id IN (<productIds>)";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bindList("productIds", productIds)
                        .map((rs, ctx) -> Map.entry(rs.getInt("product_id"), mapHairCondition(rs)))
                        .list()
                        .stream()
                        .collect(Collectors.groupingBy(
                                Map.Entry::getKey,
                                LinkedHashMap::new,
                                Collectors.mapping(Map.Entry::getValue, Collectors.toList())
                        ))
        );
    }

    @Override
    public int insert(HairCondition entity) {
        return jdbi.withHandle(handle ->
                handle.createUpdate(
                                "INSERT INTO hair_conditions(condition_name, condition_slug)" + "VALUES (:name,:slug)")
                        .bind("name", entity.getConditionName())
                        .bind("slug", entity.getConditionSlug())
                        .execute()
        );
    }

    @Override
    public boolean update(HairCondition entity) {
        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(
                                "UPDATE hair_conditions SET condition_name = :name, condition_slug = :slug WHERE condition_id = :id")
                        .bind("name", entity.getConditionName())
                        .bind("slug", entity.getConditionSlug())
                        .bind("id", entity.getConditionId())
                        .execute()
        );
        return rows > 0;
    }

    @Override
    public boolean delete(int id) {
        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(
                                "DELETE FROM hair_conditions WHERE condition_id =:id")
                        .bind("id", id)
                        .execute()
        );
        return rows > 0;
    }

    private HairCondition mapHairCondition(ResultSet rs) {
        try {
            HairCondition h = new HairCondition();
            h.setConditionId(rs.getInt("condition_id"));
            h.setConditionName(rs.getString("condition_name"));
            h.setConditionSlug(rs.getString("condition_slug"));
            h.setCreatedAt(getOptionalTimestamp(rs, "created_at"));
            h.setUpdatedAt(getOptionalTimestamp(rs, "updated_at"));
            return h;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private java.sql.Timestamp getOptionalTimestamp(ResultSet rs, String columnLabel) {
        try {
            return rs.getTimestamp(columnLabel);
        } catch (SQLException ignored) {
            return null;
        }
    }

}
