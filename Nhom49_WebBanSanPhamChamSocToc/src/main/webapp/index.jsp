<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HairGlow | Sản phẩm chăm sóc tóc</title>
    <link
            href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Manrope:wght@600;700;800&family=Montserrat:wght@700;800&family=Playfair+Display:wght@400;500;600;700&display=swap"
            rel="stylesheet">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/animation.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/user/style_for_main-page.css">
</head>
<body class="home-page">
<jsp:include page="/layout/header.jsp"/>

<section class="hero-section section-animate">
    <div class="hero-shell">
        <div class="hero-copy">
            <h1>Chăm tóc chuẩn salon, mua sắm tinh gọn tại HairGlow</h1>
            <p class="hero-description">
                Khám phá dầu gội, dầu xả, serum, mặt nạ tóc và sản phẩm tạo kiểu được chọn lọc theo từng nhu cầu chăm sóc tóc.
            </p>
            <div class="hero-cta">
                <a class="hero-btn hero-btn-primary" href="${pageContext.request.contextPath}/store">
                    Khám phá sản phẩm
                </a>
                <a class="hero-btn hero-btn-outline" href="${pageContext.request.contextPath}/deals">
                    Xem ưu đãi
                </a>
                <a class="hero-btn hero-btn-soft" href="${pageContext.request.contextPath}/support">
                    Tư vấn routine
                </a>
            </div>
            <div class="hero-metrics" aria-label="Điểm nổi bật HairGlow">
                <div class="hero-metric">
                    <strong>${not empty featuredProducts ? featuredProducts.size() : 0}+</strong>
                    <span>Sản phẩm chọn lọc</span>
                </div>
                <div class="hero-metric">
                    <strong>${not empty brands ? brands.size() : 0}+</strong>
                    <span>Thương hiệu uy tín</span>
                </div>
                <div class="hero-metric">
                    <strong>24/7</strong>
                    <span>Hỗ trợ tư vấn</span>
                </div>
            </div>
        </div>

        <div class="hero-visual-stack">
            <div class="banner-container">
                <c:set var="bannerCount" value="${fn:length(requestScope.activeBanners)}"/>
                <div class="slider" id="homeBannerSlider" data-autoplay="true" data-interval="4500" tabindex="0">
                    <div class="banner-slides">
                        <c:choose>
                            <c:when test="${bannerCount > 0}">
                                <c:forEach var="banner" items="${requestScope.activeBanners}" varStatus="status">
                                    <div class="item ${status.first ? 'active' : ''}">
                                        <img
                                                alt="<c:out value='${banner.title}'/>"
                                                class="banner-image"
                                                src="<c:out value='${banner.imageUrl}'/>"
                                                loading="eager">
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="item active hero-fallback-slide">
                                    <img
                                            alt="HairGlow routine chăm sóc tóc"
                                            class="banner-image"
                                            src="${pageContext.request.contextPath}/static/assets/images/banner2.png"
                                            loading="eager">
                                    <div class="hero-fallback-copy">
                                        <span>Routine Lab</span>
                                        <strong>Chọn đúng sản phẩm cho từng tình trạng tóc</strong>
                                        <p>Từ làm sạch dịu nhẹ, phục hồi hư tổn đến bảo vệ tóc khỏi nhiệt.</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${bannerCount > 1}">
                        <button aria-label="Banner trước" class="nav prev" type="button">
                            <i class="fas fa-chevron-left" aria-hidden="true"></i>
                        </button>
                        <button aria-label="Banner tiếp theo" class="nav next" type="button">
                            <i class="fas fa-chevron-right" aria-hidden="true"></i>
                        </button>
                        <div aria-label="Chọn banner" class="slider-dots">
                            <c:forEach var="banner" items="${requestScope.activeBanners}" varStatus="status">
                                <button type="button"
                                        class="dot ${status.index == 0 ? 'active' : ''}"
                                        data-slide="${status.index}"
                                        aria-label="Chuyển đến banner ${status.index + 1}"
                                        aria-current="${status.index == 0 ? 'true' : 'false'}">
                                </button>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="hero-promo-grid">
                <a class="hero-promo-card" href="${pageContext.request.contextPath}/products?category=serum">
                    <span class="promo-icon"><i class="fas fa-seedling" aria-hidden="true"></i></span>
                    <p class="promo-label">Routine phục hồi</p>
                    <h3>Chọn dầu gội, mask và serum cho tóc khô xơ, dễ gãy</h3>
                    <span class="promo-link">Xem gợi ý</span>
                </a>
                <a class="hero-promo-card" href="${pageContext.request.contextPath}/deals">
                    <span class="promo-icon"><i class="fas fa-tags" aria-hidden="true"></i></span>
                    <p class="promo-label">Ưu đãi hôm nay</p>
                    <h3>Flash sale theo khung giờ cho routine chăm tóc tiết kiệm</h3>
                    <span class="promo-link">Vào trang ưu đãi</span>
                </a>
            </div>
        </div>
    </div>
