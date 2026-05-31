<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/form.css">
    <link rel="stylesheet" href ="${pageContext.request.contextPath}/static/css/admin/productmanagement.css">
</head>
<body>
<div class="container">
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
            <li><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/flash-sale">Quản lý giảm giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/">
            Quay lại Website
        </a>
    </aside>
    <main class="content">
        <div class="header">
            <h1>Quản lý sản phẩm</h1>
            <button class="btn-add" type="button" onclick="openModal()">+ Thêm sản phẩm</button>
        </div>

        <c:if test="${param.err == '1'}">
            <div
                    style="margin:10px 0;padding:10px 12px;border-radius:8px;background:#ffebee;color:#c62828;font-weight:700">
                Lưu sản phẩm bị lỗi. Mở Tomcat Log để xem chi tiết.
            </div>
        </c:if>

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
                            <c:choose>
                                <c:when test="${not empty p.primaryImageUrl}">
                                    <img class="thumb" src="${p.primaryImageUrl}" alt="thumb">
                                </c:when>
                            </c:choose>
                        </c:if>
                    </td>

                    <td>
                        <c:out value="${p.productName}"/>
                    </td>
                    <td>
                        <c:out value="${p.productSlug}"/>
                    </td>
                    <td>
                        <c:out value="${p.brandName}"/>
                    </td>
                    <td>
                        <c:out value="${p.categoryName}"/>
                    </td>
                    <td>
                        <c:out value="${p.origin}"/>
                    </td>

                    <td>
                        <c:choose>
                            <c:when
                                    test="${p.defaultVariant != null && p.defaultVariant.salePrice != null && p.defaultVariant.salePrice > 0}">
                                <fmt:formatNumber value="${p.defaultVariant.salePrice}"
                                                  type="number"/> &#8363;
                            </c:when>
                            <c:when
                                    test="${p.defaultVariant != null && p.defaultVariant.originalPrice != null && p.defaultVariant.originalPrice > 0}">
                                <fmt:formatNumber value="${p.defaultVariant.originalPrice}"
                                                  type="number"/> &#8363;
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>

                    <td>${p.remainingStock}</td>

                    <td>
                        <c:choose>
                            <c:when test="${p.remainingStock > 0}">
                                <span class="status-active">Còn hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-lock">Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="action-cell">
                        <button class="action-btn edit" onclick="location.href='${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}'">Sửa</button>
                        <button class="action-btn edit" onclick="if(confirm('Xoá sản phẩm?'))location.href='${pageContext.request.contextPath}/admin/products?action=detele&id=${p.productId}'">Xoá</button>
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

<div id="productModal" class="modal" onclick="backdropClose(event)">
    <div class="modal-content">
        <div class="modal-header">
            <h2 class="modal-title">Thêm sản phẩm</h2>
            <button class="close" type="button" onclick="closeModal()">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/products" method="post"
              enctype="multipart/form-data">
            <input type="hidden" name="action" value="create">

            <div class="modal-body">
                <div class="form-grid">

                    <div class="form-group span-2">
                        <label>Tên sản phẩm</label>
                        <input type="text" name="name" required>
                    </div>

                    <div class="form-group">
                        <label>Slug</label>
                        <input type="text" name="slug">
                    </div>

                    <div class="form-group">
                        <label>Xuất xứ</label>
                        <input type="text" name="origin">
                    </div>

                    <div class="form-group">
                        <label>Danh mục</label>
                        <select name="categoryId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}">
                                    <c:out value="${c.categoryName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Thương hiệu</label>
                        <select name="brandId" required>
                            <option value="">-- Chọn thương hiệu --</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b.brandId}">
                                    <c:out value="${b.brandName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Variants Section -->
                    <div class="form-group span-2">
                        <label>Biến thể sản phẩm <span style="color:#666;font-weight:normal">(ít nhất 1
                                                biến thể)</span></label>
                        <div id="variants-container">
                            <div class="variant-row">
                                <input type="text" name="variantName[]" placeholder="Tên (vd: 100ml)"
                                       required>
                                <input type="number" name="variantOriginalPrice[]" placeholder="Giá gốc"
                                       min="0" required>
                                <input type="number" name="variantSalePrice[]" placeholder="Giá sale"
                                       min="0">
                                <input type="number" name="variantStock[]" placeholder="Tồn kho" min="0"
                                       value="0">
                                <button type="button" class="btn-variant-remove"
                                        onclick="removeVariantRow(this)" title="Xóa biến thể">✕
                                </button>
                            </div>
                        </div>
                        <button type="button" class="btn-add-variant" onclick="addVariantRow()">+ Thêm
                            biến thể
                        </button>
                    </div>

                    <div class="form-group span-2">
                        <label>Mô tả ngắn</label>
                        <textarea name="shortDescription"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Mô tả chi tiết</label>
                        <textarea name="fullDescription"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Ảnh sản phẩm</label>
                        <input type="file" name="image" accept="image/*">
                    </div>

                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" onclick="closeModal()">Hủy</button>
                <button class="btn btn-primary" type="submit">Lưu sản phẩm</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal() {
        document.getElementById("productModal").style.display = "block";
        document.body.style.overflow = "hidden";
    }

    function closeModal() {
        document.getElementById("productModal").style.display = "none";
        document.body.style.overflow = "";
    }

    function backdropClose(e) {
        if (e.target && e.target.classList.contains('modal')) closeModal();
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeModal();
    });

    // Variant management functions
    function addVariantRow() {
        var container = document.getElementById('variants-container');
        var newRow = document.createElement('div');
        newRow.className = 'variant-row';
        newRow.innerHTML =
            '<input type="text" name="variantName[]" placeholder="Tên (vd: 100ml)" required>' +
            '<input type="number" name="variantOriginalPrice[]" placeholder="Giá gốc" min="0" required>' +
            '<input type="number" name="variantSalePrice[]" placeholder="Giá sale" min="0">' +
            '<input type="number" name="variantStock[]" placeholder="Tồn kho" min="0" value="0">' +
            '<button type="button" class="btn-variant-remove" onclick="removeVariantRow(this)" title="Xóa biến thể">✕</button>';
        container.appendChild(newRow);
    }

    function removeVariantRow(btn) {
        var row = btn.parentElement;
        var container = document.getElementById('variants-container');
        // Don't remove if it's the only row
        if (container.querySelectorAll('.variant-row').length > 1) {
            row.remove();
        } else {
            alert('Phải có ít nhất 1 biến thể!');
        }
    }
</script>

</body>

</html>
