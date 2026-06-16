<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục</title>

    <!-- CSS admin -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/categorymanagement.css">

</head>

<body>
<div class="container">

    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="categories"/>
    </jsp:include>

    <!-- CONTENT -->
    <main class="content">

        <div class="header">
            <h1>Quản lý danh mục</h1>
            <button class="btn-add" onclick="location.href='${pageContext.request.contextPath}/admin/category/add'">
                + Thêm danh mục
            </button>
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
                    <td class="action-cell">

                        <button class="action-btn edit"
                                onclick="location.href='${pageContext.request.contextPath}/admin/category/edit?id=${c.categoryId}'">
                            Sửa
                        </button>

                        <button class="action-btn delete"
                                onclick="if(confirm('Xoá danh mục này?')) location.href='${pageContext.request.contextPath}/admin/category/delete?id=${c.categoryId}'">
                            Xoá
                        </button>

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
