<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:05 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
    <script src="<%= request.getContextPath() %>/static/js/login.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
</head>

<body>

<jsp:include page="/layout/header.jsp"/>

<div class="login-wrapper">
    <div class="login-box">
        <div class="logo-container">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo">
        </div>

        <h2>Đăng ký</h2>
        <p>Tạo tài khoản mới để tiếp tục</p>

        <!-- Hiển thị lỗi -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/authentication/register.jsp" method="post">


        <label>Email</label>
            <label>
                <input type="email" name="email" required>
            </label>

            <label>Mật khẩu</label>
            <div class="password-wrapper">
                <label for="password"></label><input type="password" name="password" id="password" required>
                <i class="fas fa-eye toggle-password" data-target="password"></i>
            </div>

            <label>Xác nhận mật khẩu</label>
            <div class="password-wrapper">
                <input type="password" name="confirmPassword" id="confirm" required>
                <i class="fas fa-eye toggle-password" data-target="confirm"></i>
            </div>

            <label>Họ tên</label>
            <input type="text" name="fullName" required>

            <label>Số điện thoại</label>
            <input type="text" name="phone" required>

            <button type="submit" class="btn-primary">Đăng ký</button>

            <div class="or-divider">
                <span>Hoặc</span>
            </div>

            <div class="social-login">
                <a class="google-btn" href="${pageContext.request.contextPath}/authentication/Googlelogin.jsp">
                    <img src="https://developers.google.com/identity/images/g-logo.png">
                    Đăng ký với Google
                </a>
            </div>

            <p class="signup-text">
                Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/authentication/login.jsp">Đăng nhập</a>
            </p>

        </form>
    </div>
</div>

<jsp:include page="/layout/footer.jsp"/>
</body>
</html>
