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
                                        ${address.districtName},
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

        <!-- Add New Address Form -->
        <div class="mt-4 pt-4 border-top">
            <h5 class="fw-semibold mb-3">
                <i class="fas fa-plus-circle text-primary me-2"></i>Thêm địa chỉ mới
            </h5>
            <form action="${pageContext.request.contextPath}/profile/addresses/add" method="post"
                  class="profile-form">
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group mb-0">
                            <label class="form-label" for="fullName">Họ và tên</label>
                            <input type="text" class="form-control" name="fullName" id="fullName" required
                                   placeholder="Nhập họ tên người nhận">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-0">
                            <label class="form-label" for="phone">Số điện thoại</label>
                            <input type="text" class="form-control" name="phone" id="phone" required
                                   placeholder="Nhập số điện thoại">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-0">
                            <label class="form-label" for="email">Email (tùy chọn)</label>
                            <input type="email" class="form-control" name="email" id="email"
                                   placeholder="Nhập email">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-0">
                            <label class="form-label" for="province">Tỉnh/Thành phố</label>
                            <select class="form-control" name="provinceCode" id="province" required>
                                <option value="">-- Chọn Tỉnh/Thành phố --</option>
                            </select>
                            <input type="hidden" name="provinceName" id="provinceName">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-0">
                            <label class="form-label" for="district">Quận/Huyện</label>
                            <select class="form-control" name="districtCode" id="district" required
                                    disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                            <input type="hidden" name="districtName" id="districtName">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-0">
                            <label class="form-label" for="ward">Phường/Xã</label>
                            <select class="form-control" name="wardCode" id="ward" required disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                            <input type="hidden" name="wardName" id="wardName">
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="form-group mb-0">
                            <label class="form-label" for="specificAddress">Địa chỉ cụ thể</label>
                            <textarea class="form-control" name="specificAddress" id="specificAddress"
                                      rows="2" required placeholder="Số nhà, tên đường..."></textarea>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="form-group mb-0">
                            <label class="form-label" for="note">Ghi chú (tùy chọn)</label>
                            <textarea class="form-control" name="note" id="note" rows="2"
                                      placeholder="Ghi chú cho shipper..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-profile btn-profile-primary">
                        <i class="fas fa-plus me-1"></i> Thêm địa chỉ
                    </button>
                    <a href="${pageContext.request.contextPath}/profile"
                       class="btn-profile btn-profile-outline">
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
    // Vietnam Address API
    const API_URL = 'https://provinces.open-api.vn/api';

    document.addEventListener('DOMContentLoaded', function () {
        loadProvinces();
    });

    async function loadProvinces() {
        try {
            const response = await fetch(API_URL + '/p/');
            const provinces = await response.json();
            const select = document.getElementById('province');
            provinces.forEach(p => {
                const option = document.createElement('option');
                option.value = p.code;
                option.textContent = p.name;
                option.dataset.name = p.name;
                select.appendChild(option);
            });
        } catch (error) {
            console.error('Error loading provinces:', error);
        }
    }

    document.getElementById('province').addEventListener('change', async function () {
        const provinceCode = this.value;
        const provinceName = this.options[this.selectedIndex].dataset.name || '';
        document.getElementById('provinceName').value = provinceName;

        const districtSelect = document.getElementById('district');
        const wardSelect = document.getElementById('ward');

        districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        districtSelect.disabled = true;
        wardSelect.disabled = true;

        if (provinceCode) {
            try {
                const response = await fetch(API_URL + '/p/' + provinceCode + '?depth=2');
                const data = await response.json();
                data.districts.forEach(d => {
                    const option = document.createElement('option');
                    option.value = d.code;
                    option.textContent = d.name;
                    option.dataset.name = d.name;
                    districtSelect.appendChild(option);
                });
                districtSelect.disabled = false;
            } catch (error) {
                console.error('Error loading districts:', error);
            }
        }
    });

    document.getElementById('district').addEventListener('change', async function () {
        const districtCode = this.value;
        const districtName = this.options[this.selectedIndex].dataset.name || '';
        document.getElementById('districtName').value = districtName;

        const wardSelect = document.getElementById('ward');
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;

        if (districtCode) {
            try {
                const response = await fetch(API_URL + '/d/' + districtCode + '?depth=2');
                const data = await response.json();
                data.wards.forEach(w => {
                    const option = document.createElement('option');
                    option.value = w.code;
                    option.textContent = w.name;
                    option.dataset.name = w.name;
                    wardSelect.appendChild(option);
                });
                wardSelect.disabled = false;
            } catch (error) {
                console.error('Error loading wards:', error);
            }
        }
    });

    document.getElementById('ward').addEventListener('change', function () {
        const wardName = this.options[this.selectedIndex].dataset.name || '';
        document.getElementById('wardName').value = wardName;
    });
</script>

</body>

</html>