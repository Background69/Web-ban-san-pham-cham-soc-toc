<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/login.css">
</head>

<body class="login-page">

<%@ include file="/layout/header.jsp" %>

<main class="login-main">
    <div class="login-container">
        <div class="login-box">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png"
                 class="logo" alt="HairGlow Logo">

            <h1>Quên mật khẩu</h1>
            <p class="subtitle">Nhập email để nhận mã OTP đặt lại mật khẩu</p>

            <c:if test="${not empty message}">
                <div class="success-msg">${message}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post" autocomplete="on">
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="email-field">
                        <input type="email" id="email" name="email"
                               placeholder="Nhập email của bạn" required autocomplete="email">
                        <span class="email-icon email-icon--valid" aria-hidden="true">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.2"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                <polyline points="22 4 12 14.01 9 11.01"/>
                            </svg>
                        </span>
                        <span class="email-icon email-icon--invalid" aria-hidden="true">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.2"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"/>
                                <line x1="12" y1="8" x2="12" y2="12"/>
                                <line x1="12" y1="16" x2="12.01" y2="16"/>
                            </svg>
                        </span>
                    </div>
                    <p class="email-hint" id="emailHint">
                        <i class="fa-solid fa-circle-info"></i>
                        Định dạng email có vẻ chưa đúng.
                    </p>
                </div>

                <button type="submit" id="btnSendOtp" class="btn-login">Gửi mã OTP</button>
            </form>

            <p class="spam-hint">
                <i class="fa-solid fa-circle-info"></i>
                Nếu chưa thấy mã gửi đến hòm thư chính sau 30 giây,
                hãy kiểm tra cả hộp thư rác (Spam) hoặc thư quảng cáo.
            </p>

            <div class="mt-3 text-center">
                <a href="${pageContext.request.contextPath}/auth/verify-otp">Đã có mã OTP? Nhập mã tại đây</a>
            </div>

            <p class="signup-text">
                Còn nhớ mật khẩu?
                <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập ngay!</a>
            </p>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        'use strict';

        var form = document.querySelector('form[action$="/auth/forgot-password"]');
        var email = document.getElementById('email');
        var hint = document.getElementById('emailHint');
        if (!form || !email) return;

        var EMAIL_RE = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;

        function clearState() {
            email.classList.remove('is-valid', 'is-invalid');
            if (hint) hint.classList.remove('visible');
        }

        email.addEventListener('focus', clearState);
        email.addEventListener('input', clearState);

        email.addEventListener('blur', function () {
            var v = email.value.trim();
            if (v.length === 0) {
                clearState();
                return;
            }

            if (EMAIL_RE.test(v)) {
                email.classList.add('is-valid');
                email.classList.remove('is-invalid');
                if (hint) hint.classList.remove('visible');
            } else {
                email.classList.add('is-invalid');
                email.classList.remove('is-valid');
                if (hint) hint.classList.add('visible');
            }
        });

        form.addEventListener('submit', function (e) {
            var v = email.value.trim();
            if (!EMAIL_RE.test(v)) {
                e.preventDefault();
                email.classList.add('is-invalid');
                email.classList.remove('is-valid');
                if (hint) hint.classList.add('visible');
                email.focus();
                return;
            }
            var btn = document.getElementById('btnSendOtp');
            if (btn) {
                btn.classList.add('btn-loading');
                btn.disabled = true;
            }
        });
    })();
</script>
</body>
</html>
