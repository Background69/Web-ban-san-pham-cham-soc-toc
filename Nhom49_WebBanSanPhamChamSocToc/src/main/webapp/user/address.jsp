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
    <c:set var="activeTab" value="addresses" scope="request"/>

    <div class="account-layout">
        <jsp:include page="/user/layout/account-sidebar.jsp"/>

        <div class="account-main">
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
                                <div class="address-actions-bar">
                                    <div class="address-actions-left">
                                        <c:if test="${!address.defaultAddress}">
                                            <form action="${pageContext.request.contextPath}/profile/addresses/set-default"
                                                  method="post" class="inline-form">
                                                <input type="hidden" name="addressId" value="${address.addressId}">
                                                <button type="submit" class="btn-address btn-set-default">
                                                    <i class="fas fa-check"></i> Đặt mặc định
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${address.defaultAddress}">
                                            <span class="address-default-label">
                                                <i class="fas fa-check-circle"></i> Địa chỉ mặc định
                                            </span>
                                        </c:if>
                                    </div>
                                    <div class="address-actions-right">
                                        <button type="button" class="btn-address btn-edit"
                                                data-id="${address.addressId}"
                                                data-name="${address.fullName}"
                                                data-phone="${address.phone}"
                                                data-street="${address.specificAddress}"
                                                data-ward-code="${address.wardCode}"
                                                data-ward-name="${address.wardName}"
                                                data-district-code="${address.districtCode}"
                                                data-district-name="${address.districtName}"
                                                data-province-code="${address.provinceCode}"
                                                data-province-name="${address.provinceName}"
                                                onclick="openEditModal(this)">
                                            <i class="fas fa-pen"></i> Chỉnh sửa
                                        </button>
                                        <button type="button" class="btn-address btn-delete"
                                                data-id="${address.addressId}"
                                                data-name="${address.fullName}"
                                                onclick="openDeleteModal(this)">
                                            <i class="fas fa-trash-alt"></i> Xóa
                                        </button>
                                    </div>
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
    </div>
</main>

<div class="hg-modal-overlay" id="editAddressModal">
    <div class="hg-modal">
        <div class="hg-modal-header">
            <h4 class="hg-modal-title">
                <i class="fas fa-pen-fancy"></i> Chỉnh sửa địa chỉ
            </h4>
            <button type="button" class="hg-modal-close" onclick="closeEditModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/profile/addresses/edit" method="post" id="editAddressForm">
            <div class="hg-modal-body">
                <input type="hidden" name="addressId" id="editAddressId">

                <div class="hg-modal-form-grid">
                    <div class="addr-form-group">
                        <label for="editFullName">Họ và tên <span class="required">*</span></label>
                        <input type="text" class="addr-input" name="fullName" id="editFullName"
                               placeholder="Nhập họ tên người nhận" required>
                    </div>
                    <div class="addr-form-group">
                        <label for="editPhone">Số điện thoại <span class="required">*</span></label>
                        <input type="tel" class="addr-input" name="phone" id="editPhone"
                               placeholder="Nhập số điện thoại" required>
                    </div>

                    <div class="addr-form-group">
                        <label>Tỉnh/Thành phố <span class="required">*</span></label>
                        <div class="addr-custom-select" id="editAddrProvince"></div>
                        <input type="hidden" name="provinceCode" id="editProvinceCode">
                        <input type="hidden" name="provinceName" id="editProvinceName">
                    </div>
                    <div class="addr-form-group">
                        <label>Quận/Huyện <span class="required">*</span></label>
                        <div class="addr-custom-select" id="editAddrDistrict"></div>
                        <input type="hidden" name="districtCode" id="editDistrictCode">
                        <input type="hidden" name="districtName" id="editDistrictName">
                    </div>
                    <div class="addr-form-group">
                        <label>Phường/Xã <span class="required">*</span></label>
                        <div class="addr-custom-select" id="editAddrWard"></div>
                        <input type="hidden" name="wardCode" id="editWardCode">
                        <input type="hidden" name="wardName" id="editWardName">
                    </div>
                    <div class="addr-form-group">
                        <label for="editSpecificAddress">Địa chỉ cụ thể <span class="required">*</span></label>
                        <input type="text" class="addr-input" name="specificAddress" id="editSpecificAddress"
                               placeholder="Số nhà, tên đường, ngõ..." required>
                    </div>
                </div>
            </div>
            <div class="hg-modal-footer">
                <button type="button" class="hg-modal-btn hg-btn-cancel" onclick="closeEditModal()">
                    Hủy
                </button>
                <button type="submit" class="hg-modal-btn hg-btn-save">
                    <i class="fas fa-save"></i> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>
