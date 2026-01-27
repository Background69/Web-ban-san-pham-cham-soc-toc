<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
          rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/profile.css">
</head>

<body class="profile-page">

<jsp:include page="/layout/header.jsp"/>

<main class="profile-container">
    <!-- Profile Header Card -->
    <div class="profile-header-card">
        <div class="profile-header-content">
            <!-- Avatar Section -->
            <div class="profile-avatar-section">
                <div class="profile-avatar">
                    <c:choose>
                        <c:when test="${not empty user.avatar && user.avatar != 'avatar/avatar.jpg'}">
                            <img src="${pageContext.request.contextPath}/static/${user.avatar}"
                                 alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user default-avatar-icon"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Profile Info -->
            <div class="profile-info">
                <h1 class="profile-name">
                    ${user.username}
                    <c:if test="${user.authProvider == 'GOOGLE'}">
                        <span class="verified-badge"><i class="fas fa-check"></i> Google</span>
                    </c:if>
                </h1>
                <p class="profile-username">@${user.username}</p>

                <div class="profile-meta">
                    <div class="profile-meta-item">
                        <i class="fas fa-envelope"></i>
                        <span>${user.email}</span>
                    </div>
                    <c:if test="${not empty user.phone}">
                        <div class="profile-meta-item">
                            <i class="fas fa-phone"></i>
                            <span>${user.phone}</span>
                        </div>
                    </c:if>
                    <div class="profile-meta-item">
                        <i class="fas fa-user-tag"></i>
                        <span>${user.role}</span>
                    </div>
                </div>

                <div class="profile-badges">
                    <c:if test="${user.authProvider == 'GOOGLE'}">
                                        <span class="profile-badge badge-success">
                                            <i class="fab fa-google"></i> Google
                                        </span>
                    </c:if>
                    <c:if test="${user.active}">
                                        <span class="profile-badge badge-success">
                                            <i class="fas fa-check-circle"></i> Đang hoạt động
                                        </span>
                    </c:if>
                </div>
            </div>

            <!-- Profile Actions -->
            <div class="profile-actions">
                <a href="${pageContext.request.contextPath}/profile/edit"
                   class="btn-profile btn-profile-primary">
                    <i class="fas fa-pen"></i> Chỉnh sửa
                </a>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon icon-orders">
                <i class="fas fa-box"></i>
            </div>
            <div class="stat-value">${stats.totalOrders != null ? stats.totalOrders : 0}</div>
            <div class="stat-label">Đơn hàng</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon icon-spending">
                <i class="fas fa-wallet"></i>
            </div>
            <div class="stat-value">
                <fmt:formatNumber value="${stats.totalSpending != null ? stats.totalSpending : 0}"
                                  type="number" maxFractionDigits="0"/>đ
            </div>
            <div class="stat-label">Chi tiêu</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon icon-addresses">
                <i class="fas fa-map-marker-alt"></i>
            </div>
            <div class="stat-value">${stats.totalAddresses != null ? stats.totalAddresses : 0}</div>
            <div class="stat-label">Địa chỉ</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon icon-points">
                <i class="fas fa-star"></i>
            </div>
            <div class="stat-value">${stats.loyaltyPoints != null ? stats.loyaltyPoints : 0}</div>
            <div class="stat-label">Điểm tích lũy</div>
        </div>
    </div>

    <!-- Tab Navigation -->
    <div class="tab-navigation">
        <a href="${pageContext.request.contextPath}/profile" class="tab-link active">
            <i class="fas fa-home"></i>
            <span>Tổng quan</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/orders" class="tab-link">
            <i class="fas fa-box"></i>
            <span>Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/addresses" class="tab-link">
            <i class="fas fa-map-marker-alt"></i>
            <span>Địa chỉ</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/reviews" class="tab-link">
            <i class="fas fa-star"></i>
            <span>Đánh giá</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/change-password" class="tab-link">
            <i class="fas fa-lock"></i>
            <span>Bảo mật</span>
        </a>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <h3 class="quick-actions-title">Thao tác nhanh</h3>
        <div class="quick-actions-grid">
            <a href="${pageContext.request.contextPath}/profile/orders" class="quick-action-btn">
                <i class="fas fa-box"></i>
                <span>Xem đơn hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/profile/addresses" class="quick-action-btn">
                <i class="fas fa-plus"></i>
                <span>Thêm địa chỉ</span>
            </a>
            <a href="${pageContext.request.contextPath}/profile/change-password"
               class="quick-action-btn">
                <i class="fas fa-key"></i>
                <span>Đổi mật khẩu</span>
            </a>
            <a href="${pageContext.request.contextPath}/store" class="quick-action-btn">
                <i class="fas fa-shopping-bag"></i>
                <span>Mua sắm</span>
            </a>
        </div>
    </div>

    <!-- Tab Content -->
    <div class="tab-content">
        <div class="row g-4">
            <!-- Account Info -->
            <div class="col-12 col-lg-6">
                <div class="tab-content-header"
                     style="border-bottom: none; padding-bottom: 0; margin-bottom: 15px;">
                    <h4 class="tab-content-title">
                        <i class="fas fa-user-circle"></i> Thông tin tài khoản
                    </h4>
                </div>
                <div class="info-list">
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span class="text-muted">Email</span>
                        <span class="fw-medium">${user.email}</span>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span class="text-muted">Tên đăng nhập</span>
                        <span class="fw-medium">${user.username}</span>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span class="text-muted">Số điện thoại</span>
                        <span class="fw-medium">${not empty user.phone ? user.phone : 'Chưa cập
                                nhật'}</span>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span class="text-muted">Vai trò</span>
                        <span class="fw-medium">${user.role}</span>
                    </div>
                    <div class="d-flex justify-content-between py-2">
                        <span class="text-muted">Đăng nhập bằng</span>
                        <span class="fw-medium">
                                            <c:choose>
                                                <c:when test="${user.authProvider == 'GOOGLE'}">
                                                    <i class="fab fa-google text-danger me-1"></i> Google
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-envelope text-primary me-1"></i> Email
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                    </div>
                </div>
            </div>

            <!-- Default Address -->
            <div class="col-12 col-lg-6">
                <div class="tab-content-header"
                     style="border-bottom: none; padding-bottom: 0; margin-bottom: 15px;">
                    <h4 class="tab-content-title">
                        <i class="fas fa-map-marker-alt"></i> Địa chỉ mặc định
                    </h4>
                    <a href="${pageContext.request.contextPath}/profile/addresses"
                       class="btn-profile btn-profile-outline"
                       style="padding: 6px 12px; font-size: 13px;">
                        <i class="fas fa-cog"></i> Quản lý
                    </a>
                </div>
                <c:choose>
                    <c:when test="${not empty defaultAddress}">
                        <div class="address-card is-default">
                            <div class="address-card-header">
                                                <span class="address-type">
                                                    <i class="fas fa-home"></i> Địa chỉ giao hàng
                                                </span>
                                <span class="address-default-badge">Mặc định</span>
                            </div>
                            <div class="address-name">${defaultAddress.fullName}</div>
                            <div class="address-phone">
                                <i class="fas fa-phone-alt me-1"></i> ${defaultAddress.phone}
                            </div>
                            <div class="address-detail">
                                    ${defaultAddress.specificAddress},
                                    ${defaultAddress.wardName},
                                    ${defaultAddress.districtName},
                                    ${defaultAddress.provinceName}
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state" style="padding: 40px 20px;">
                            <div class="empty-state-icon" style="width: 70px; height: 70px;">
                                <i class="fas fa-map-marker-alt" style="font-size: 28px;"></i>
                            </div>
                            <h5 class="empty-state-title" style="font-size: 16px;">Chưa có địa chỉ</h5>
                            <p class="empty-state-text" style="font-size: 13px;">Thêm địa chỉ giao hàng
                                để đặt hàng
                                nhanh hơn</p>
                            <a href="${pageContext.request.contextPath}/profile/addresses"
                               class="btn-profile btn-profile-primary"
                               style="padding: 8px 16px; font-size: 13px;">
                                <i class="fas fa-plus"></i> Thêm địa chỉ
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Recent Orders -->
            <div class="col-12">
                <div class="tab-content-header"
                     style="border-bottom: none; padding-bottom: 0; margin-bottom: 15px;">
                    <h4 class="tab-content-title">
                        <i class="fas fa-history"></i> Đơn hàng gần đây
                    </h4>
                    <a href="${pageContext.request.contextPath}/profile/orders"
                       class="btn-profile btn-profile-outline"
                       style="padding: 6px 12px; font-size: 13px;">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <c:choose>
                    <c:when test="${not empty recentOrders}">
                        <c:forEach var="order" items="${recentOrders}" end="2">
                            <div class="order-card">
                                <div class="order-card-header">
                                    <div class="order-info">
                                        <span class="order-id">Đơn #${order.orderCode}</span>
                                        <span class="order-date">
                                                            <i class="far fa-clock"></i>
                                                            <fmt:formatDate value="${order.createdAt}"
                                                                            pattern="dd/MM/yyyy"/>
                                                        </span>
                                    </div>
                                    <span
                                            class="order-status status-${order.orderStatus != null ? order.orderStatus.toLowerCase() : 'pending'}">
                                                        <c:choose>
                                                            <c:when test="${order.orderStatus == 'PENDING'}"><i
                                                                    class="fas fa-clock"></i> Chờ xác nhận</c:when>
                                                            <c:when test="${order.orderStatus == 'CONFIRMED'}"><i
                                                                    class="fas fa-check"></i> Đã xác nhận</c:when>
                                                            <c:when test="${order.orderStatus == 'SHIPPING'}"><i
                                                                    class="fas fa-truck"></i> Đang giao</c:when>
                                                            <c:when test="${order.orderStatus == 'COMPLETED'}"><i
                                                                    class="fas fa-check-circle"></i> Hoàn thành</c:when>
                                                            <c:when test="${order.orderStatus == 'CANCELLED'}"><i
                                                                    class="fas fa-times-circle"></i> Đã hủy</c:when>
                                                            <c:otherwise>${order.orderStatus}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                </div>
                                <div class="order-card-footer">
                                    <div class="order-total">
                                        Tổng: <span>
                                                            <fmt:formatNumber value="${order.totalAmount}"
                                                                              type="number"/>đ
                                                        </span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/orders/${order.orderId}"
                                       class="btn-order btn-order-primary">
                                        <i class="fas fa-eye"></i> Chi tiết
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state" style="padding: 40px 20px;">
                            <div class="empty-state-icon" style="width: 70px; height: 70px;">
                                <i class="fas fa-shopping-bag" style="font-size: 28px;"></i>
                            </div>
                            <h5 class="empty-state-title" style="font-size: 16px;">Chưa có đơn hàng</h5>
                            <p class="empty-state-text" style="font-size: 13px;">Hãy khám phá và mua sắm
                                sản phẩm yêu
                                thích</p>
                            <a href="${pageContext.request.contextPath}/store"
                               class="btn-profile btn-profile-primary"
                               style="padding: 8px 16px; font-size: 13px;">
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