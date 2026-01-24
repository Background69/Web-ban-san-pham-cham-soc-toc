<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Quản lý danh mục</h2>

<a href="${pageContext.request.contextPath}/admin/category/form">
    ➕ Thêm danh mục
</a>

<table border="1" cellpadding="8" cellspacing="0">
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
                <a href="${pageContext.request.contextPath}/admin/category/edit?id=${c.categoryId}">
                    ✏ Sửa
                </a>
                |
                <a href="${pageContext.request.contextPath}/admin/category/delete?id=${c.categoryId}"
                   onclick="return confirm('Xóa danh mục này?')">
                    🗑 Xóa
                </a>
            </td>
        </tr>
    </c:forEach>
</table>
