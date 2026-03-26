<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${empty category}">Thêm danh mục</c:when>
            <c:otherwise>Cập nhật danh mục</c:otherwise>
        </c:choose>
    </title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f6f7fb;
            margin: 0
        }

        .wrap {
            max-width: 720px;
            margin: 60px auto;
            background: #fff;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, .08)
        }

        h2 {
            margin: 0 0 16px
        }

        label {
            display: block;
            margin: 12px 0 6px
        }

        input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 10px;
            outline: none
        }

        input:focus {
            border-color: #6b8e23
        }

        .actions {
            margin-top: 18px;
            display: flex;
            gap: 10px;
            justify-content: flex-end
        }

        .btn {
            padding: 10px 14px;
            border-radius: 10px;
            border: 1px solid #ccc;
            background: #fff;
            cursor: pointer;
            text-decoration: none;
            color: #111;
            display: inline-flex;
            align-items: center;
            gap: 6px
        }

        .btn.primary {
            background: #6b8e23;
            border-color: #6b8e23;
            color: #fff
        }
    </style>
</head>
<body>

<div class="wrap">
    <h2>
        <c:choose>
            <c:when test="${empty category}">Thêm danh mục</c:when>
            <c:otherwise>Cập nhật danh mục</c:otherwise>
        </c:choose>
    </h2>

    <form action="${pageContext.request.contextPath}/admin/category/save" method="post">
        <c:if test="${not empty category}">
            <input type="hidden" name="id" value="${category.categoryId}">
        </c:if>

        <label>Tên danh mục:</label>
        <input type="text" name="categoryName" value="${category.categoryName}" required maxlength="100">

        <label>Slug:</label>
        <input type="text" name="categorySlug" value="${category.categorySlug}" required maxlength="120">

        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/admin/categories">← Quay lại</a>
            <button class="btn primary" type="submit">💾 Lưu</button>
        </div>
    </form>
</div>

</body>
</html>

