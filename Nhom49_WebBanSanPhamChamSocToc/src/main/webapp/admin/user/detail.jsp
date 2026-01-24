<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết người dùng</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <%@ include file="../common/sidebar.jsp" %>

    <main class="content">
        <h1>Chi tiết người dùng</h1>

        <form action="${pageContext.request.contextPath}/admin/users" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${user.userId}">

            <p><b>ID:</b> #U${user.userId}</p>

            <label>Tên người dùng</label>
            <input type="text" value="${user.username}" disabled>

            <label>Email</label>
            <input type="text" value="${user.email}" disabled>

            <label>Số điện thoại</label>
            <input type="text" value="${user.phone}" disabled>

            <label>Vai trò</label>
            <select name="role">
                <option value="User" ${user.role == 'User' ? 'selected' : ''}>User</option>
                <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
            </select>

            <br><br>

            <button type="submit">Lưu thay đổi</button>
            <a href="${pageContext.request.contextPath}/admin/users">← Quay lại</a>
        </form>
    </main>
</div>
</body>
</html>
