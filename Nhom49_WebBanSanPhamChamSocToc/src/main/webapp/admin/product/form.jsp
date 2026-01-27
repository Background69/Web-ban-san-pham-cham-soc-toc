<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">

<div class="product-form-wrapper">
    <h2>
        <c:choose>
            <c:when test="${product != null}">Sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm</c:otherwise>
        </c:choose>
    </h2>

    <form id="productForm" class="product-form" enctype="multipart/form-data">

        <input type="hidden" name="action"
               value="${product != null ? 'edit' : 'create'}">

        <c:if test="${product != null}">
            <input type="hidden" name="id" value="${product.productId}">
        </c:if>

        <div class="form-group">
            <label>Tên sản phẩm</label>
            <input name="name" value="${product.name}" required>
        </div>

        <div class="form-group">
            <label>Giá</label>
            <input type="number" name="price" value="${product.price}" required>
        </div>

        <div class="form-group">
            <label>Danh mục</label>
            <input name="name" value="${product.name}" required>
        </div>
        <div class="form-group">
            <label>Ảnh</label>
            <input type="file" name="image">
        </div>

        <button type="submit" class="btn-submit">Lưu</button>
    </form>
</div>
