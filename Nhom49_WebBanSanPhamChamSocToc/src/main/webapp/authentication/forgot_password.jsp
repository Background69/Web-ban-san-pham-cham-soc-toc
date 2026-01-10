<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:03 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>

    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
    <script src="<%= request.getContextPath() %>/static/js/login.js"></script>
</head>
<body>

<div class="login-wrapper">
    <div class="login-box">
        <div class="logo-container">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo" alt="logo">
        </div>

        <h2>Quên mật khẩu</h2>
        <p>Nhập địa chỉ Email đã liên kết</p>

        <!-- Form gửi sang Servlet -->
        <form action="${pageContext.request.contextPath}/ForgotPassword" method="post">
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
            <a href="login.jsp">Đăng nhập ngay!</a>
        </p>
    </div>
</div>

</body>
</html>

