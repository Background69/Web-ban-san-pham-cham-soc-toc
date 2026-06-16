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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/productmanagement.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="container">
    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="products"/>
    </jsp:include>
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
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>#P${p.productId}</td>

                    <td>

                        <c:choose>

                            <c:when test="${not empty p.primaryImageUrl}">
                                <img class="thumb"
                                     src="${p.primaryImageUrl}">
                            </c:when>

                            <c:otherwise>
                                <div class="thumb-placeholder"></div>
                            </c:otherwise>

                        </c:choose>

                    </td>
                    <td>
                        <div class="product-name">
                            <c:out value="${p.productName}"/>
                        </div>
                    </td>
                    <td>
                        <div class="product-slug">
                            <c:out value="${p.productSlug}"/>
                        </div>
                    </td>
                    <td>
                        <c:out value="${p.brandName}"/>
                    </td>
                    <td>
                        <div class="product-category">
                            <c:out value="${p.categoryName}"/>
                        </div>
                    </td>
                    <td>
                        <c:out value="${p.origin}"/>
                    </td>

                    <td class="product-price">
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

                    <td class="action-cell">
                        <button class="action-btn edit" onclick="openEditModal(${p.productId})">Sửa</button>
                        <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display:inline"
                              onsubmit="return confirm('Xoá sản phẩm?')">
                            <input type="hidden" name="_csrf" value="${fn:escapeXml(_csrf)}">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${p.productId}">
                            <button type="submit" class="action-btn delete">Xoá</button>
                        </form>
                        <button class="action-btn stats"
                                onclick="openStatsModal(${p.productId})">
                            Thống kê
                        </button>
                    </td>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty products}">
                <tr>
                    <td colspan="9" style="text-align:center">Không có sản phẩm</td>
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
            <input type="hidden" name="_csrf" value="${fn:escapeXml(_csrf)}">
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
                        <select id="createCategoryId" name="categoryId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}"> ${c.categoryName}
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
                        <label>Thành phần</label>
                        <textarea name="ingredients"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Hướng dẫn sử dụng</label>
                        <textarea name="usageInstructions"></textarea>
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

