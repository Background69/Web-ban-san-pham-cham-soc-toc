package com.example.nhom49_webbansanphamchamsoctoc.services;
import com.cloudinary.utils.ObjectUtils;
import com.example.nhom49_webbansanphamchamsoctoc.dao.FeedbackDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Feedback;
import com.example.nhom49_webbansanphamchamsoctoc.model.FeedbackImage;
import com.example.nhom49_webbansanphamchamsoctoc.model.FeedbackMessage;
import com.example.nhom49_webbansanphamchamsoctoc.util.CloudinaryConfig;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FeedbackService {

    private static final Logger LOGGER = Logger.getLogger(FeedbackService.class.getName());

    private static final Set<String> VALID_STATUSES = Set.of(
            "RECEIVED", "PROCESSING", "RESOLVED", "CLOSED"
    );

    private final FeedbackDAO feedbackDAO;

    public FeedbackService() {
        this.feedbackDAO = new FeedbackDAO();
    }

    public String createFeedback(Feedback feedback, List<byte[]> imageBytes) {
        try {
            String ticketCode = feedbackDAO.generateTicketCode();
            feedback.setTicketCode(ticketCode);
            feedback.setStatus("RECEIVED");

            int feedbackId = feedbackDAO.insert(feedback);
            if (feedbackId < 0) {
                LOGGER.warning("Không thể lưu feedback vào database");
                return null;
            }
            feedback.setFeedbackId(feedbackId);
            if (imageBytes != null && !imageBytes.isEmpty()) {
                for (int i = 0; i < imageBytes.size() && i < 3; i++) {
                    try {
                        Map<?, ?> result = CloudinaryConfig.getInstance()
                                .uploader()
                                .upload(
                                        imageBytes.get(i),
                                        ObjectUtils.asMap(
                                                "folder", "feedbacks",
                                                "public_id", "feedback_" + feedbackId + "_" + (i + 1),
                                                "overwrite", true,
                                                "resource_type", "image"
                                        )
                                );
                        String imageUrl = (String) result.get("secure_url");
                        String publicId = (String) result.get("public_id");

                        if (imageUrl != null && !imageUrl.isBlank()) {
                            FeedbackImage image = new FeedbackImage();
                            image.setFeedbackId(feedbackId);
                            image.setImageUrl(imageUrl);
                            image.setPublicId(publicId);
                            feedbackDAO.insertImage(image);
                        }
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Lỗi upload ảnh feedback #" + (i + 1), e);
                    }
                }
            }
            feedbackDAO.addMessage(feedbackId, "CUSTOMER", feedback.getContent());
            try {
                EmailService emailService = new EmailService();
                emailService.sendFeedbackConfirmation(
                        feedback.getCustomerEmail(),
                        ticketCode,
                        feedback.getCategory(),
                        feedback.getTitle(),
                        feedback.getContent()
                );
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Không gửi được email xác nhận feedback: " + ticketCode, e);
            }
            return ticketCode;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi tạo feedback", e);
            return null;
        }
    }

    public List<Feedback> findByUserId(int userId) {
        return feedbackDAO.findByUserId(userId);
    }

    public List<Feedback> findAll(String keyword, String status, String category, int page, int pageSize) {
        return feedbackDAO.findAll(keyword, status, category, page, pageSize);
    }

    public int countAll(String keyword, String status, String category) {
        return feedbackDAO.countAll(keyword, status, category);
    }

    public Feedback findById(int feedbackId) {
        return feedbackDAO.findById(feedbackId);
    }

    public List<FeedbackImage> findImagesByFeedbackId(int feedbackId) {
        return feedbackDAO.findImagesByFeedbackId(feedbackId);
    }

    public List<FeedbackMessage> findMessagesByFeedbackId(int feedbackId) {
        return feedbackDAO.findMessagesByFeedbackId(feedbackId);
    }

    public Map<String, Integer> getStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", feedbackDAO.countTotal());
        stats.put("received", feedbackDAO.countByStatus("RECEIVED"));
        stats.put("processing", feedbackDAO.countByStatus("PROCESSING"));
        stats.put("resolved", feedbackDAO.countByStatus("RESOLVED"));
        stats.put("closed", feedbackDAO.countByStatus("CLOSED"));
        return stats;
    }

    public boolean adminReply(int feedbackId, String message, String newStatus) {
        try {
            Feedback feedback = feedbackDAO.findById(feedbackId);
            if (feedback == null) {
                LOGGER.warning("Không tìm thấy feedback ID: " + feedbackId);
                return false;
            }
            if (newStatus != null && !newStatus.isBlank() && VALID_STATUSES.contains(newStatus)) {
                feedbackDAO.updateStatus(feedbackId, newStatus);
            } else {
                if ("RECEIVED".equals(feedback.getStatus())) {
                    feedbackDAO.updateStatus(feedbackId, "PROCESSING");
                    newStatus = "PROCESSING";
                } else {
                    newStatus = feedback.getStatus();
                }
            }
            feedbackDAO.addMessage(feedbackId, "ADMIN", message);
            final String finalStatus = newStatus;
            try {
                EmailService emailService = new EmailService();
                emailService.sendFeedbackReplyNotification(
                        feedback.getCustomerEmail(),
                        feedback.getTicketCode(),
                        message,
                        finalStatus
                );
            } catch (Exception e) {
                LOGGER.log(Level.WARNING,
                        "Không gửi được email phản hồi cho ticket: " + feedback.getTicketCode(), e);
            }
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi admin reply feedback #" + feedbackId, e);
            return false;
        }
    }

    public boolean updateStatus(int feedbackId, String newStatus) {
        if (newStatus == null || !VALID_STATUSES.contains(newStatus)) {
            return false;
        }
        try {
            feedbackDAO.updateStatus(feedbackId, newStatus);
            String statusLabel = switch (newStatus) {
                case "RECEIVED" -> "Đã tiếp nhận";
                case "PROCESSING" -> "Đang xử lý";
                case "RESOLVED" -> "Đã giải quyết";
                case "CLOSED" -> "Đã đóng";
                default -> newStatus;
            };
            feedbackDAO.addMessage(feedbackId, "SYSTEM",
                    "Trạng thái ticket đã được cập nhật thành: " + statusLabel);
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi cập nhật status feedback #" + feedbackId, e);
            return false;
        }
    }
}