<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/admin/form.css">

<style>
    /* Reset nhẹ */
    * {
        box-sizing: border-box;
        font-family: "Segoe UI", Tahoma, sans-serif;
    }

    /* Wrapper ngoài */
    .product-form-wrapper {
        max-width: 600px;
        max-height: 80vh;          /* 👈 để có scroll */
        margin: 40px auto;
        padding: 25px;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        overflow-y: auto;          /* 👈 thanh cuộn dọc */
    }

    /* Tiêu đề */
    .product-form-wrapper h2 {
        text-align: center;
        margin-bottom: 25px;
        color: #2e7d32; /* xanh lá đậm */
    }

    /* Form */
    .product-form {
        display: flex;
        flex-direction: column;
        gap: 18px;
    }

    /* Group */
    .form-group {
        display: flex;
        flex-direction: column;
    }

    /* Label */
    .form-group label {
        font-weight: 600;
        margin-bottom: 6px;
        color: #333;
    }

    /* Input + Select */
    .form-group input,
    .form-group select {
        padding: 10px 12px;
        border-radius: 8px;
        border: 1px solid #cfd8dc;
        font-size: 15px;
        transition: all 0.25s ease;
    }

    /* Focus */
    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #4caf50;
        box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
    }

    /* Button */
    .btn-submit {
        margin-top: 10px;
        padding: 12px;
        border: none;
        border-radius: 10px;
        background: linear-gradient(135deg, #43a047, #66bb6a);
        color: white;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    /* Hover button */
    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(76, 175, 80, 0.4);
    }

    /* Thanh cuộn đẹp (Chrome) */
    .product-form-wrapper::-webkit-scrollbar {
        width: 8px;
    }

    .product-form-wrapper::-webkit-scrollbar-thumb {
        background: #81c784;
        border-radius: 10px;
    }

    .product-form-wrapper::-webkit-scrollbar-track {
        background: #e8f5e9;
    }

</style>

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
