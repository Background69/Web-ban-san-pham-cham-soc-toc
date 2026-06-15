<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm | HairGlow Admin</title>
    <meta name="description" content="Theo dõi danh mục, tồn kho, giá bán và trạng thái kinh doanh sản phẩm HairGlow.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/productmanagement.css">
</head>
<body class="hg-admin-products">
<div class="container hg-admin-shell">
    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="products"/>
    </jsp:include>
    <main class="content hg-products-content">
        <c:if test="${param.err == '1' || param.created == '1' || param.updated == '1' || not empty param.deleted}">
            <div class="hg-flash-stack" aria-live="polite">
                <c:if test="${param.created == '1'}">
                    <div class="hg-flash hg-flash--success">
                        <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                        <span>Đã thêm sản phẩm mới.</span>
                    </div>
                </c:if>
                <c:if test="${param.updated == '1'}">
                    <div class="hg-flash hg-flash--success">
                        <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                        <span>Đã cập nhật sản phẩm.</span>
                    </div>
                </c:if>
                <c:if test="${not empty param.deleted && param.deleted != '0'}">
                    <div class="hg-flash hg-flash--success">
                        <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                        <span>Đã ẩn ${fn:escapeXml(param.deleted)} sản phẩm khỏi danh sách kinh doanh.</span>
                    </div>
                </c:if>
                <c:if test="${param.err == '1'}">
                    <div class="hg-flash hg-flash--error">
                        <i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i>
                        <span>Lưu sản phẩm bị lỗi. Vui lòng kiểm tra dữ liệu nhập và log server.</span>
                    </div>
                </c:if>
            </div>
        </c:if>

        <section class="hg-kpi-grid" aria-label="Thống kê sản phẩm">
            <article class="hg-kpi-card hg-kpi-card--total">
                <span class="hg-kpi-card__label">Tổng sản phẩm</span>
                <strong>${totalProducts}</strong>
                <span>Đang quản lý trong HairGlow</span>
            </article>
            <article class="hg-kpi-card hg-kpi-card--selling">
                <span class="hg-kpi-card__label">Đang bán</span>
                <strong>${sellingProducts}</strong>
                <span>Còn tồn kho khả dụng</span>
            </article>
            <article class="hg-kpi-card hg-kpi-card--warning">
                <span class="hg-kpi-card__label">Hết / sắp hết</span>
                <strong>${lowOrOutProducts}</strong>
                <span>Ngưỡng thấp: ${lowStockThreshold} sản phẩm</span>
            </article>
            <article class="hg-kpi-card hg-kpi-card--hidden">
                <span class="hg-kpi-card__label">Tạm dừng / ẩn</span>
                <strong>${hiddenProducts}</strong>
                <span>Sản phẩm soft-delete</span>
            </article>
        </section>

        <section class="hg-toolbar-panel" aria-label="Bộ lọc sản phẩm">
            <div class="hg-toolbar-panel__header">
                <div>
                    <h2>Danh mục sản phẩm</h2>
                    <p>Tìm nhanh theo tên, SKU, thương hiệu, danh mục hoặc trạng thái tồn kho.</p>
                </div>
                <a class="hg-btn hg-btn--ghost" href="${pageContext.request.contextPath}/admin/products" id="resetProductFilters">
                    <i class="fa-solid fa-rotate-right" aria-hidden="true"></i>
                    <span>Làm mới</span>
                </a>
            </div>

            <form class="hg-filter-form" id="productFilterForm" action="${pageContext.request.contextPath}/admin/products" method="get">
                <input type="hidden" name="alpha" id="alphaFilterInput" value="${fn:escapeXml(selectedAlpha)}">

                <label class="hg-field hg-field--search" for="productSearch">
                    <span>Tìm kiếm</span>
                    <span class="hg-search-control">
                        <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                        <input id="productSearch"
                               name="q"
                               value="${fn:escapeXml(selectedQuery)}"
                               type="search"
                               autocomplete="off"
                               placeholder="Tên sản phẩm, SKU, thương hiệu, danh mục..."
                               data-filter-input>
                        <button type="button" class="hg-search-clear" id="clearProductSearch" aria-label="Xóa từ khóa tìm kiếm">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </span>
                </label>

                <label class="hg-field" for="statusFilter">
                    <span>Trạng thái</span>
                    <select id="statusFilter" name="status" data-filter-input>
                        <option value="" ${empty selectedStatus ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="selling" ${selectedStatus == 'selling' ? 'selected' : ''}>Đang bán</option>
                        <option value="out" ${selectedStatus == 'out' ? 'selected' : ''}>Hết hàng</option>
                        <option value="sale" ${selectedStatus == 'sale' ? 'selected' : ''}>Đang sale</option>
                    </select>
                </label>

                <label class="hg-field" for="categoryFilter">
                    <span>Danh mục</span>
                    <select id="categoryFilter" name="categoryId" data-filter-input>
                        <option value="" ${empty selectedCategoryId ? 'selected' : ''}>Tất cả danh mục</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${not empty selectedCategoryId && selectedCategoryId == c.categoryId ? 'selected' : ''}>
                                <c:out value="${c.categoryName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </label>

                <label class="hg-field" for="brandFilter">
                    <span>Thương hiệu</span>
                    <select id="brandFilter" name="brandId" data-filter-input>
                        <option value="" ${empty selectedBrandId ? 'selected' : ''}>Tất cả thương hiệu</option>
                        <c:forEach var="b" items="${brands}">
                            <option value="${b.brandId}" ${not empty selectedBrandId && selectedBrandId == b.brandId ? 'selected' : ''}>
                                <c:out value="${b.brandName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </label>

                <label class="hg-field" for="stockFilter">
                    <span>Tồn kho</span>
                    <select id="stockFilter" name="stock" data-filter-input>
                        <option value="" ${empty selectedStock ? 'selected' : ''}>Tất cả tồn kho</option>
                        <option value="low" ${selectedStock == 'low' ? 'selected' : ''}>Sắp hết hàng</option>
                        <option value="out" ${selectedStock == 'out' ? 'selected' : ''}>Hết hàng</option>
                    </select>
                </label>

                <button class="hg-btn hg-btn--dark hg-filter-submit" type="submit">
                    <i class="fa-solid fa-filter" aria-hidden="true"></i>
                    <span>Lọc</span>
                </button>
            </form>

            <div class="hg-alpha-bar" aria-label="Lọc theo chữ cái đầu">
                <button class="hg-alpha-btn ${empty selectedAlpha ? 'is-active' : ''}" type="button" data-alpha="">Tất cả</button>
                <c:forEach var="letter" items="${fn:split('A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z', ',')}">
                    <button class="hg-alpha-btn ${selectedAlpha == letter ? 'is-active' : ''}" type="button" data-alpha="${letter}">
                        ${letter}
                    </button>
                </c:forEach>
            </div>
        </section>

        <section class="hg-table-card" aria-labelledby="productsTableTitle">
            <div class="hg-table-card__top">
                <div class="hg-table-card__heading">
                    <h2 id="productsTableTitle">Sản phẩm hiện có</h2>
                    <p id="productTableSummary">Đang hiển thị ${filteredProducts} sản phẩm</p>
                </div>
                <div class="hg-table-actions" aria-label="Thao tác bảng sản phẩm">
                    <button class="hg-btn hg-btn--primary" type="button" id="openCreateProductBtn">
                        <i class="fa-solid fa-plus" aria-hidden="true"></i>
                        <span>Thêm sản phẩm</span>
                    </button>
                    <button class="hg-btn hg-btn--secondary" type="button" id="exportProductsBtn">
                        <i class="fa-solid fa-file-export" aria-hidden="true"></i>
                        <span>Xuất CSV</span>
                    </button>
                    <label class="hg-page-size" for="productPageSize">
                        <span>Dòng/trang</span>
                        <select id="productPageSize">
                            <option value="10">10</option>
                            <option value="15" selected>15</option>
                            <option value="25">25</option>
                            <option value="50">50</option>
                        </select>
                    </label>
                </div>
            </div>

            <div class="hg-table-scroll">
                <table class="hg-product-table" id="productTable">
                    <thead>
                    <tr>
                        <th class="hg-col-check">
                            <input type="checkbox" id="selectAllProducts" aria-label="Chọn tất cả sản phẩm đang hiển thị">
                        </th>
                        <th scope="col" class="hg-sortable-th" aria-sort="none">
                            <button type="button" id="sortProductNameBtn" aria-label="Sắp xếp sản phẩm theo tên">
                                <span>Sản phẩm</span>
                                <span id="nameSortIndicator" aria-hidden="true">↕</span>
                            </button>
                        </th>
                        <th scope="col">Giá bán</th>
                        <th scope="col">Tồn kho</th>
                        <th scope="col">Trạng thái</th>
                        <th scope="col">Cập nhật</th>
                        <th scope="col">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody id="productTableBody">
                    <c:forEach var="p" items="${products}" varStatus="loop">
                        <c:set var="variant" value="${p.defaultVariant}"/>
                        <c:set var="skuValue" value="${variant != null ? variant.sku : ''}"/>
                        <c:set var="stockValue" value="${p.remainingStock}"/>
                        <c:set var="rawImage" value="${fn:trim(p.primaryImageUrl)}"/>
                        <c:set var="imageSrc" value="${pageContext.request.contextPath}/static/assets/images/default-product.png"/>
                        <c:if test="${not empty rawImage}">
                            <c:choose>
                                <c:when test="${fn:startsWith(rawImage, 'http://') || fn:startsWith(rawImage, 'https://')}">
                                    <c:set var="imageSrc" value="${rawImage}"/>
                                </c:when>
                                <c:when test="${fn:startsWith(rawImage, '/')}">
                                    <c:set var="imageSrc" value="${pageContext.request.contextPath}${rawImage}"/>
                                </c:when>
                                <c:when test="${fn:startsWith(rawImage, 'static/')}">
                                    <c:set var="imageSrc" value="${pageContext.request.contextPath}/${rawImage}"/>
                                </c:when>
                                <c:when test="${fn:startsWith(rawImage, 'images/')}">
                                    <c:set var="imageSrc" value="${pageContext.request.contextPath}/static/assets/${rawImage}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="imageSrc" value="${pageContext.request.contextPath}/static/assets/images/products/${rawImage}"/>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <tr class="hg-product-row"
                            data-product-id="${p.productId}"
                            data-product-name="${fn:escapeXml(p.productName)}"
                            data-product-slug="${fn:escapeXml(p.productSlug)}"
                            data-product-sku="${fn:escapeXml(skuValue)}"
                            data-product-brand="${fn:escapeXml(p.brandName)}"
                            data-product-category="${fn:escapeXml(p.categoryName)}"
                            data-product-status="${stockValue <= 0 ? 'out' : 'selling'}"
                            data-product-sale="${p.onSale ? 'sale' : ''}"
                            data-product-stock="${stockValue}"
                            data-product-alpha="${fn:toUpperCase(fn:substring(p.productName, 0, 1))}"
                            data-original-index="${loop.index}">
                            <td class="hg-col-check" data-label="Chọn">
                                <input class="product-checkbox" type="checkbox" value="${p.productId}" aria-label="Chọn sản phẩm ${fn:escapeXml(p.productName)}">
                            </td>
                            <td class="hg-product-cell" data-label="Sản phẩm">
                                <div class="hg-product-cell__inner">
                                    <img class="hg-product-thumb"
                                         src="<c:out value='${imageSrc}'/>"
                                         alt="Ảnh sản phẩm ${fn:escapeXml(p.productName)}"
                                         loading="lazy"
                                         onerror="this.src='${pageContext.request.contextPath}/static/assets/images/default-product.png';">
                                    <div class="hg-product-meta">
                                        <strong><c:out value="${p.productName}"/></strong>
                                        <span>
                                            #P${p.productId}
                                            <c:if test="${not empty skuValue}">
                                                · SKU <c:out value="${skuValue}"/>
                                            </c:if>
                                        </span>
                                        <small>
                                            <c:choose>
                                                <c:when test="${not empty p.brandName || not empty p.categoryName}">
                                                    <c:if test="${not empty p.brandName}">
                                                        <c:out value="${p.brandName}"/>
                                                    </c:if>
                                                    <c:if test="${not empty p.brandName && not empty p.categoryName}"> · </c:if>
                                                    <c:if test="${not empty p.categoryName}">
                                                        <c:out value="${p.categoryName}"/>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>Chưa phân loại</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                            </td>
                            <td class="hg-price-cell" data-label="Giá bán">
                                <c:choose>
                                    <c:when test="${variant != null && variant.salePrice != null && variant.salePrice > 0}">
                                        <strong><fmt:formatNumber value="${variant.salePrice}" type="number"/> ₫</strong>
                                        <small><fmt:formatNumber value="${variant.originalPrice}" type="number"/> ₫</small>
                                    </c:when>
                                    <c:when test="${variant != null && variant.originalPrice != null && variant.originalPrice > 0}">
                                        <strong><fmt:formatNumber value="${variant.originalPrice}" type="number"/> ₫</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="hg-muted">Chưa có giá</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Tồn kho">
                                <c:choose>
                                    <c:when test="${stockValue <= 0}">
                                        <span class="hg-stock-badge hg-stock-badge--danger">Hết hàng</span>
                                    </c:when>
                                    <c:when test="${stockValue <= lowStockThreshold}">
                                        <span class="hg-stock-badge hg-stock-badge--warning">Còn ${stockValue}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="hg-stock-badge hg-stock-badge--success">${stockValue} sản phẩm</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Trạng thái">
                                <c:choose>
                                    <c:when test="${stockValue <= 0}">
                                        <span class="hg-status-badge hg-status-badge--danger">
                                            <span></span>Hết hàng
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="hg-status-badge hg-status-badge--success">
                                            <span></span>Đang bán
                                        </span>
                                        <c:if test="${p.onSale}">
                                            <span class="hg-status-badge hg-status-badge--sale">
                                                <span></span>Đang sale
                                            </span>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="hg-date-cell" data-label="Cập nhật">
                                <c:choose>
                                    <c:when test="${not empty p.updatedAt}">
                                        <fmt:formatDate value="${p.updatedAt}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>Chưa có</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="hg-action-cell" data-label="Thao tác">
                                <div class="hg-action-cell__inner">
                                    <a class="hg-icon-btn hg-icon-btn--view"
                                       href="${pageContext.request.contextPath}/product/${fn:escapeXml(p.productSlug)}"
                                       target="_blank"
                                       rel="noopener"
                                       aria-label="Xem sản phẩm ${fn:escapeXml(p.productName)}"
                                       title="Xem">
                                        <i class="fa-regular fa-eye" aria-hidden="true"></i>
                                    </a>
                                    <button class="hg-icon-btn hg-icon-btn--edit"
                                            type="button"
                                            aria-label="Sửa sản phẩm ${fn:escapeXml(p.productName)}"
                                            title="Sửa"
                                            onclick="openEditModal(${p.productId})">
                                        <i class="fa-regular fa-pen-to-square" aria-hidden="true"></i>
                                    </button>
                                    <button class="hg-icon-btn hg-icon-btn--soft"
                                            type="button"
                                            aria-label="Ẩn hoặc hiện sản phẩm ${fn:escapeXml(p.productName)}"
                                            title="Ẩn/Hiện"
                                            data-ui-todo="toggle-visibility">
                                        <i class="fa-regular fa-eye-slash" aria-hidden="true"></i>
                                    </button>
                                    <button class="hg-icon-btn hg-icon-btn--delete"
                                            type="button"
                                            aria-label="Xóa sản phẩm ${fn:escapeXml(p.productName)}"
                                            title="Xóa"
                                            data-delete-product
                                            data-product-id="${p.productId}"
                                            data-product-name="${fn:escapeXml(p.productName)}">
                                        <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr id="filterEmptyRow" class="hg-empty-row" style="display:none">
                        <td colspan="7">
                            <i class="fa-regular fa-folder-open" aria-hidden="true"></i>
                            <strong>Không tìm thấy sản phẩm phù hợp</strong>
                            <span>Thử đổi từ khóa, danh mục hoặc trạng thái tồn kho.</span>
                        </td>
                    </tr>
                    <c:if test="${empty products}">
                        <tr class="hg-empty-row hg-empty-row--server">
                            <td colspan="7">
                                <i class="fa-regular fa-folder-open" aria-hidden="true"></i>
                                <strong>Chưa có sản phẩm</strong>
                                <span>Thêm sản phẩm đầu tiên để bắt đầu quản lý danh mục HairGlow.</span>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <div class="hg-table-footer">
                <span id="productPaginationSummary">Hiển thị 0 - 0 trong 0 sản phẩm</span>
                <nav class="hg-pagination" aria-label="Phân trang sản phẩm">
                    <button type="button" id="prevProductPage" aria-label="Trang trước">
                        <i class="fa-solid fa-chevron-left" aria-hidden="true"></i>
                    </button>
                    <span id="productPaginationPages"></span>
                    <button type="button" id="nextProductPage" aria-label="Trang sau">
                        <i class="fa-solid fa-chevron-right" aria-hidden="true"></i>
                    </button>
                </nav>
            </div>
        </section>
    </main>
</div>

<div class="hg-bulk-bar" id="bulkActionBar" aria-live="polite">
    <strong><span id="bulkSelectedCount">0</span> sản phẩm đã chọn</strong>
    <div class="hg-bulk-actions">
        <button type="button" class="hg-btn hg-btn--secondary" data-ui-todo="bulk-visibility">
            <i class="fa-regular fa-eye-slash" aria-hidden="true"></i>
            <span>Ẩn/Hiện</span>
        </button>
        <button type="button" class="hg-btn hg-btn--secondary" data-ui-todo="bulk-category">
            <i class="fa-solid fa-tags" aria-hidden="true"></i>
            <span>Gán danh mục</span>
        </button>
        <button type="button" class="hg-btn hg-btn--danger" id="bulkDeleteBtn">
            <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
            <span>Xóa hàng loạt</span>
        </button>
    </div>
</div>

<form id="bulkDeleteForm" action="${pageContext.request.contextPath}/admin/products" method="post" hidden>
    <input type="hidden" name="action" value="bulkDelete">
    <div id="bulkDeleteInputs"></div>
</form>

<div class="hg-modal" id="productModal" role="dialog" aria-modal="true" aria-labelledby="productModalTitle" hidden>
    <div class="hg-product-modal">
        <div class="hg-modal-header">
            <div>
                <span class="hg-modal-kicker">Trình chỉnh sửa sản phẩm</span>
                <h2 id="productModalTitle">Thêm sản phẩm</h2>
            </div>
            <button class="hg-icon-btn" type="button" id="closeProductModalBtn" aria-label="Đóng modal sản phẩm">
                <i class="fa-solid fa-xmark" aria-hidden="true"></i>
            </button>
        </div>

        <form id="productForm" action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data" novalidate>
            <input type="hidden" name="action" id="productFormAction" value="create">
            <input type="hidden" name="id" id="productId">

            <div class="hg-modal-tabs" role="tablist" aria-label="Các bước nhập sản phẩm">
                <button type="button" class="hg-tab-btn is-active" data-tab="basic">Thông tin</button>
                <button type="button" class="hg-tab-btn" data-tab="pricing">Giá & Kho</button>
                <button type="button" class="hg-tab-btn" data-tab="images">Hình ảnh</button>
                <button type="button" class="hg-tab-btn" data-tab="content">Mô tả & SEO</button>
            </div>

            <div class="hg-modal-body">
                <section class="hg-tab-panel is-active" data-tab-panel="basic">
                    <div class="hg-form-grid">
                        <label class="hg-field hg-span-2" for="productName">
                            <span>Tên sản phẩm</span>
                            <input type="text" id="productName" name="name" required>
                            <small class="hg-field-error" data-field-error="name"></small>
                        </label>

                        <label class="hg-field" for="productSlug">
                            <span>Slug</span>
                            <input type="text" id="productSlug" name="slug" placeholder="Tự sinh nếu để trống">
                        </label>

                        <label class="hg-field" for="productOrigin">
                            <span>Xuất xứ</span>
                            <input type="text" id="productOrigin" name="origin" placeholder="Hàn Quốc, Pháp...">
                        </label>

                        <label class="hg-field" for="categorySearchInput">
                            <span>Tìm danh mục</span>
                            <input type="search" id="categorySearchInput" data-select-search="productCategoryId" placeholder="Gõ để lọc danh mục">
                        </label>

                        <label class="hg-field" for="productCategoryId">
                            <span>Danh mục</span>
                            <select id="productCategoryId" name="categoryId" required>
                                <option value="">Chọn danh mục</option>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}"><c:out value="${c.categoryName}"/></option>
                                </c:forEach>
                            </select>
                            <small class="hg-field-error" data-field-error="categoryId"></small>
                        </label>

                        <label class="hg-field" for="brandSearchInput">
                            <span>Tìm thương hiệu</span>
                            <input type="search" id="brandSearchInput" data-select-search="productBrandId" placeholder="Gõ để lọc thương hiệu">
                        </label>

                        <label class="hg-field" for="productBrandId">
                            <span>Thương hiệu</span>
                            <select id="productBrandId" name="brandId" required>
                                <option value="">Chọn thương hiệu</option>
                                <c:forEach var="b" items="${brands}">
                                    <option value="${b.brandId}"><c:out value="${b.brandName}"/></option>
                                </c:forEach>
                            </select>
                            <small class="hg-field-error" data-field-error="brandId"></small>
                        </label>

                        <div class="hg-toggle-row hg-span-2">
                            <label>
                                <input type="checkbox" id="productFeatured" name="isFeatured">
                                <span>Sản phẩm nổi bật</span>
                            </label>
                            <label>
                                <input type="checkbox" id="productOnSale" name="isOnSale">
                                <span>Đang sale</span>
                            </label>
                        </div>

                        <label class="hg-field hg-span-2" for="productShortDescription">
                            <span>Mô tả ngắn</span>
                            <textarea id="productShortDescription" name="shortDescription" rows="3"></textarea>
                        </label>
                    </div>
                </section>

                <section class="hg-tab-panel" data-tab-panel="pricing">
                    <div class="hg-section-heading">
                        <h3>Biến thể, SKU, giá và tồn kho</h3>
                        <button type="button" class="hg-btn hg-btn--secondary" id="addVariantBtn">
                            <i class="fa-solid fa-plus" aria-hidden="true"></i>
                            <span>Thêm biến thể</span>
                        </button>
                    </div>
                    <div id="variantsContainer" class="hg-variants"></div>
                    <small class="hg-field-error" data-field-error="variants"></small>
                </section>

                <section class="hg-tab-panel" data-tab-panel="images">
                    <div class="hg-image-uploader" id="imageDropZone">
                        <input type="file" id="productImageInput" name="image" accept="image/*">
                        <i class="fa-regular fa-image" aria-hidden="true"></i>
                        <strong>Kéo ảnh vào đây hoặc chọn ảnh sản phẩm</strong>
                        <span>JPG, PNG, WEBP hoặc GIF. Backend hiện lưu ảnh chính lên Cloudinary.</span>
                    </div>
                    <div class="hg-image-preview-grid" id="selectedImagePreview"></div>
                    <div class="hg-existing-images">
                        <h3>Ảnh hiện có</h3>
                        <div class="hg-image-preview-grid" id="existingImagesGrid"></div>
                    </div>
                </section>

                <section class="hg-tab-panel" data-tab-panel="content">
                    <div class="hg-form-grid">
                        <label class="hg-field hg-span-2" for="productFullDescription">
                            <span>Mô tả chi tiết</span>
                            <textarea id="productFullDescription" name="fullDescription" rows="5"></textarea>
                        </label>

                        <label class="hg-field hg-span-2" for="productIngredients">
                            <span>Thành phần</span>
                            <textarea id="productIngredients" name="ingredients" rows="4"></textarea>
                        </label>

                        <label class="hg-field hg-span-2" for="productUsageInstructions">
                            <span>Hướng dẫn sử dụng</span>
                            <textarea id="productUsageInstructions" name="usageInstructions" rows="4"></textarea>
                        </label>

                        <div class="hg-seo-box hg-span-2">
                            <div>
                                <h3>SEO preview</h3>
                                <p>Meta title/description chưa có cột DB riêng; phần này dùng dữ liệu tên, slug và mô tả ngắn hiện có.</p>
                            </div>
                            <label class="hg-field" for="seoTitle">
                                <span>Meta title gợi ý</span>
                                <input type="text" id="seoTitle" maxlength="70">
                            </label>
                            <label class="hg-field" for="seoDescription">
                                <span>Meta description gợi ý</span>
                                <textarea id="seoDescription" rows="3" maxlength="170"></textarea>
                            </label>
                            <div class="hg-google-preview">
                                <span id="seoPreviewUrl">hairglow.vn/product/slug</span>
                                <strong id="seoPreviewTitle">Tên sản phẩm HairGlow</strong>
                                <p id="seoPreviewDescription">Mô tả ngắn của sản phẩm sẽ hiển thị tại đây.</p>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

            <div class="hg-modal-footer">
                <button type="button" class="hg-btn hg-btn--ghost" id="clearProductDraftBtn">
                    <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
                    <span>Xóa bản nháp</span>
                </button>
                <div>
                    <button type="button" class="hg-btn hg-btn--secondary" id="cancelProductModalBtn">Hủy</button>
                    <button type="submit" class="hg-btn hg-btn--primary" id="saveProductBtn">
                        <i class="fa-solid fa-floppy-disk" aria-hidden="true"></i>
                        <span>Lưu sản phẩm</span>
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="hg-confirm-modal" id="deleteConfirmModal" role="dialog" aria-modal="true" aria-labelledby="deleteConfirmTitle" hidden>
    <div class="hg-confirm-box">
        <i class="fa-regular fa-trash-can" aria-hidden="true"></i>
        <h2 id="deleteConfirmTitle">Xác nhận xóa sản phẩm</h2>
        <p id="deleteConfirmMessage">Sản phẩm sẽ được ẩn khỏi danh sách kinh doanh.</p>
        <form id="deleteProductForm" action="${pageContext.request.contextPath}/admin/products" method="post">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="deleteProductId">
            <div class="hg-confirm-actions">
                <button type="button" class="hg-btn hg-btn--secondary" id="cancelDeleteBtn">Hủy</button>
                <button type="submit" class="hg-btn hg-btn--danger">Xóa sản phẩm</button>
            </div>
        </form>
    </div>
