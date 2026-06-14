package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model Review - Bảng reviews trong database
 * Quản lý đánh giá sản phẩm từ khách hàng
 */
public class Review implements Serializable {
    private int reviewId;
    private int productId;
    private Integer userId;
    private User reviewer;
    private String reviewerName;
    private int rating; // 1-5 sao
    private String content;
    private Timestamp createdAt;
    private String productName;
    private String productSlug;
    private String productImageUrl;
    private List<Image> images = new ArrayList<>();
    private String adminReply;
    private Timestamp adminReplyDate;

    // Constructors
    public Review() {
    }

    // Getters and Setters
    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public User getReviewer() {
        return reviewer;
    }

    public void setReviewer(User reviewer) {
        this.reviewer = reviewer;
    }

    public String getReviewerName() {
        return reviewerName;
    }

    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductSlug() {
        return productSlug;
    }

    public void setProductSlug(String productSlug) {
        this.productSlug = productSlug;
    }

    public String getProductImageUrl() {
        return productImageUrl;
    }

    public void setProductImageUrl(String productImageUrl) {
        this.productImageUrl = productImageUrl;
    }

    public List<Image> getImages() {
        return images;
    }

    public void setImages(List<Image> images) {
        this.images = images;
    }

    public String getAdminReply() {
        return adminReply;
    }

    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public Timestamp getAdminReplyDate() {
        return adminReplyDate;
    }

    public void setAdminReplyDate(Timestamp adminReplyDate) {
        this.adminReplyDate = adminReplyDate;
    }

}
