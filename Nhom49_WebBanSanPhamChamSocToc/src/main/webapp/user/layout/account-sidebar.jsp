<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="account-sidebar">
    <div class="account-sidebar-header">
        <div class="account-sidebar-title">Tài khoản của tôi</div>
        <div class="account-sidebar-subtitle">Quản lý thông tin, đơn hàng và bảo mật tài khoản</div>
    </div>

    <nav class="tab-navigation" aria-label="Điều hướng tài khoản">
        <a href="${pageContext.request.contextPath}/profile"
           class="tab-link ${requestScope.activeTab == 'overview' ? 'active' : ''}">
            <i class="fas fa-home"></i>
            <span>Tổng quan</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/addresses"
           class="tab-link ${requestScope.activeTab == 'addresses' ? 'active' : ''}">
            <i class="fas fa-map-marker-alt"></i>
            <span>Địa chỉ</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/orders"
           class="tab-link ${requestScope.activeTab == 'orders' ? 'active' : ''}">
            <i class="fas fa-box"></i>
            <span>Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/change-password"
           class="tab-link ${requestScope.activeTab == 'password' ? 'active' : ''}">
            <i class="fas fa-lock"></i>
            <span>Đổi mật khẩu</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/reviews"
           class="tab-link ${requestScope.activeTab == 'reviews' ? 'active' : ''}">
            <i class="fas fa-star"></i>
            <span>Đánh giá</span>
        </a>
    </nav>
</aside>

