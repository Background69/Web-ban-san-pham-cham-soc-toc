<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: ACER
  Date: 10-Jan-26
  Time: 7:47 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/images/LOGO.png" alt="logo">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li class="active"><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/banners">Quản lý banner</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">Quay lại Website</a>
    </aside>


    <!-- Main content -->
    <main class="content">
        <div class="header">
            <h1>Quản lý người dùng</h1>
            <button class="btn-add">+ Thêm người dùng</button>
        </div>

        <!-- User Table -->
        <div class="recent-orders">
            <h2>Danh sách ngư ời dùng</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Tên người dùng</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Vai trò</th>
                    <th>Hành động</th>
                </tr>
                <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>#U${user.userId}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${user.phone}</td>
                        <td>$${user.role}</td>
                        <td>
                            <a href="#">Sửa</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>

            </table>
        </div>

    </main>

</div>
</body>
</html>