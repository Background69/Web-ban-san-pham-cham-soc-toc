<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá của tôi - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
          rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/profile.css">
    <style>
        .my-review-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 15px;
            transition: var(--transition);
        }

        .my-review-card:hover {
            box-shadow: var(--shadow-md);
        }

        .review-product-info {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--gray-100);
        }

        .review-product-image {
            width: 80px;
            height: 80px;
            border-radius: var(--radius-md);
            overflow: hidden;
            flex-shrink: 0;
            background: var(--gray-100);
        }

        .review-product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .review-product-details {
            flex: 1;
            min-width: 0;
        }

        .review-product-name {
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 5px;
            text-decoration: none;
            display: block;
        }

        .review-product-name:hover {
            color: var(--primary-green);
        }

        .review-date {
            font-size: 13px;
            color: var(--gray-500);
        }

        .review-stars {
            display: flex;
            gap: 3px;
            margin-bottom: 10px;
        }

        .review-stars .star {
            color: #ddd;
            font-size: 18px;
        }

        .review-stars .star.filled {
            color: #f59e0b;
        }

        .review-content-text {
            color: var(--gray-700);
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .review-actions {
            display: flex;
            gap: 10px;
        }

        .btn-review-action {
            padding: 8px 16px;
            border-radius: var(--radius-md);
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: none;
        }

        .btn-review-edit {
            background: var(--gray-100);
            color: var(--gray-700);
        }

        .btn-review-edit:hover {
            background: var(--primary-green);
            color: white;
        }

        .btn-review-delete {
            background: #fee2e2;
            color: #dc2626;
        }

        .btn-review-delete:hover {
            background: #dc2626;
            color: white;
        }

        /* Edit Modal */
        .edit-modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .edit-modal-overlay.active {
            display: flex;
        }

        .edit-modal {
            background: white;
            border-radius: var(--radius-lg);
            padding: 25px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
        }

        .edit-modal h3 {
            margin-bottom: 20px;
            color: var(--gray-900);
        }

        .edit-form .form-group {
            margin-bottom: 15px;
        }

        .edit-form label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: var(--gray-700);
        }

        .edit-form textarea {
            width: 100%;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            padding: 10px;
            resize: vertical;
        }

        .edit-form .star-rating-edit {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 5px;
        }

        .edit-form .star-rating-edit input {
            display: none;
        }

        .edit-form .star-rating-edit label {
            cursor: pointer;
            font-size: 28px;
            color: #ddd;
        }

        .edit-form .star-rating-edit label:hover,
        .edit-form .star-rating-edit label:hover ~ label,
        .edit-form .star-rating-edit input:checked ~ label {
            color: #f59e0b;
        }

        .edit-modal-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .admin-reply-block {
            margin-top: 16px;
            margin-left: 24px;
            padding: 18px 20px;
            background: #F9FAFB;
            border-radius: 10px;
            border-left: 3.5px solid var(--primary-green);
            position: relative;
            transition: var(--transition);
        }

        .admin-reply-block:hover {
            background: #F3F5F3;
            box-shadow: 0 2px 8px rgba(50, 110, 81, 0.06);
        }

        .admin-reply-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .admin-reply-logo {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            background: linear-gradient(135deg, var(--primary-green), #3f805f);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .admin-reply-logo i {
            color: #fff;
            font-size: 13px;
        }

        .admin-reply-name {
            font-size: 14px;
            font-weight: 700;
            color: var(--primary-green);
            letter-spacing: -0.01em;
        }

        .badge-admin {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 10px;
            font-size: 10.5px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-radius: 4px;
            background: #1F2937;
            color: #FBBF24;
            border: 1px solid rgba(251, 191, 36, 0.3);
        }

        .badge-admin i {
            font-size: 9px;
        }

        .admin-reply-date {
            font-size: 12px;
            color: var(--gray-400);
            margin-left: auto;
        }

        .admin-reply-content {
            font-size: 14px;
            line-height: 1.65;
            color: var(--gray-700);
            white-space: pre-line;
        }

        /* --- Badge "Có phản hồi mới" --- */
        .reply-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            font-size: 11px;
            font-weight: 600;
            color: #D32F2F;
            background: rgba(211, 47, 47, 0.08);
            border-radius: 20px;
            margin-left: 8px;
            vertical-align: middle;
            animation: replyBadgePulse 2s ease-in-out infinite;
        }

        .reply-badge .reply-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #D32F2F;
            animation: replyDotBlink 1.5s ease-in-out infinite;
        }

        @keyframes replyDotBlink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }

        @keyframes replyBadgePulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(211, 47, 47, 0); }
            50% { box-shadow: 0 0 0 4px rgba(211, 47, 47, 0.08); }
        }

        @media (max-width: 576px) {
            .admin-reply-block {
                margin-left: 12px;
                padding: 14px 16px;
            }

            .admin-reply-date {
                margin-left: 0;
                width: 100%;
                margin-top: 4px;
            }
        }
    </style>
