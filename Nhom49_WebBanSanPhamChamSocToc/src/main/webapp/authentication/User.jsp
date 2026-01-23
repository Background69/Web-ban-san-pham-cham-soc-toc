<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 22/12/2025
  Time: 2:25 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/user.css">
    <script src="<%= request.getContextPath() %>/static/js/login.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
</head>
<body>

<div class="profile-card">

    <div class="profile-header">
        <h2>Xin chào ${sessionScope.user.fullName}</h2>
    </div>

    <div class="profile-info">
        <div class="profile-left">
            <img src="${pageContext.request.contextPath}/images/${sessionScope.user.avatar}" alt="avatar">

            <h3>${sessionScope.user.username}</h3>

            <p>Số điện thoại</p>
            <div class="email-box">
                <i class="fa-solid fa-phone"></i>
                ${sessionScope.user.phone}
            </div>

            <p>Email</p>
            <div class="email-box">
                <i class="fa-solid fa-envelope"></i>
                ${sessionScope.user.email}
            </div>
        </div>
    </div>

    <!-- FORM CẬP NHẬT THÔNG TIN -->
    <form action="${pageContext.request.contextPath}/UpdateProfile" method="post" class="profile-right">

        <div>
            <label>Số điện thoại</label>
            <input type="text" name="phone" value="${sessionScope.user.phone}">
        </div>

        <div>
            <label>Tên người dùng</label>
            <input type="text" name="username" value="${sessionScope.user.username}">
        </div>

        <div>
            <label>Giới tính</label>
            <select name="gender">
                <option value="Nam" ${sessionScope.user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                <option value="Nữ" ${sessionScope.user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                <option value="Khác" ${sessionScope.user.gender == 'Khác' ? 'selected' : ''}>Khác</option>
            </select>
        </div>

        <div>
            <label>Vai trò</label>
            <input type="text" value="${sessionScope.user.role}" disabled>
        </div>

        <button type="submit" class="save-btn">Lưu</button>
    </form>

</div>

</body>
</html>