<div id="editProductModal" class="modal">

    <div class="modal-content edit-modal-content">

        <div class="modal-header">
            <h2 class="modal-title">Sửa sản phẩm</h2>
            <button class="close" type="button" onclick="closeEditModal()">
                &times;
            </button>
        </div>

        <form id="editForm"
              action="${pageContext.request.contextPath}/admin/products"
              method="post"
              enctype="multipart/form-data">

            <input type="hidden" name="_csrf" value="${fn:escapeXml(_csrf)}">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" id="editId">

            <div class="modal-body edit-modal-body">
                <div class="edit-form-grid">
                    <div class="form-group span-2">
                        <label>Tên sản phẩm</label>
                        <input type="text" id="editName" name="name">
                    </div>

                    <div class="form-group">
                        <label>Slug</label>
                        <input type="text" id="editSlug" name="slug">
                    </div>

                    <div class="form-group">
                        <label>Xuất xứ</label>
                        <input type="text" id="editOrigin" name="origin">
                    </div>
                    <div class="form-group">
                        <label>Danh mục</label>
                        <select id="editCategoryId" name="categoryId">
                            <option value="">Chọn danh mục</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}">
                                        ${c.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Thương hiệu</label>
                        <select id="editBrandId" name="brandId">
                            <option value="">-- Chọn thương hiệu --</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b.brandId}">
                                        ${b.brandName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group span-2">
                        <label>Mô tả ngắn</label>
                        <textarea id="editShortDescription" name="shortDescription"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Mô tả chi tiết</label>
                        <textarea id="editFullDescription" name="fullDescription"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Thành phần</label>
                        <textarea id="editIngredients" name="ingredients"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Hướng dẫn sử dụng</label>
                        <textarea id="editUsageInstructions" name="usageInstructions"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Ảnh sản phẩm</label>
                        <input type="file" name="image">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button"
                        class="btn btn-secondary"
                        onclick="closeEditModal()">
                    Huỷ
                </button>

                <button type="submit"
                        class="btn btn-primary">
                    Cập nhật
                </button>
            </div>
        </form>
    </div>
</div>
<div id="statsModal" class="modal">
    <div class="modal-content stats-modal">
        <button class="close" type="button" onclick="closeStatsModal()">&times;</button>
        <div class="modal-body">

            <h3 id="productName" class="product-title"></h3>

            <div class="stats-summary">

                <div class="stat-card">
                    <span class="stat-label">Tồn kho hiện tại</span>
                    <span class="stat-value" id="currentStock">0</span>
                </div>

                <div class="stat-card">
                    <span class="stat-label">Đã bán</span>
                    <span class="stat-value" id="totalSold">0</span>
                </div>

            </div>

            <div class="chart-wrapper">
                <canvas id="salesChart"></canvas>
            </div>
        </div>
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

    function openEditModal(productId) {
        fetch('${pageContext.request.contextPath}/admin/products?action=get&id=' + productId)
            .then(function (res) {
                if (!res.ok) {
                    throw new Error('HTTP ' + res.status);
                }

                return res.json();
            })
            .then(function (product) {
                console.log('Product response:', product);

                document.getElementById("editId").value = product.productId || productId;
                document.getElementById("editName").value = product.name || product.productName || "";
                document.getElementById("editSlug").value = product.slug || product.productSlug || "";
                document.getElementById("editOrigin").value = product.origin || "";

                document.getElementById("editCategoryId").value = product.categoryId || "";
                document.getElementById("editBrandId").value = product.brandId || "";

                document.getElementById("editShortDescription").value = product.shortDescription || "";
                document.getElementById("editFullDescription").value = product.fullDescription || "";
                document.getElementById("editIngredients").value = product.ingredients || "";
                document.getElementById("editUsageInstructions").value = product.usageInstructions || "";

                document.getElementById("editProductModal").style.display = "block";
                document.body.style.overflow = "hidden";
            })
            .catch(function (error) {
                console.error('Không thể tải thông tin sản phẩm:', error);
                alert('Không thể tải thông tin sản phẩm. Vui lòng kiểm tra console hoặc server log.');
            });
    }

    function closeEditModal() {
        document.getElementById("editProductModal").style.display = "none";
        document.body.style.overflow = "";
    }

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
        if (container.querySelectorAll('.variant-row').length > 1) {
            row.remove();
        } else {
            alert('Phải có ít nhất 1 biến thể!');
        }
    }
        document.getElementById("editForm").addEventListener("submit", function (e) {
            e.preventDefault();

            const form = this;
            const formData = new FormData(form);

            fetch(
                '${pageContext.request.contextPath}/admin/products',
                {
                    method: 'POST',
                    body: formData,
                    headers: { 'X-CSRF-TOKEN': document.querySelector('#editForm input[name="_csrf"]').value }
                }
            )
                .then(res => res.json())
                .then(data => {

                    if(data.success){

                        alert("Cập nhật thành công");

                        closeEditModal();

                        // reload lại danh sách
                        location.reload();

                    }else{
                        alert(data.message || "Có lỗi xảy ra");
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert("Lỗi server");
                });
        });
    let salesChart = null;

    function openStatsModal(productId){

        fetch(
            '${pageContext.request.contextPath}/admin/products?action=stats&id=' + productId
        )
            .then(res => res.json())
            .then(data => {

                document.getElementById("statsModal").style.display = "block";

                document.getElementById("productName").innerText =
                    data.productName;

                document.getElementById("currentStock").innerText =
                    data.currentStock;

                document.getElementById("totalSold").innerText =
                    data.totalSold;

                const ctx = document.getElementById("salesChart");

                if(salesChart){
                    salesChart.destroy();
                }

                salesChart = new Chart(ctx,{
                    type:'line',
                    data:{
                        labels:data.months,
                        datasets:[{
                            label:'Số lượng bán',
                            data:data.quantities,
                            tension:0.4,
                            fill:true,
                            borderWidth:3
                        }]
                    },
                    options:{
                        responsive:true,
                        maintainAspectRatio:false,
                        plugins:{
                            legend:{
                                position:'top'
                            }
                        }
                    }
                });

            })
            .catch(err=>{
                console.error(err);
            });
    }

    function closeStatsModal(){
        document.getElementById("statsModal").style.display="none";
    }
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeStatsModal();
    });
</script>

</body>

</html>
