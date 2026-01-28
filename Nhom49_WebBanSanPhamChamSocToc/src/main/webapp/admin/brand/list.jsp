<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý thương hiệu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <style>
        .thumb {
            width: 52px;
            height: 52px;
            object-fit: contain;
            border-radius: 8px;
            border: 1px solid #eee;
            background: #f9f9f9;
        }

        .thumb-placeholder {
            width: 52px;
            height: 52px;
            border-radius: 8px;
            background: #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #9ca3af;
        }
    </style>
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương
                hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/flash-sale">Quản lý giảm
                giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <main class="content">
        <div class="header">
            <h1>Quản lý thương hiệu</h1>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/brands/form">
                + Thêm thương hiệu
            </a>
        </div>
        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên thương hiệu</th>
                <th>Mô tả</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="b" items="${brands}">
                <tr>
                    <td>${b.brandId}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty b.logoUrl}">
                                <img class="thumb"
                                     src="${pageContext.request.contextPath}/static/${b.logoUrl}"
                                     alt="${b.brandName}">
                            </c:when>
                            <c:otherwise>
                                <div class="thumb-placeholder">🏪</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${b.brandName}</td>
                    <td>${b.shortDescription}</td>
                    <td>
                        <a class="edit"
                           href="${pageContext.request.contextPath}/admin/brands/edit?id=${b.brandId}">
                            Sửa
                        </a>

                        <a class="delete"
                           href="${pageContext.request.contextPath}/admin/brands/delete?id=${b.brandId}"
                           onclick="return confirm('Xóa thương hiệu này?')">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </main>
</div>
</body>

</html>