<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - HairGlow</title>
    <meta name="description" content="Đặt lại mật khẩu tài khoản HairGlow của bạn một cách an toàn và nhanh chóng.">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Roboto:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/reset-password.css">
</head>

<body class="login-page">

<%@ include file="/layout/header.jsp" %>

<main>
    <div class="login-container">
        <div class="reset-card">

            <div class="reset-icon-wrapper">
                <div class="reset-icon-circle">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none"
                         stroke="#3B5838" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        <path d="m9 12 2 2 4-4"/>
                    </svg>
                </div>
            </div>

            <h1 class="reset-title">Đặt lại mật khẩu</h1>
            <p class="reset-subtitle">Tạo mật khẩu mới để bảo vệ tài khoản của bạn</p>

            <c:if test="${not empty error}">
                <div class="error-msg">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${error}
                </div>
            </c:if>

            <form id="resetForm" action="${pageContext.request.contextPath}/reset-password" method="post" autocomplete="off" novalidate>

                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới</label>
                    <div class="password-field">
                        <input type="password" id="newPassword" name="newPassword"
                               placeholder="Tối thiểu 6 ký tự" minlength="6" required
                               autocomplete="new-password">
                        <button type="button" class="toggle-password" data-target="newPassword"
                                aria-label="Hiện/ẩn mật khẩu mới" tabindex="-1">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                        <span class="match-check" aria-hidden="true">
                            <i class="fa-solid fa-circle-check"></i>
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Nhập lại mật khẩu mới</label>
                    <div class="password-field">
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Xác nhận mật khẩu" minlength="6" required
                               autocomplete="new-password">
                        <button type="button" class="toggle-password" data-target="confirmPassword"
                                aria-label="Hiện/ẩn xác nhận mật khẩu" tabindex="-1">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                        <span class="match-check" aria-hidden="true">
                            <i class="fa-solid fa-circle-check"></i>
                        </span>
                    </div>
                    <p class="mismatch-hint" id="mismatchHint">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        Mật khẩu chưa trùng khớp
                    </p>
                </div>

                <div class="password-strength" id="strengthBar">
                    <div class="strength-track">
                        <div class="strength-fill" id="strengthFill"></div>
                    </div>
                    <span class="strength-label" id="strengthLabel"></span>
                </div>

                <button type="submit" id="btnReset" class="btn-login btn-reset" disabled>
                    <i class="fa-solid fa-key"></i>
                    Cập nhật mật khẩu
                </button>
            </form>

            <div class="reset-footer">
                <a href="${pageContext.request.contextPath}/auth/forgot-password" class="footer-link">
                    <i class="fa-solid fa-rotate-right"></i>
                    Gửi lại OTP
                </a>
                <span class="footer-divider"></span>
                <a href="${pageContext.request.contextPath}/auth/login" class="footer-link">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay về đăng nhập
                </a>
            </div>

        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    'use strict';

    const pwd    = document.getElementById('newPassword');
    const cfm    = document.getElementById('confirmPassword');
    const btn    = document.getElementById('btnReset');
    const hint   = document.getElementById('mismatchHint');
    const fill   = document.getElementById('strengthFill');
    const label  = document.getElementById('strengthLabel');
    const form   = document.getElementById('resetForm');
    const MIN    = 6;

    document.querySelectorAll('.toggle-password').forEach(function (toggle) {
        toggle.addEventListener('click', function () {
            var input = document.getElementById(this.dataset.target);
            if (!input) return;

            var icon = this.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
                this.classList.add('active');
            } else {
                input.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
                this.classList.remove('active');
            }
        });
    });

    function getStrength(v) {
        var score = 0;
        if (v.length >= 6)  score++;
        if (v.length >= 10) score++;
        if (/[A-Z]/.test(v)) score++;
        if (/[0-9]/.test(v)) score++;
        if (/[^A-Za-z0-9]/.test(v)) score++;
        return score;          // 0-5
    }

    var strengthMap = [
        { width: '0%',   color: 'transparent',label: '' },
        { width: '20%',  color: '#ef4444',    label: 'Rất yếu' },
        { width: '40%',  color: '#f97316',    label: 'Yếu' },
        { width: '60%',  color: '#eab308',    label: 'Trung bình' },
        { width: '80%',  color: '#84cc16',    label: 'Mạnh' },
        { width: '100%', color: '#22c55e',    label: 'Rất mạnh' }
    ];

    function updateStrength() {
        var s = getStrength(pwd.value);
        var m = strengthMap[s];
        fill.style.width = m.width;
        fill.style.background = m.color;
        label.textContent = m.label;
        label.style.color = m.color;
    }

    function validate() {
        var pv = pwd.value;
        var cv = cfm.value;
        var matched = pv.length >= MIN && cv.length >= MIN && pv === cv;
        var typing  = cv.length > 0 && !matched;

        pwd.classList.toggle('is-matched', matched);
        cfm.classList.toggle('is-matched', matched);

        cfm.classList.toggle('is-mismatched', typing && cv.length >= MIN);

        pwd.closest('.password-field').querySelector('.match-check')
           .classList.toggle('visible', matched);
        cfm.closest('.password-field').querySelector('.match-check')
           .classList.toggle('visible', matched);

        hint.classList.toggle('visible', typing && cv.length >= MIN);

        btn.disabled = !matched;
    }

    pwd.addEventListener('input', function () { updateStrength(); validate(); });
    cfm.addEventListener('input', validate);

    form.addEventListener('submit', function (e) {
        if (pwd.value !== cfm.value || pwd.value.length < MIN) {
            e.preventDefault();
            return;
        }
        btn.classList.add('btn-loading');
        btn.disabled = true;
    });
})();
</script>
</body>
</html>
