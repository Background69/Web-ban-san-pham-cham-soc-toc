<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/form.css">

    <style>
        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            inset: 0;
            background: rgba(0, 0, 0, .45)
        }

        .modal-content {
            background: #fff;
            width: min(720px, 92vw);
            margin: 60px auto;
            border-radius: 12px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, .25)
        }

        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 20px;
            border-bottom: 1px solid #eee;
            background: #fff
        }

        .modal-title {
            font-size: 22px;
            font-weight: 800;
            margin: 0
        }

        .close {
            background: transparent;
            border: none;
            font-size: 22px;
            cursor: pointer;
            line-height: 1;
            padding: 6px 10px
        }

        .modal-body {
            max-height: calc(90vh - 120px);
            overflow-y: auto;
            padding: 18px 20px 20px
        }

        .modal-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            padding: 14px 20px;
            border-top: 1px solid #eee;
            background: #fff
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px 16px
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px
        }

        .form-group label {
            font-weight: 700
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #cfcfcf;
            border-radius: 8px;
            outline: none
        }

        .form-group textarea {
            min-height: 90px;
            resize: vertical
        }

        .span-2 {
            grid-column: span 2
        }

        .btn {
            border: none;
            padding: 10px 14px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 700
        }

        .btn-primary {
            background: #2e7d32;
            color: #fff
        }

        .btn-secondary {
            background: #e0e0e0;
            color: #111
        }

        .thumb {
            width: 52px;
            height: 52px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #eee
        }

        /* Variant Styles */
        #variants-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 10px;
        }

        .variant-row {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 0.8fr auto;
            gap: 8px;
            align-items: center;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .variant-row input {
            padding: 8px 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px;
        }

        .variant-row input:focus {
            border-color: #4b6b3c;
            outline: none;
        }

        .btn-variant-remove {
            width: 32px;
            height: 32px;
            border: none;
            background: #ffebee;
            color: #c62828;
            border-radius: 50%;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
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
            transition: all 0.2s;
        }

        .btn-add-variant:hover {
            background: #c8e6c9;
        }

        @media (max-width: 720px) {
            .variant-row {
                grid-template-columns: 1fr 1fr;
                gap: 6px;
            }

            .variant-row input:first-child {
                grid-column: span 2;
            }
        }

        @media (max-width: 720px) {
            .modal-content {
                margin: 30px auto
            }

            .form-grid {
                grid-template-columns: 1fr
            }

            .span-2 {
                grid-column: span 1
            }
        }
    </style>
</head>

<body>
<div class="container">
    <jsp:include page="/admin/layout/sidebar.jsp"/>

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
                            <img class="thumb"
                                 src="${pageContext.request.contextPath}/static/${p.primaryImageUrl}"
                                 alt="thumb">
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
                                                  type="number"/> ₫
                            </c:when>
                            <c:when
                                    test="${p.defaultVariant != null && p.defaultVariant.originalPrice != null && p.defaultVariant.originalPrice > 0}">
                                <fmt:formatNumber value="${p.defaultVariant.originalPrice}"
                                                  type="number"/> ₫
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
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
                        <a
                                href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}">Sửa</a>
                        |
                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}"
                           onclick="return confirm('Xóa sản phẩm?')">Xóa</a>
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
            <button class="close" type="button" onclick="closeModal()">×</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/products" method="post"
              enctype="multipart/form-data" style="margin:0;">
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
                                        onclick="removeVariantRow(this)" title="Xóa biến thể">×
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
    }

    function closeModal() {
        document.getElementById("productModal").style.display = "none";
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
            '<button type="button" class="btn-variant-remove" onclick="removeVariantRow(this)" title="Xóa biến thể">×</button>';
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