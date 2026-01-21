<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
    <script defer src="${pageContext.request.contextPath}/static/js/login.js"></script>

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <!-- JS -->
    <script defer src="${pageContext.request.contextPath}/static/js/login.js"></script>
</head>
<body>

<jsp:include page="/layout/header.jsp" />

<div class="login-wrapper">
    <div class="login-box">

        <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo" alt="Logo">

        <h1>Đăng nhập</h1>
        <p class="subtitle">Tiếp tục để mua</p>


        <c:if test="${not empty error}">
            <div class="error-msg">${error}</div>
        </c:if>


        <form action="${pageContext.request.contextPath}/auth/login" method="post">

            <label for="email">Email</label>
            <input id="email" type="email" name="email" required>

            <label for="password">Mật khẩu</label>
            <div class="password-field">
                <input id="password" type="password" name="password" required>
                <i class="fa-solid fa-eye toggle-password" data-target="password"></i>
            </div>

            <div class="options">
                <a class="forgot" href="${pageContext.request.contextPath}/authentication/forgot_password.jsp">
                    Quên mật khẩu
                </a>
            </div>

            <button class="btn primary-btn" type="submit">Đăng nhập</button>

            <div class="or-divider"><span>Hoặc</span></div>

            <div class="social-login">
                <a class="google-btn" href="${pageContext.request.contextPath}/auth/google">
                    <img src="https://developers.google.com/identity/images/g-logo.png" alt="">
                    Đăng nhập với Google
                </a>
            </div>

        </form>

        <p class="signup-text">
            Không có tài khoản?
            <a href="${pageContext.request.contextPath}/authentication/register.jsp">Đăng ký ngay</a>
        </p>

    </div>
</div>

<jsp:include page="/layout/footer.jsp" />

</body>
</html>
