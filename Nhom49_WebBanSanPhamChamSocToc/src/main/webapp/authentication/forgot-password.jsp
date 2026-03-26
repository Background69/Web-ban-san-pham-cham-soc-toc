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
                    <input type="email" id="email" name="email"
                           placeholder="Nhập email của bạn" required autocomplete="email">
                </div>

                <button type="submit" class="btn-login">Gửi mã OTP</button>
            </form>

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
</body>
</html>
