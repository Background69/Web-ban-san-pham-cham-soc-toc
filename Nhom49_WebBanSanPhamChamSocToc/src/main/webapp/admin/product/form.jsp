<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="activeMenu" value="products"/>

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
    <style>
        .form-container {
            background: #fff;
            border-radius: 16px;
            padding: 32px;
            max-width: 980px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-group.span-2 {
            grid-column: span 2;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #4b6b3c;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .variants-section {
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            background: #fafafa;
        }

        .variants-section h3 {
            margin: 0 0 16px 0;
            font-size: 16px;
            color: #333;
        }

        #variants-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 12px;
        }

        .variant-row {
            display: grid;
            grid-template-columns: 1.4fr 1.2fr 1fr 1fr 0.8fr auto;
            gap: 10px;
            align-items: center;
            padding: 14px;
            background: #fff;
            border-radius: 10px;
            border: 1px solid #e9ecef;
        }

        .variant-row input {
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 13px;
        }

        .btn-variant-remove {
            width: 34px;
            height: 34px;
            border: none;
            background: #ffebee;
            color: #c62828;
            border-radius: 50%;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
        }

        .btn-variant-remove:hover {
            background: #ffcdd2;
        }

        .btn-add-variant {
            padding: 10px 16px;
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px dashed #4caf50;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
        }

        .btn-add-variant:hover {
            background: #c8e6c9;
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4b6b3c, #5d8a47);
            color: #fff;
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }

        @media (max-width: 920px) {
            .variant-row {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 720px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.span-2 {
                grid-column: span 1;
            }
        }
    </style>
</head>

<body>
<div class="container">
    <jsp:include page="/admin/layout/sidebar.jsp"/>

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
