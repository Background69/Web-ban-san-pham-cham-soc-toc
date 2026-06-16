<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket ${fn:escapeXml(feedback.ticketCode)} — HairGlow Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/support.css">
</head>
<body>
<div class="container">
    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="support"/>
    </jsp:include>
    <main class="content admin-support-page">
        <c:if test="${not empty successMessage}">
            <div class="as-alert as-alert--success">
                <i class="fas fa-check-circle"></i> ${fn:escapeXml(successMessage)}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="as-alert as-alert--error">
                <i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(errorMessage)}
            </div>
        </c:if>
        <div class="as-detail-header">
            <div class="as-detail-header-left">
                <a href="${pageContext.request.contextPath}/admin/support" class="as-btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
                <span class="as-detail-ticket-code">${fn:escapeXml(feedback.ticketCode)}</span>
            </div>
            <c:set var="statusClass" value="" />
            <c:set var="statusLabel" value="" />
            <c:choose>
                <c:when test="${feedback.status == 'RECEIVED'}">
                    <c:set var="statusClass" value="as-status--received" />
                    <c:set var="statusLabel" value="Đã tiếp nhận" />
                </c:when>
                <c:when test="${feedback.status == 'PROCESSING'}">
                    <c:set var="statusClass" value="as-status--processing" />
                    <c:set var="statusLabel" value="Đang xử lý" />
                </c:when>
                <c:when test="${feedback.status == 'RESOLVED'}">
                    <c:set var="statusClass" value="as-status--resolved" />
                    <c:set var="statusLabel" value="Đã giải quyết" />
                </c:when>
                <c:when test="${feedback.status == 'CLOSED'}">
                    <c:set var="statusClass" value="as-status--closed" />
                    <c:set var="statusLabel" value="Đã đóng" />
                </c:when>
            </c:choose>
            <span class="as-status ${statusClass}" style="font-size:13px;padding:7px 16px;">
                ${statusLabel}
            </span>
        </div>
        <div class="as-detail-grid">

            <div class="as-card">
                <div class="as-card-title"><i class="fas fa-user"></i> Thông tin khách hàng</div>
                <div class="as-info-row">
                    <span class="as-info-label">Họ tên:</span>
                    <span class="as-info-value">
                        <c:choose>
                            <c:when test="${not empty feedback.customerName}">
                                ${fn:escapeXml(feedback.customerName)}
                            </c:when>
                            <c:otherwise><em style="color:var(--support-muted)">Không cung cấp</em></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="as-info-row">
                    <span class="as-info-label">Email:</span>
                    <span class="as-info-value">${fn:escapeXml(feedback.customerEmail)}</span>
                </div>
                <c:if test="${feedback.userId != null}">
                    <div class="as-info-row">
                        <span class="as-info-label">User ID:</span>
                        <span class="as-info-value">#${feedback.userId}</span>
                    </div>
                </c:if>
                <div class="as-info-row">
                    <span class="as-info-label">Ngày gửi:</span>
                    <span class="as-info-value">
                        <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </span>
                </div>
            </div>

            <div class="as-card">
                <div class="as-card-title"><i class="fas fa-ticket-alt"></i> Thông tin ticket</div>
                <div class="as-info-row">
                    <span class="as-info-label">Mã ticket:</span>
                    <span class="as-info-value" style="font-weight:700;color:var(--support-primary);">
                        ${fn:escapeXml(feedback.ticketCode)}
                    </span>
                </div>
                <div class="as-info-row">
                    <span class="as-info-label">Chủ đề:</span>
                    <span class="as-info-value">
                        <c:set var="catClass" value="" />
                        <c:set var="catLabel" value="${fn:escapeXml(feedback.category)}" />
                        <c:choose>
                            <c:when test="${feedback.category == 'SYSTEM_ERROR'}">
                                <c:set var="catClass" value="as-category--system_error" />
                                <c:set var="catLabel" value="Lỗi hệ thống" />
                            </c:when>
                            <c:when test="${feedback.category == 'SHIPPING'}">
                                <c:set var="catClass" value="as-category--shipping" />
                                <c:set var="catLabel" value="Vận chuyển / Giao hàng" />
                            </c:when>
                            <c:when test="${feedback.category == 'PRODUCT_QUALITY'}">
                                <c:set var="catClass" value="as-category--product_quality" />
                                <c:set var="catLabel" value="Chất lượng sản phẩm" />
                            </c:when>
                            <c:when test="${feedback.category == 'SHOPPING_GUIDE'}">
                                <c:set var="catLabel" value="Hướng dẫn mua hàng" />
                            </c:when>
                            <c:when test="${feedback.category == 'OTHER'}">
                                <c:set var="catLabel" value="Khác" />
                            </c:when>
                        </c:choose>
                        <span class="as-category ${catClass}">${catLabel}</span>
                    </span>
                </div>
                <div class="as-info-row">
                    <span class="as-info-label">Tiêu đề:</span>
                    <span class="as-info-value" style="font-weight:600;">${fn:escapeXml(feedback.title)}</span>
                </div>
                <div class="as-info-row">
                    <span class="as-info-label">Cập nhật:</span>
                    <span class="as-info-value">
                        <fmt:formatDate value="${feedback.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </span>
                </div>
            </div>
            <div class="as-card as-content-card">
                <div class="as-card-title"><i class="fas fa-align-left"></i> Nội dung ban đầu</div>
                <div class="as-ticket-content">${fn:escapeXml(feedback.content)}</div>
            </div>
        </div>
        <div class="as-card" style="margin-bottom:28px;">
            <div class="as-card-title"><i class="fas fa-images"></i> Ảnh đính kèm</div>
            <c:choose>
                <c:when test="${not empty feedbackImages}">
                    <div class="as-images-grid">
                        <c:forEach var="img" items="${feedbackImages}">
                            <a href="${fn:escapeXml(img.imageUrl)}" target="_blank" rel="noopener noreferrer">
                                <img src="${fn:escapeXml(img.imageUrl)}"
                                     alt="Ảnh bằng chứng"
                                     class="as-image-thumb"
                                     loading="lazy">
                            </a>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="as-images-empty">Không có ảnh đính kèm cho ticket này.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="as-card" style="margin-bottom:28px;">
            <div class="as-card-title"><i class="fas fa-comments"></i> Lịch sử trao đổi</div>
            <c:choose>
                <c:when test="${not empty feedbackMessages}">
                    <div class="as-timeline">
                        <c:forEach var="msg" items="${feedbackMessages}">
                            <c:set var="senderClass" value="" />
                            <c:set var="senderLabel" value="" />
                            <c:choose>
                                <c:when test="${msg.senderType == 'CUSTOMER'}">
                                    <c:set var="senderClass" value="as-timeline-item--customer" />
                                    <c:set var="senderLabel" value="Khách hàng" />
                                </c:when>
                                <c:when test="${msg.senderType == 'ADMIN'}">
                                    <c:set var="senderClass" value="as-timeline-item--admin" />
                                    <c:set var="senderLabel" value="Admin" />
                                </c:when>
                                <c:when test="${msg.senderType == 'SYSTEM'}">
                                    <c:set var="senderClass" value="as-timeline-item--system" />
                                    <c:set var="senderLabel" value="Hệ thống" />
                                </c:when>
                            </c:choose>
                            <div class="as-timeline-item ${senderClass}">
                                <div class="as-timeline-dot"></div>
                                <div class="as-timeline-sender">${senderLabel}</div>
                                <div class="as-timeline-message">${fn:escapeXml(msg.message)}</div>
                                <div class="as-timeline-time">
                                    <fmt:formatDate value="${msg.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color:var(--support-muted);font-size:14px;font-style:italic;">
                        Chưa có tin nhắn nào trong ticket này.
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="as-card as-reply-card">
            <div class="as-card-title"><i class="fas fa-reply"></i> Phản hồi ticket</div>
            <form class="as-reply-form"
                  method="post"
                  action="${pageContext.request.contextPath}/admin/support?action=reply"
                  id="adminReplyForm">
                <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">

                <textarea name="message"
                          placeholder="Nhập nội dung phản hồi cho khách hàng..."
                          required
                          minlength="5"
                          id="replyMessage"></textarea>
                <div class="as-reply-actions">
                    <select name="newStatus" id="replyStatus">
                        <option value="">— Giữ trạng thái hiện tại —</option>
                        <option value="PROCESSING" ${feedback.status == 'RECEIVED' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="RESOLVED">Đã giải quyết</option>
                        <option value="CLOSED">Đã đóng</option>
                    </select>
                    <button type="submit" class="as-btn-submit" id="btnReply">
                        <i class="fas fa-paper-plane"></i> Gửi phản hồi
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>
<script>
(function() {
    'use strict';
    var form = document.getElementById('adminReplyForm');
    if (!form) return;
    form.addEventListener('submit', function(e) {
        var msg = document.getElementById('replyMessage');
        if (!msg || msg.value.trim().length < 5) {
            e.preventDefault();
            msg.style.borderColor = '#C62828';
            msg.focus();
            return;
        }
        var btn = document.getElementById('btnReply');
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
        }
    });
    var msg = document.getElementById('replyMessage');
    if (msg) {
        msg.addEventListener('input', function() {
            this.style.borderColor = '';
        });
    }
})();
</script>
</body>
</html>