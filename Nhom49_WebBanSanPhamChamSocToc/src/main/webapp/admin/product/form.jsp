<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product != null ? "Sửa sản phẩm" : "Thêm sản phẩm"}</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin.css">
</head>

<body>
<div class="container">

    <%-- Sidebar dùng chung --%>
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/images/logo.png">
        </div>
        <p>HairGlow Admin</p>
    </aside>

    <main class="content">

        <h1>
            <c:choose>
                <c:when test="${product != null}">Sửa sản phẩm</c:when>
                <c:otherwise>Thêm sản phẩm</c:otherwise>
            </c:choose>
        </h1>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/products">

            <input type="hidden" name="action"
                   value="${product != null ? 'edit' : 'create'}">

            <c:if test="${product != null}">
                <input type="hidden" name="id" value="${product.productId}">
            </c:if>

            <label>Tên sản phẩm</label>
            <input name="name" value="${product.name}" required>

            <label>Giá</label>
            <input name="price" value="${product.price}" required>

            <label>Danh mục</label>
            <input name="category" value="${product.categoryName}" required>

            <label>Ảnh</label>
            <input name="image" value="${product.image}">

            <button type="submit">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/products">Hủy</a>
        </form>

    </main>
</div>
</body>
</html>
