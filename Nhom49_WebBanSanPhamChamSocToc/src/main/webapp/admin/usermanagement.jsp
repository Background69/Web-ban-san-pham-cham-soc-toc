<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" alt="logo">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li class="active">
                <a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a>
            </li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/banners">Quản lý banner</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <!-- Main content -->
    <main class="content">
        <div class="header">
            <h1>Quản lý người dùng</h1>
            <button class="btn-add">+ Thêm người dùng</button>
        </div>

        <div class="recent-orders">
            <h2>Danh sách người dùng</h2>

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên người dùng</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
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
                            <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userId}">
                                Sửa
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty users}">
                    <tr>
                        <td colspan="6" style="text-align:center">
                            Không có người dùng nào
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>
</body>
</html>
