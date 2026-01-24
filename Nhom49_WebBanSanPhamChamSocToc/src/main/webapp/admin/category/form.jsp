<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>
    <c:if test="${empty category}">Thêm danh mục</c:if>
    <c:if test="${not empty category}">Cập nhật danh mục</c:if>
</h2>

<form action="${pageContext.request.contextPath}/admin/category/save" method="post">

    <c:if test="${not empty category}">
        <input type="hidden" name="id" value="${category.categoryId}">
    </c:if>

    <label>Tên danh mục:</label><br>
    <input type="text" name="categoryName"
           value="${category.categoryName}" required><br><br>

    <label>Slug:</label><br>
    <input type="text" name="categorySlug"
           value="${category.categorySlug}" required><br><br>

    <button type="submit">💾 Lưu</button>
    <a href="${pageContext.request.contextPath}/admin/category">⬅ Quay lại</a>
</form>
