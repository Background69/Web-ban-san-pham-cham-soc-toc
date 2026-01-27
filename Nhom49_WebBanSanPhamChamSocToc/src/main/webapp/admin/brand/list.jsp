<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý thương hiệu</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
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
            <li ><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></li>
            <li ><a href="${pageContext.request.contextPath}/admin/user/list.jsp">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/product/list.jsp">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/order/list.jsp">Quản lý đơn hàng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/brand/list.jsp">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/category/list.jsp">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/promotion/flash-sale.jsp">Quản lý giảm giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <main class="content">
        <div class="header">
            <h1>Quản lý thương hiệu</h1>
            <a class="btn-add"
               href="${pageContext.request.contextPath}/admin/brand/form">
                + Thêm thương hiệu
            </a>
        </div>
        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên thương hiệu</th>
                <th>Mô tả</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="b" items="${brands}">
                <tr>
                    <td>${b.brandId}</td>
                    <td>${b.brandName}</td>
                    <td>${b.shortDescription}</td>
                    <td>
                        <a class="edit"
                           href="${pageContext.request.contextPath}/admin/brand/edit?id=${b.id}">
                            Sửa
                        </a>
                        <a class="delete"
                           href="${pageContext.request.contextPath}/admin/brand/delete?id=${b.id}"
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
</head>
</html>