</div>

<div class="hg-toast-stack" id="toastStack" aria-live="polite" aria-atomic="true"></div>

<script>
    (function () {
        var contextPath = '${pageContext.request.contextPath}';
        var defaultImage = contextPath + '/static/assets/images/default-product.png';
        var lowStockThreshold = Number('${lowStockThreshold}') || 10;
        var createSucceeded = '${param.created}' === '1';
        var draftKey = 'hairglow.admin.product.create.draft';
        var currentProductPage = 1;
        var currentPageSize = 15;
        var currentNameSort = 'none';
        var currentRows = [];
        var searchTimer = null;

        var productForm = document.getElementById('productForm');
        var productModal = document.getElementById('productModal');
        var productTableBody = document.getElementById('productTableBody');
        var alphaFilterInput = document.getElementById('alphaFilterInput');
        var selectAllProducts = document.getElementById('selectAllProducts');

        if (createSucceeded) {
            localStorage.removeItem(draftKey);
        }

        window.openEditModal = function (productId) {
            resetProductForm('edit');
            setProductModalLoading(true);

            fetch(contextPath + '/admin/products?action=get&id=' + encodeURIComponent(productId), {
                headers: { 'Accept': 'application/json' }
            })
                .then(function (res) {
                    if (!res.ok) {
                        throw new Error('HTTP ' + res.status);
                    }
                    return res.json();
                })
                .then(function (product) {
                    fillProductForm(product);
                    openProductModal('edit');
                })
                .catch(function (error) {
                    console.error(error);
                    showToast('Không thể tải thông tin sản phẩm. Vui lòng kiểm tra server log.', 'error');
                })
                .finally(function () {
                    setProductModalLoading(false);
                });
        };

        function stripVietnamese(value) {
            return String(value || '')
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .replace(/đ/g, 'd')
                .replace(/Đ/g, 'D')
                .toLocaleLowerCase('vi')
                .trim();
        }

        function getAllProductRows() {
            return Array.prototype.slice.call(document.querySelectorAll('#productTableBody tr.hg-product-row'));
        }

        function getFilterValues() {
            return {
                keyword: stripVietnamese(document.getElementById('productSearch').value),
                status: document.getElementById('statusFilter').value,
                categoryId: document.getElementById('categoryFilter').value,
                brandId: document.getElementById('brandFilter').value,
                stock: document.getElementById('stockFilter').value,
                alpha: alphaFilterInput ? alphaFilterInput.value : ''
            };
        }

        function rowMatchesFilters(row, filters) {
            var text = [
                row.dataset.productName,
                row.dataset.productSlug,
                row.dataset.productSku,
                row.dataset.productBrand,
                row.dataset.productCategory
            ].join(' ');
            var stock = Number(row.dataset.productStock) || 0;
            var alpha = stripVietnamese(row.dataset.productName).charAt(0).toUpperCase();

            if (filters.keyword && !stripVietnamese(text).includes(filters.keyword)) {
                return false;
            }
            if (filters.status === 'selling' && row.dataset.productStatus !== 'selling') {
                return false;
            }
            if (filters.status === 'out' && row.dataset.productStatus !== 'out') {
                return false;
            }
            if (filters.status === 'sale' && row.dataset.productSale !== 'sale') {
                return false;
            }
            if (filters.categoryId) {
                var categorySelect = document.getElementById('categoryFilter');
                var selectedCategory = categorySelect.options[categorySelect.selectedIndex].text;
                if (stripVietnamese(row.dataset.productCategory) !== stripVietnamese(selectedCategory)) {
                    return false;
                }
            }
            if (filters.brandId) {
                var brandSelect = document.getElementById('brandFilter');
                var selectedBrand = brandSelect.options[brandSelect.selectedIndex].text;
                if (stripVietnamese(row.dataset.productBrand) !== stripVietnamese(selectedBrand)) {
                    return false;
                }
            }
            if (filters.stock === 'low' && !(stock > 0 && stock <= lowStockThreshold)) {
                return false;
            }
            if (filters.stock === 'out' && stock > 0) {
                return false;
            }
            return !filters.alpha || alpha === filters.alpha;
        }

        function applyProductTableState() {
            var rows = getAllProductRows();
            rows.forEach(function (row) {
                row.style.display = 'none';
            });

            applyNameSort(rows);
            var filters = getFilterValues();
            currentRows = rows.filter(function (row) {
                return rowMatchesFilters(row, filters);
            });

            var total = currentRows.length;
            var totalPages = Math.max(1, Math.ceil(total / currentPageSize));
            if (currentProductPage > totalPages) {
                currentProductPage = totalPages;
            }

            var startIndex = (currentProductPage - 1) * currentPageSize;
            var endIndex = Math.min(startIndex + currentPageSize, total);
            currentRows.slice(startIndex, endIndex).forEach(function (row) {
                row.style.display = '';
            });

            updateProductSummary(total, startIndex, endIndex);
            renderProductPagination(totalPages, total);
            updateFilterEmptyRow(total, rows.length);
            updateBulkBar();
            updateSearchClearButton();
        }

        function applyNameSort(rows) {
            if (!productTableBody) {
                return;
            }
            if (currentNameSort === 'none') {
                rows.sort(function (a, b) {
                    return Number(a.dataset.originalIndex) - Number(b.dataset.originalIndex);
                });
            } else {
                rows.sort(function (a, b) {
                    var nameA = stripVietnamese(a.dataset.productName);
                    var nameB = stripVietnamese(b.dataset.productName);
                    return currentNameSort === 'asc'
                        ? nameA.localeCompare(nameB, 'vi')
                        : nameB.localeCompare(nameA, 'vi');
                });
            }

            var emptyRow = document.getElementById('filterEmptyRow');
            rows.forEach(function (row) {
                if (emptyRow) {
                    productTableBody.insertBefore(row, emptyRow);
                } else {
                    productTableBody.appendChild(row);
                }
            });
        }

        function updateProductSummary(total, startIndex, endIndex) {
            var tableSummary = document.getElementById('productTableSummary');
            var paginationSummary = document.getElementById('productPaginationSummary');
            var text = total === 0
                ? 'Hiển thị 0 - 0 trong 0 sản phẩm'
                : 'Hiển thị ' + (startIndex + 1) + ' - ' + endIndex + ' trong ' + total.toLocaleString('vi-VN') + ' sản phẩm';
            if (tableSummary) {
                tableSummary.textContent = text;
            }
            if (paginationSummary) {
                paginationSummary.textContent = text;
            }
        }

        function renderProductPagination(totalPages, totalRows) {
            var pagesBox = document.getElementById('productPaginationPages');
            var prevBtn = document.getElementById('prevProductPage');
            var nextBtn = document.getElementById('nextProductPage');
            if (!pagesBox) {
                return;
            }
            pagesBox.innerHTML = '';

            if (prevBtn) {
                prevBtn.disabled = totalRows === 0 || currentProductPage <= 1;
            }
            if (nextBtn) {
                nextBtn.disabled = totalRows === 0 || currentProductPage >= totalPages;
            }
            if (totalRows === 0) {
                return;
            }

            buildPageList(currentProductPage, totalPages).forEach(function (item) {
                if (item === '...') {
                    var ellipsis = document.createElement('span');
                    ellipsis.className = 'hg-pagination-ellipsis';
                    ellipsis.textContent = '...';
                    pagesBox.appendChild(ellipsis);
                    return;
                }
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.textContent = item;
                btn.setAttribute('aria-label', 'Trang ' + item);
                if (item === currentProductPage) {
                    btn.classList.add('is-active');
                    btn.setAttribute('aria-current', 'page');
                }
                btn.addEventListener('click', function () {
                    currentProductPage = item;
                    applyProductTableState();
                });
                pagesBox.appendChild(btn);
            });
        }

        function buildPageList(current, total) {
            var pages = [];
            if (total <= 7) {
                for (var i = 1; i <= total; i++) {
                    pages.push(i);
                }
                return pages;
            }
            pages.push(1);
            if (current > 4) {
                pages.push('...');
            }
            var start = Math.max(2, current - 1);
            var end = Math.min(total - 1, current + 1);
            for (var j = start; j <= end; j++) {
                pages.push(j);
            }
            if (current < total - 3) {
                pages.push('...');
            }
            pages.push(total);
            return pages;
        }

        function updateFilterEmptyRow(total, totalRows) {
            var emptyRow = document.getElementById('filterEmptyRow');
            if (emptyRow) {
                emptyRow.style.display = totalRows > 0 && total === 0 ? '' : 'none';
            }
        }

        function updateSearchClearButton() {
            var input = document.getElementById('productSearch');
            var clearBtn = document.getElementById('clearProductSearch');
            if (input && clearBtn) {
                clearBtn.classList.toggle('is-visible', input.value.trim().length > 0);
            }
        }

        function updateAlphaButtons() {
            document.querySelectorAll('.hg-alpha-btn').forEach(function (btn) {
                btn.classList.toggle('is-active', btn.dataset.alpha === (alphaFilterInput ? alphaFilterInput.value : ''));
            });
        }

        function goToPreviousProductPage() {
            if (currentProductPage > 1) {
                currentProductPage--;
                applyProductTableState();
            }
        }

        function goToNextProductPage() {
            var totalPages = Math.max(1, Math.ceil(currentRows.length / currentPageSize));
            if (currentProductPage < totalPages) {
                currentProductPage++;
                applyProductTableState();
            }
        }

        function updateBulkBar() {
            var selected = getSelectedProductCheckboxes();
            var bulkBar = document.getElementById('bulkActionBar');
            var count = document.getElementById('bulkSelectedCount');
            if (bulkBar) {
                bulkBar.classList.toggle('is-visible', selected.length > 0);
            }
            if (count) {
                count.textContent = selected.length;
            }
            if (selectAllProducts) {
                var visibleRows = currentRows.filter(function (row) {
                    return row.style.display !== 'none';
                });
                var checkedVisible = visibleRows.filter(function (row) {
                    var checkbox = row.querySelector('.product-checkbox');
                    return checkbox && checkbox.checked;
                });
                selectAllProducts.checked = visibleRows.length > 0 && checkedVisible.length === visibleRows.length;
                selectAllProducts.indeterminate = checkedVisible.length > 0 && checkedVisible.length < visibleRows.length;
            }
        }

        function getSelectedProductCheckboxes() {
            return Array.prototype.slice.call(document.querySelectorAll('.product-checkbox:checked'));
        }

        function openDeleteConfirm(productId, productName) {
            document.getElementById('deleteProductId').value = productId;
            document.getElementById('deleteConfirmMessage').textContent = 'Sản phẩm "' + productName + '" sẽ được ẩn khỏi danh sách kinh doanh.';
            document.getElementById('deleteConfirmModal').hidden = false;
        }

        function closeDeleteConfirm() {
            document.getElementById('deleteConfirmModal').hidden = true;
        }

        function openBulkDeleteConfirm() {
            var selected = getSelectedProductCheckboxes();
            if (!selected.length) {
                return;
            }
            var inputs = document.getElementById('bulkDeleteInputs');
            inputs.innerHTML = '';
            selected.forEach(function (checkbox) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'selectedProductIds';
                input.value = checkbox.value;
                inputs.appendChild(input);
            });
            document.getElementById('deleteProductForm').onsubmit = function (event) {
                event.preventDefault();
                document.getElementById('bulkDeleteForm').submit();
            };
            document.getElementById('deleteProductId').value = '';
            document.getElementById('deleteConfirmMessage').textContent = selected.length + ' sản phẩm đã chọn sẽ được ẩn khỏi danh sách kinh doanh.';
            document.getElementById('deleteConfirmModal').hidden = false;
        }

        function resetDeleteFormSubmit() {
            document.getElementById('deleteProductForm').onsubmit = null;
        }

        function openProductModal(mode) {
            document.getElementById('productModalTitle').textContent = mode === 'edit' ? 'Sửa sản phẩm' : 'Thêm sản phẩm';
            document.getElementById('saveProductBtn').querySelector('span').textContent = mode === 'edit' ? 'Cập nhật sản phẩm' : 'Lưu sản phẩm';
            document.getElementById('clearProductDraftBtn').hidden = mode === 'edit';
            productModal.hidden = false;
            document.body.classList.add('hg-modal-open');
            setActiveProductTab('basic');
            var modalBody = productModal.querySelector('.hg-modal-body');
            if (modalBody) {
                modalBody.scrollTo({ top: 0 });
            }
            setTimeout(function () {
                document.getElementById('productName').focus();
            }, 80);
        }

        function closeProductModal() {
            productModal.hidden = true;
            document.body.classList.remove('hg-modal-open');
        }

        function resetProductForm(mode) {
            productForm.reset();
            productForm.dataset.mode = mode || 'create';
            document.getElementById('productFormAction').value = mode === 'edit' ? 'edit' : 'create';
            document.getElementById('productId').value = '';
            clearValidation();
            document.getElementById('variantsContainer').innerHTML = '';
            addVariantRow();
            document.getElementById('selectedImagePreview').innerHTML = '';
            document.getElementById('existingImagesGrid').innerHTML = '<span class="hg-empty-inline">Chưa có ảnh hiện có.</span>';
            updateSeoPreview();
        }

        function setProductModalLoading(isLoading) {
            document.getElementById('openCreateProductBtn').disabled = isLoading;
        }

        function fillProductForm(product) {
            document.getElementById('productId').value = product.productId || product.id || '';
            document.getElementById('productName').value = product.name || '';
            document.getElementById('productSlug').value = product.slug || '';
            document.getElementById('productOrigin').value = product.origin || '';
            document.getElementById('productCategoryId').value = product.categoryId || '';
            document.getElementById('productBrandId').value = product.brandId || '';
            document.getElementById('productShortDescription').value = product.shortDescription || '';
            document.getElementById('productFullDescription').value = product.fullDescription || '';
            document.getElementById('productIngredients').value = product.ingredients || '';
            document.getElementById('productUsageInstructions').value = product.usageInstructions || '';
            document.getElementById('productFeatured').checked = Boolean(product.isFeatured);
            document.getElementById('productOnSale').checked = Boolean(product.isOnSale);
            document.getElementById('variantsContainer').innerHTML = '';
            if (product.variants && product.variants.length) {
                product.variants.forEach(function (variant) {
                    addVariantRow(variant);
                });
            } else {
                addVariantRow();
            }
            renderExistingImages(product.images || [], product.primaryImageUrl);
            updateSeoPreview();
        }

        function setActiveProductTab(tabName) {
            document.querySelectorAll('.hg-tab-btn').forEach(function (btn) {
                btn.classList.toggle('is-active', btn.dataset.tab === tabName);
            });
            document.querySelectorAll('.hg-tab-panel').forEach(function (panel) {
                panel.classList.toggle('is-active', panel.dataset.tabPanel === tabName);
            });
        }

        function addVariantRow(variant) {
            var container = document.getElementById('variantsContainer');
            var row = document.createElement('div');
            row.className = 'hg-variant-row';
            row.innerHTML =
                '<label><span>Biến thể</span><input type="text" name="variantName[]" required></label>' +
                '<label><span>SKU</span><span class="hg-inline-input"><input type="text" name="variantSku[]"><button type="button" class="hg-mini-btn" data-generate-sku>Gợi ý</button></span></label>' +
                '<label><span>Giá gốc</span><input type="number" name="variantOriginalPrice[]" min="1" step="1000" required></label>' +
                '<label><span>Giá sale</span><input type="number" name="variantSalePrice[]" min="0" step="1000"></label>' +
                '<label><span>Tồn kho</span><input type="number" name="variantStock[]" min="0" step="1" value="0"></label>' +
                '<button type="button" class="hg-icon-btn hg-icon-btn--delete" data-remove-variant aria-label="Xóa biến thể"><i class="fa-solid fa-xmark" aria-hidden="true"></i></button>';
            container.appendChild(row);

            row.querySelector('[name="variantName[]"]').value = variant && variant.variantName ? variant.variantName : 'Mặc định';
            row.querySelector('[name="variantSku[]"]').value = variant && variant.sku ? variant.sku : '';
            row.querySelector('[name="variantOriginalPrice[]"]').value = variant && variant.originalPrice ? variant.originalPrice : '';
            row.querySelector('[name="variantSalePrice[]"]').value = variant && variant.salePrice ? variant.salePrice : '';
            row.querySelector('[name="variantStock[]"]').value = variant && typeof variant.stockQuantity !== 'undefined' ? variant.stockQuantity : 0;

            row.querySelector('[data-remove-variant]').addEventListener('click', function () {
                if (container.querySelectorAll('.hg-variant-row').length <= 1) {
                    showToast('Phải có ít nhất một biến thể sản phẩm.', 'error');
                    return;
                }
                row.remove();
                saveDraftIfCreate();
            });
            row.querySelector('[data-generate-sku]').addEventListener('click', function () {
                generateSkuForRow(row);
            });
            row.querySelectorAll('input').forEach(function (input) {
                input.addEventListener('input', saveDraftIfCreate);
            });
        }

        function generateSkuForRow(row) {
            var categoryText = getSelectedText('productCategoryId');
            var brandText = getSelectedText('productBrandId');
            var nameText = document.getElementById('productName').value;
            var prefix = [brandText, categoryText, nameText].map(function (value) {
                return stripVietnamese(value).replace(/[^a-z0-9]+/g, ' ').trim().split(' ').slice(0, 2).map(function (part) {
                    return part.charAt(0).toUpperCase();
                }).join('');
            }).join('');
            row.querySelector('[name="variantSku[]"]').value = (prefix || 'HG') + '-' + Date.now().toString().slice(-6);
            saveDraftIfCreate();
        }

        function getSelectedText(selectId) {
            var select = document.getElementById(selectId);
            if (!select || !select.value) {
                return '';
            }
            return select.options[select.selectedIndex].text || '';
        }

        function renderExistingImages(images, primaryImageUrl) {
            var grid = document.getElementById('existingImagesGrid');
            grid.innerHTML = '';
            var list = images && images.length ? images : (primaryImageUrl ? [{ imageUrl: primaryImageUrl, isPrimary: true }] : []);
            if (!list.length) {
                grid.innerHTML = '<span class="hg-empty-inline">Chưa có ảnh hiện có.</span>';
                return;
            }
            list.forEach(function (image) {
                var src = resolveImageUrl(image.imageUrl);
                var card = document.createElement('div');
                card.className = 'hg-image-card';
                card.innerHTML = '<img alt="Ảnh sản phẩm hiện có"><span>' + (image.isPrimary ? 'Ảnh đại diện' : 'Ảnh phụ') + '</span>';
                card.querySelector('img').src = withCacheBust(src);
                card.querySelector('img').onerror = function () {
                    this.src = defaultImage;
                };
                grid.appendChild(card);
            });
        }

        function resolveImageUrl(url) {
            var value = String(url || '').trim();
            if (!value) {
                return defaultImage;
            }
            if (/^https?:\/\//i.test(value)) {
                return value;
            }
            if (value.charAt(0) === '/') {
                return contextPath + value;
            }
            if (value.indexOf('static/') === 0) {
                return contextPath + '/' + value;
            }
            if (value.indexOf('images/') === 0) {
                return contextPath + '/static/assets/' + value;
            }
            return contextPath + '/static/assets/images/products/' + value;
        }

        function withCacheBust(url) {
            if (!url || url === defaultImage) {
                return url;
            }
            return url + (url.indexOf('?') >= 0 ? '&' : '?') + 'v=' + Date.now();
        }

        function renderSelectedImage(file) {
            var grid = document.getElementById('selectedImagePreview');
            grid.innerHTML = '';
            if (!file) {
                return;
            }
            var card = document.createElement('div');
            card.className = 'hg-image-card';
            card.innerHTML = '<img alt="Preview ảnh vừa chọn"><span>Ảnh mới</span>';
            card.querySelector('img').src = URL.createObjectURL(file);
            grid.appendChild(card);
        }

        function validateProductForm() {
            clearValidation();
            var valid = true;
            var name = document.getElementById('productName').value.trim();
            var categoryId = document.getElementById('productCategoryId').value;
            var brandId = document.getElementById('productBrandId').value;
            var rows = Array.prototype.slice.call(document.querySelectorAll('.hg-variant-row'));

            if (!name) {
                setFieldError('name', 'Tên sản phẩm không được để trống.');
                valid = false;
            }
            if (!categoryId) {
                setFieldError('categoryId', 'Vui lòng chọn danh mục.');
                valid = false;
            }
            if (!brandId) {
                setFieldError('brandId', 'Vui lòng chọn thương hiệu.');
                valid = false;
            }
            if (!rows.length) {
                setFieldError('variants', 'Phải có ít nhất một biến thể.');
                valid = false;
            }

            rows.forEach(function (row) {
                row.classList.remove('is-invalid');
                var variantName = row.querySelector('[name="variantName[]"]').value.trim();
                var original = Number(row.querySelector('[name="variantOriginalPrice[]"]').value);
                var saleValue = row.querySelector('[name="variantSalePrice[]"]').value;
                var sale = saleValue === '' ? null : Number(saleValue);
                var stock = Number(row.querySelector('[name="variantStock[]"]').value);
                if (!variantName || !original || original <= 0 || stock < 0 || (sale !== null && (sale <= 0 || sale >= original))) {
                    row.classList.add('is-invalid');
                    valid = false;
                }
            });

            if (!valid) {
                setFieldError('variants', 'Kiểm tra lại biến thể: tên, giá dương, giá sale nhỏ hơn giá gốc và tồn kho không âm.');
                showToast('Vui lòng sửa các trường chưa hợp lệ trước khi lưu.', 'error');
                var firstError = productForm.querySelector('.hg-field-error:not(:empty), .is-invalid');
                if (firstError) {
                    var parentPanel = firstError.closest('.hg-tab-panel');
                    if (parentPanel && parentPanel.dataset.tabPanel) {
                        setActiveProductTab(parentPanel.dataset.tabPanel);
                    }
                    setTimeout(function () {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }, 80);
                }
            }
            return valid;
        }

        function clearValidation() {
            document.querySelectorAll('.hg-field-error').forEach(function (el) {
                el.textContent = '';
            });
            document.querySelectorAll('.is-invalid').forEach(function (el) {
                el.classList.remove('is-invalid');
            });
        }

        function setFieldError(name, message) {
            var error = document.querySelector('[data-field-error="' + name + '"]');
            if (error) {
                error.textContent = message;
            }
        }

        function serializeDraft() {
            var variants = Array.prototype.slice.call(document.querySelectorAll('.hg-variant-row')).map(function (row) {
                return {
                    variantName: row.querySelector('[name="variantName[]"]').value,
                    sku: row.querySelector('[name="variantSku[]"]').value,
                    originalPrice: row.querySelector('[name="variantOriginalPrice[]"]').value,
                    salePrice: row.querySelector('[name="variantSalePrice[]"]').value,
                    stockQuantity: row.querySelector('[name="variantStock[]"]').value
                };
            });
            return {
                name: document.getElementById('productName').value,
                slug: document.getElementById('productSlug').value,
                origin: document.getElementById('productOrigin').value,
                categoryId: document.getElementById('productCategoryId').value,
                brandId: document.getElementById('productBrandId').value,
                shortDescription: document.getElementById('productShortDescription').value,
                fullDescription: document.getElementById('productFullDescription').value,
                ingredients: document.getElementById('productIngredients').value,
                usageInstructions: document.getElementById('productUsageInstructions').value,
                isFeatured: document.getElementById('productFeatured').checked,
                isOnSale: document.getElementById('productOnSale').checked,
                variants: variants
            };
        }

        function saveDraftIfCreate() {
            if (productForm.dataset.mode !== 'create') {
                return;
            }
            localStorage.setItem(draftKey, JSON.stringify(serializeDraft()));
        }

        function loadCreateDraft() {
            var raw = localStorage.getItem(draftKey);
            if (!raw) {
                return;
            }
            try {
                var draft = JSON.parse(raw);
                fillProductForm(draft);
                document.getElementById('productId').value = '';
                document.getElementById('productFormAction').value = 'create';
                productForm.dataset.mode = 'create';
                showToast('Đã khôi phục bản nháp sản phẩm.', 'success');
            } catch (error) {
                localStorage.removeItem(draftKey);
            }
        }

        function updateSeoPreview() {
            var name = document.getElementById('productName').value.trim();
            var slug = document.getElementById('productSlug').value.trim() || slugify(name) || 'slug';
            var description = document.getElementById('productShortDescription').value.trim();
            document.getElementById('seoTitle').value = name ? name + ' | HairGlow' : '';
            document.getElementById('seoDescription').value = description;
            document.getElementById('seoPreviewUrl').textContent = 'hairglow.vn/product/' + slug;
            document.getElementById('seoPreviewTitle').textContent = name || 'Tên sản phẩm HairGlow';
            document.getElementById('seoPreviewDescription').textContent = description || 'Mô tả ngắn của sản phẩm sẽ hiển thị tại đây.';
        }

        function slugify(value) {
            return stripVietnamese(value).replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
        }

        function showToast(message, type) {
            var stack = document.getElementById('toastStack');
            var toast = document.createElement('div');
            toast.className = 'hg-toast hg-toast--' + (type || 'success');
            toast.textContent = message;
            stack.appendChild(toast);
            setTimeout(function () {
                toast.classList.add('is-leaving');
                setTimeout(function () {
                    toast.remove();
                }, 180);
            }, 3200);
        }

        function exportVisibleProducts() {
            var rows = currentRows.length ? currentRows : getAllProductRows();
            var lines = [['ID', 'Tên sản phẩm', 'SKU', 'Thương hiệu', 'Danh mục', 'Tồn kho', 'Trạng thái']];
            rows.forEach(function (row) {
                lines.push([
                    row.dataset.productId,
                    row.dataset.productName,
                    row.dataset.productSku,
                    row.dataset.productBrand,
                    row.dataset.productCategory,
                    row.dataset.productStock,
                    row.dataset.productStatus === 'out' ? 'Hết hàng' : 'Đang bán'
                ]);
            });
            var csv = lines.map(function (cells) {
                return cells.map(function (cell) {
                    return '"' + String(cell || '').replace(/"/g, '""') + '"';
                }).join(',');
            }).join('\r\n');
            var blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' });
            var link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'hairglow-products.csv';
            link.click();
            URL.revokeObjectURL(link.href);
            showToast('Đã xuất CSV theo danh sách đang lọc.', 'success');
        }

        function bindSelectSearch() {
            document.querySelectorAll('[data-select-search]').forEach(function (input) {
                input.addEventListener('input', function () {
                    var select = document.getElementById(input.dataset.selectSearch);
                    var keyword = stripVietnamese(input.value);
                    Array.prototype.slice.call(select.options).forEach(function (option, index) {
                        option.hidden = index !== 0 && keyword && !stripVietnamese(option.text).includes(keyword);
                    });
                });
            });
        }

        document.getElementById('productFilterForm').addEventListener('submit', function (event) {
            event.preventDefault();
            currentProductPage = 1;
            applyProductTableState();
        });

        document.querySelectorAll('[data-filter-input]').forEach(function (input) {
            input.addEventListener('input', function () {
                window.clearTimeout(searchTimer);
                searchTimer = window.setTimeout(function () {
                    currentProductPage = 1;
                    applyProductTableState();
                }, 220);
            });
            input.addEventListener('change', function () {
                currentProductPage = 1;
                applyProductTableState();
            });
        });

        document.querySelectorAll('.hg-alpha-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                alphaFilterInput.value = btn.dataset.alpha || '';
                currentProductPage = 1;
                updateAlphaButtons();
                applyProductTableState();
            });
        });

        document.getElementById('clearProductSearch').addEventListener('click', function () {
            document.getElementById('productSearch').value = '';
            currentProductPage = 1;
            applyProductTableState();
            document.getElementById('productSearch').focus();
        });

        document.getElementById('productPageSize').addEventListener('change', function () {
            currentPageSize = Number(this.value) || 15;
            currentProductPage = 1;
            applyProductTableState();
        });

        document.getElementById('prevProductPage').addEventListener('click', goToPreviousProductPage);
        document.getElementById('nextProductPage').addEventListener('click', goToNextProductPage);

        document.getElementById('sortProductNameBtn').addEventListener('click', function () {
            currentNameSort = currentNameSort === 'asc' ? 'desc' : 'asc';
            document.getElementById('nameSortIndicator').textContent = currentNameSort === 'asc' ? '↑' : '↓';
            currentProductPage = 1;
            applyProductTableState();
        });

        if (selectAllProducts) {
            selectAllProducts.addEventListener('change', function () {
                currentRows.forEach(function (row) {
                    if (row.style.display !== 'none') {
                        var checkbox = row.querySelector('.product-checkbox');
                        if (checkbox) {
                            checkbox.checked = selectAllProducts.checked;
                        }
                    }
                });
                updateBulkBar();
            });
        }

        document.addEventListener('change', function (event) {
            if (event.target.classList.contains('product-checkbox')) {
                updateBulkBar();
            }
        });

        document.querySelectorAll('[data-delete-product]').forEach(function (btn) {
            btn.addEventListener('click', function () {
                resetDeleteFormSubmit();
                openDeleteConfirm(btn.dataset.productId, btn.dataset.productName);
            });
        });

        document.getElementById('bulkDeleteBtn').addEventListener('click', openBulkDeleteConfirm);
        document.getElementById('cancelDeleteBtn').addEventListener('click', function () {
            resetDeleteFormSubmit();
            closeDeleteConfirm();
        });
        document.getElementById('deleteConfirmModal').addEventListener('click', function (event) {
            if (event.target === this) {
                resetDeleteFormSubmit();
                closeDeleteConfirm();
            }
        });

        document.querySelectorAll('[data-ui-todo]').forEach(function (btn) {
            btn.addEventListener('click', function () {
                showToast('Chức năng này cần endpoint/schema backend trước khi bật thao tác thật.', 'error');
            });
        });

        document.getElementById('openCreateProductBtn').addEventListener('click', function () {
            resetProductForm('create');
            loadCreateDraft();
            openProductModal('create');
        });
        document.getElementById('closeProductModalBtn').addEventListener('click', closeProductModal);
        document.getElementById('cancelProductModalBtn').addEventListener('click', closeProductModal);
        document.querySelectorAll('.hg-tab-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                setActiveProductTab(btn.dataset.tab);
            });
        });
        document.getElementById('addVariantBtn').addEventListener('click', function () {
            addVariantRow();
            saveDraftIfCreate();
        });

        productForm.addEventListener('input', function () {
            saveDraftIfCreate();
            updateSeoPreview();
        });
        productForm.addEventListener('change', function () {
            saveDraftIfCreate();
            updateSeoPreview();
        });
        productForm.addEventListener('submit', function (event) {
            if (!validateProductForm()) {
                event.preventDefault();
                return;
            }
            if (productForm.dataset.mode === 'edit') {
                event.preventDefault();
                var formData = new FormData(productForm);
                fetch(contextPath + '/admin/products', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Accept': 'application/json'
                    },
                    body: formData
                })
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (!data.success) {
                            throw new Error(data.message || 'Update failed');
                        }
                        showToast('Đã cập nhật sản phẩm.', 'success');
                        window.setTimeout(function () {
                            window.location.href = contextPath + '/admin/products?updated=1';
                        }, 450);
                    })
                    .catch(function (error) {
                        console.error(error);
                        showToast('Cập nhật sản phẩm bị lỗi.', 'error');
                    });
            }
        });

        document.getElementById('clearProductDraftBtn').addEventListener('click', function () {
            localStorage.removeItem(draftKey);
            showToast('Đã xóa bản nháp.', 'success');
        });

        document.getElementById('productImageInput').addEventListener('change', function () {
            renderSelectedImage(this.files && this.files[0]);
        });

        var dropZone = document.getElementById('imageDropZone');
        ['dragenter', 'dragover'].forEach(function (eventName) {
            dropZone.addEventListener(eventName, function (event) {
                event.preventDefault();
                dropZone.classList.add('is-dragging');
            });
        });
        ['dragleave', 'drop'].forEach(function (eventName) {
            dropZone.addEventListener(eventName, function (event) {
                event.preventDefault();
                dropZone.classList.remove('is-dragging');
            });
        });
        dropZone.addEventListener('drop', function (event) {
            var file = event.dataTransfer.files && event.dataTransfer.files[0];
            if (!file) {
                return;
            }
            document.getElementById('productImageInput').files = event.dataTransfer.files;
            renderSelectedImage(file);
        });

        document.getElementById('exportProductsBtn').addEventListener('click', exportVisibleProducts);

        document.addEventListener('keydown', function (event) {
            if (event.key !== 'Escape') {
                return;
            }
            if (!document.getElementById('deleteConfirmModal').hidden) {
                resetDeleteFormSubmit();
                closeDeleteConfirm();
                return;
            }
            if (!productModal.hidden) {
                closeProductModal();
            }
        });

        bindSelectSearch();
        updateAlphaButtons();
        applyProductTableState();
    })();
</script>
</body>
</html>
