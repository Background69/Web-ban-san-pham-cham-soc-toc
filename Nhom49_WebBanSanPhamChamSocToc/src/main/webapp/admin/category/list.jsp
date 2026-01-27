<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý danh mục</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>
<body>
<div class="container">
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/user/list.jsp">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/product/list.jsp">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/order/list.jsp">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brand/list.jsp">Quản lý thương hiệu</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/category">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/promotion/flash-sale.jsp">Quản lý giảm giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/">Quay lại Website</a>

    </aside>

    <main class="content">
        <div class="header">
            <h1>Quản lý danh mục</h1>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/category/add">+ Thêm danh mục</a>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert">${param.error}</div>
        </c:if>

        <table class="product-table">
            <tr>
                <th>ID</th>
                <th>Tên danh mục</th>
                <th>Slug</th>
                <th>Hành động</th>
            </tr>

            <c:forEach var="c" items="${categories}">
                <tr>
                    <td>${c.categoryId}</td>
                    <td>${c.categoryName}</td>
                    <td>${c.categorySlug}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/category/edit?id=${c.categoryId}">✏ Sửa</a>
                        |
                        <a href="${pageContext.request.contextPath}/admin/category/delete?id=${c.categoryId}"
                           onclick="return confirm('Xóa danh mục này?')">🗑 Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </main>
</div>
</body>
</html>
