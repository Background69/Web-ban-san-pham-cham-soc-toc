<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin.css">

    <style>
        /* ===== Modal ===== */
        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: #fff;
            padding: 20px;
            width: 400px;
            border-radius: 8px;
        }
        .modal-content input {
            width: 100%;
            margin-bottom: 10px;
            padding: 8px;
        }
    </style>
</head>

<body>
<div class="container">

    <!-- ===== Sidebar ===== -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/images/logo.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <!-- ===== Main ===== -->
    <main class="content">

        <div class="header">
            <h1>Quản lý sản phẩm</h1>
            <button class="btn-add" onclick="openCreateModal()">+ Thêm sản phẩm</button>
        </div>

        <!-- ===== Table ===== -->
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
                        <a onclick="openEditModal(
                                '${p.productId}',
                                '${p.name}',
                                '${p.price}',
                                '${p.categoryName}',
                                '${p.image}'
                        )">Sửa</a>
                        |
                        <a onclick="deleteProduct(${p.productId})">Xóa</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty products}">
                <tr>
                    <td colspan="6" style="text-align:center">
                        Không có sản phẩm
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>

    </main>
</div>

<!-- ===== MODAL ===== -->
<div class="modal" id="productModal">
    <div class="modal-content">
        <h3 id="modalTitle">Thêm sản phẩm</h3>

        <input type="hidden" id="productId">

        <input id="name" placeholder="Tên sản phẩm">
        <input id="price" placeholder="Giá">
        <input id="category" placeholder="Danh mục">
        <input id="image" placeholder="Tên ảnh">

        <button onclick="submitProduct()">Lưu</button>
        <button onclick="closeModal()">Hủy</button>
    </div>
</div>

<!-- ===== JS ===== -->
<script>
    let action = "create";

    function openCreateModal() {
        action = "create";
        document.getElementById("modalTitle").innerText = "Thêm sản phẩm";
        document.getElementById("productId").value = "";
        document.getElementById("name").value = "";
        document.getElementById("price").value = "";
        document.getElementById("category").value = "";
        document.getElementById("image").value = "";
        document.getElementById("productModal").style.display = "flex";
    }

    function openEditModal(id, name, price, category, image) {
        action = "edit";
        document.getElementById("modalTitle").innerText = "Sửa sản phẩm";
        document.getElementById("productId").value = id;
        document.getElementById("name").value = name;
        document.getElementById("price").value = price;
        document.getElementById("category").value = category;
        document.getElementById("image").value = image;
        document.getElementById("productModal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("productModal").style.display = "none";
    }

    function submitProduct() {
        const data = new URLSearchParams();
        data.append("action", action);
        data.append("id", document.getElementById("productId").value);
        data.append("name", document.getElementById("name").value);
        data.append("price", document.getElementById("price").value);
        data.append("category", document.getElementById("category").value);
        data.append("image", document.getElementById("image").value);

        fetch("${pageContext.request.contextPath}/admin/products", {
            method: "POST",
            body: data
        }).then(() => location.reload());
    }

    function deleteProduct(id) {
        if (!confirm("Xóa sản phẩm này?")) return;

        fetch("${pageContext.request.contextPath}/admin/products?action=delete&id=" + id)
            .then(() => location.reload());
    }
</script>

</body>
</html>
