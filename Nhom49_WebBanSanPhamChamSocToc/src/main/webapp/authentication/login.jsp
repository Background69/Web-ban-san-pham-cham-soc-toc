<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:04 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
    <script src="<%= request.getContextPath() %>/static/js/login.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
</head>
<body>

<jsp:include page="/layout/header.jsp"/>

<div class="login-wrapper">
    <div class="login-box">
        <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo">

        <h1>Đăng nhập</h1>
        <p class="subtitle">Tiếp tục để mua</p>

        <!-- Hiển thị lỗi từ servlet -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/authentication/login.jsp" method="post">


        <label>Email</label>
            <label>
                <input type="email" name="email" required>
            </label>

            <label>Mật khẩu</label>
            <div class="password-field">
                <label for="password"></label><input type="password" name="password" id="password" required>
                <i class="fa-solid fa-eye toggle-password" data-target="password"></i>
            </div>

            <div class="options">
                <a class="forgot" href="${pageContext.request.contextPath}/authentication/forgot_password.jsp">Quên mật khẩu</a>
            </div>

            <button class="btn primary-btn" type="submit">Đăng nhập</button>

            <div class="or-divider">
                <span>Hoặc</span>
            </div>

            <div class="social-login">
                <a class="google-btn" href="${pageContext.request.contextPath}/auth/google">
                <img src="https://developers.google.com/identity/images/g-logo.png" alt="">
                    Đăng nhập với Google
                </a>
            </div>

        </form>

        <p class="signup-text">
            Không có tài khoản? <a href="${pageContext.request.contextPath}/authentication/register.jsp">Đăng ký ngay</a>
        </p>
    </div>
</div>
<jsp:include page="/layout/footer.jsp"/>

</body>
</html>

