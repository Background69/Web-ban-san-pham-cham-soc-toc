<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flash Sale - HairGlow</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/user/style_for_flash-sale.css">
</head>

<body>
<jsp:include page="/layout/header.jsp"/>

<c:set var="saleProductCount" value="${not empty saleProducts ? saleProducts.size() : 0}"/>
<c:set var="displayTotalPages" value="${totalPages != null && totalPages > 0 ? totalPages : 1}"/>

<main class="flash-sale-page">
    <section class="flash-sale-hero flash-sale-section">
        <div class="flash-hero-luxury-shell">
            <div class="flash-hero-copy">
                <p class="flash-hero-kicker">
                    <span class="kicker-line"></span>
                    <span class="kicker-text">⚡ HAIRGLOW LUXURY FLASH SALE ⚡</span>
                    <span class="kicker-line"></span>
                </p>
                <h1 class="flash-hero-title">Giờ vàng giá sốc</h1>
                <p class="flash-hero-subtext">
                    Deal chọn lọc cho dầu gội, dầu xả, serum & phục hồi tóc —
                    <strong>chỉ trong hôm nay.</strong>
                </p>
            </div>

            <div class="flash-hero-timer" aria-label="Đồng hồ đếm ngược Flash Sale">
                <div class="countdown-panel flash-sale-countdown">
                    <p class="panel-label">
                        <span class="panel-line"></span>
                        <span>DEAL KẾT THÚC SAU</span>
                        <span class="panel-line"></span>
                    </p>
                    <div class="countdown-clock" aria-live="polite">
                        <div class="time-box">
                            <span id="hours">00</span>
                            <small>GIỜ</small>
                        </div>
                        <div class="time-separator">:</div>
                        <div class="time-box">
                            <span id="minutes">00</span>
                            <small>PHÚT</small>
                        </div>
                        <div class="time-separator">:</div>
                        <div class="time-box time-box--seconds">
                            <span id="seconds">00</span>
                            <small>GIÂY</small>
                        </div>
                    </div>
                    <p class="countdown-urgency">Thời gian có hạn — Đừng bỏ lỡ! <span class="urgency-spark">✦</span></p>
                </div>
            </div>

            <div class="flash-hero-actions">
                <a class="hero-btn hero-btn-primary" href="#flash-sale-deals">
                    <span class="hero-btn-icon">⚡</span>
                    <span>Săn deal ngay</span>
                </a>
                <a class="hero-btn hero-btn-ghost"
                   href="${pageContext.request.contextPath}/products">
                    <span>Khám phá sản phẩm</span>
                    <span class="hero-btn-arrow">›</span>
                </a>
            </div>

            <div class="flash-stats-strip" aria-label="Tổng quan Flash Sale">
                <div class="flash-stat">
                    <span class="stat-icon" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M6 2 3 7v13a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V7l-3-5H6z"/>
                            <path d="M3 7h18"/>
                            <path d="M16 11a4 4 0 0 1-8 0"/>
                        </svg>
                    </span>
                    <div class="stat-content">
                        <strong>${saleProductCount}</strong>
                        <span class="stat-label">SẢN PHẨM ĐANG SALE</span>
                    </div>
                </div>
                <div class="flash-stat">
                    <span class="stat-icon" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <path d="M14 2v6h6"/>
                            <path d="M8 13h8"/>
                            <path d="M8 17h8"/>
                            <path d="M8 9h3"/>
                        </svg>
                    </span>
                    <div class="stat-content">
                        <strong>${currentPage != null ? currentPage : 1}/${displayTotalPages}</strong>
                        <span class="stat-label">TRANG HIỆN TẠI</span>
                    </div>
                </div>
                <div class="flash-stat">
                    <span class="stat-icon" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M8.5 14.5C8.5 17.54 10.96 20 14 20s5.5-2.46 5.5-5.5c0-4.5-4.2-7.3-5.2-12.1-3.1 1.9-6.8 5.8-5.8 12.1Z"/>
                            <path d="M7 20c-2.2 0-4-1.8-4-4 0-2.6 2-4.3 2.8-6.8 1.8 1.2 3.7 3.4 3.2 6.8"/>
                        </svg>
                    </span>
                    <div class="stat-content">
                        <strong>Khô xơ, da dầu, tóc nhuộm</strong>
                        <span class="stat-label">NHÓM CHĂM TÓC TRỌNG ĐIỂM</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="super-deal-container flash-sale-wrapper">
        <section id="flash-sale-deals" class="super-deal-section flash-sale-deals">
            <div class="section-heading">
                <h2>Deal chăm tóc được chọn lọc</h2>
                <p>Giá tốt mỗi ngày với bố cục rõ ràng, dễ so sánh và dễ chọn.</p>
            </div>

            <div class="flash-filter-panel" id="flashAdvancedFilters">
                <div class="flash-filter-header">
                    <div class="flash-filter-header-main">
                        <span class="flash-filter-badge">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                                <path d="M13 2L4 14h6l-1 8 9-12h-6l1-8z"/>
                            </svg>
                            FLASH SALE
                        </span>
                        <span class="flash-filter-header-divider" aria-hidden="true"></span>
                        <h3>Bộ lọc sản phẩm</h3>
                    </div>
                    <p class="flash-filter-header-note">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                            <line x1="7" y1="7" x2="7.01" y2="7"/>
                        </svg>
                        Lọc thông minh - Tìm nhanh sản phẩm bạn yêu thích
                    </p>
                </div>

                <div class="flash-filter-card">
                    <div class="flash-filter-grid flash-filter-grid-top">
                        <div class="flash-filter-cell price-filter-cell">
                            <h4 class="filter-cell-title">
                                <span class="filter-title-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <rect x="2" y="6" width="20" height="14" rx="2"/>
                                        <path d="M2 10h20"/>
                                        <circle cx="17" cy="15" r="1"/>
                                    </svg>
                                </span>
                                Khoảng giá
                            </h4>

                            <div class="price-slider-wrapper">
                                <div class="price-inputs">
                                    <div class="price-input-group">
                                        <label for="priceMin">TỪ</label>
                                        <input type="number" id="priceMin" class="price-input" placeholder="0₫" min="0" step="10000">
                                    </div>
                                    <span class="price-separator-dash" aria-hidden="true">–</span>
                                    <div class="price-input-group">
                                        <label for="priceMax">ĐẾN</label>
                                        <input type="number" id="priceMax" class="price-input" placeholder="700.000₫" min="0" step="10000">
                                    </div>
                                </div>

                                <div class="range-slider-container">
                                    <div class="range-track">
                                        <div class="range-fill" id="rangeFill"></div>
                                    </div>
                                    <input type="range" id="rangeMin" class="range-input range-input--min" min="0" max="5000000" value="0" step="10000">
                                    <input type="range" id="rangeMax" class="range-input range-input--max" min="0" max="5000000" value="5000000" step="10000">
                                </div>

                                <div class="price-range-labels">
                                    <span id="labelMin">0₫</span>
                                    <span id="labelMax">5.000.000₫</span>
                                </div>
                            </div>
                        </div>

                        <div class="flash-filter-cell brand-filter-cell">
                            <h4 class="filter-cell-title">
                                <span class="filter-title-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <path d="m12 2 3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77 5.82 21l1.18-6.86-5-4.87 6.91-1.01L12 2z"/>
                                    </svg>
                                </span>
                                Thương hiệu
                            </h4>

                            <div class="filter-chip-list brand-chips-container" id="brandChips" data-mode="multi">
                                <button type="button" class="filter-chip brand-chip active" data-brand="all">Tất cả</button>
                                <%-- Collect unique brands from saleProducts --%>
                                <c:set var="seenBrands" value="," />
                                <c:forEach var="product" items="${saleProducts}">
                                    <c:if test="${product.brandId != null && !seenBrands.contains(','.concat(product.brandId).concat(','))}">
                                        <c:set var="seenBrands" value="${seenBrands}${product.brandId}," />
                                        <button type="button" class="filter-chip brand-chip" data-brand="${product.brandId}">
                                                ${product.brandName}
                                        </button>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="flash-filter-cell type-filter-cell">
                            <h4 class="filter-cell-title">
                                <span class="filter-title-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <path d="M10 2h4"/>
                                        <path d="M12 2v5"/>
                                        <rect x="8" y="7" width="8" height="15" rx="2"/>
                                    </svg>
                                </span>
                                Loại sản phẩm
                            </h4>

                            <div class="filter-chip-list" id="productTypeChips" data-mode="multi">
                                <button type="button" class="filter-chip" data-product-type="dau-goi">Dầu gội</button>
                                <button type="button" class="filter-chip" data-product-type="dau-xa">Dầu xả</button>
                                <button type="button" class="filter-chip" data-product-type="serum-toc">Serum tóc</button>
                                <button type="button" class="filter-chip" data-product-type="kem-u">Kem ủ</button>
                                <button type="button" class="filter-chip" data-product-type="xit-duong">Xịt dưỡng</button>
                                <button type="button" class="filter-chip" data-product-type="tay-da-dau">Tẩy da đầu</button>
                            </div>
                        </div>
                    </div>

                    <div class="flash-filter-row-divider" aria-hidden="true"></div>

                    <div class="flash-filter-grid flash-filter-grid-bottom">
                        <div class="flash-filter-cell need-filter-cell">
                            <h4 class="filter-cell-title">
                                <span class="filter-title-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <path d="M11 20A7 7 0 0 1 4 13C4 8.5 7.5 5 12 5c4 0 7 3 7 7a8 8 0 0 1-8 8Z"/>
                                        <path d="M12 5V3"/>
                                        <path d="M8.5 11.5c1.5 0 2.5-.5 3.5-1.5 1.1-1.1 2.1-2.5 4-2.5"/>
                                    </svg>
                                </span>
                                Nhu cầu tóc
                            </h4>

                            <div class="filter-chip-list" id="hairNeedChips" data-mode="multi">
                                <button type="button" class="filter-chip" data-hair-need="phuc-hoi">Phục hồi</button>
                                <button type="button" class="filter-chip" data-hair-need="giam-gay-rung">Giảm gãy rụng</button>
                                <button type="button" class="filter-chip" data-hair-need="duong-am">Dưỡng ẩm</button>
                                <button type="button" class="filter-chip" data-hair-need="toc-nhuom">Cho tóc nhuộm</button>
                                <button type="button" class="filter-chip" data-hair-need="kiem-soat-dau">Kiểm soát dầu</button>
                                <button type="button" class="filter-chip" data-hair-need="chong-gau">Chống gàu</button>
                            </div>
                        </div>

                        <div class="flash-filter-cell offer-filter-cell">
                            <h4 class="filter-cell-title">
                                <span class="filter-title-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <path d="M20.59 13.41 13.41 20.6a2 2 0 0 1-2.82 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82Z"/>
                                        <circle cx="7.5" cy="7.5" r=".5"/>
                                    </svg>
                                </span>
                                Ưu đãi
                            </h4>

                            <div class="filter-chip-list" id="offerChips" data-mode="single">
                                <button type="button" class="filter-chip" data-discount="under-30">Dưới 30%</button>
                                <button type="button" class="filter-chip" data-discount="30-50">30% - 50%</button>
                                <button type="button" class="filter-chip" data-discount="over-50">Trên 50%</button>
                            </div>
                        </div>

                        <div class="flash-filter-cell filter-actions-cell">
                            <div class="filter-actions">
                                <button type="button" class="filter-reset-btn" id="resetFilters">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <polyline points="1 4 1 10 7 10"/>
                                        <path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"/>
                                    </svg>
                                    Xóa bộ lọc
                                </button>
                                <button type="button" class="filter-apply-btn" id="applyFilters">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                        <line x1="4" y1="6" x2="20" y2="6"/>
                                        <line x1="7" y1="12" x2="17" y2="12"/>
                                        <line x1="10" y1="18" x2="14" y2="18"/>
                                    </svg>
                                    Áp dụng
                                </button>
                            </div>
                            <span class="filter-result-count" id="filterResultCount"></span>
                        </div>
                    </div>
                </div>

                <div class="flash-filter-trust">
                    <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M12 2 4 5v6c0 5 3.4 9.7 8 11 4.6-1.3 8-6 8-11V5l-8-3Z"/>
                        <path d="m9 12 2 2 4-4"/>
                    </svg>
                    <span>Sản phẩm chính hãng 100%</span>
                    <span class="trust-sep">•</span>
                    <span>Giao nhanh toàn quốc</span>
                    <span class="trust-sep">•</span>
                    <span>Đổi trả dễ dàng</span>
                </div>
            </div>

            <c:if test="${not empty saleProducts}">
                <div class="deals-grid flash-sale-grid">
                    <c:forEach var="product" items="${saleProducts}">
                        <article class="product-item flash-sale-item"
                                 data-category="${product.defaultVariant != null && product.defaultVariant.discountPercent >= 30 ? 'flash-sale' : 'sale'}"
                                 data-discount="${product.defaultVariant != null ? product.defaultVariant.discountPercent : 0}"
                                 data-price="${product.defaultVariant != null ? (product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice) : 0}"
                                 data-brand-id="${product.brandId != null ? product.brandId : 0}"
                                 data-brand-name="${product.brandName != null ? product.brandName : ''}">
                            <div class="product-img">
                                <c:if test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                                    <div class="flash-sale-badge">
                                        <span class="badge-percent">-${product.defaultVariant.discountPercent}%</span>
                                        <span class="badge-label">GIẢM</span>
                                    </div>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                    <c:choose>
                                        <c:when test="${not empty product.primaryImageUrl}">
                                            <img alt="${product.productName}" class="product-image"
                                                 src="${product.primaryImageUrl}">
                                        </c:when>
                                        <c:otherwise>
                                            <img alt="${product.productName}" class="product-image"
                                                 src="${pageContext.request.contextPath}/static/images/default-product.png">
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>

                            <div class="product-body">
                                <h3 class="product-title">
                                    <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                            ${product.productName}
                                    </a>
                                </h3>

                                <div class="product-footer">
                                    <div class="product-price">
                                        <c:if test="${product.defaultVariant != null}">
                                            <p class="price-current">
                                                <fmt:formatNumber
                                                        value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                                        type="number"/>&#8363;
                                            </p>
                                            <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                                <p class="price-old">
                                                    <fmt:formatNumber value="${product.defaultVariant.originalPrice}"
                                                                      type="number"/>&#8363;
                                                </p>
                                                <p class="badge-discount">
                                                    -${product.defaultVariant.discountPercent}%</p>
                                            </c:if>
                                        </c:if>
                                    </div>

                                    <c:if test="${product.defaultVariant != null && product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                        <c:set var="savedAmount" value="${product.defaultVariant.originalPrice - product.defaultVariant.salePrice}"/>
                                        <div class="price-savings">
                                            <span class="savings-icon">🔥</span>
                                            <span class="savings-text">Tiết kiệm ngay <strong><fmt:formatNumber value="${savedAmount}" type="number"/>₫</strong></span>
                                        </div>
                                    </c:if>

                                    <c:if test="${product.stockQuantity > 0}">
                                        <c:set var="percent" value="${product.soldPercent}"/>
                                        <c:set var="remaining" value="${product.stockQuantity - (product.soldQuantity != null ? product.soldQuantity : 0)}"/>
                                        <div class="stock-progress">
                                            <div class="stock-fomo-label">
                                                <c:choose>
                                                    <c:when test="${percent >= 90}">
                                                        <span class="fomo-text fomo-critical">🔥 Chỉ còn ${remaining > 0 ? remaining : 1} sản phẩm cuối cùng!</span>
                                                    </c:when>
                                                    <c:when test="${percent >= 80}">
                                                        <span class="fomo-text fomo-danger">🔥 Sắp cháy hàng!</span>
                                                        <span class="fomo-sold">${percent}% đã bán</span>
                                                    </c:when>
                                                    <c:when test="${percent >= 50}">
                                                        <span class="fomo-text fomo-hot">Đang bán rất chạy!</span>
                                                        <span class="fomo-sold">${percent}% đã được mua</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="fomo-text">Đã bán ${product.soldQuantity != null ? product.soldQuantity : 0}</span>
                                                        <span class="fomo-sold">còn ${remaining} sp</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="stock-progress-bar ${percent > 80 ? 'is-danger' : ''}">
                                                <div class="stock-progress-fill"
                                                     style="width: ${percent}%"></div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <form class="action-buttons"
                                          action="${pageContext.request.contextPath}/cart/add"
                                          method="post">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" name="action" value="buy_now"
                                                class="btn btn-buy-now">
                                            Mua ngay
                                        </button>
                                        <button type="submit" name="action" value="add_to_cart"
                                                class="btn btn-icon-cart" aria-label="Thêm vào giỏ">
                                            <i class="fas fa-cart-plus"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>

                <%-- Empty state shown when filters match nothing --%>
                <div class="filter-empty-state" id="filterEmptyState" style="display:none;">
                    <div class="filter-empty-icon">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/><line x1="8" y1="11" x2="14" y2="11"/>
                        </svg>
                    </div>
                    <h3>Không tìm thấy sản phẩm phù hợp</h3>
                    <p>Thử điều chỉnh khoảng giá hoặc chọn thương hiệu khác.</p>
                </div>
            </c:if>

            <c:if test="${totalPages > 1}">
                <c:set var="startPage" value="${currentPage - 2}"/>
                <c:set var="endPage" value="${currentPage + 2}"/>
                <c:if test="${startPage < 1}">
                    <c:set var="endPage" value="${endPage + (1 - startPage)}"/>
                    <c:set var="startPage" value="1"/>
                </c:if>
                <c:if test="${endPage > totalPages}">
                    <c:set var="startPage" value="${startPage - (endPage - totalPages)}"/>
                    <c:set var="endPage" value="${totalPages}"/>
                </c:if>
                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1"/>
                </c:if>
                <c:set var="prevPage" value="${currentPage > 1 ? currentPage - 1 : 1}"/>
                <c:set var="nextPage" value="${currentPage < totalPages ? currentPage + 1 : totalPages}"/>

                <nav class="flash-sale-pagination" aria-label="Flash sale pagination">
                    <ul class="flash-pagination-list">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/flash-sale?page=${prevPage}">Trước</a>
                        </li>

                        <c:if test="${startPage > 1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/flash-sale?page=1">1</a>
                            </li>
                            <c:if test="${startPage > 2}">
                                <li class="page-item ellipsis"><span class="page-ellipsis">...</span></li>
                            </c:if>
                        </c:if>

                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/flash-sale?page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <li class="page-item ellipsis"><span class="page-ellipsis">...</span></li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/flash-sale?page=${totalPages}">${totalPages}</a>
                            </li>
                        </c:if>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/flash-sale?page=${nextPage}">Tiếp</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <c:if test="${empty saleProducts}">
                <div class="empty-state">
                    <h3>Chưa có khuyến mãi phù hợp</h3>
                    <p>Vui lòng quay lại sau để xem các deal chăm tóc mới nhất.</p>
                    <a href="${pageContext.request.contextPath}/products" class="empty-state-link">
                        Xem tất cả sản phẩm
                    </a>
                </div>
            </c:if>
        </section>

        <c:if test="${not empty comboDeals}">
            <section class="combo-section flash-sale-combo">
                <div class="section-heading">
                    <h2>Combo chăm tóc tiết kiệm</h2>
                    <p>Kết hợp sẵn các bước gội, xả, dưỡng để tối ưu ngân sách.</p>
                </div>
                <div class="combo-grid flash-sale-combo-grid">
                    <c:forEach var="combo" items="${comboDeals}">
                        <article class="combo-item">
                            <div class="combo-badge">
                                Tiết kiệm <fmt:formatNumber value="${combo.saveAmount}" type="number"/>₫
                            </div>
                            <div class="combo-images">
                                <c:forEach var="item" items="${combo.products}">
                                    <img src="${item.primaryImage}" alt="${item.name}" loading="lazy"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/images/default-product.png';">
                                </c:forEach>
                            </div>
                            <div class="combo-content">
                                <h3>${combo.name}</h3>
                                <p>${combo.description}</p>
                                <div class="combo-price">
                                    <span class="combo-current-price">
                                        <fmt:formatNumber value="${combo.comboPrice}" type="number"/>₫
                                    </span>
                                    <span class="combo-original-price">
                                        <fmt:formatNumber value="${combo.originalPrice}" type="number"/>₫
                                    </span>
                                </div>
                                <button type="button" class="combo-btn">Mua combo</button>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <section class="flash-trust-strip flash-sale-trust" aria-label="Cam kết hỗ trợ">
            <article class="trust-item">
                <h3>Đổi trả minh bạch</h3>
                <p>Thông tin đổi trả rõ ràng, theo dõi trạng thái xử lý dễ dàng.</p>
            </article>
            <article class="trust-item">
                <h3>Tư vấn chọn sản phẩm</h3>
                <p>Đội ngũ hỗ trợ giúp chọn routine phù hợp với tóc và da đầu.</p>
            </article>
            <article class="trust-item">
                <h3>Theo dõi đơn hàng</h3>
                <p>Cập nhật tiến trình giao hàng liên tục ngay trong tài khoản.</p>
            </article>
        </section>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script>
    (function startCountdown() {
        const hoursEl = document.getElementById('hours');
        const minutesEl = document.getElementById('minutes');
        const secondsEl = document.getElementById('seconds');
        const secondsBox = secondsEl ? secondsEl.closest('.time-box--seconds') : null;
        if (!hoursEl || !minutesEl || !secondsEl) {
            return;
        }

        function updateCountdown() {
            const now = new Date();
            const endOfDay = new Date();
            endOfDay.setHours(23, 59, 59, 999);
            const diff = endOfDay - now;

            if (diff <= 0) {
                hoursEl.textContent = '00';
                minutesEl.textContent = '00';
                secondsEl.textContent = '00';
                return;
            }

            const hours = Math.floor(diff / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

            hoursEl.textContent = hours.toString().padStart(2, '0');
            minutesEl.textContent = minutes.toString().padStart(2, '0');
            secondsEl.textContent = seconds.toString().padStart(2, '0');
            if (secondsBox) {
                secondsBox.classList.remove('tick');
                void secondsBox.offsetWidth;
                secondsBox.classList.add('tick');
            }
        }

        updateCountdown();
        setInterval(updateCountdown, 1000);
    })();

    function normalizeText(raw) {
        if (!raw) return '';
        return raw
            .toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .replace(/\u0111/g, 'd')
            .replace(/\u0110/g, 'd')
            .trim();
    }

    function inferProductType(name) {
        if (name.indexOf('dau goi') !== -1 || name.indexOf('shampoo') !== -1) return 'dau-goi';
        if (name.indexOf('dau xa') !== -1 || name.indexOf('conditioner') !== -1) return 'dau-xa';
        if (name.indexOf('serum') !== -1) return 'serum-toc';
        if (name.indexOf('kem u') !== -1 || name.indexOf('mat na') !== -1 || name.indexOf('hair mask') !== -1) return 'kem-u';
        if (name.indexOf('xit') !== -1 || name.indexOf('spray') !== -1 || name.indexOf('mist') !== -1) return 'xit-duong';
        if (name.indexOf('tay da dau') !== -1 || name.indexOf('scalp scrub') !== -1 || name.indexOf('detox') !== -1 || name.indexOf('peeling') !== -1) return 'tay-da-dau';
        return '';
    }

    function inferHairNeeds(name) {
        const needs = [];
        if (name.indexOf('phuc hoi') !== -1 || name.indexOf('repair') !== -1 || name.indexOf('damage') !== -1) needs.push('phuc-hoi');
        if (name.indexOf('gay rung') !== -1 || name.indexOf('chong rung') !== -1 || name.indexOf('anti hair loss') !== -1 || name.indexOf('fall') !== -1) needs.push('giam-gay-rung');
        if (name.indexOf('duong am') !== -1 || name.indexOf('moist') !== -1 || name.indexOf('hydrate') !== -1) needs.push('duong-am');
        if (name.indexOf('nhuom') !== -1 || name.indexOf('color') !== -1 || name.indexOf('colour') !== -1) needs.push('toc-nhuom');
        if (name.indexOf('kiem soat dau') !== -1 || name.indexOf('oil control') !== -1 || name.indexOf('sebum') !== -1 || name.indexOf('oily scalp') !== -1) needs.push('kiem-soat-dau');
        if (name.indexOf('chong gau') !== -1 || name.indexOf('anti dandruff') !== -1 || name.indexOf('dandruff') !== -1 || name.indexOf('tri gau') !== -1) needs.push('chong-gau');
        return needs;
    }

    function bindChipGroup(groupSelector, options) {
        const group = document.querySelector(groupSelector);
        if (!group) return;
        const chips = group.querySelectorAll('.filter-chip');

        chips.forEach(function (chip) {
            chip.addEventListener('click', function () {
                if (options && options.brandMode) {
                    if (chip.dataset.brand === 'all') {
                        chips.forEach(function (c) {
                            c.classList.remove('active');
                        });
                        chip.classList.add('active');
                    } else {
                        chip.classList.toggle('active');
                        const allChip = group.querySelector('.filter-chip[data-brand="all"]');
                        if (allChip) allChip.classList.remove('active');

                        const selected = group.querySelectorAll('.filter-chip.active:not([data-brand="all"])');
                        if (!selected.length && allChip) {
                            allChip.classList.add('active');
                        }
                    }
                    return;
                }

                if (options && options.mode === 'single') {
                    const wasActive = chip.classList.contains('active');
                    chips.forEach(function (c) {
                        c.classList.remove('active');
                    });
                    if (!wasActive) {
                        chip.classList.add('active');
                    }
                    return;
                }

                chip.classList.toggle('active');
            });
        });
    }

    (function initAdvancedFilters() {
        const allItems = document.querySelectorAll('.deals-grid .product-item');
        if (!allItems.length) return;

        const rangeMin = document.getElementById('rangeMin');
        const rangeMax = document.getElementById('rangeMax');
        const inputMin = document.getElementById('priceMin');
        const inputMax = document.getElementById('priceMax');
        const rangeFill = document.getElementById('rangeFill');
        const labelMin = document.getElementById('labelMin');
        const labelMax = document.getElementById('labelMax');
        const resetBtn = document.getElementById('resetFilters');
        const applyBtn = document.getElementById('applyFilters');

        if (!rangeMin || !rangeMax || !rangeFill) return;

        let dataMaxPrice = 0;
        allItems.forEach(function (item) {
            const p = parseFloat(item.dataset.price) || 0;
            if (p > dataMaxPrice) dataMaxPrice = p;
        });
        dataMaxPrice = Math.ceil(dataMaxPrice / 100000) * 100000;
        if (dataMaxPrice <= 0) dataMaxPrice = 5000000;

        rangeMin.min = 0;
        rangeMin.max = dataMaxPrice;
        rangeMin.value = 0;
        rangeMax.min = 0;
        rangeMax.max = dataMaxPrice;
        rangeMax.value = dataMaxPrice;

        function formatVND(v) {
            return new Intl.NumberFormat('vi-VN').format(v) + '₫';
        }

        function updateRangeFill() {
            const min = parseInt(rangeMin.value, 10) || 0;
            const max = parseInt(rangeMax.value, 10) || 0;
            const total = parseInt(rangeMax.max, 10) || 1;
            const left = (min / total) * 100;
            const right = (max / total) * 100;

            rangeFill.style.left = left + '%';
            rangeFill.style.width = (right - left) + '%';
            if (labelMin) labelMin.textContent = formatVND(min);
            if (labelMax) labelMax.textContent = formatVND(max);
        }

        function syncSlidersFromInputs() {
            let min = parseInt(inputMin.value, 10) || 0;
            let max = parseInt(inputMax.value, 10) || parseInt(rangeMax.max, 10);

            if (min < 0) min = 0;
            if (max > parseInt(rangeMax.max, 10)) max = parseInt(rangeMax.max, 10);
            if (min > max) min = max;

            rangeMin.value = min;
            rangeMax.value = max;
            updateRangeFill();
        }

        rangeMin.addEventListener('input', function () {
            if (parseInt(rangeMin.value, 10) > parseInt(rangeMax.value, 10)) {
                rangeMin.value = rangeMax.value;
            }
            inputMin.value = rangeMin.value > 0 ? rangeMin.value : '';
            updateRangeFill();
        });

        rangeMax.addEventListener('input', function () {
            if (parseInt(rangeMax.value, 10) < parseInt(rangeMin.value, 10)) {
                rangeMax.value = rangeMin.value;
            }
            inputMax.value = parseInt(rangeMax.value, 10) < parseInt(rangeMax.max, 10) ? rangeMax.value : '';
            updateRangeFill();
        });

        let inputTimer;
        function onInputChange() {
            clearTimeout(inputTimer);
            inputTimer = setTimeout(syncSlidersFromInputs, 350);
        }

        inputMin.addEventListener('input', onInputChange);
        inputMax.addEventListener('input', onInputChange);

        bindChipGroup('#brandChips', { brandMode: true });
        bindChipGroup('#productTypeChips', { mode: 'multi' });
        bindChipGroup('#hairNeedChips', { mode: 'multi' });
        bindChipGroup('#offerChips', { mode: 'single' });

        if (applyBtn) {
            applyBtn.addEventListener('click', function () {
                applyAllFilters();
            });
        }

        if (resetBtn) {
            resetBtn.addEventListener('click', function () {
                rangeMin.value = 0;
                rangeMax.value = rangeMax.max;
                inputMin.value = '';
                inputMax.value = '';

                const brandChips = document.querySelectorAll('#brandChips .filter-chip');
                brandChips.forEach(function (chip) {
                    chip.classList.remove('active');
                });
                const allBrandChip = document.querySelector('#brandChips .filter-chip[data-brand="all"]');
                if (allBrandChip) allBrandChip.classList.add('active');

                ['#productTypeChips', '#hairNeedChips', '#offerChips'].forEach(function (selector) {
                    document.querySelectorAll(selector + ' .filter-chip.active').forEach(function (chip) {
                        chip.classList.remove('active');
                    });
                });

                updateRangeFill();
                applyAllFilters();
            });
        }

        inputMin.placeholder = formatVND(0);
        inputMax.placeholder = formatVND(dataMaxPrice);
        updateRangeFill();
        applyAllFilters();
    })();

    function applyAllFilters() {
        const allItems = document.querySelectorAll('.deals-grid .product-item');
        if (!allItems.length) return;

        const rangeMin = document.getElementById('rangeMin');
        const rangeMax = document.getElementById('rangeMax');
        const minPrice = rangeMin ? parseInt(rangeMin.value, 10) || 0 : 0;
        const maxPrice = rangeMax ? parseInt(rangeMax.value, 10) || Infinity : Infinity;

        const brandAll = document.querySelector('#brandChips .filter-chip[data-brand="all"]');
        const isAllBrands = brandAll && brandAll.classList.contains('active');
        const selectedBrands = [];
        document.querySelectorAll('#brandChips .filter-chip.active:not([data-brand="all"])').forEach(function (chip) {
            selectedBrands.push(chip.dataset.brand);
        });

        const selectedTypes = [];
        document.querySelectorAll('#productTypeChips .filter-chip.active').forEach(function (chip) {
            selectedTypes.push(chip.dataset.productType);
        });

        const selectedNeeds = [];
        document.querySelectorAll('#hairNeedChips .filter-chip.active').forEach(function (chip) {
            selectedNeeds.push(chip.dataset.hairNeed);
        });

        const activeOffer = document.querySelector('#offerChips .filter-chip.active');
        const offerFilter = activeOffer ? activeOffer.dataset.discount : '';

        function passOffer(discount) {
            if (!offerFilter) return true;
            if (offerFilter === 'under-30') return discount < 30;
            if (offerFilter === '30-50') return discount >= 30 && discount <= 50;
            if (offerFilter === 'over-50') return discount > 50;
            return true;
        }

        let visibleCount = 0;

        allItems.forEach(function (item) {
            const price = parseFloat(item.dataset.price) || 0;
            const brandId = item.dataset.brandId || '0';
            const discount = parseFloat(item.dataset.discount) || 0;
            const titleNode = item.querySelector('.product-title a');
            const normalizedName = normalizeText(titleNode ? titleNode.textContent : '');
            const inferredType = inferProductType(normalizedName);
            const inferredNeeds = inferHairNeeds(normalizedName);

            const passPrice = price >= minPrice && price <= maxPrice;
            const passBrand = isAllBrands || selectedBrands.indexOf(brandId) !== -1;
            const passType = !selectedTypes.length || (inferredType && selectedTypes.indexOf(inferredType) !== -1);
            const passNeed = !selectedNeeds.length || selectedNeeds.some(function (need) {
                return inferredNeeds.indexOf(need) !== -1;
            });
            const passDiscount = passOffer(discount);

            if (passPrice && passBrand && passType && passNeed && passDiscount) {
                item.style.display = '';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        const resultCount = document.getElementById('filterResultCount');
        if (resultCount) {
            resultCount.textContent = visibleCount + ' / ' + allItems.length + ' sản phẩm';
        }

        const emptyState = document.getElementById('filterEmptyState');
        if (emptyState) {
            emptyState.style.display = visibleCount === 0 ? 'flex' : 'none';
        }
    }
</script>
</body>
</html>
