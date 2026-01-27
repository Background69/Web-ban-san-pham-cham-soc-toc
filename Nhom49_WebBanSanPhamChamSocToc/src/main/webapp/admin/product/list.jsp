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
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brand/list.jsp">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/category/list.jsp">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/promotion/flash-sale.jsp">Quản lý giảm giá</a></li>

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
                <th>Slug</th>
                <th>Thương hiệu</th>
                <th>Danh mục</th>
                <th>Xuất xứ</th>
                <th>Giá</th>
                <th>Tồn kho</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>#P${p.productId}</td>

                    <td>
                        <c:if test="${not empty p.primaryImageUrl}">
                            <img class="thumb"
                                 src="${pageContext.request.contextPath}/uploads/${p.primaryImageUrl}">
                        </c:if>
                    </td>

                    <td>${p.productName}</td>
                    <td>${p.productSlug}</td>
                    <td>${p.brandName}</td>
                    <td>${p.categoryName}</td>
                    <td>${p.origin}</td>

                    <td>
                        <fmt:formatNumber value="${p.finalPrice}" type="number"/> ₫
                    </td>

                    <td>${p.remainingStock}</td>

                    <td>
                        <c:choose>
                            <c:when test="${p.remainingStock > 0}">
                                <span style="color:green;font-weight:bold">Còn hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color:red;font-weight:bold">Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}">
                            Sửa
                        </a> |
                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}"
                           onclick="return confirm('Xóa sản phẩm?')">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty products}">
                <tr>
                    <td colspan="11" style="text-align:center">Không có sản phẩm</td>
                </tr>
            </c:if>
            </tbody>
        </table>

    </main>
</div>

<!-- ===== MODAL ADD PRODUCT ===== -->
<div id="productModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>

        <h2>Thêm sản phẩm</h2>

        <form action="${pageContext.request.contextPath}/admin/products"
              method="post"
              enctype="multipart/form-data">

            <input type="hidden" name="action" value="create">

            <label>Tên sản phẩm</label>
            <input type="text" name="name" required>

            <label>Slug</label>
            <input type="text" name="slug">

            <label>Xuất xứ</label>
            <input type="text" name="origin">

            <label>Danh mục</label>
            <select name="categoryId">
                <c:forEach var="c" items="${categories}">
                    <option value="${c.categoryId}">${c.categoryName}</option>
                </c:forEach>
            </select>

            <label>Giá gốc</label>
            <input type="number" name="originalprice" required>

            <label>Giá sale</label>
            <input type="number" name="SalePrice">

            <label>Mô tả ngắn</label>
            <textarea name="shortDescription"></textarea>

            <label>Mô tả chi tiết</label>
            <textarea name="fullDescription"></textarea>

            <label>Ảnh sản phẩm</label>
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
