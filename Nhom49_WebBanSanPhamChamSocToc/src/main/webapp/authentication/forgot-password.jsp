<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/Forgot.css">
</head>
<body>

<%@ include file="/layout/header.jsp" %>

<main>
    <div class="login-container">
        <div class="login-box">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo" alt="HairGlow Logo">
            </div>

            <h2>Quên mật khẩu</h2>
            <p>Nhập địa chỉ Email đã liên kết với tài khoản</p>

            <c:if test="${not empty message}">
                <div class="success-msg">${message}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post">
                <input type="email" name="email" placeholder="Nhập email của bạn" required>
                <button type="submit" class="btn-primary">Gửi link đặt lại mật khẩu</button>
            </form>

            <p class="signup-text">
                Còn nhớ mật khẩu?
                <a href="${pageContext.request.contextPath}/authentication/login.jsp">Đăng nhập ngay!</a>
            </p>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
