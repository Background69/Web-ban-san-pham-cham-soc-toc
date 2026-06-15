<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý thương hiệu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/brandmanagement.css">

</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/flash-sale">Quản lý giảm
                giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/">
            Quay lại Website
        </a>
    </aside>

    <main class="content">
        <div class="header">
            <h1>Quản lý thương hiệu</h1>
            <button type="button" class="btn-add" id="openBrandModal">+ Thêm thương hiệu</button>
        </div>
        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên thương hiệu</th>
                <th>Mô tả</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="b" items="${brands}">
                <tr>
                    <td>${b.brandId}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty b.logoUrl}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(b.logoUrl, 'http')}">
                                        <img class="thumb" src="${b.logoUrl}" alt="${b.brandName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="thumb"
                                             src="${pageContext.request.contextPath}/static/assets/${b.logoUrl}"
                                             alt="${b.brandName}">
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <div class="thumb-placeholder"></div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${b.brandName}</td>
                    <td>${b.shortDescription}</td>
                    <td>
                       <button type="button" class="edit-btn" data-id="${b.brandId}" data-name="${b.brandName}" data-slug="${b.brandSlug}" data-origin="${b.origin}" data-short="${b.shortDescription}" data-full="${b.fullDescription}" data-logo="${b.logoUrl}">Sửa</button>

                        <a class="delete"
                           href="${pageContext.request.contextPath}/admin/brands/delete?id=${b.brandId}"
                           onclick="return confirm('Xóa thương hiệu này?')">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </main>
</div>
<div id="brandModal"class="modal">
    <div class="modal-content">
        <h2 id="modalTitle">Thêm thương hiệu</h2>
        <form id="brandForm" action="${pageContext.request.contextPath}/admin/brands/save" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" id="brandId">
            <input type="text" id ="brandName" name="brandName" placeholder="Tên thương hiệu" required>
            <input type="text" id ="brandSlug" name="brandSlug" placeholder="Slug">
            <input type="text" id="origin" name="origin" placeholder="Xuất xứ">
            <textarea id="shortDescription" name="shortDescription" placeholder="Mô tả ngắn"></textarea>
            <textarea id="fullDescription" name="fullDescription" placeholder="Mô tả chi tiết"></textarea>
            <input type="file" id="logoInput" name="logo" accept=".png,.jpg,.webp">
            <img id="previewImg" alt="Preview logo">
            <p id="fileInfo"></p>
            <div class="modal-actions">
                <button type="submit">Lưu</button>
                <button type="button" id="closeBrandModal">Huỷ</button>
            </div>
        </form>
    </div>
</div>
<script>

    const modal =
        document.getElementById("brandModal");

    document
        .getElementById("openBrandModal")
        .onclick = () => {
        document.getElementById("brandForm").reset();

        document.getElementById("brandId").value = "";

        previewImg.style.display = "none";

        fileInfo.textContent = "";

        modal.style.display = "flex";
    };

    document
        .getElementById("closeBrandModal")
        .onclick = () => {
        modal.style.display = "none";
    };

    document
        .getElementById("brandForm")
        .addEventListener("submit", async function(e){

            e.preventDefault();

            const formData =
                new FormData(this);

            try{

                const response =
                    await fetch(this.action,{
                        method:"POST",
                        body:formData
                    });

                if(response.ok){
                    alert("Thêm thương hiệu thành công");
                    location.reload();
                }else{
                    alert("Có lỗi xảy ra");
                }

            }catch(err){
                alert("Không thể kết nối server");
            }
        });
    window.addEventListener("click", (e) => {
        if (e.target === modal) {
            modal.style.display = "none";
        }
    });
    document
        .querySelectorAll(".edit-btn")
        .forEach(btn => {

            btn.addEventListener("click", () => {

                modal.style.display = "flex";

                document.getElementById("brandId").value =
                    btn.dataset.id;

                document.getElementById("brandName").value =
                    btn.dataset.name;

                document.getElementById("brandSlug").value =
                    btn.dataset.slug;

                document.getElementById("origin").value =
                    btn.dataset.origin;

                document.getElementById("shortDescription").value =
                    btn.dataset.short;

                document.getElementById("fullDescription").value =
                    btn.dataset.full;

                if(btn.dataset.logo){

                    previewImg.src =
                        btn.dataset.logo;

                    previewImg.style.display = "block";
                }

            });

        });
    document.getElementById("modalTitle").textContent =
        "Thêm thương hiệu";
    document.getElementById("modalTitle").textContent =
        "Cập nhật thương hiệu";
</script>
</body>

</html>
