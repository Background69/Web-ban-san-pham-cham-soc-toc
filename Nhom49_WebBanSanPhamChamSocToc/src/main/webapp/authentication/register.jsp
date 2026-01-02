<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:05 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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


<div class="login-wrapper">
    <div class="login-box">
        <div class="logo-container">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo" alt="logo">
        </div>

        <h2>Đăng ký</h2>
        <p>Tạo tài khoản mới để tiếp tục</p>

        <!-- Form gửi sang Servlet -->
        <form action="${pageContext.request.contextPath}/Signup" method="post">
        <label>Email</label>
            <input type="email" name="email" placeholder="Nhập Email" required>

            <label>Mật khẩu</label>
            <input type="password" name="password" placeholder="Nhập mật khẩu" required>

            <label>Xác nhận mật khẩu</label>
            <input type="password" name="confirm" placeholder="Nhập lại mật khẩu" required>

            <label>Họ tên</label>
            <input type="text" name="name" placeholder="Nhập họ tên" required>

            <label>Số điện thoại</label>
            <input type="text" name="phone" placeholder="Nhập số điện thoại" required>

            <button type="submit" class="btn-primary">Đăng ký</button>
        </form>

        <!-- Hiển thị lỗi -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <p style="color:red; margin-top:10px;"><%= error %></p>
        <%
            }
        %>

        <p class="signup-text">
            Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay!</a>
        </p>
    </div>
</div>

</body>
</html>

