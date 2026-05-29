<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý địa chỉ - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/address-form.css">
</head>

<body class="profile-page">

<jsp:include page="/layout/header.jsp"/>

<main class="profile-container">
    <!-- Tab Navigation -->
    <div class="tab-navigation">
        <a href="${pageContext.request.contextPath}/profile" class="tab-link">
            <i class="fas fa-home"></i>
            <span>Tổng quan</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/orders" class="tab-link">
            <i class="fas fa-box"></i>
            <span>Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/addresses" class="tab-link active">
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

    <!-- Tab Content -->
    <div class="tab-content">
        <div class="tab-content-header">
            <h3 class="tab-content-title">
                <i class="fas fa-map-marker-alt"></i> Địa chỉ giao hàng
            </h3>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Existing Addresses -->
        <div class="mb-4">
            <h5 class="fw-semibold mb-3">Địa chỉ đã lưu</h5>
            <c:choose>
                <c:when test="${empty addresses}">
                    <div class="empty-state" style="padding: 40px 20px;">
                        <div class="empty-state-icon" style="width: 80px; height: 80px;">
                            <i class="fas fa-map-marker-alt" style="font-size: 32px;"></i>
                        </div>
                        <h5 class="empty-state-title">Chưa có địa chỉ nào</h5>
                        <p class="empty-state-text">Thêm địa chỉ giao hàng để đặt hàng nhanh hơn</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="address-list">
                        <c:forEach var="address" items="${addresses}">
                            <div class="address-card ${address.defaultAddress ? 'is-default' : ''}">
                                <div class="address-card-header">
                                                <span class="address-type">
                                                    <i class="fas fa-home"></i> Địa chỉ giao hàng
                                                </span>
                                    <c:if test="${address.defaultAddress}">
                                        <span class="address-default-badge">Mặc định</span>
                                    </c:if>
                                </div>
                                <div class="address-name">${address.fullName}</div>
                                <div class="address-phone">
                                    <i class="fas fa-phone-alt me-1"></i> ${address.phone}
                                </div>
                                <div class="address-detail">
                                        ${address.specificAddress},
                                        ${address.wardName},
                                    <c:if test="${not empty address.districtName}">
                                        ${address.districtName},
                                    </c:if>
                                        ${address.provinceName}
                                </div>
                                <div class="address-actions">
                                    <c:if test="${!address.defaultAddress}">
                                        <form
                                                action="${pageContext.request.contextPath}/profile/addresses/set-default"
                                                method="post" style="display: inline;">
                                            <input type="hidden" name="addressId"
                                                   value="${address.addressId}">
                                            <button type="submit" class="btn-address btn-set-default">
                                                <i class="fas fa-check"></i> Đặt mặc định
                                            </button>
                                        </form>
                                    </c:if>
                                    <form
                                            action="${pageContext.request.contextPath}/profile/addresses/delete"
                                            method="post" style="display: inline;">
                                        <input type="hidden" name="addressId" value="${address.addressId}">
                                        <button type="submit" class="btn-address btn-delete"
                                                onclick="return confirm('Bạn chắc chắn muốn xóa địa chỉ này?')">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="address-form-section">
            <div class="section-title">
                <i class="fas fa-plus-circle" style="color: var(--addr-accent); margin-right: 6px;"></i>Thêm địa chỉ mới
            </div>
            <p class="section-subtitle">Vui lòng điền đầy đủ thông tin để giao hàng chính xác.</p>

            <form action="${pageContext.request.contextPath}/profile/addresses/add" method="post"
                  id="addressForm">

                <div class="address-form-grid">

                    <!-- Họ và tên -->
                    <div class="addr-form-group">
                        <label for="fullName">Họ và tên <span class="required">*</span></label>
                        <input type="text" class="addr-input" name="fullName" id="fullName"
                               placeholder="Nhập họ tên người nhận" required>
                    </div>

                    <!-- Số điện thoại -->
                    <div class="addr-form-group">
                        <label for="phone">Số điện thoại <span class="required">*</span></label>
                        <input type="tel" class="addr-input" name="phone" id="phone"
                               placeholder="Nhập số điện thoại" required>
                    </div>

                    <!-- Tỉnh/Thành phố -->
                    <div class="addr-form-group">
                        <label>Tỉnh/Thành phố <span class="required">*</span></label>
                        <div class="addr-custom-select" id="addrProvince"></div>
                        <input type="hidden" name="provinceCode" id="provinceCode">
                        <input type="hidden" name="provinceName" id="provinceName">
                    </div>

                    <!-- Quận/Huyện  -->
                    <div class="addr-form-group">
                        <label>Quận/Huyện <span class="required">*</span></label>
                        <div class="addr-custom-select" id="addrDistrict"></div>
                        <input type="hidden" name="districtCode" id="districtCode">
                        <input type="hidden" name="districtName" id="districtName">
                    </div>

                    <!-- Phường/Xã  -->
                    <div class="addr-form-group">
                        <label>Phường/Xã <span class="required">*</span></label>
                        <div class="addr-custom-select" id="addrWard"></div>
                        <input type="hidden" name="wardCode" id="wardCode">
                        <input type="hidden" name="wardName" id="wardName">
                    </div>

                    <!-- Địa chỉ cụ thể -->
                    <div class="addr-form-group">
                        <label for="specificAddress">Địa chỉ cụ thể <span class="required">*</span></label>
                        <input type="text" class="addr-input" name="specificAddress" id="specificAddress"
                               placeholder="Số nhà, tên đường, ngõ..." required>
                    </div>

                    <!-- Ghi chú -->
                    <div class="addr-form-group full-width">
                        <label for="note">Ghi chú cho shipper</label>
                        <textarea class="addr-textarea" name="note" id="note" rows="2"
                                  placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi giao..."></textarea>
                    </div>
                </div>

                <div style="margin-top: 24px; display: flex; gap: 12px; align-items: center;">
                    <button type="submit" class="addr-submit-btn" id="addrSubmitBtn">
                        <i class="fas fa-plus"></i> Thêm địa chỉ
                    </button>
                    <a href="${pageContext.request.contextPath}/profile"
                       style="font-size: 0.88rem; color: var(--addr-text-muted); text-decoration: none;">
                        Quay lại
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.body.dataset.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/static/js/address.js"></script>

<script>
    document.getElementById('addressForm').addEventListener('submit', function (e) {
        const pCode = document.getElementById('provinceCode').value;
        const dCode = document.getElementById('districtCode').value;
        const wCode = document.getElementById('wardCode').value;

        if (!pCode || !dCode || !wCode) {
            e.preventDefault();
            alert('Vui lòng chọn đầy đủ Tỉnh/Thành phố, Quận/Huyện và Phường/Xã.');
        }
    });
</script>

</body>

</html>