</section>

<section class="home-trust-strip section-animate">
    <div class="trust-shell">
        <article class="trust-item">
            <span class="trust-icon"><i class="fas fa-certificate" aria-hidden="true"></i></span>
            <h3>Sản phẩm chính hãng</h3>
            <p>Nguồn gốc rõ ràng, minh bạch thành phần và xuất xứ.</p>
        </article>
        <article class="trust-item">
            <span class="trust-icon"><i class="fas fa-spa" aria-hidden="true"></i></span>
            <h3>Tư vấn routine</h3>
            <p>Gợi ý sản phẩm theo tình trạng tóc và da đầu thực tế.</p>
        </article>
        <article class="trust-item">
            <span class="trust-icon"><i class="fas fa-truck-fast" aria-hidden="true"></i></span>
            <h3>Giao hàng nhanh</h3>
            <p>Đóng gói chỉn chu, theo dõi đơn hàng rõ ràng.</p>
        </article>
        <article class="trust-item">
            <span class="trust-icon"><i class="fas fa-rotate-left" aria-hidden="true"></i></span>
            <h3>Đổi trả minh bạch</h3>
            <p>Quy trình hỗ trợ rõ ràng khi sản phẩm chưa phù hợp.</p>
        </article>
    </div>
</section>

<main class="home-main page-animate">
    <section class="categories-container section-animate" id="categories-container">
        <div class="section-head section-head-center">
            <p class="section-kicker">Danh mục chăm sóc</p>
            <h2 class="section-title">Khám phá theo nhu cầu mái tóc</h2>
            <p class="section-subtitle">
                Bắt đầu từ danh mục đúng nhu cầu để xây routine nhanh hơn, ít phân vân hơn.
            </p>
        </div>

        <c:choose>
            <c:when test="${not empty topCategories}">
                <div class="categories-grid stagger-fade">
                    <c:forEach var="category" items="${topCategories}">
                        <a class="category-item"
                           href="${pageContext.request.contextPath}/products?category=<c:out value='${category.categorySlug}'/>">
                            <span class="category-icon">
                                <c:choose>
                                    <c:when test="${category.categorySlug == 'dau-goi'}">
                                        <i class="fas fa-shower" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${category.categorySlug == 'dau-xa'}">
                                        <i class="fas fa-pump-soap" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${category.categorySlug == 'kem-u'}">
                                        <i class="fas fa-spa" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${category.categorySlug == 'serum'}">
                                        <i class="fas fa-droplet" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${category.categorySlug == 'tri-gau'}">
                                        <i class="fas fa-shield-heart" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${category.categorySlug == 'sap-gel'}">
                                        <i class="fas fa-wand-magic-sparkles" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${category.categorySlug == 'tinh-dau'}">
                                        <i class="fas fa-bottle-droplet" aria-hidden="true"></i>
                                    </c:when>
                                    <c:when test="${category.categorySlug == 'phu-kien'}">
                                        <i class="fas fa-scissors" aria-hidden="true"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-leaf" aria-hidden="true"></i>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            <span class="category-content">
                                <span class="category-name"><c:out value="${category.categoryName}"/></span>
                                <span class="category-pill">Khám phá ngay</span>
                            </span>
                        </a>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-layer-group" aria-hidden="true"></i>
                    <p>Danh mục chăm sóc đang được cập nhật.</p>
                    <a href="${pageContext.request.contextPath}/store">Xem toàn bộ sản phẩm</a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="social-discovery-section section-animate">
        <div class="section-head">
            <div>
                <p class="section-kicker">Routine Lab</p>
                <h2 class="section-title">Gợi ý routine và xu hướng chăm tóc</h2>
                <p class="section-subtitle">
                    Các nhóm sản phẩm được sắp theo vấn đề thường gặp để khách hàng chọn nhanh và mua đúng hơn.
                </p>
            </div>
            <a class="section-link" href="${pageContext.request.contextPath}/support">
                Nhận tư vấn routine <i class="fas fa-arrow-right" aria-hidden="true"></i>
            </a>
        </div>

        <div class="social-discovery-grid">
            <article class="social-card social-main-card">
                <c:choose>
                    <c:when test="${not empty featuredProducts}">
                        <c:set var="trendProduct" value="${featuredProducts[0]}"/>
                        <a class="social-main-link"
                           href="${pageContext.request.contextPath}/product/<c:out value='${trendProduct.productSlug}'/>">
                            <div class="social-main-media">
                                <c:choose>
                                    <c:when test="${not empty trendProduct.primaryImageUrl}">
                                        <img alt="<c:out value='${trendProduct.productName}'/>"
                                             src="<c:out value='${trendProduct.primaryImageUrl}'/>">
                                    </c:when>
                                    <c:otherwise>
                                        <img alt="<c:out value='${trendProduct.productName}'/>"
                                             src="${pageContext.request.contextPath}/static/assets/images/default-product.png">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="social-main-content">
                                <p class="social-label">Sản phẩm được quan tâm</p>
                                <h3><c:out value="${trendProduct.productName}"/></h3>
                                <p>Phù hợp để bắt đầu routine chăm sóc tóc hằng ngày với trải nghiệm mua sắm gọn gàng.</p>
                                <span class="social-link-inline">Xem chi tiết</span>
                            </div>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="social-main-link" href="${pageContext.request.contextPath}/store">
                            <div class="social-main-media">
                                <img alt="Xu hướng chăm tóc"
                                     src="${pageContext.request.contextPath}/static/assets/images/banner2.png">
                            </div>
                            <div class="social-main-content">
                                <p class="social-label">Xu hướng chăm tóc</p>
                                <h3>Khám phá bộ sản phẩm đang được HairGlow tuyển chọn</h3>
                                <p>Danh sách gợi ý sẽ được cập nhật khi có sản phẩm nổi bật.</p>
                                <span class="social-link-inline">Vào cửa hàng</span>
                            </div>
                        </a>
                    </c:otherwise>
                </c:choose>
            </article>

            <article class="social-card social-routine-card">
                <p class="social-label">Chọn theo vấn đề tóc</p>
                <h3>Ba hướng routine phổ biến tại HairGlow</h3>
                <div class="routine-chip-list">
                    <a href="${pageContext.request.contextPath}/products?category=serum">
                        <i class="fas fa-seedling" aria-hidden="true"></i>
                        <span>Routine phục hồi</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/products?category=hair-loss">
                        <i class="fas fa-droplet-slash" aria-hidden="true"></i>
                        <span>Chăm sóc da đầu</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/store?sort=bestseller">
                        <i class="fas fa-chart-line" aria-hidden="true"></i>
                        <span>Sản phẩm bán chạy</span>
                    </a>
                </div>
            </article>

            <article class="social-card social-community-card">
                <p class="social-label">Tổng quan cửa hàng</p>
                <h3>Danh sách mua sắm được cập nhật liên tục</h3>
                <p class="social-community-desc">
                    Theo dõi ưu đãi, sản phẩm nổi bật và thương hiệu để chọn combo chăm tóc phù hợp hơn.
                </p>
                <div class="social-stat-grid">
                    <div class="social-stat">
                        <strong>${not empty saleProducts ? saleProducts.size() : 0}</strong>
                        <span>Sản phẩm ưu đãi</span>
                    </div>
                    <div class="social-stat">
                        <strong>${not empty featuredProducts ? featuredProducts.size() : 0}</strong>
                        <span>Đề xuất nổi bật</span>
                    </div>
                    <div class="social-stat">
                        <strong>${not empty brands ? brands.size() : 0}</strong>
                        <span>Thương hiệu</span>
                    </div>
                </div>
                <a class="social-link-inline" href="${pageContext.request.contextPath}/deals">
                    Xem ưu đãi hiện tại
                </a>
            </article>
        </div>
    </section>

    <section class="flash-sale-section section-animate" id="flash-sale">
        <div class="flash-sale-container">
            <div class="section-head flash-sale-header">
                <div>
                    <p class="section-kicker">Ưu đãi hôm nay</p>
                    <h2 class="section-title">Flash sale chăm tóc</h2>
                    <p class="section-subtitle">
                        Sản phẩm giảm giá có thời hạn, trình bày gọn để dễ so sánh giá và thêm vào giỏ.
                    </p>
                </div>
                <div class="flash-sale-countdown" aria-label="Đếm ngược flash sale">
                    <div class="countdown-box">
                        <span class="countdown-number" id="flash-sale-hours">00</span>
                        <span class="countdown-label">Giờ</span>
                    </div>
                    <div class="countdown-box">
                        <span class="countdown-number" id="flash-sale-minutes">00</span>
                        <span class="countdown-label">Phút</span>
                    </div>
                    <div class="countdown-box">
                        <span class="countdown-number" id="flash-sale-seconds">00</span>
                        <span class="countdown-label">Giây</span>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty saleProducts}">
                    <div class="flash-sale-slider-wrap">
                        <button class="flash-sale-nav prev" id="flash-sale-prev" type="button"
                                aria-label="Sản phẩm trước">
                            <i class="fas fa-chevron-left" aria-hidden="true"></i>
                        </button>
                        <div class="flash-sale-track stagger-fade" id="flash-sale-track">
                            <c:forEach var="product" items="${saleProducts}">
                                <article class="product-item flash-sale-item">
                                    <div class="product-img">
                                        <c:if test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                                            <div class="flash-sale-badge">
                                                <span class="badge-percent">-${product.defaultVariant.discountPercent}%</span>
                                                <span class="badge-label">Giảm</span>
                                            </div>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/product/<c:out value='${product.productSlug}'/>">
                                            <c:choose>
                                                <c:when test="${not empty product.primaryImageUrl}">
                                                    <img alt="<c:out value='${product.productName}'/>" class="product-image"
                                                         src="<c:out value='${product.primaryImageUrl}'/>">
                                                </c:when>
                                                <c:otherwise>
                                                    <img alt="<c:out value='${product.productName}'/>" class="product-image"
                                                         src="${pageContext.request.contextPath}/static/assets/images/default-product.png">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                    <div class="product-body">
                                        <h3 class="product-title">
                                            <a href="${pageContext.request.contextPath}/product/<c:out value='${product.productSlug}'/>">
                                                <c:out value="${product.productName}"/>
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
                                                            <fmt:formatNumber
                                                                    value="${product.defaultVariant.originalPrice}"
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
                                                    <i class="fas fa-bolt savings-icon" aria-hidden="true"></i>
                                                    <span class="savings-text">Tiết kiệm <strong><fmt:formatNumber value="${savedAmount}" type="number"/>&#8363;</strong></span>
                                                </div>
                                            </c:if>
                                            <c:if test="${product.stockQuantity > 0}">
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
                                            <c:choose>
                                                <c:when test="${product.stockQuantity > 0}">
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
                                                            <i class="fas fa-cart-plus" aria-hidden="true"></i>
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="btn btn-disabled product-unavailable">Tạm hết hàng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                        <button class="flash-sale-nav next" id="flash-sale-next" type="button"
                                aria-label="Sản phẩm tiếp theo">
                            <i class="fas fa-chevron-right" aria-hidden="true"></i>
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-box-open" aria-hidden="true"></i>
                        <p>Hiện chưa có sản phẩm flash sale.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="featured-container section-animate" id="featured-container">
        <div class="section-head">
            <div>
                <p class="section-kicker">Sản phẩm nổi bật</p>
                <h2 class="section-title">Lựa chọn đáng chú ý cho routine hằng ngày</h2>
                <p class="section-subtitle">
                    Sản phẩm được tuyển chọn để khách hàng dễ xem ảnh, thương hiệu, đánh giá, giá và thao tác mua.
                </p>
            </div>
            <a class="section-link" href="${pageContext.request.contextPath}/store">
                Xem tất cả <i class="fas fa-arrow-right" aria-hidden="true"></i>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty featuredProducts}">
                <div class="product-grid stagger-fade" id="featured-products">
                    <c:forEach var="product" items="${featuredProducts}">
                        <article class="product-item">
                            <div class="product-img">
                                <a href="${pageContext.request.contextPath}/product/<c:out value='${product.productSlug}'/>">
                                    <c:choose>
                                        <c:when test="${not empty product.primaryImageUrl}">
                                            <img alt="<c:out value='${product.productName}'/>" class="product-image"
                                                 src="<c:out value='${product.primaryImageUrl}'/>">
                                        </c:when>
                                        <c:otherwise>
                                            <img alt="<c:out value='${product.productName}'/>" class="product-image"
                                                 src="${pageContext.request.contextPath}/static/assets/images/default-product.png">
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>

                            <div class="product-body">
                                <div class="product-content">
                                    <h3 class="product-title">
                                        <a href="${pageContext.request.contextPath}/product/<c:out value='${product.productSlug}'/>">
                                            <c:out value="${product.productName}"/>
                                        </a>
                                    </h3>

                                    <div class="product-small-details">
                                        <p>
                                            <c:if test="${product.brand != null}">
                                                <span><c:out value="${product.brand.brandName}"/></span>
                                            </c:if>
                                            <c:if test="${product.category != null}">
                                                <span><c:if test="${product.brand != null}">&bull;</c:if> <c:out value="${product.category.categoryName}"/></span>
                                            </c:if>
                                            <c:if test="${not empty product.origin}">
                                                <span>&bull; <c:out value="${product.origin}"/></span>
                                            </c:if>
                                        </p>
                                    </div>

                                    <div class="product-rating">
                                        <div class="rating-stars" aria-hidden="true">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${product.averageRating != null && i <= product.averageRating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <p class="review-count">${product.reviewCount} đánh giá</p>
                                    </div>

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

                                    <div class="product-sale-slot">
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
                                    </div>
                                </div>

                                <div class="product-actions">
                                    <a class="btn btn-view"
                                       href="${pageContext.request.contextPath}/product/<c:out value='${product.productSlug}'/>">
                                        Chi tiết
                                    </a>

                                    <c:choose>
                                        <c:when test="${product.stockQuantity > 0}">
                                            <a class="btn btn-add add-to-cart" href="#"
                                               data-product-id="${product.productId}">
                                                Thêm vào giỏ
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="btn btn-disabled">Tạm hết hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-box-open" aria-hidden="true"></i>
                    <p>Chưa có sản phẩm nổi bật.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="brands-container section-animate" id="brands-container">
        <div class="section-head section-head-center">
            <p class="section-kicker">Thương hiệu đồng hành</p>
            <h2 class="section-title">Các brand chăm sóc tóc được HairGlow tuyển chọn</h2>
            <p class="section-subtitle">
                Logo và tên thương hiệu được trình bày tối giản để khách hàng nhận diện nhanh, không làm rối trải nghiệm mua sắm.
            </p>
        </div>

        <c:choose>
            <c:when test="${not empty brands}">
                <div class="brands-showcase stagger-fade">
                    <c:forEach var="brand" items="${brands}" varStatus="status">
                        <c:if test="${status.index < 12}">
                            <a class="brand-card"
                               href="${pageContext.request.contextPath}/products?brand=${brand.brandSlug}"
                               title="Xem sản phẩm của ${fn:escapeXml(brand.brandName)}">
                                <div class="brand-logo-wrap">
                                    <c:set var="brandLogoUrl" value="${brand.logoUrl}"/>
                                    <c:set var="brandLogoSrc" value=""/>
                                    <c:if test="${not empty brandLogoUrl}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(brandLogoUrl, 'http://') || fn:startsWith(brandLogoUrl, 'https://')}">
                                                <c:set var="brandLogoSrc" value="${brandLogoUrl}"/>
                                            </c:when>
                                            <c:when test="${fn:startsWith(brandLogoUrl, '/')}">
                                                <c:set var="brandLogoSrc" value="${pageContext.request.contextPath}${brandLogoUrl}"/>
                                            </c:when>
                                            <c:when test="${fn:contains(brandLogoUrl, '/')}">
                                                <c:set var="brandLogoSrc" value="${pageContext.request.contextPath}/${brandLogoUrl}"/>
                                            </c:when>
                                        </c:choose>
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${not empty brandLogoSrc}">
                                            <img class="brand-logo-img"
                                                 src="${brandLogoSrc}"
                                                 alt="Logo thương hiệu ${fn:escapeXml(brand.brandName)}"
                                                 loading="lazy"
                                                 onerror="this.classList.add('is-hidden'); this.closest('.brand-logo-wrap').classList.add('brand-logo-missing');">
                                            <div class="stylized-brand-name brand-logo-fallback">
                                                <span><c:out value="${brand.brandName}"/></span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="stylized-brand-name">
                                                <span><c:out value="${brand.brandName}"/></span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
                <c:if test="${brands.size() > 12}">
                    <div class="brands-view-more">
                        <a href="${pageContext.request.contextPath}/brands" class="btn btn-outline-primary">
                            Khám phá tất cả thương hiệu <i class="fas fa-arrow-right" aria-hidden="true"></i>
                        </a>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-industry" aria-hidden="true"></i>
                    <p>Danh sách thương hiệu đang được cập nhật.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="support-section section-animate">
        <div class="support-card">
            <div class="support-copy">
                <p class="section-kicker">Beauty consultation</p>
                <h2>Xây routine chăm tóc rõ ràng hơn cùng HairGlow</h2>
                <p>
                    Chia sẻ tình trạng tóc hiện tại để nhận gợi ý sản phẩm phù hợp, tránh mua dàn trải và khó theo dõi hiệu quả.
                </p>
            </div>
            <a class="support-action" href="${pageContext.request.contextPath}/support">
                Nhận tư vấn ngay <i class="fas fa-arrow-right" aria-hidden="true"></i>
            </a>
        </div>
    </section>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        (function initBannerSlider() {
            const slider = document.getElementById('homeBannerSlider');
            if (!slider) {
                return;
            }

            const track = slider.querySelector('.banner-slides');
            const slides = Array.from(slider.querySelectorAll('.banner-slides .item'));
            const prevBtn = slider.querySelector('.nav.prev');
            const nextBtn = slider.querySelector('.nav.next');
            const dots = Array.from(slider.querySelectorAll('.slider-dots .dot'));

            if (!track || slides.length <= 1) {
                return;
            }

            let current = 0;
            let timer = null;
            let touchStartX = 0;
            const interval = Number(slider.dataset.interval || 4500);
            const reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            function goTo(index) {
                current = (index + slides.length) % slides.length;
                track.style.transform = 'translateX(-' + (current * 100) + '%)';
                slides.forEach(function (slide, i) {
                    slide.classList.toggle('active', i === current);
                });
                dots.forEach(function (dot, i) {
                    dot.classList.toggle('active', i === current);
                    dot.setAttribute('aria-current', i === current ? 'true' : 'false');
                });
            }

            function next() {
                goTo(current + 1);
            }

            function prev() {
                goTo(current - 1);
            }

            function stop() {
                if (timer) {
                    window.clearInterval(timer);
                    timer = null;
                }
            }

            function start() {
                if (reduceMotion || slider.dataset.autoplay === 'false') {
                    return;
                }
                stop();
                timer = window.setInterval(next, interval);
            }

            if (nextBtn) {
                nextBtn.addEventListener('click', function () {
                    next();
                    start();
                });
            }

            if (prevBtn) {
                prevBtn.addEventListener('click', function () {
                    prev();
                    start();
                });
            }

            dots.forEach(function (dot, index) {
                dot.addEventListener('click', function () {
                    goTo(index);
                    start();
                });
            });

            slider.addEventListener('mouseenter', stop);
            slider.addEventListener('mouseleave', start);
            slider.addEventListener('focusin', stop);
            slider.addEventListener('focusout', function (event) {
                if (!slider.contains(event.relatedTarget)) {
                    start();
                }
            });

            slider.addEventListener('keydown', function (event) {
                if (event.key === 'ArrowLeft') {
                    event.preventDefault();
                    prev();
                    start();
                } else if (event.key === 'ArrowRight') {
                    event.preventDefault();
                    next();
                    start();
                }
            });

            slider.addEventListener('touchstart', function (event) {
                touchStartX = event.changedTouches[0].clientX;
                stop();
            }, {passive: true});

            slider.addEventListener('touchend', function (event) {
                const touchEndX = event.changedTouches[0].clientX;
                const diff = touchStartX - touchEndX;
                if (Math.abs(diff) >= 45) {
                    if (diff > 0) {
                        next();
                    } else {
                        prev();
                    }
                }
                start();
            }, {passive: true});

            goTo(0);
            start();
        })();

        (function initFlashSaleSlider() {
            var track = document.getElementById('flash-sale-track');
            var prevBtn = document.getElementById('flash-sale-prev');
            var nextBtn = document.getElementById('flash-sale-next');

            if (!track || !prevBtn || !nextBtn) {
                return;
            }

            var items = track.querySelectorAll('.flash-sale-item');
            if (items.length === 0) {
                prevBtn.style.display = 'none';
                nextBtn.style.display = 'none';
                return;
            }

            function getScrollStep() {
                var item = items[0];
                var style = window.getComputedStyle(track);
                var gap = parseFloat(style.columnGap || style.gap || '0');
                return item.getBoundingClientRect().width + gap;
            }

            function updateNavState() {
                var atStart = track.scrollLeft <= 1;
                var atEnd = track.scrollLeft + track.clientWidth >= track.scrollWidth - 1;
                prevBtn.disabled = atStart;
                nextBtn.disabled = atEnd;
                prevBtn.classList.toggle('is-disabled', atStart);
                nextBtn.classList.toggle('is-disabled', atEnd);
            }

            track.addEventListener('scroll', updateNavState, {passive: true});
            window.addEventListener('resize', updateNavState);

            prevBtn.addEventListener('click', function () {
                track.scrollBy({left: -getScrollStep(), behavior: 'smooth'});
            });

            nextBtn.addEventListener('click', function () {
                track.scrollBy({left: getScrollStep(), behavior: 'smooth'});
            });

            var isDragging = false;
            var startX = 0;
            var scrollStart = 0;
            var rafId = null;
            var targetScroll = 0;

            track.addEventListener('mousedown', function (e) {
                isDragging = true;
                startX = e.pageX;
                scrollStart = track.scrollLeft;
                track.style.scrollBehavior = 'auto';
                track.style.cursor = 'grabbing';
                track.style.userSelect = 'none';
                e.preventDefault();
            });

            window.addEventListener('mousemove', function (e) {
                if (!isDragging) return;
                targetScroll = scrollStart + (startX - e.pageX);
                if (rafId) return;
                rafId = requestAnimationFrame(function () {
                    track.scrollLeft = targetScroll;
                    rafId = null;
                });
            });

            window.addEventListener('mouseup', function () {
                if (!isDragging) return;
                isDragging = false;
                track.style.scrollBehavior = '';
                track.style.cursor = '';
                track.style.userSelect = '';
                if (rafId) {
                    cancelAnimationFrame(rafId);
                    rafId = null;
                }
                updateNavState();
            });

            updateNavState();
        })();

        (function initFlashSaleCountdown() {
            var hoursEl = document.getElementById('flash-sale-hours');
            var minutesEl = document.getElementById('flash-sale-minutes');
            var secondsEl = document.getElementById('flash-sale-seconds');

            if (!hoursEl || !minutesEl || !secondsEl) {
                return;
            }

            function animateIfChanged(el, newText) {
                if (el.textContent !== newText) {
                    el.textContent = newText;
                    el.classList.remove('tick');
                    void el.offsetWidth;
                    el.classList.add('tick');
                }
            }

            function updateCountdown() {
                var now = new Date();
                var endOfDay = new Date();
                endOfDay.setHours(23, 59, 59, 999);
                var diff = endOfDay - now;

                if (diff <= 0) {
                    animateIfChanged(hoursEl, '00');
                    animateIfChanged(minutesEl, '00');
                    animateIfChanged(secondsEl, '00');
                    return;
                }

                var hours = Math.floor(diff / (1000 * 60 * 60));
                var minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                var seconds = Math.floor((diff % (1000 * 60)) / 1000);

                animateIfChanged(hoursEl, String(hours).padStart(2, '0'));
                animateIfChanged(minutesEl, String(minutes).padStart(2, '0'));
                animateIfChanged(secondsEl, String(seconds).padStart(2, '0'));
            }

            updateCountdown();
            setInterval(updateCountdown, 1000);
        })();
    });
</script>
</body>
</html>
