<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:03 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/static/css/login.css" var="loginCss" />
<c:url value="/static/js/login.js" var="loginJs" />
<c:url value="/static/assets/icons/LOGO.png" var="logoUrl" />
<c:url value="/ForgotPassword" var="forgotPasswordUrl" />
<c:url value="/authentication/login.jsp" var="loginPageUrl" />
<!DOCTYPE html>
<html lang="vi">
<head>

    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${loginCss}">
    <script defer src="${loginJs}"></script>
</head>
<body>
<jsp:include page="/layout/header.jsp"/>

<div class="login-wrapper">
    <div class="login-box">
        <div class="logo-container">
            <img src="${logoUrl}" class="logo" alt="logo">
        </div>

        <h2>Quên mật khẩu</h2>
        <p>Nhập địa chỉ Email đã liên kết</p>

        <!-- Form gửi sang Servlet -->
        <form action="${forgotPasswordUrl}" method="post">
            <input type="email" name="email" placeholder="Nhập email" required>
            <button type="submit" class="btn-primary">
                Gửi link đặt lại mật khẩu
            </button>
        </form>

        <!-- Hiển thị thông báo -->
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
        <p style="color:green; margin-top:10px;"><%= message %></p>
        <%
            }

            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <p style="color:red; margin-top:10px;"><%= error %></p>
        <%
            }
        %>

        <p class="signup-text">
            Còn nhớ mật khẩu?
            <a href="${loginPageUrl}">Đăng nhập ngay!</a>
        </p>
    </div>
</div>
<jsp:include page="/layout/footer.jsp"/>
</body>
</html>

