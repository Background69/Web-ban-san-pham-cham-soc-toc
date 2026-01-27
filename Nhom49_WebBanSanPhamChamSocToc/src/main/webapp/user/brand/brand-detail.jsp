<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${brand.brandName} - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/user/style_for_brand-detail.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        /* ===== BRAND DETAIL - FORCE 4 COLUMN GRID ===== */
        .brand-detail-main {
            max-width: 1400px;
            margin: 40px auto 60px;
            padding: 0 20px;
        }

        .brand-products-section .product-grid {
            display: grid !important;
            grid-template-columns: repeat(4, 1fr) !important;
            gap: 24px !important;
            margin-top: 30px !important;
        }

        .brand-products-section .product-item {
            width: 100% !important;
            max-width: none !important;
            min-width: 0 !important;
        }

        .brand-products-section .product-img {
            aspect-ratio: 1 / 1;
        }

        .brand-products-section .product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        @media (max-width: 1199px) {
            .brand-products-section .product-grid {
                grid-template-columns: repeat(3, 1fr) !important;
                gap: 20px !important;
            }
        }

        @media (max-width: 768px) {
            .brand-products-section .product-grid {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 16px !important;
            }
        }

        @media (max-width: 575px) {
            .brand-detail-main {
                padding: 0 12px;
            }

            .brand-products-section .product-grid {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 12px !important;
            }
        }
    </style>
</head>

<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<!-- Brand Banner -->
<section class="brand-banner section-animate">
    <div class="brand-banner-overlay"></div>
    <div class="brand-banner-content">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span class="separator">›</span>
            <a href="${pageContext.request.contextPath}/brands">Thương hiệu</a>
            <span class="separator">›</span>
            <span class="current">${brand.brandName}</span>
        </nav>
        <div class="brand-banner-info">
            <div class="brand-logo-wrapper">
                <c:choose>
                    <c:when test="${not empty brand.logoUrl}">
                        <img src="${brand.logoUrl}" alt="Logo ${brand.brandName}">
                    </c:when>
                    <c:otherwise>
                        <div class="brand-logo-placeholder"><i class="fas fa-building"></i></div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="brand-text">
                <h1>${brand.brandName}</h1>
                <p class="brand-tagline">${brand.shortDescription}</p>
                <div class="brand-meta">
                    <c:if test="${not empty brand.origin}">
                        <span class="meta-item"><i class="fas fa-globe"></i> ${brand.origin}</span>
                    </c:if>
                    <span class="meta-item"><i class="fas fa-box"></i> ${totalProducts} sản
                                            phẩm</span>
                </div>
            </div>
        </div>
    </div>
</section>

<main class="brand-detail-main page-animate">
    <!-- Brand Info Section -->
    <div class="brand-info-section section-animate">
        <c:if test="${not empty brand.fullDescription}">
            <div class="brand-description-card">
                <h2><i class="fas fa-info-circle"></i> Giới thiệu thương hiệu</h2>
                <p>${brand.fullDescription}</p>
            </div>
        </c:if>

        <!-- Category Stats -->
        <c:if test="${not empty categoryStats}">
            <div class="brand-stats">
                <h3><i class="fas fa-chart-pie"></i> Danh mục sản phẩm</h3>
                <div class="stats-grid stagger-fade">
                    <c:forEach var="stat" items="${categoryStats}">
                        <div class="stat-item">
                            <span class="stat-number">${stat.value}</span>
                            <span class="stat-label">${stat.key}</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Products Section -->
    <section class="brand-products-section store-page">
        <div class="brand-products-header">
            <h2>Sản phẩm của ${brand.brandName}</h2>
            <p class="product-count">${totalProducts} sản phẩm</p>
            <div class="product-filter-tags">
                <button class="product-filter-tag active" data-category="all">Tất cả</button>
                <c:forEach var="category" items="${categories}">
                    <button class="product-filter-tag"
                            data-category="${category.categorySlug}">${category.categoryName}</button>
                </c:forEach>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty products}">
                <div class="product-grid stagger-fade">
                    <c:forEach var="product" items="${products}">
                        <div class="product-item"
                             data-category="${product.category != null ? product.category.categorySlug : 'unknown'}">
                            <div class="product-img">
                                <a
                                        href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                    <img alt="${product.productName}" class="product-image"
                                         src="${pageContext.request.contextPath}/static/images/${not empty product.primaryImageUrl ? product.primaryImageUrl : 'default-product.png'}">
                                </a>
                            </div>
                            <div class="product-body">
                                <h3 class="product-title">${product.productName}</h3>
                                <div class="product-small-details">
                                    <p>
                                                            <span>${product.brand != null ? product.brand.brandName :
                                                                    ''}</span>
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
                                                                        <c:when test="${i <= product.averageRating}">★
                                                                        </c:when>
                                                                        <c:otherwise>☆</c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </span>
                                    </div>
                                    <p class="review-count">(${product.reviewCount})</p>
                                </div>
                                <c:if test="${not empty product.hairConditions}">
                                    <div class="product-tags">
                                        <c:forEach var="condition" items="${product.hairConditions}"
                                                   varStatus="status">
                                            <c:if test="${status.index < 2}">
                                                                    <span
                                                                            class="tag-chip">${condition.conditionName}</span>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${fn:length(product.hairConditions) > 2}">
                                                                <span
                                                                        class="tag-chip more">+${fn:length(product.hairConditions)
                                                                        - 2}</span>
                                        </c:if>
                                    </div>
                                </c:if>
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
                                            Đã bán ${product.soldQuantity}/${product.stockQuantity}
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
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>Chưa có sản phẩm nào</h3>
                    <p>Thương hiệu này chưa có sản phẩm. Vui lòng quay lại sau.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <jsp:include page="/layout/pagination.jsp"/>
        </c:if>
    </section>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    // ===== ADD TO CART - Đã được xử lý trong header.jsp =====

    // Filter products by category
    document.querySelectorAll('.product-filter-tag').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.product-filter-tag').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const category = this.dataset.category;
            document.querySelectorAll('.product-item').forEach(card => {
                if (category === 'all' || card.dataset.category === category) {
                    card.classList.remove('hidden');
                } else {
                    card.classList.add('hidden');
                }
            });
        });
    });
</script>
</body>

</html>