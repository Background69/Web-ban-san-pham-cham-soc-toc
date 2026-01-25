<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="/auth/login"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/user.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
</head>
<body>

<div class="profile-card">

    <div class="profile-header">
        <h2>Xin chào ${sessionScope.currentUser.username}</h2>
    </div>

    <div class="profile-info">
        <div class="profile-left">
            <img src="${pageContext.request.contextPath}/${sessionScope.currentUser.avatar}" alt="avatar">

            <h3>${sessionScope.currentUser.username}</h3>

            <p>Số điện thoại</p>
            <div class="email-box">
                <i class="fa-solid fa-phone"></i>
                ${sessionScope.currentUser.phone}
            </div>

            <p>Email</p>
            <div class="email-box">
                <i class="fa-solid fa-envelope"></i>
                ${sessionScope.currentUser.email}
            </div>
        </div>
    </div>

    <!-- TODO: nếu bạn có servlet UpdateProfile thì giữ, không thì đổi action -->
    <form action="${pageContext.request.contextPath}/UpdateProfile" method="post" class="profile-right">

        <div>
            <label>Số điện thoại</label>
            <input type="text" name="phone" value="${sessionScope.currentUser.phone}">
        </div>

        <div>
            <label>Tên người dùng</label>
            <input type="text" name="username" value="${sessionScope.currentUser.username}">
        </div>

        <div>
            <label>Vai trò</label>
            <input type="text" value="${sessionScope.currentUser.role}" disabled>
        </div>

        <button type="submit" class="save-btn">Lưu</button>
    </form>

</div>

</body>
</html>
