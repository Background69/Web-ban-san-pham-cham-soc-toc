<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/form.css">

<div class="product-form-wrapper">
    <h2>
        <c:choose>
            <c:when test="${product != null}">Sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm</c:otherwise>
        </c:choose>
    </h2>

    <!-- ✅ FIX: PHẢI CÓ action + method -->
    <form id="productForm"
          class="product-form"
          action="${pageContext.request.contextPath}/admin/products"
          method="post"
          enctype="multipart/form-data">

        <input type="hidden" name="action" value="${product != null ? 'edit' : 'create'}">

        <c:if test="${product != null}">
            <input type="hidden" name="id" value="${product.productId}">
        </c:if>

        <div class="form-group">
            <label>Tên sản phẩm</label>
            <input name="name" value="${product.productName}" required>
        </div>

        <div class="form-group">
            <label>Slug</label>
            <input name="slug" value="${product.productSlug}">
        </div>

        <div class="form-group">
            <label>Xuất xứ</label>
            <input name="origin" value="${product.origin}">
        </div>

        <div class="form-group">
            <label>Danh mục</label>
            <select name="categoryId" required>
                <option value="">-- Chọn danh mục --</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.categoryId}"
                            <c:if test="${product != null && product.categoryId == c.categoryId}">selected</c:if>>
                            ${c.categoryName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>Thương hiệu</label>
            <select name="brandId" required>
                <option value="">-- Chọn thương hiệu --</option>
                <c:forEach var="b" items="${brands}">
                    <option value="${b.brandId}"
                            <c:if test="${product != null && product.brandId == b.brandId}">selected</c:if>>
                            ${b.brandName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>Giá gốc</label>
            <input type="number" name="originalPrice" min="0" required>
        </div>

        <div class="form-group">
            <label>Giá sale</label>
            <input type="number" name="salePrice" min="0">
        </div>

        <div class="form-group">
            <label>Tồn kho</label>
            <input type="number" name="stockQuantity" min="0" value="${product.stockQuantity}">
        </div>

        <div class="form-group">
            <label>Mô tả ngắn</label>
            <textarea name="shortDescription">${product.shortDescription}</textarea>
        </div>

        <div class="form-group">
            <label>Mô tả chi tiết</label>
            <textarea name="fullDescription">${product.fullDescription}</textarea>
        </div>

        <div class="form-group">
            <label>Ảnh</label>
            <input type="file" name="image" accept="image/*">
        </div>

        <!-- ✅ NÚT LƯU Ở ĐÂY -->
        <button type="submit" class="btn-submit">Lưu</button>
    </form>
</div>
