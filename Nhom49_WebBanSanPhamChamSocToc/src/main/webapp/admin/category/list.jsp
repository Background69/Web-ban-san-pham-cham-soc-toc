<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục</title>

    <!-- CSS admin -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">

    <style>
        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .btn-add {
            padding: 10px 14px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 700;
            background: #4b6b3c;
            color: #fff;
        }

        .btn-add:hover { opacity: 0.9; }

        .category-table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
        }

        .category-table thead th {
            text-align: left;
            padding: 14px 12px;
            background: #f3f3f3;
            font-weight: 800;
        }

        .category-table tbody td {
            padding: 12px;
            border-top: 1px solid #eee;
            vertical-align: middle;
        }

        .actions a {
            text-decoration: none;
            font-weight: 700;
        }

        .actions a.edit { color: #1a73e8; }
        .actions a.delete { color: #d93025; }

        .actions a + a { margin-left: 10px; }

        .slug-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            background: #eef2ff;
            font-weight: 700;
            font-size: 12px;
        }
    </style>
</head>

<body>
<div class="container">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" alt="Logo">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/promotion/flash-sale.jsp">Quản lý giảm giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <!-- CONTENT -->
    <main class="content">

        <div class="header">
            <h1>Quản lý danh mục</h1>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/category/add">+ Thêm danh mục</a>
        </div>

        <table class="category-table">
            <thead>
            <tr>
                <th style="width: 90px;">ID</th>
                <th>Tên danh mục</th>
                <th style="width: 320px;">Slug</th>
                <th style="width: 180px;">Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="c" items="${categories}">
                <tr>
                    <td>#C${c.categoryId}</td>
                    <td>${c.categoryName}</td>
                    <td><span class="slug-badge">${c.categorySlug}</span></td>
                    <td class="actions">
                        <a class="edit"
                           href="${pageContext.request.contextPath}/admin/category/edit?id=${c.categoryId}">
                            Sửa
                        </a>
                        <a class="delete"
                           href="${pageContext.request.contextPath}/admin/category/delete?id=${c.categoryId}"
                           onclick="return confirm('Xóa danh mục này?')">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty categories}">
                <tr>
                    <td colspan="4" style="text-align:center; padding: 18px;">
                        Không có danh mục
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>

    </main>
</div>
</body>
</html>
