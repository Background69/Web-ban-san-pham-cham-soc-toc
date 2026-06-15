<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${product != null}">Sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm</c:otherwise>
        </c:choose>
        | HairGlow Admin
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/ordermanagement.css">


</head>

<body>
<div class="container">
    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="products"/>
    </jsp:include>

    <main class="content">
        <div class="header">
            <h1>
                <c:choose>
                    <c:when test="${product != null}">Sửa sản phẩm</c:when>
                    <c:otherwise>Thêm sản phẩm mới</c:otherwise>
                </c:choose>
            </h1>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">
                ← Quay lại
            </a>
        </div>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/admin/products" method="post"
                  enctype="multipart/form-data">
                <input type="hidden" name="action" value="${product != null ? 'edit' : 'create'}">
                <c:if test="${product != null}">
                    <input type="hidden" name="id" value="${product.productId}">
                </c:if>

                <div class="form-grid">
                    <div class="form-group span-2">
                        <label>Tên sản phẩm <span style="color:red">*</span></label>
                        <input type="text" name="name" value="${product.productName}" required
                               placeholder="Nhập tên sản phẩm">
                    </div>

                    <div class="form-group">
                        <label>Slug</label>
                        <input type="text" name="slug" value="${product.productSlug}"
                               placeholder="Tự động tạo nếu để trống">
                    </div>

                    <div class="form-group">
                        <label>Xuất xứ</label>
                        <input type="text" name="origin" value="${product.origin}"
                               placeholder="vd: Hàn Quốc, Pháp...">
                    </div>

                    <div class="form-group">
                        <label>Danh mục <span style="color:red">*</span></label>
                        <select name="categoryId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" <c:if
                                        test="${product != null && product.categoryId == c.categoryId}">
                                    selected</c:if>>
                                        ${c.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Thương hiệu <span style="color:red">*</span></label>
                        <select name="brandId" required>
                            <option value="">-- Chọn thương hiệu --</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b.brandId}" <c:if
                                        test="${product != null && product.brandId == b.brandId}">selected
                                </c:if>>
                                        ${b.brandName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group span-2">
                        <div class="variants-section">
                            <h3>Biến thể sản phẩm <span
                                    style="color:#666;font-weight:normal;font-size:13px">(ít nhất 1 biến
                                                    thể)</span></h3>
                            <div id="variants-container">
                                <c:choose>
                                    <c:when test="${not empty variants}">
                                        <c:forEach var="v" items="${variants}">
                                            <div class="variant-row">
                                                <input type="text" name="variantName[]" value="${v.variantName}"
                                                       placeholder="Tên (VD: 100ml)" required>
                                                <input type="text" name="variantSku[]" value="${v.sku}"
                                                       placeholder="SKU">
                                                <input type="number" name="variantOriginalPrice[]"
                                                       value="${v.originalPrice}" placeholder="Giá gốc"
                                                       min="1" step="0.01" required>
                                                <input type="number" name="variantSalePrice[]"
                                                       value="${v.salePrice}" placeholder="Giá sale"
                                                       min="0" step="0.01">
                                                <input type="number" name="variantStock[]"
                                                       value="${v.stockQuantity}" placeholder="Tồn kho"
                                                       min="0">
                                                <button type="button" class="btn-variant-remove"
                                                        onclick="removeVariantRow(this)"
                                                        title="Xóa biến thể">×
                                                </button>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="variant-row">
                                            <input type="text" name="variantName[]"
                                                   placeholder="Tên (VD: 100ml)" required>
                                            <input type="text" name="variantSku[]"
                                                   placeholder="SKU">
                                            <input type="number" name="variantOriginalPrice[]"
                                                   placeholder="Giá gốc" min="1" step="0.01" required>
                                            <input type="number" name="variantSalePrice[]"
                                                   placeholder="Giá sale" min="0" step="0.01">
                                            <input type="number" name="variantStock[]"
                                                   placeholder="Tồn kho" min="0" value="0">
                                            <button type="button" class="btn-variant-remove"
                                                    onclick="removeVariantRow(this)"
                                                    title="Xóa biến thể">×
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <button type="button" class="btn-add-variant" onclick="addVariantRow()">+ Them bien the
                            </button>
                        </div>
                    </div>

                    <div class="form-group span-2">
                        <label>Mô tả ngắn</label>
                        <textarea name="shortDescription"
                                  placeholder="Mô tả ngắn gọn về sản phẩm...">${product.shortDescription}</textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Mô tả chi tiết</label>
                        <textarea name="fullDescription" rows="6"
                                  placeholder="Mô tả chi tiết về thành phần, công dụng...">${product.fullDescription}</textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Thành phần</label>
                        <textarea name="ingredients" rows="4"
                                  placeholder="Liệt kê thành phần...">${product.ingredients}</textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Hướng dẫn sử dụng</label>
                        <textarea name="usageInstructions" rows="4"
                                  placeholder="Nhập hướng dẫn sử dụng...">${product.usageInstructions}</textarea>
                    </div>

                    <div class="form-group span-2">
                        <label>Ảnh sản phẩm</label>
                        <input type="file" name="image" accept="image/*">
                        <c:if test="${not empty product.primaryImageUrl}">
                            <div style="margin-top:10px">
                                <img src="${product.primaryImageUrl}" alt="Current image"
                                     style="max-width:120px;border-radius:8px;border:1px solid #eee">
                                <span style="margin-left:10px;color:#666;font-size:13px">Anh hien tai</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${product != null}">Cập nhật sản phẩm</c:when>
                            <c:otherwise>Thêm sản phẩm</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/products"
                       class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    function addVariantRow() {
        var container = document.getElementById('variants-container');
        var newRow = document.createElement('div');
        newRow.className = 'variant-row';
        newRow.innerHTML =
            '<input type="text" name="variantName[]" placeholder="Tên (vd: 100ml)" required>' +
            '<input type="number" name="variantOriginalPrice[]" placeholder="Giá gốc" min="0" required>' +
            '<input type="number" name="variantSalePrice[]" placeholder="Giá sale" min="0">' +
            '<input type="number" name="variantStock[]" placeholder="Tồn kho" min="0" value="0">' +
            '<button type="button" class="btn-variant-remove" onclick="removeVariantRow(this)" title="Xóa biến thể">×</button>';
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
</script>

</body>

</html>
