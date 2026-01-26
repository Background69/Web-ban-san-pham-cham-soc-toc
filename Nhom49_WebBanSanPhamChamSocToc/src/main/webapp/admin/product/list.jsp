<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">

    <style>
        /* ===== MODAL ===== */
        .modal {
            display: none;
            position: fixed;
            z-index: 999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);
        }

        .modal-content {
            background: #fff;
            width: 500px;
            margin: 80px auto;
            padding: 25px;
            border-radius: 10px;
            position: relative;
        }

        .close {
            position: absolute;
            right: 15px;
            top: 10px;
            font-size: 22px;
            cursor: pointer;
        }

        .modal-content label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
        }

        .modal-content input,
        .modal-content select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
        }
    </style>
</head>

<body>
<div class="container">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/user/list.jsp">Quản lý người dùng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/product/list.jsp">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/order/list.jsp">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brand/list.jsp">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/category/list.jsp">Quản lý danh mục</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <!-- CONTENT -->
    <main class="content">

        <div class="header">
            <h1>Quản lý sản phẩm</h1>
            <button class="btn-add" onclick="openModal()">+ Thêm sản phẩm</button>
        </div>

        <!-- TABLE -->
        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên</th>
                <th>Giá</th>
                <th>Danh mục</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>#P${p.productId}</td>
                    <td>
                        <img class="thumb"
                             src="${pageContext.request.contextPath}/uploads/${p.image}">
                    </td>
                    <td>${p.name}</td>
                    <td>
                        <fmt:formatNumber value="${p.price}" type="number"/> ₫
                    </td>
                    <td>${p.categoryName}</td>
                    <td>
                        <a href="#">Sửa</a> |
                        <a href="#" onclick="return confirm('Xóa sản phẩm?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty products}">
                <tr>
                    <td colspan="6" style="text-align:center">Không có sản phẩm</td>
                </tr>
            </c:if>
            </tbody>
        </table>

    </main>
</div>

<!-- ===== MODAL FORM ===== -->
<div id="productModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>

        <h2>Thêm sản phẩm</h2>

        <form action="${pageContext.request.contextPath}/admin/product/list.jsp" method="post"
              enctype="multipart/form-data">
            <input type="hidden" name="action" value="create">

            <label>Tên sản phẩm</label>
            <input type="text" name="name" required>

            <label>Giá</label>
            <input type="number" name="price" required>

            <label>Danh mục</label>
            <select name="categoryId">
                <c:forEach var="c" items="${categories}">
                    <option value="${c.id}">${c.name}</option>
                </c:forEach>
            </select>

            <label>Ảnh</label>
            <input type="file" name="image">

            <br><br>
            <button type="submit" class="btn-add">Lưu</button>
        </form>
    </div>
</div>

<script>
    function openModal() {
        document.getElementById("productModal").style.display = "block";
    }

    function closeModal() {
        document.getElementById("productModal").style.display = "none";
    }
</script>

</body>
</html>