</head>

<body class="profile-page">

<jsp:include page="/layout/header.jsp"/>

<main class="profile-container">
    <c:set var="activeTab" value="reviews" scope="request"/>

    <div class="account-layout">
        <jsp:include page="/user/layout/account-sidebar.jsp"/>

        <div class="account-main">
            <!-- Profile Header Card -->
            <div class="profile-header-card">
                <div class="profile-header-content">
                    <div class="profile-avatar-section">
                        <div class="profile-avatar">
                            <c:set var="avatarUrl" value="${sessionScope.currentUser.avatar}"/>
                            <c:choose>
                                <c:when test="${empty avatarUrl || avatarUrl == 'avatar/avatar.jpg'}">
                                    <i class="fas fa-user default-avatar-icon"></i>
                                </c:when>

                                <c:when test="${avatarUrl.startsWith('https://') || avatarUrl.startsWith('https://')}">
                                    <img src="${avatarUrl}" alt="Avatar">
                                </c:when>

                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/${avatarUrl}" alt="Avatar">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="profile-info">
                        <h1 class="profile-name">${sessionScope.currentUser.username}</h1>
                        <p class="profile-username">@${sessionScope.currentUser.username}</p>
                    </div>
                </div>
            </div>

            <!-- Reviews Content -->
            <div class="tab-content">
                <div class="tab-content-header"
                     style="border-bottom: none; padding-bottom: 0; margin-bottom: 20px;">
                    <h4 class="tab-content-title">
                        <i class="fas fa-star"></i> Đánh giá của tôi
                        <span class="badge bg-primary ms-2">${reviews.size()}</span>
                    </h4>
                </div>

        <c:choose>
            <c:when test="${not empty reviews}">
                <c:forEach var="review" items="${reviews}">
                    <div class="my-review-card" data-review-id="${review.reviewId}">
                        <div class="review-product-info">
                            <div class="review-product-image">
                                <c:choose>
                                    <c:when test="${not empty review.productImageUrl && (review.productImageUrl.startsWith('https://') || review.productImageUrl.startsWith('https://'))}">
                                        <img src="${review.productImageUrl}" alt="${review.productName}">
                                    </c:when>

                                    <c:when test="${not empty review.productImageUrl}">
                                        <img src="${pageContext.request.contextPath}/static/${review.productImageUrl}"
                                             alt="${review.productName}">
                                    </c:when>

                                    <c:otherwise>
                                        <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#f0f0f0;">
                                            <i class="fas fa-image" style="color:#ccc;font-size:24px;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="review-product-details">
                                <a href="${pageContext.request.contextPath}/product/${review.productSlug}"
                                   class="review-product-name">
                                        ${review.productName}
                                </a>
                                <div class="review-date">
                                    <i class="far fa-clock me-1"></i>
                                    <fmt:formatDate value="${review.createdAt}"
                                                    pattern="dd/MM/yyyy HH:mm"/>
                                    <c:if test="${not empty review.adminReply}">
                                        <span class="reply-badge">
                                            <span class="reply-dot"></span> Có phản hồi mới
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="review-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <span class="star ${i <= review.rating ? 'filled' : ''}">★</span>
                            </c:forEach>
                        </div>

                        <div class="review-content-text">
                                ${review.content}
                        </div>

                        <c:if test="${not empty review.adminReply}">
                            <div class="admin-reply-block">
                                <div class="admin-reply-header">
                                    <div class="admin-reply-logo">
                                        <i class="fas fa-leaf"></i>
                                    </div>
                                    <span class="admin-reply-name">Phản hồi từ HairGlow</span>
                                    <span class="badge-admin">
                                        <i class="fas fa-shield-alt"></i> Quản trị viên
                                    </span>
                                    <c:if test="${not empty review.adminReplyDate}">
                                        <span class="admin-reply-date">
                                            <i class="far fa-clock me-1"></i>
                                            <fmt:formatDate value="${review.adminReplyDate}"
                                                            pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                    </c:if>
                                </div>
                                <div class="admin-reply-content">${review.adminReply}</div>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state" style="padding: 60px 20px; text-align: center;">
                    <div class="empty-state-icon"
                         style="width: 80px; height: 80px; margin: 0 auto 20px; background: rgba(245, 158, 11, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-star" style="font-size: 32px; color: #f59e0b;"></i>
                    </div>
                    <h5 style="color: var(--gray-900); margin-bottom: 10px;">Chưa có đánh giá nào</h5>
                    <p style="color: var(--gray-500); margin-bottom: 20px;">Hãy mua sắm và đánh giá sản
                        phẩm để chia sẻ trải nghiệm của bạn</p>
                    <a href="${pageContext.request.contextPath}/store"
                       class="btn-profile btn-profile-primary">
                        <i class="fas fa-shopping-bag"></i> Mua sắm ngay
                    </a>
                </div>
            </c:otherwise>
            </c:choose>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
