<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đổi mật khẩu - HairGlow</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/profile.css">
        </head>

        <body class="profile-page">

            <jsp:include page="/layout/header.jsp" />

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
                    <a href="${pageContext.request.contextPath}/profile/addresses" class="tab-link">
                        <i class="fas fa-map-marker-alt"></i>
                        <span>Địa chỉ</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/reviews" class="tab-link">
                        <i class="fas fa-star"></i>
                        <span>Đánh giá</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/change-password" class="tab-link active">
                        <i class="fas fa-lock"></i>
                        <span>Bảo mật</span>
                    </a>
                </div>

                <!-- Tab Content -->
                <div class="tab-content">
                    <div class="tab-content-header">
                        <h3 class="tab-content-title">
                            <i class="fas fa-shield-alt"></i> Bảo mật tài khoản
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

                    <div class="profile-form">
                        <form action="${pageContext.request.contextPath}/profile/change-password" method="post"
                            id="passwordForm">
                            <div class="form-group">
                                <label class="form-label" for="currentPassword">
                                    <i class="fas fa-key me-1"></i> Mật khẩu hiện tại
                                </label>
                                <div class="position-relative">
                                    <input type="password" class="form-control" id="currentPassword"
                                        name="currentPassword" required>
                                    <button type="button"
                                        class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted toggle-password"
                                        data-target="currentPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="newPassword">
                                    <i class="fas fa-lock me-1"></i> Mật khẩu mới
                                </label>
                                <div class="position-relative">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword"
                                        required onkeyup="checkPasswordStrength()">
                                    <button type="button"
                                        class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted toggle-password"
                                        data-target="newPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>

                                <!-- Password Strength Meter -->
                                <div class="password-strength" id="strengthMeter" style="display: none;">
                                    <div class="strength-meter">
                                        <div class="strength-meter-fill" id="strengthFill"></div>
                                    </div>
                                    <span class="strength-text" id="strengthText"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="confirmPassword">
                                    <i class="fas fa-check-double me-1"></i> Xác nhận mật khẩu mới
                                </label>
                                <div class="position-relative">
                                    <input type="password" class="form-control" id="confirmPassword"
                                        name="confirmPassword" required onkeyup="checkPasswordMatch()">
                                    <button type="button"
                                        class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted toggle-password"
                                        data-target="confirmPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="form-hint" id="matchHint"></div>
                            </div>

                            <!-- Password Requirements -->
                            <div class="password-requirements">
                                <div class="password-requirements-title">Yêu cầu mật khẩu:</div>
                                <div class="password-requirement" id="req-length">
                                    <i class="fas fa-circle"></i> Ít nhất 8 ký tự
                                </div>
                                <div class="password-requirement" id="req-upper">
                                    <i class="fas fa-circle"></i> Có chữ hoa (A-Z)
                                </div>
                                <div class="password-requirement" id="req-lower">
                                    <i class="fas fa-circle"></i> Có chữ thường (a-z)
                                </div>
                                <div class="password-requirement" id="req-number">
                                    <i class="fas fa-circle"></i> Có số (0-9)
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn-profile btn-profile-primary" id="submitBtn">
                                    <i class="fas fa-shield-alt me-1"></i> Đổi mật khẩu
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

            <jsp:include page="/layout/footer.jsp" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Toggle password visibility
                document.querySelectorAll('.toggle-password').forEach(btn => {
                    btn.addEventListener('click', function () {
                        const targetId = this.getAttribute('data-target');
                        const input = document.getElementById(targetId);
                        const icon = this.querySelector('i');

                        if (input.type === 'password') {
                            input.type = 'text';
                            icon.classList.remove('fa-eye');
                            icon.classList.add('fa-eye-slash');
                        } else {
                            input.type = 'password';
                            icon.classList.remove('fa-eye-slash');
                            icon.classList.add('fa-eye');
                        }
                    });
                });

                // Check password strength
                function checkPasswordStrength() {
                    const password = document.getElementById('newPassword').value;
                    const strengthMeter = document.getElementById('strengthMeter');
                    const strengthFill = document.getElementById('strengthFill');
                    const strengthText = document.getElementById('strengthText');

                    // Show/hide meter
                    if (password.length > 0) {
                        strengthMeter.style.display = 'block';
                    } else {
                        strengthMeter.style.display = 'none';
                        return;
                    }

                    // Check requirements
                    const hasLength = password.length >= 8;
                    const hasUpper = /[A-Z]/.test(password);
                    const hasLower = /[a-z]/.test(password);
                    const hasNumber = /[0-9]/.test(password);

                    // Update requirement icons
                    updateRequirement('req-length', hasLength);
                    updateRequirement('req-upper', hasUpper);
                    updateRequirement('req-lower', hasLower);
                    updateRequirement('req-number', hasNumber);

                    // Calculate strength
                    let strength = 0;
                    if (hasLength) strength++;
                    if (hasUpper) strength++;
                    if (hasLower) strength++;
                    if (hasNumber) strength++;

                    // Update meter
                    strengthFill.className = 'strength-meter-fill';
                    strengthText.className = 'strength-text';

                    if (strength === 1) {
                        strengthFill.classList.add('weak');
                        strengthText.classList.add('weak');
                        strengthText.textContent = 'Yếu';
                    } else if (strength === 2) {
                        strengthFill.classList.add('fair');
                        strengthText.classList.add('fair');
                        strengthText.textContent = 'Trung bình';
                    } else if (strength === 3) {
                        strengthFill.classList.add('good');
                        strengthText.classList.add('good');
                        strengthText.textContent = 'Tốt';
                    } else if (strength === 4) {
                        strengthFill.classList.add('strong');
                        strengthText.classList.add('strong');
                        strengthText.textContent = 'Mạnh ✓';
                    }
                }

                function updateRequirement(reqId, isValid) {
                    const req = document.getElementById(reqId);
                    const icon = req.querySelector('i');

                    if (isValid) {
                        req.classList.add('valid');
                        icon.classList.remove('fa-circle');
                        icon.classList.add('fa-check-circle');
                    } else {
                        req.classList.remove('valid');
                        icon.classList.remove('fa-check-circle');
                        icon.classList.add('fa-circle');
                    }
                }

                // Check password match
                function checkPasswordMatch() {
                    const password = document.getElementById('newPassword').value;
                    const confirm = document.getElementById('confirmPassword').value;
                    const hint = document.getElementById('matchHint');
                    const confirmInput = document.getElementById('confirmPassword');

                    if (confirm.length === 0) {
                        hint.textContent = '';
                        confirmInput.classList.remove('is-valid', 'is-invalid');
                        return;
                    }

                    if (password === confirm) {
                        hint.innerHTML = '<i class="fas fa-check-circle text-success me-1"></i> Mật khẩu khớp';
                        hint.style.color = '#10b981';
                        confirmInput.classList.add('is-valid');
                        confirmInput.classList.remove('is-invalid');
                    } else {
                        hint.innerHTML = '<i class="fas fa-times-circle text-danger me-1"></i> Mật khẩu không khớp';
                        hint.style.color = '#ef4444';
                        confirmInput.classList.add('is-invalid');
                        confirmInput.classList.remove('is-valid');
                    }
                }

                // Form validation
                document.getElementById('passwordForm').addEventListener('submit', function (e) {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;

                    if (newPassword !== confirmPassword) {
                        e.preventDefault();
                        alert('Mật khẩu xác nhận không khớp!');
                        return false;
                    }

                    if (newPassword.length < 8) {
                        e.preventDefault();
                        alert('Mật khẩu phải có ít nhất 8 ký tự!');
                        return false;
                    }
                });
            </script>

        </body>

        </html>