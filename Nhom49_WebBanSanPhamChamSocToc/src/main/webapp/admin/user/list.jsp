<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/images/LOGO.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <!-- Main -->
    <main class="content">
        <div class="header">
            <h1>Quản lý người dùng</h1>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Email</th>
                <th>SĐT</th>
                <th>Vai trò</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>#U${user.userId}</td>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>${user.phone}</td>
                    <td>${user.role}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/users?action=detail&id=${user.userId}">
                            Chi tiết
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty users}">
                <tr>
                    <td colspan="6" style="text-align:center">Không có dữ liệu</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </main>
</div>
</body>
</html>
