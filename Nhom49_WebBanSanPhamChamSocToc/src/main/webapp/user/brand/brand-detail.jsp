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

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400;1,500&display=swap"
          rel="stylesheet">
    <style>
        .brand-detail-main {
            max-width: 1400px;
            margin: 40px auto 60px;
            padding: 0 20px;
        }

        .brand-products-section .product-grid {
            display: flex !important;
            flex-wrap: wrap !important;
            justify-content: center !important;
            gap: 24px !important;
            margin-top: 30px !important;
        }

        .brand-products-section .product-item {
            width: calc((100% - 72px) / 4) !important;
            max-width: calc((100% - 72px) / 4) !important;
            min-width: 0 !important;
            flex-shrink: 0 !important;
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
                gap: 20px !important;
            }

            .brand-products-section .product-item {
                width: calc((100% - 40px) / 3) !important;
                max-width: calc((100% - 40px) / 3) !important;
            }
        }

        @media (max-width: 768px) {
            .brand-products-section .product-grid {
                gap: 16px !important;
            }

            .brand-products-section .product-item {
                width: calc((100% - 16px) / 2) !important;
                max-width: calc((100% - 16px) / 2) !important;
            }
        }

        @media (max-width: 575px) {
            .brand-detail-main {
                padding: 0 12px;
            }

            .brand-products-section .product-grid {
                gap: 12px !important;
            }

            .brand-products-section .product-item {
                width: calc((100% - 12px) / 2) !important;
                max-width: calc((100% - 12px) / 2) !important;
            }
        }
    </style>
</head>

<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<!-- Brand Banner -->
<section class="brand-hero section-animate" <c:choose>
    <c:when test="${not empty brand.logoUrl}">
        style="background-image:
        url('${pageContext.request.contextPath}/static/assets/${brand.logoUrl}');"
    </c:when>
    <c:otherwise>
        style="background-image: none;"
    </c:otherwise>
</c:choose>
>
    <div class="brand-hero-overlay"></div>

    <div class="brand-hero-particles">
        <span></span><span></span><span></span><span></span><span></span>
    </div>

    <div class="brand-hero-content">
        <%-- Breadcrumb --%>
        <nav class="breadcrumb brand-hero-breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span class="separator">›</span>
            <a href="${pageContext.request.contextPath}/brands">Thương hiệu</a>
            <span class="separator">›</span>
            <span class="current">${brand.brandName}</span>
        </nav>
        <div class="brand-hero-logo">
            <c:choose>
                <c:when test="${not empty brand.logoUrl}">
                    <img src="${pageContext.request.contextPath}/static/assets/${brand.logoUrl}"
                         alt="Logo ${brand.brandName}">
                </c:when>
                <c:otherwise>
                    <div class="brand-hero-logo-fallback">
                        <i class="fas fa-gem"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <h1 class="brand-hero-title">${brand.brandName}</h1>

        <c:if test="${not empty brand.shortDescription}">
            <p class="brand-hero-philosophy">"${brand.shortDescription}"</p>
        </c:if>

        <div class="brand-hero-meta">
            <c:if test="${not empty brand.origin}">
                                        <span class="hero-meta-badge">
                                            <i class="fas fa-globe-asia"></i> ${brand.origin}
                                        </span>
            </c:if>
            <span class="hero-meta-badge">
                                        <i class="fas fa-box-open"></i> ${totalProducts} sản phẩm
                                    </span>
        </div>
    </div>
</section>

