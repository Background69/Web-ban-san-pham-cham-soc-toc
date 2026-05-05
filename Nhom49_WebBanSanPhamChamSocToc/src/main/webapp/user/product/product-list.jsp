<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Sản phẩm'} - HairGlow</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <!-- Font Awesome 6 -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/store.css">

    <style>
        @keyframes paginationFadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes activePulse {

            0%,
            100% {
                box-shadow: 0 8px 20px rgba(44, 89, 64, 0.3);
            }

            50% {
                box-shadow: 0 8px 24px rgba(44, 89, 64, 0.4);
            }
        }

        .pagination {
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin: 60px auto 40px;
            padding: 0;
            max-width: 100%;
            list-style: none;
            animation: paginationFadeIn 0.5s ease-out;
        }

        .pagination .page-numbers {
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px;
        }

        /* === 2. BASE STYLES === */
        .page-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            min-width: 48px;
            height: 48px;
            padding: 0 16px;
            font-size: 15px;
            font-weight: 600;
            line-height: 1;
            text-decoration: none;
            white-space: nowrap;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            background: #ffffff;
            color: #333333;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
        }

        /* === 3. HOVER === */
        .page-link:hover:not(.active):not(.disabled) {
            background: linear-gradient(135deg, #f0f7ea, #e8f1e1);
            border-color: #89af63;
            color: #2c5940;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(137, 175, 99, 0.2);
        }

        /* === 4. ACTIVE STATE === */
        .page-link.active {
            background: linear-gradient(135deg, #2c5940, #3d7a5a);
            border-color: #2c5940;
            color: #ffffff;
            font-weight: 700;
            box-shadow: 0 8px 20px rgba(44, 89, 64, 0.3);
            transform: scale(1.08);
            cursor: default;
            pointer-events: none;
            animation: activePulse 2s ease-in-out infinite;
        }

        /* === 5. DISABLED STATE === */
        .page-link.disabled {
            background: #f5f5f5;
            border-color: #e8e8e8;
            color: #cccccc;
            cursor: not-allowed;
            pointer-events: none;
            opacity: 0.6;
            transform: none;
            box-shadow: none;
        }

        /* === 6. PREV/NEXT === */
        .page-link.page-prev,
        .page-link.page-next,
        .page-link.prev,
        .page-link.next {
            min-width: auto;
            padding: 0 18px;
            gap: 8px;
            font-weight: 600;
        }

        /* === 7. ELLIPSIS === */
        .pagination-ellipsis {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 48px;
            height: 48px;
            color: #999999;
            font-size: 16px;
            font-weight: bold;
            cursor: default;
            user-select: none;
            pointer-events: none;
        }

        /* === 8. ICON ANIMATION === */
        .page-link i {
            font-size: 14px;
            transition: transform 0.3s ease;
        }

        .page-link.page-prev:hover i,
        .page-link.prev:hover i {
            transform: translateX(-3px);
        }

        .page-link.page-next:hover i,
        .page-link.next:hover i {
            transform: translateX(3px);
        }

        /* === 9. FOCUS STATE === */
        .page-link:focus {
            outline: 3px solid rgba(137, 175, 99, 0.4);
            outline-offset: 2px;
        }

        .page-link:focus:not(:focus-visible) {
            outline: none;
        }

        /* === 10. RESPONSIVE === */
        @media (max-width: 768px) {
            .pagination {
                gap: 6px;
                margin: 40px auto 30px;
            }

            .pagination .page-numbers {
                gap: 6px;
            }

            .page-link {
                min-width: 44px;
                height: 44px;
                font-size: 14px;
                border-radius: 10px;
            }

            .page-link.page-prev,
            .page-link.page-next,
            .page-link.prev,
            .page-link.next {
                min-width: 44px;
                padding: 0;
                font-size: 0;
                gap: 0;
            }

            .page-link.page-prev i,
            .page-link.page-next i,
            .page-link.prev i,
            .page-link.next i {
                font-size: 14px;
            }

            .pagination-ellipsis {
                min-width: 36px;
                height: 44px;
            }
        }

        @media (max-width: 480px) {
            .pagination {
                gap: 4px;
            }

            .page-link {
                min-width: 40px;
                height: 40px;
                font-size: 13px;
            }

            .page-link.page-prev,
            .page-link.page-next,
            .page-link.prev,
            .page-link.next {
                min-width: 40px;
            }

            .pagination-ellipsis {
                min-width: 40px;
                height: 40px;
            }
        }
    </style>
</head>

<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="store-container store-page page-animate">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <span>/</span>
        <c:choose>
            <c:when test="${not empty currentCategory}">
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <span>/</span>
                <span>${currentCategory.categoryName}</span>
            </c:when>
            <c:when test="${not empty currentBrand}">
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <span>/</span>
                <span>${currentBrand.brandName}</span>
            </c:when>
            <c:otherwise>
                <span>Sản phẩm</span>
            </c:otherwise>
        </c:choose>
    </nav>

    <c:set var="searchTerm" value="${not empty param.search ? param.search : param.q}"/>
    <c:url var="clearFiltersUrl" value="/products">
        <c:if test="${not empty searchTerm}">
            <c:param name="search" value="${searchTerm}"/>
        </c:if>
    </c:url>

    <div class="store-layout">
        <!-- Sidebar Filters -->
        <jsp:include page="/user/product/filter-sidebar.jsp"/>

        <!-- Product Grid -->
        <div class="store-main">
            <!-- Header with sort -->
            <div class="store-header">
                <div class="result-count">
                    <c:choose>
                        <c:when test="${not empty searchTerm}">
                            <h2>Kết quả tìm kiếm: "${searchTerm}"</h2>
                            <p>Tìm thấy ${totalProducts} sản phẩm</p>
                        </c:when>
                        <c:when test="${not empty currentCategory}">
                            <h2>${currentCategory.categoryName}</h2>
                            <p>${totalProducts} sản phẩm</p>
                        </c:when>
                        <c:when test="${not empty currentBrand}">
                            <h2>${currentBrand.brandName}</h2>
                            <p>${totalProducts} sản phẩm</p>
                        </c:when>
                        <c:otherwise>
                            <h2>Tất cả sản phẩm</h2>
                            <p>${totalProducts} sản phẩm</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sort-options">
                    <label>Sắp xếp:</label>
                    <c:set var="sortBaseUrl" value="${pageContext.request.contextPath}/products"/>
                    <c:choose>
                        <c:when test="${empty queryString}">
                            <c:set var="sortBaseUrl" value="${sortBaseUrl}?sort="/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="sortBaseUrl" value="${sortBaseUrl}?${queryString}&sort="/>
                        </c:otherwise>
                    </c:choose>
                    <select name="sort" onchange="window.location.href=this.value">
                        <option value="${sortBaseUrl}newest" ${param.sort=='newest' || empty
                                param.sort ? 'selected' : '' }>Mới nhất
                        </option>
                        <option value="${sortBaseUrl}bestseller" ${param.sort=='bestseller'
                                ? 'selected' : '' }>Bán chạy
                        </option>
                        <option value="${sortBaseUrl}price-asc" ${param.sort=='price-asc'
                                ? 'selected' : '' }>Giá thấp đến cao
                        </option>
                        <option value="${sortBaseUrl}price-desc" ${param.sort=='price-desc'
                                ? 'selected' : '' }>Giá cao đến thấp
                        </option>
                        <option value="${sortBaseUrl}rating" ${param.sort=='rating' ? 'selected'
                                : '' }>Đánh giá cao
                        </option>
                        <option value="${sortBaseUrl}most-reviewed" ${param.sort=='most-reviewed'
                                ? 'selected' : '' }>Nhiều đánh giá
                        </option>
                        <option value="${sortBaseUrl}discount-desc" ${param.sort=='discount-desc'
                                ? 'selected' : '' }>Giảm giá nhiều
                        </option>
                        <option value="${sortBaseUrl}stock-desc" ${param.sort=='stock-desc'
                                ? 'selected' : '' }>Còn hàng nhiều
                        </option>
                        <option value="${sortBaseUrl}featured" ${param.sort=='featured' ? 'selected'
                                : '' }>Nổi bật
                        </option>
                        <option value="${sortBaseUrl}name-asc" ${param.sort=='name-asc' ? 'selected'
                                : '' }>Tên A - Z
                        </option>
                        <option value="${sortBaseUrl}name-desc" ${param.sort=='name-desc'
                                ? 'selected' : '' }>Tên Z - A
                        </option>
                    </select>
                </div>
            </div>

            <!-- Products -->
            <c:choose>
                <c:when test="${not empty products}">
                    <div class="product-grid stagger-fade">
                        <c:forEach var="product" items="${products}">
                            <div class="product-item">
                                <div class="product-img">
                                    <a
                                            href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                        <img alt="${product.productName}" class="product-image"
                                             src="${pageContext.request.contextPath}/static/${not empty product.primaryImageUrl ? product.primaryImageUrl : (product.primaryImage != null and not empty product.primaryImage.imageUrl ? product.primaryImage.imageUrl : 'images/default-product.png')}"
                                             loading="lazy"
                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/images/default-product.png'">
                                    </a>
                                </div>
                                <div class="product-body">
                                    <h3 class="product-title">
                                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}">${product.productName}</a>
                                    </h3>
                                    <div class="product-small-details">
                                        <p>
                                                                <span>${product.brand != null ? product.brand.brandName
                                                                        : ''}</span>
                                            • <span>${product.category != null ?
                                                product.category.categoryName : ''}</span>
                                            • ${product.origin}
                                        </p>
                                    </div>
                                    <div class="product-rating">
                                        <div class="rating-stars">
                                                                <span class="stars">
                                                                    <c:forEach begin="1" end="5" var="i">
                                                                        <c:choose>
                                                                            <c:when
                                                                                    test="${i <= product.averageRating}">★
                                                                            </c:when>
                                                                            <c:otherwise>☆</c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </span>
                                        </div>
                                        <p class="review-count">(${product.reviewCount})</p>
                                    </div>
                                    <div class="product-price">
                                        <c:if test="${product.defaultVariant != null}">
                                            <p class="price-current">
                                                <fmt:formatNumber
                                                        value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                                        type="number"/>₫
                                            </p>
                                            <c:if
                                                    test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                                <p class="price-old">
                                                    <fmt:formatNumber
                                                            value="${product.defaultVariant.originalPrice}"
                                                            type="number"/>₫
                                                </p>
                                                <p class="badge-discount">
                                                    -${product.defaultVariant.discountPercent}%</p>
                                            </c:if>
                                        </c:if>
                                    </div>
                                    <c:if test="${product.onSale && product.stockQuantity > 0}">
                                        <div class="stock-progress">
                                            <div class="stock-progress-bar">
                                                <div class="stock-progress-fill"
                                                     style="width: ${product.soldPercent}%"></div>
                                            </div>
                                            <div class="stock-progress-text">
                                                Đã bán
                                                    ${product.soldQuantity}/${product.stockQuantity}
                                            </div>
                                        </div>
                                    </c:if>
                                    <div class="product product-actions">
                                        <a class="btn"
                                           href="${pageContext.request.contextPath}/product/${product.productSlug}">Xem
                                            thêm</a>
                                        <a class="btn primary add-to-cart" href="#"
                                           data-product-id="${product.productId}">Thêm vào
                                            giỏ</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <jsp:include page="/layout/pagination.jsp"/>
                </c:when>
                <c:otherwise>
                    <div class="no-products">
                        <i class="fas fa-search"></i>
                        <h3>Không tìm thấy sản phẩm</h3>
                        <p>Vui lòng thử lại với từ khóa khác hoặc xóa bộ lọc</p>
                        <a href="${pageContext.request.contextPath}/products"
                           class="btn btn-primary">Xem tất cả sản
                            phẩm</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

</body>

</html>
