<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>
    <c:choose>
        <c:when test="${product != null}">Sửa sản phẩm</c:when>
        <c:otherwise>Thêm sản phẩm</c:otherwise>
    </c:choose>
</h2>

<form id="productForm" enctype="multipart/form-data">

    <input type="hidden" name="action"
           value="${product != null ? 'edit' : 'create'}">

    <c:if test="${product != null}">
        <input type="hidden" name="id" value="${product.productId}">
    </c:if>

    <label>Tên sản phẩm</label>
    <input name="name" value="${product.name}" required>

    <label>Giá</label>
    <input type="number" name="price" value="${product.price}" required>

    <label>Danh mục</label>
    <select name="categoryId">
        <c:forEach var="c" items="${categories}">
            <option value="${c.id}"
                ${product.categoryId == c.id ? "selected" : ""}>
                    ${c.name}
            </option>
        </c:forEach>
    </select>

    <label>Ảnh</label>
    <input type="file" name="image">

    <br><br>
    <button type="submit">Lưu</button>
</form>
