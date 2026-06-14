package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Feedback;
import com.example.nhom49_webbansanphamchamsoctoc.model.FeedbackImage;
import com.example.nhom49_webbansanphamchamsoctoc.model.FeedbackMessage;
import org.jdbi.v3.core.Jdbi;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    private final Jdbi jdbi;

    public FeedbackDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }
    public int insert(Feedback feedback) {
        String sql = "INSERT INTO feedbacks (ticket_code, user_id, customer_name, customer_email, category, title, content, status) " +
                "VALUES (:ticketCode, :userId, :customerName, :customerEmail, :category, :title, :content, :status)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("ticketCode", feedback.getTicketCode())
                .bind("userId", feedback.getUserId())
                .bind("customerName", feedback.getCustomerName())
                .bind("customerEmail", feedback.getCustomerEmail())
                .bind("category", feedback.getCategory())
                .bind("title", feedback.getTitle())
                .bind("content", feedback.getContent())
                .bind("status", feedback.getStatus() != null ? feedback.getStatus() : "RECEIVED")
                .executeAndReturnGeneratedKeys("feedback_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    public void insertImage(FeedbackImage image) {
        String sql = "INSERT INTO feedback_images (feedback_id, image_url, public_id) " +
                "VALUES (:feedbackId, :imageUrl, :publicId)";
        jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("feedbackId", image.getFeedbackId())
                .bind("imageUrl", image.getImageUrl())
                .bind("publicId", image.getPublicId())
                .execute());
    }

    public void addMessage(int feedbackId, String senderType, String message) {
        String sql = "INSERT INTO feedback_messages (feedback_id, sender_type, message) " +
                "VALUES (:feedbackId, :senderType, :message)";
        jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("feedbackId", feedbackId)
                .bind("senderType", senderType)
                .bind("message", message)
                .execute());
    }
    public Feedback findByTicketCode(String ticketCode) {
        String sql = "SELECT * FROM feedbacks WHERE ticket_code = :ticketCode";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("ticketCode", ticketCode)
                .map((rs, ctx) -> mapFeedback(rs))
                .findFirst()
                .orElse(null));
    }

    public Feedback findById(int feedbackId) {
        String sql = "SELECT * FROM feedbacks WHERE feedback_id = :feedbackId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("feedbackId", feedbackId)
                .map((rs, ctx) -> mapFeedback(rs))
                .findFirst()
                .orElse(null));
    }

    public List<Feedback> findByUserId(int userId) {
        String sql = "SELECT * FROM feedbacks WHERE user_id = :userId ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map((rs, ctx) -> mapFeedback(rs))
                .list());
    }

    public List<Feedback> findAll(String keyword, String status, String category, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM feedbacks WHERE 1=1");
        List<Object> params = new ArrayList<>();

        appendFilters(sql, params, keyword, status, category);
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }
            return query.map((rs, ctx) -> mapFeedback(rs)).list();
        });
    }

    public int countAll(String keyword, String status, String category) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM feedbacks WHERE 1=1");
        List<Object> params = new ArrayList<>();

        appendFilters(sql, params, keyword, status, category);

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }
            return query.mapTo(Integer.class).findFirst().orElse(0);
        });
    }

    public List<FeedbackImage> findImagesByFeedbackId(int feedbackId) {
        String sql = "SELECT * FROM feedback_images WHERE feedback_id = :feedbackId ORDER BY created_at ASC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("feedbackId", feedbackId)
                .map((rs, ctx) -> {
                    FeedbackImage image = new FeedbackImage();
                    image.setImageId(rs.getInt("image_id"));
                    image.setFeedbackId(rs.getInt("feedback_id"));
                    image.setImageUrl(rs.getString("image_url"));
                    image.setPublicId(rs.getString("public_id"));
                    image.setCreatedAt(rs.getTimestamp("created_at"));
                    return image;
                })
                .list());
    }

    public List<FeedbackMessage> findMessagesByFeedbackId(int feedbackId) {
        String sql = "SELECT * FROM feedback_messages WHERE feedback_id = :feedbackId ORDER BY created_at ASC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("feedbackId", feedbackId)
                .map((rs, ctx) -> {
                    FeedbackMessage msg = new FeedbackMessage();
                    msg.setMessageId(rs.getInt("message_id"));
                    msg.setFeedbackId(rs.getInt("feedback_id"));
                    msg.setSenderType(rs.getString("sender_type"));
                    msg.setMessage(rs.getString("message"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    return msg;
                })
                .list());
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM feedbacks";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class).findFirst().orElse(0));
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM feedbacks WHERE status = :status";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("status", status)
                .mapTo(Integer.class).findFirst().orElse(0));
    }

    public int countToday() {
        String sql = "SELECT COUNT(*) FROM feedbacks WHERE DATE(created_at) = CURDATE()";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }

    public void updateStatus(int feedbackId, String status) {
        String sql = "UPDATE feedbacks SET status = :status WHERE feedback_id = :feedbackId";
        jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("status", status)
                .bind("feedbackId", feedbackId)
                .execute());
    }

    public String generateTicketCode() {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        int count = countToday() + 1;
        return String.format("HG-%s-%04d", datePart, count);
    }

    private void appendFilters(StringBuilder sql, List<Object> params,
                               String keyword, String status, String category) {
        if (status != null && !status.isBlank()) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }
        if (category != null && !category.isBlank()) {
            sql.append(" AND category = ?");
            params.add(category.trim());
        }
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (ticket_code LIKE ? OR customer_email LIKE ? OR customer_name LIKE ? OR title LIKE ?)");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
    }

    private Feedback mapFeedback(java.sql.ResultSet rs) throws java.sql.SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setTicketCode(rs.getString("ticket_code"));
        feedback.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
        feedback.setCustomerName(rs.getString("customer_name"));
        feedback.setCustomerEmail(rs.getString("customer_email"));
        feedback.setCategory(rs.getString("category"));
        feedback.setTitle(rs.getString("title"));
        feedback.setContent(rs.getString("content"));
        feedback.setStatus(rs.getString("status"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
        return feedback;
    }
}