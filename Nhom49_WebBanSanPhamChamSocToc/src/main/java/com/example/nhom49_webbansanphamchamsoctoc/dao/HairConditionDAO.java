package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.HairCondition;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class HairConditionDAO implements IDAO<HairCondition> {
    private final Jdbi jdbi = JDBIConnector.getInstance();

    @Override
    public HairCondition findById(int id) {

        return jdbi.withHandle(handle -> handle.createQuery(
                        "SELECT condition_id, condition_name, condition_slug" + "FROM hair_conditions WHERE condition_id=:id")
                .bind("id", id)
                .mapToBean(HairCondition.class)
                .findOne()
                .orElse(null));
    }

    @Override
    public List<HairCondition> findAll() {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT condition_id, condition_name, condition_slug FROM hair_conditions")
                        .mapToBean(HairCondition.class)
                        .list()
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
       return rows >0;
}
    @Override
    public boolean delete(int id) {
        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(
                        "DELETE FROM hair_conditions WHERE conditon_id =:id")
                        .bind("id",id)
                        .execute()
        );
        return rows >0;
    }
}
