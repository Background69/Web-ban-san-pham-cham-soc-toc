<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin.css">
</head>

<body>
<div class="container">

    <%-- Sidebar giữ nguyên --%>
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/images/logo.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <main class="content">

        <div class="header">
            <h1>Quản lý sản phẩm</h1>
            <a class="btn-add"
               href="${pageContext.request.contextPath}/admin/products?action=create">
                + Thêm sản phẩm
            </a>
        </div>

        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên</th>
                <th>Giá</th>
                <th>Danh mục</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>#P${p.productId}</td>
                    <td>
                        <img class="thumb"
                             src="${pageContext.request.contextPath}/uploads/${p.image}">
                    </td>
                    <td>${p.name}</td>
                    <td>
                        <fmt:formatNumber value="${p.price}" type="number"/> ₫
                    </td>
                    <td>${p.categoryName}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}">
                            Sửa
                        </a>
                        |
                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}"
                           onclick="return confirm('Xóa sản phẩm này?')">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty products}">
                <tr>
                    <td colspan="6" style="text-align:center">
                        Không có sản phẩm
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>

    </main>
</div>
</body>
</html>
