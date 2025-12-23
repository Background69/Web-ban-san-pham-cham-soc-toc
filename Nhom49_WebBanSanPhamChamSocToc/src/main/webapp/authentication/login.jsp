<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:04 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

<div class="login-wrapper">
    <div class="login-box">
        <img src="images/logo.png" class="logo" alt="logo">
        <h1>Đăng nhập</h1>
        <p class="subtitle">Tiếp tục để mua</p>

        <!-- Form gửi sang Servlet -->
        <form action="login" method="post">
            <label>Email</label>
            <input type="text" name="email" placeholder="Nhập Email" required>

            <label>Mật khẩu</label>
            <input type="password" name="password" placeholder="Nhập mật khẩu" required>

            <div class="options">
                <a href="Forgotpassword.jsp">Quên mật khẩu</a>
            </div>

            <button type="submit" class="btn primary-btn">Đăng nhập</button>
        </form>

        <!-- Hiển thị lỗi từ Servlet -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <p style="color:red; margin-top:10px;"><%= error %></p>
        <%
            }
        %>

        <p class="signup-text">
            Không có tài khoản? <a href="Signup.jsp">Đăng ký ngay!</a>
        </p>
    </div>
</div>

</body>
</html>