<main class="brand-detail-main page-animate">
    <c:if test="${not empty brand.fullDescription}">
        <div class="brand-story-section section-animate">
            <div class="brand-story-card">
                <div class="brand-story-accent"></div>
                <div class="brand-story-body">
                    <h2 class="brand-story-heading">
                        <i class="fas fa-feather-pointed"></i>
                        <span>Câu chuyện thương hiệu</span>
                    </h2>
                    <p class="brand-story-text">${brand.fullDescription}</p>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty categoryStats}">
        <div class="brand-stats section-animate">
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

    <section class="brand-products-section store-page" id="brand-products-section">
        <div class="brand-products-header">
            <h2>Bộ sưu tập của ${brand.brandName}</h2>
            <p class="product-count">${totalProducts} sản phẩm</p>

            <nav class="collection-filter" id="collectionFilter" aria-label="Lọc theo bộ sưu tập">
                <div class="collection-filter-track">
                    <button class="collection-filter-btn is-active" data-collection="all">
                        <span class="collection-filter-label">Tất cả</span>
                        <span class="collection-filter-count">${totalProducts}</span>
                    </button>
                    <c:forEach var="entry" items="${categoryStats}">
                        <c:forEach var="category" items="${categories}">
                            <c:if test="${category.categoryName == entry.key}">
                                <button class="collection-filter-btn"
                                        data-collection="${category.categorySlug}">
                                                        <span
                                                                class="collection-filter-label">${category.categoryName}</span>
                                    <span class="collection-filter-count">${entry.value}</span>
                                </button>
                            </c:if>
                        </c:forEach>
                    </c:forEach>
                </div>
            </nav>
        </div>

        <div class="product-grid-wrapper" id="productGridWrapper">
            <c:choose>
                <c:when test="${not empty products}">
                    <div class="product-grid stagger-fade" id="productGrid">
                        <c:forEach var="product" items="${products}">
                            <div class="product-item"
                                 data-category="${product.category != null ? product.category.categorySlug : 'unknown'}">
                                <div class="product-img">
                                    <a
                                            href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                        <img alt="${product.productName}" class="product-image"
                                             src="${pageContext.request.contextPath}/static/${not empty product.primaryImageUrl ? product.primaryImageUrl : 'images/default-product.png'}">
                                    </a>
                                </div>
                                <div class="product-body">
                                    <h3 class="product-title">${product.productName}</h3>
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
                                    <c:if test="${not empty product.hairConditions}">
                                        <div class="product-tags">
                                            <c:forEach var="condition"
                                                       items="${product.hairConditions}"
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
                                           data-product-id="${product.productId}">Thêm vào giỏ</a>
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
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <jsp:include page="/layout/pagination.jsp"/>
        </c:if>
    </section>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    (function () {
        'use strict';

        const filterNav = document.getElementById('collectionFilter');
        const productGrid = document.getElementById('productGrid');
        const productCount = document.querySelector('.product-count');

        if (!filterNav || !productGrid) return;

        const allButtons = filterNav.querySelectorAll('.collection-filter-btn');
        const allItems = productGrid.querySelectorAll('.product-item');

        const SLIDE_OUT_DURATION = 350;
        const PAUSE_BETWEEN = 80;
        const STAGGER_CLEANUP = 550;

        let isAnimating = false;

        allButtons.forEach(function (btn) {
            btn.addEventListener('click', function () {
                if (isAnimating || btn.classList.contains('is-active')) return;
                isAnimating = true;

                const selectedCollection = btn.dataset.collection;

                allButtons.forEach(function (b) {
                    b.classList.remove('is-active');
                });
                btn.classList.add('is-active');

                btn.scrollIntoView({behavior: 'smooth', inline: 'center', block: 'nearest'});

                productGrid.classList.add('is-animating-out');

                setTimeout(function () {
                    productGrid.classList.remove('is-animating-out');

                    let visibleCount = 0;
                    allItems.forEach(function (item) {
                        if (selectedCollection === 'all' ||
                            item.dataset.category === selectedCollection) {
                            item.classList.remove('is-hidden');
                            visibleCount++;
                        } else {
                            item.classList.add('is-hidden');
                        }
                    });

                    if (productCount) {
                        productCount.textContent = visibleCount + ' sản phẩm';
                    }

                    setTimeout(function () {
                        productGrid.classList.add('is-stagger-in');

                        setTimeout(function () {
                            productGrid.classList.remove('is-stagger-in');

                            allItems.forEach(function (item) {
                                if (!item.classList.contains('is-hidden')) {
                                    item.style.opacity = '';
                                    item.style.transform = '';
                                }
                            });

                            isAnimating = false;

                        }, STAGGER_CLEANUP);

                    }, PAUSE_BETWEEN);

                }, SLIDE_OUT_DURATION);
            });
        });
    })();
</script>
</body>
</html>