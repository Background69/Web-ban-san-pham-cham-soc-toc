<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ - HairGlow</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/profile.css">
</head>

<body class="profile-page">

<jsp:include page="/layout/header.jsp"/>

<main class="profile-container">
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

    <!-- Tab Content -->
    <div class="tab-content">
        <div class="tab-content-header">
            <h3 class="tab-content-title">
                <i class="fas fa-user-edit"></i> Chỉnh sửa hồ sơ
            </h3>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Avatar Upload Section -->
        <div class="profile-form mb-4" style="padding-bottom: 20px; border-bottom: 1px solid #dee2e6;">
            <h5 class="mb-3"><i class="fas fa-camera me-2"></i>Ảnh đại diện</h5>
            <div class="d-flex align-items-center gap-4">
                <div class="avatar-preview position-relative"
                     style="width: 120px; height: 120px; border-radius: 50%; overflow: hidden; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center;">
                    <c:set var="avatarUrl" value="${sessionScope.currentUser.avatar}"/>
                    <%-- Case 1: No custom avatar set --%>
                    <c:choose>
                        <c:when test="${empty avatarUrl || avatarUrl == 'avatar/avatar.jpg'}">
                            <i class="fas fa-user" id="defaultAvatarIcon"
                               style="font-size: 48px; color: white;"></i>
                            <img src="" alt="Avatar" id="avatarPreview"
                                 style="width: 100%; height: 100%; object-fit: cover; display: none;">
                        </c:when>
                        <%-- Case 2: Cloudinary URL (https://) --%>
                        <c:when test="${avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://')}">
                            <img src="${avatarUrl}" alt="Avatar" id="avatarPreview"
                                 style="width: 100%; height: 100%; object-fit: cover;"
                                 onerror="this.style.display='none'; document.getElementById('defaultAvatarIcon').style.display='block';">
                            <i class="fas fa-user" id="defaultAvatarIcon"
                               style="font-size: 48px; color: white; display: none;"></i>
                        </c:when>
                        <%-- Case 3: Local path (static/) --%>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/static/${avatarUrl}" alt="Avatar"
                                 id="avatarPreview"
                                 style="width: 100%; height: 100%; object-fit: cover;"
                                 onerror="this.style.display='none'; document.getElementById('defaultAvatarIcon').style.display='block';">
                            <i class="fas fa-user" id="defaultAvatarIcon"
                               style="font-size: 48px; color: white; display: none;"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <form action="${pageContext.request.contextPath}/profile/avatar" method="post"
                          enctype="multipart/form-data" id="avatarForm">
                        <input type="file" name="avatar" id="avatarFile"
                               accept="image/jpeg,image/png,image/gif,image/webp" style="display: none;"
                               onchange="previewAvatar(this)">
                        <button type="button" class="btn-profile btn-profile-outline"
                                onclick="document.getElementById('avatarFile').click()">
                            <i class="fas fa-upload me-1"></i> Chọn ảnh
                        </button>
                        <button type="submit" class="btn-profile btn-profile-primary ms-2" id="uploadBtn"
                                style="display: none;">
                            <i class="fas fa-save me-1"></i> Lưu avatar
                        </button>
                    </form>
                    <div class="form-hint mt-2">Chấp nhận: JPG, PNG, GIF, WebP. Tối đa 2MB.</div>
                </div>
            </div>
        </div>

        <!-- Profile Edit Form -->
        <div class="profile-form">
            <form action="${pageContext.request.contextPath}/profile/edit" method="post">
                <div class="form-group">
                    <label class="form-label" for="email">
                        <i class="fas fa-envelope me-1"></i> Email
                    </label>
                    <input type="email" class="form-control" id="email" value="${user.email}" disabled>
                    <div class="form-hint">
                        <i class="fas fa-lock me-1"></i> Email không thể thay đổi
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="fullname">
                        <i class="fas fa-user me-1"></i> Họ tên
                    </label>
                    <input type="text" class="form-control" id="fullname"
                           name="fullname"
                           value="${user.fullName}"
                           required minlength="10" maxlength="30"
                           pattern="[A-Za-zÀ-ỹ\s]+"
                           oninput="validateFullname(this)">
                    <div class="form-hint" id="fullnameHint">
                        Chỉ chứa chữ cái
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="username">
                        <i class="fas fa-user me-1"></i> Tên đăng nhập
                    </label>
                    <input type="text" class="form-control" id="username" name="username"
                           value="${user.username}" required minlength="3" maxlength="50"
                           pattern="[a-zA-Z0-9_]+" oninput="validateUsername(this)">
                    <div class="form-hint" id="usernameHint">
                        Chỉ chứa chữ cái, số và dấu gạch dưới (_)
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="phone">
                        <i class="fas fa-phone me-1"></i> Số điện thoại
                    </label>
                    <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}"
                           pattern="[0-9]{10,11}" placeholder="VD: 0912345678" oninput="validatePhone(this)">
                    <div class="form-hint" id="phoneHint">
                        Nhập số điện thoại 10-11 chữ số
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-shield-alt me-1"></i> Phương thức đăng nhập
                    </label>
                    <div class="d-flex align-items-center gap-2 p-3 bg-light rounded">
                        <c:choose>
                            <c:when test="${user.authProvider == 'GOOGLE'}">
                                <i class="fab fa-google text-danger" style="font-size: 24px;"></i>
                                <span>Đăng nhập bằng Google</span>
                                <span class="profile-badge badge-success ms-auto">
                                                <i class="fas fa-check"></i> Đã liên kết
                                            </span>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-envelope text-primary" style="font-size: 24px;"></i>
                                <span>Đăng nhập bằng Email/Mật khẩu</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-profile btn-profile-primary">
                        <i class="fas fa-save me-1"></i> Lưu thay đổi
                    </button>
                    <a href="${pageContext.request.contextPath}/profile"
                       class="btn-profile btn-profile-outline">
                        Hủy
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ========== TOAST NOTIFICATION SYSTEM ==========
    function showToast(message, type = 'success', duration = 3000) {
        const toastContainer = document.getElementById('toastContainer');
        if (!toastContainer) return;

        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        const icons = {
            success: '<i class="fas fa-check-circle"></i>',
            error: '<i class="fas fa-exclamation-circle"></i>',
            warning: '<i class="fas fa-exclamation-triangle"></i>',
            info: '<i class="fas fa-info-circle"></i>',
            loading: '<i class="fas fa-spinner toast-spinner"></i>'
        };

        toast.innerHTML = `
        <div class="toast-icon ${type}">
            ${icons[type] || icons.info}
        </div>
        <div class="toast-content">${message}</div>
    `;

        toastContainer.appendChild(toast);

        if (type !== 'loading') {
            setTimeout(() => {
                toast.classList.add('hide');
                setTimeout(() => toast.remove(), 300);
            }, duration);
        }

        return toast;
    }

    document.addEventListener('DOMContentLoaded', function () {
        const avatarForm = document.getElementById('avatarForm');
        const uploadBtn = document.getElementById('uploadBtn');
        const avatarFile = document.getElementById('avatarFile');

        let isSubmittingAvatar = false;

        if (avatarForm) {
            avatarForm.addEventListener('submit', function (e) {
                if (isSubmittingAvatar) {
                    e.preventDefault();
                    return;
                }

                if (!avatarFile || !avatarFile.files || avatarFile.files.length === 0) {
                    e.preventDefault();
                    showToast('Vui lòng chọn ảnh đại diện trước khi lưu.', 'warning', 3000);
                    return;
                }

                isSubmittingAvatar = true;

                if (uploadBtn) {
                    uploadBtn.disabled = true;
                    uploadBtn.style.opacity = '0.6';
                    uploadBtn.style.cursor = 'not-allowed';
                    uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang xử lý...';
                }
            });
        }

        const successAlert = document.querySelector('.alert-success');
        const errorAlert = document.querySelector('.alert-danger');

        if (successAlert) {
            const message = successAlert.innerText.replace(/×/g, '').trim();

            showToast(message, 'success', 3000);

            successAlert.style.display = 'none';
        }

        if (errorAlert) {
            const message = errorAlert.innerText.replace(/×/g, '').trim();

            showToast(message, 'error', 3000);

            errorAlert.style.display = 'none';

            if (uploadBtn) {
                uploadBtn.disabled = false;
                uploadBtn.style.opacity = '1';
                uploadBtn.style.cursor = 'pointer';
                uploadBtn.innerHTML = '<i class="fas fa-save me-1"></i> Lưu avatar';
            }
        }
    });

    function validateUsername(input) {
        const hint = document.getElementById('usernameHint');
        const value = input.value;
        const isValid = /^[a-zA-Z0-9_]+$/.test(value) && value.length >= 3;

        if (value.length === 0) {
            input.classList.remove('is-valid', 'is-invalid');
            hint.innerHTML = 'Chỉ chứa chữ cái, số và dấu gạch dưới (_)';
            hint.style.color = '';
        } else if (isValid) {
            input.classList.add('is-valid');
            input.classList.remove('is-invalid');
            hint.innerHTML = '<i class="fas fa-check-circle me-1"></i> Hợp lệ';
            hint.style.color = '#10b981';
        } else {
            input.classList.add('is-invalid');
            input.classList.remove('is-valid');
            hint.innerHTML = '<i class="fas fa-times-circle me-1"></i> Không hợp lệ (chỉ chứa chữ, số, _)';
            hint.style.color = '#ef4444';
        }
    }

    function validateFullname(input) {
        const hint = document.getElementById('fullnameHint');
        const value = input.value.trim().replace(/\s+/g, " ");
        const regex = /^[A-Za-zÀ-ỹ\s]+$/;

        if (value.length === 0) {
            input.classList.remove('is-valid', 'is-invalid');
            hint.innerHTML = 'Họ tên chỉ được chứa chữ cái và khoảng trắng';
            hint.style.color = '';
            return;
        }

        if (value.length < 10 || value.length > 30) {
            input.classList.add('is-invalid');
            input.classList.remove('is-valid');
            hint.innerHTML = '<i class="fas fa-times-circle me-1"></i> Họ tên phải từ 10–30 ký tự';
            hint.style.color = '#ef4444';
            return;
        }

        if (!regex.test(value)) {
            input.classList.add('is-invalid');
            input.classList.remove('is-valid');
            hint.innerHTML = '<i class="fas fa-times-circle me-1"></i> Chỉ được chứa chữ cái và khoảng trắng';
            hint.style.color = '#ef4444';
            return;
        }

        input.classList.add('is-valid');
        input.classList.remove('is-invalid');
        hint.innerHTML = '<i class="fas fa-check-circle me-1"></i> Hợp lệ';
        hint.style.color = '#10b981';
    }

    function validatePhone(input) {
        const hint = document.getElementById('phoneHint');
        const value = input.value;
        const isValid = /^[0-9]{10,11}$/.test(value);

        if (value.length === 0) {
            input.classList.remove('is-valid', 'is-invalid');
            hint.innerHTML = 'Nhập số điện thoại 10-11 chữ số';
            hint.style.color = '';
        } else if (isValid) {
            input.classList.add('is-valid');
            input.classList.remove('is-invalid');
            hint.innerHTML = '<i class="fas fa-check-circle me-1"></i> Hợp lệ';
            hint.style.color = '#10b981';
        } else {
            input.classList.add('is-invalid');
            input.classList.remove('is-valid');
            hint.innerHTML = '<i class="fas fa-times-circle me-1"></i> Số điện thoại không hợp lệ';
            hint.style.color = '#ef4444';
        }
    }

    // Preview avatar before upload
    function previewAvatar(input) {
        const file = input.files[0];
        if (!file) return;

        // Validate file type
        const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (!validTypes.includes(file.type)) {
            alert('Vui lòng chọn file ảnh hợp lệ (JPG, PNG, GIF, WebP)');
            input.value = '';
            return;
        }

        // Validate file size (max 2MB)
        if (file.size > 2 * 1024 * 1024) {
            alert('File ảnh không được vượt quá 2MB');
            input.value = '';
            return;
        }

        // Preview image
        const reader = new FileReader();
        reader.onload = function (e) {
            const preview = document.getElementById('avatarPreview');
            const defaultIcon = document.getElementById('defaultAvatarIcon');

            preview.src = e.target.result;
            preview.style.display = 'block';
            if (defaultIcon) defaultIcon.style.display = 'none';

            // Show upload button
            document.getElementById('uploadBtn').style.display = 'inline-flex';
        };
        reader.readAsDataURL(file);
    }
</script>

</body>

</html>