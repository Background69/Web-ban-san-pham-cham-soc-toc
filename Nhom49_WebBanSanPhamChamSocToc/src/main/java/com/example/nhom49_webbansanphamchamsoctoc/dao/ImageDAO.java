package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Image;
import org.jdbi.v3.core.Jdbi;

import java.util.Objects;

public class ImageDAO {
    private final Jdbi jdbi;

    public ImageDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public Image save(Image image) {
        int generatedId = jdbi.withHandle(handle ->
                handle.createUpdate("INSERT INTO image (title, image_url) VALUES (:title, :imageUrl)")
                        .bind("title", image.getTitle())
                        .bind("imageUrl", image.getImageUrl())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
        image.setId(generatedId);
        return image;
    }

    public Image findByTitle(String title) {
        return jdbi.withHandle(handle ->
                Objects.requireNonNull(handle.createQuery("SELECT * FROM image WHERE title = :title")
                        .bind("title", title)
                        .map((rs, ctx) -> new Image(
                                rs.getInt("id"),
                                rs.getString("title"),
                                rs.getString("image_url")
                        ))
                        .findOne()
                        .orElse(null))
        );
    }

    public Image findById(int id) {
        return jdbi.withHandle(handle ->
                Objects.requireNonNull(handle.createQuery("SELECT * FROM image WHERE id = :id")
                        .bind("id", id)
                        .map((rs, ctx) -> new Image(
                                rs.getInt("id"),
                                rs.getString("title"),
                                rs.getString("image_url")
                        ))
                        .findOne()
                        .orElse(null))
        );
    }

    public void delete(int id) {
        jdbi.useHandle(handle ->
                handle.createUpdate("DELETE FROM image WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }
}