<div class="hg-modal-overlay hg-modal-delete-overlay" id="deleteConfirmModal">
    <div class="hg-modal hg-modal-sm">
        <div class="hg-modal-body hg-delete-body">
            <div class="hg-delete-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h4 class="hg-delete-title">Xác nhận xóa địa chỉ</h4>
            <p class="hg-delete-text">
                Bạn có chắc chắn muốn xóa địa chỉ của
                <strong id="deleteAddressName"></strong> không?
                Hành động này không thể hoàn tác.
            </p>
        </div>
        <div class="hg-modal-footer hg-delete-footer">
            <button type="button" class="hg-modal-btn hg-btn-cancel" onclick="closeDeleteModal()">
                Hủy
            </button>
            <button type="button" class="hg-modal-btn hg-btn-danger" id="confirmDeleteBtn">
                <i class="fas fa-trash-alt"></i> Xác nhận xóa
            </button>
        </div>
    </div>
</div>
<form id="hiddenDeleteForm" action="${pageContext.request.contextPath}/profile/addresses/delete" method="post" style="display:none;">
    <input type="hidden" name="addressId" id="deleteAddressId">
</form>

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
    let editProvinceCS, editDistrictCS, editWardCS;
    let editModalInitialized = false;

    function initEditSelects() {
        if (editModalInitialized) return;
        const ctxPath = document.body.dataset.contextPath || '';

        editProvinceCS = new window.addressModule._CustomSelect(
            document.getElementById('editAddrProvince'), {
                placeholder: '-- Chọn Tỉnh/Thành phố --',
                onSelect: function(item) {
                    document.getElementById('editProvinceCode').value = item.code;
                    document.getElementById('editProvinceName').value = item.fullName;
                    loadEditDistricts(item.code);
                }
            }
        );
        editDistrictCS = new window.addressModule._CustomSelect(
            document.getElementById('editAddrDistrict'), {
                placeholder: '-- Chọn Quận/Huyện --',
                onSelect: function(item) {
                    document.getElementById('editDistrictCode').value = item.code;
                    document.getElementById('editDistrictName').value = item.fullName;
                    loadEditWards(item.code);
                }
            }
        );
        editWardCS = new window.addressModule._CustomSelect(
            document.getElementById('editAddrWard'), {
                placeholder: '-- Chọn Phường/Xã --',
                onSelect: function(item) {
                    document.getElementById('editWardCode').value = item.code;
                    document.getElementById('editWardName').value = item.fullName;
                }
            }
        );

        editModalInitialized = true;
    }

    async function fetchJSON(url, signal) {
        const res = await fetch(url, signal ? { signal } : undefined);
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.json();
    }

    let editDistrictAbort = null;
    let editWardAbort = null;
    async function loadEditProvinces(preselectedCode) {
        const ctxPath = document.body.dataset.contextPath || '';
        editProvinceCS.setLoading(true);
        try {
            const data = await fetchJSON(ctxPath + '/api/provinces');
            editProvinceCS.setItems(data);
            if (preselectedCode) {
                const found = data.find(function(p) { return String(p.code) === String(preselectedCode); });
                if (found) editProvinceCS.selectItem(found);
            }
        } catch (e) {
            console.error('Lỗi tải tỉnh (edit):', e);
        }
    }

    async function loadEditDistricts(provinceCode, preselectedCode) {
        // Hủy request cũ nếu đang chạy
        if (editDistrictAbort) editDistrictAbort.abort();
        editDistrictAbort = new AbortController();
        const signal = editDistrictAbort.signal;

        const ctxPath = document.body.dataset.contextPath || '';
        editDistrictCS.setLoading(true);
        editWardCS.reset('-- Chọn Phường/Xã --');
        try {
            const data = await fetchJSON(ctxPath + '/api/districts?provinceCode=' + provinceCode, signal);
            editDistrictCS.setItems(data);
            if (preselectedCode) {
                const found = data.find(function(d) { return String(d.code) === String(preselectedCode); });
                if (found) editDistrictCS.selectItem(found);
            }
        } catch (e) {
            if (e.name === 'AbortError') return;
            console.error('Lỗi tải quận/huyện (edit):', e);
        }
    }

    async function loadEditWards(districtCode, preselectedCode) {
        // Hủy request cũ nếu đang chạy
        if (editWardAbort) editWardAbort.abort();
        editWardAbort = new AbortController();
        const signal = editWardAbort.signal;

        const ctxPath = document.body.dataset.contextPath || '';
        editWardCS.setLoading(true);
        try {
            const data = await fetchJSON(ctxPath + '/api/wards?districtCode=' + districtCode, signal);
            editWardCS.setItems(data);
            if (preselectedCode) {
                const found = data.find(function(w) { return String(w.code) === String(preselectedCode); });
                if (found) editWardCS.selectItem(found);
            }
        } catch (e) {
            if (e.name === 'AbortError') return;
            console.error('Lỗi tải phường/xã (edit):', e);
        }
    }
    function openEditModal(btn) {
        initEditSelects();
        var id = btn.getAttribute('data-id');
        var name = btn.getAttribute('data-name');
        var phone = btn.getAttribute('data-phone');
        var street = btn.getAttribute('data-street');
        var wardCode = btn.getAttribute('data-ward-code');
        var wardName = btn.getAttribute('data-ward-name');
        var districtCode = btn.getAttribute('data-district-code');
        var districtName = btn.getAttribute('data-district-name');
        var provinceCode = btn.getAttribute('data-province-code');
        var provinceName = btn.getAttribute('data-province-name');

        document.getElementById('editAddressId').value = id;
        document.getElementById('editFullName').value = name;
        document.getElementById('editPhone').value = phone;
        document.getElementById('editSpecificAddress').value = street;

        document.getElementById('editProvinceCode').value = provinceCode;
        document.getElementById('editProvinceName').value = provinceName;
        document.getElementById('editDistrictCode').value = districtCode;
        document.getElementById('editDistrictName').value = districtName;
        document.getElementById('editWardCode').value = wardCode;
        document.getElementById('editWardName').value = wardName;

        loadEditProvinces(provinceCode).then(function() {
            return loadEditDistricts(provinceCode, districtCode);
        }).then(function() {
            return loadEditWards(districtCode, wardCode);
        });

        var modal = document.getElementById('editAddressModal');
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }

    function closeEditModal() {
        var modal = document.getElementById('editAddressModal');
        modal.classList.remove('show');
        document.body.style.overflow = '';
    }

    document.getElementById('editAddressForm').addEventListener('submit', function(e) {
        var pCode = document.getElementById('editProvinceCode').value;
        var dCode = document.getElementById('editDistrictCode').value;
        var wCode = document.getElementById('editWardCode').value;
        if (!pCode || !dCode || !wCode) {
            e.preventDefault();
            alert('Vui lòng chọn đầy đủ Tỉnh/Thành phố, Quận/Huyện và Phường/Xã.');
        }
    });
    function openDeleteModal(btn) {
        var id = btn.getAttribute('data-id');
        var name = btn.getAttribute('data-name');

        document.getElementById('deleteAddressId').value = id;
        document.getElementById('deleteAddressName').textContent = name;

        var modal = document.getElementById('deleteConfirmModal');
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }

    function closeDeleteModal() {
        var modal = document.getElementById('deleteConfirmModal');
        modal.classList.remove('show');
        document.body.style.overflow = '';
    }

    document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
        document.getElementById('hiddenDeleteForm').submit();
    });

    document.querySelectorAll('.hg-modal-overlay').forEach(function(overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === overlay) {
                overlay.classList.remove('show');
                document.body.style.overflow = '';
            }
        });
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeEditModal();
            closeDeleteModal();
        }
    });
</script>
</body>
</html>