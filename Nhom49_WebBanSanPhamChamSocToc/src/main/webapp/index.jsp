<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
            <p class="hero-eyebrow">HairGlow Social Care</p>
            <h1>Routine chăm tóc chuẩn salon cho nhịp sống hiện đại</h1>
            <p class="hero-description">
                Chọn nhanh sản phẩm theo đúng nhu cầu: làm sạch, phục hồi, dưỡng ẩm, chống gãy rụng
                và tạo kiểu. Trải nghiệm mua sắm tinh gọn, trực quan, dễ khám phá xu hướng.
            </p>
            <div class="hero-cta">
                <a class="hero-btn hero-btn-primary" href="${pageContext.request.contextPath}/store">
                    Khám phá sản phẩm
                </a>
                <a class="hero-btn hero-btn-outline" href="${pageContext.request.contextPath}/deals">
                    Xem ưu đãi hôm nay
                </a>
            </div>
            <div class="hero-metrics">
                <div class="hero-metric">
                    <strong>${not empty featuredProducts ? featuredProducts.size() : 0}+</strong>
                    <span>Sản phẩm nổi bật</span>
                </div>
                <div class="hero-metric">
                    <strong>${not empty topCategories ? topCategories.size() : 0}</strong>
                    <span>Nhóm chăm tóc chính</span>
                </div>
                <div class="hero-metric">
                    <strong>${not empty brands ? brands.size() : 0}+</strong>
                    <span>Thương hiệu uy tín</span>
                </div>
            </div>
        </div>

        <div class="hero-visual-stack">
            <div class="banner-container">
                <div class="slider" id="banner-slider">
                    <div class="banner-slides">
                        <c:forEach var="banner" items="${requestScope.activeBanners}" varStatus="status">
                            <div class="item ${status.first ? 'active' : ''}" id="slide-${status.index + 1}">
                                <img
                                        alt="${banner.title}"
                                        class="banner-image"
                                        src="${banner.imageUrl}">
                            </div>
                        </c:forEach>
                    </div>
                    <button aria-label="Slide trước" class="nav prev" type="button">&#10094;</button>
                    <button aria-label="Slide sau" class="nav next" type="button">&#10095;</button>
                    <div aria-label="Chuyển slide" class="slider-dots" role="tablist"></div>
                </div>
            </div>

            <div class="hero-promo-grid">
                <a class="hero-promo-card" href="${pageContext.request.contextPath}/products?category=serum">
                    <p class="promo-label">Khám phá nhanh</p>
                    <h3>Tinh dầu và serum dưỡng tóc theo trend phục hồi</h3>
                    <span>Xem gợi ý</span>
                </a>
                <a class="hero-promo-card" href="${pageContext.request.contextPath}/deals">
                    <p class="promo-label">Campaign nổi bật</p>
                    <h3>Flash sale theo khung giờ cho routine chăm tóc</h3>
                    <span>Vào trang ưu đãi</span>
                </a>
            </div>
        </div>
    </div>
</section>

<section class="home-trust-strip section-animate">
    <div class="trust-shell">
        <article class="trust-item">
            <h3>Sản phẩm chính hãng</h3>
            <p>Nguồn gốc rõ ràng, minh bạch thông tin thành phần và xuất xứ.</p>
        </article>
        <article class="trust-item">
            <h3>Giao hàng nhanh</h3>
            <p>Đóng gói chỉn chu, theo dõi đơn hàng liên tục trên toàn quốc.</p>
        </article>
        <article class="trust-item">
            <h3>Đổi trả linh hoạt</h3>
            <p>Hỗ trợ xử lý nhanh khi sản phẩm chưa phù hợp với nhu cầu.</p>
        </article>
        <article class="trust-item">
            <h3>Tư vấn cá nhân hóa</h3>
            <p>Đội ngũ hỗ trợ giúp chọn routine theo tình trạng tóc và da đầu.</p>
        </article>
    </div>
</section>

<main class="home-main page-animate">
    <section class="categories-container section-animate" id="categories-container">
        <div class="section-head section-head-center">
            <p class="section-kicker">Discovery</p>
            <h2 class="section-title">Khám phá danh mục theo nhu cầu tóc</h2>
            <p class="section-subtitle">
                Tập trung vào những nhóm sản phẩm quan trọng để bắt đầu routine một cách nhanh và rõ ràng.
            </p>
        </div>

        <c:choose>
            <c:when test="${not empty topCategories}">
                <div class="categories-grid stagger-fade">
                    <c:forEach var="category" items="${topCategories}">
                        <a class="category-item category-${category.categorySlug}"
                           href="${pageContext.request.contextPath}/products?category=${category.categorySlug}">
                            <span class="category-bg"></span>
                            <span class="category-icon">
                                    <c:choose>
                                        <c:when test="${category.categorySlug == 'dau-goi'}">
                                            <i class="fas fa-shower"></i>
                                        </c:when>
                                        <c:when test="${category.categorySlug == 'dau-xa'}">
                                            <i class="fas fa-spray-can"></i>
                                        </c:when>
                                        <c:when test="${category.categorySlug == 'kem-u'}">
                                            <i class="fas fa-spa"></i>
                                        </c:when>
                                        <c:when test="${category.categorySlug == 'serum'}">
                                            <i class="fas fa-droplet"></i>
                                        </c:when>
                                        <c:when test="${category.categorySlug == 'tri-gau'}">
                                            <i class="fas fa-shield-heart"></i>
                                        </c:when>
                                        <c:when test="${category.categorySlug == 'sap-gel'}">
                                            <i class="fas fa-wand-magic-sparkles"></i>
                                        </c:when>
                                        <c:when test="${category.categorySlug == 'tinh-dau'}">
                                            <i class="fas fa-bottle-droplet"></i>
                                        </c:when>
                                        <c:when test="${category.categorySlug == 'phu-kien'}">
                                            <i class="fas fa-comb"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-leaf"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            <span class="category-content">
                                <span class="category-name">${category.categoryName}</span>
                                <span class="category-pill">Khám phá ngay</span>
                            </span>
                        </a>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="categories-fallback">
                    <a href="${pageContext.request.contextPath}/products?category=shampoo">Dầu gội</a>
                    <a href="${pageContext.request.contextPath}/products?category=conditioner">Dầu xả</a>
                    <a href="${pageContext.request.contextPath}/products?category=serum">Serum dưỡng tóc</a>
                    <a href="${pageContext.request.contextPath}/products?category=hair-loss">Chăm sóc da đầu</a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="social-discovery-section section-animate">
        <div class="section-head">
            <div>
                <p class="section-kicker">Social Commerce</p>
                <h2 class="section-title">Góc xu hướng và gợi ý routine</h2>
                <p class="section-subtitle">
                    Không chỉ mua sắm, homepage còn giúp bạn khám phá sản phẩm theo insight và nhu cầu thật.
                </p>
            </div>
            <a class="section-link" href="${pageContext.request.contextPath}/support">
                Nhận tư vấn routine <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <div class="social-discovery-grid">
            <article class="social-card social-main-card">
                <c:choose>
                    <c:when test="${not empty featuredProducts}">
                        <c:set var="trendProduct" value="${featuredProducts[0]}"/>
                        <a class="social-main-link"
                           href="${pageContext.request.contextPath}/product/${trendProduct.productSlug}">
                            <div class="social-main-media">
                                <img alt="${trendProduct.productName}"
                                     src="${pageContext.request.contextPath}/static/${trendProduct.primaryImage != null ? trendProduct.primaryImage.imageUrl : 'images/default-product.png'}">
                            </div>
                            <div class="social-main-content">
                                <p class="social-label">Review nổi bật</p>
                                <h3>${trendProduct.productName}</h3>
                                <p>Sản phẩm đang được khách hàng quan tâm cho routine chăm tóc hằng ngày.</p>
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
                                <h3>Khám phá bộ sưu tập sản phẩm đang được quan tâm</h3>
                                <p>HairGlow cập nhật liên tục các gợi ý phù hợp với nhu cầu tóc hiện tại.</p>
                                <span class="social-link-inline">Vào cửa hàng</span>
                            </div>
                        </a>
                    </c:otherwise>
                </c:choose>
            </article>

            <article class="social-card social-routine-card">
                <p class="social-label">Routine theo vấn đề tóc</p>
                <h3>Danh mục bạn có thể bắt đầu ngay</h3>
                <ul class="social-routine-list">
                    <c:choose>
                        <c:when test="${not empty topCategories}">
                            <c:forEach var="category" items="${topCategories}" varStatus="status">
                                <c:if test="${status.index < 4}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/products?category=${category.categorySlug}">
                                                ${category.categoryName}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/products?category=shampoo">Dầu gội làm sạch
                                dịu nhẹ</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=conditioner">Dầu xả phục
                                hồi độ ẩm</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=serum">Serum dưỡng và bảo
                                vệ tóc</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=hair-tools">Dụng cụ tạo
                                kiểu</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </article>

            <article class="social-card social-community-card">
                <p class="social-label">Mạch nội dung khám phá</p>
                <h3>Gợi ý theo nhịp mua sắm trong tuần</h3>
                <p class="social-community-desc">
                    Theo dõi các nhóm sản phẩm đang được quan tâm nhiều để chọn nhanh các combo chăm tóc phù hợp.
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
                        <span>Brand đang có</span>
                    </div>
                </div>
                <a class="social-link-inline" href="${pageContext.request.contextPath}/deals">
                    Xem campaign hiện tại
                </a>
            </article>
        </div>
    </section>

    <section class="flash-sale-section section-animate" id="flash-sale">
        <div class="flash-sale-container">
            <div class="section-head flash-sale-header">
                <div>
                    <p class="section-kicker">Deal Theo Khung Giờ</p>
                    <h2 class="section-title">Ưu đãi flash sale hôm nay</h2>
                    <p class="section-subtitle">
                        Danh sách sản phẩm giảm giá có thời hạn, cập nhật liên tục trong ngày.
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
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <div class="flash-sale-track stagger-fade" id="flash-sale-track">
                            <c:forEach var="product" items="${saleProducts}">
                                <article class="product-item flash-sale-item">
                                    <div class="product-img">
                                        <c:if test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                                            <div class="flash-sale-badge">
                                                -${product.defaultVariant.discountPercent}%
                                            </div>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                            <img alt="${product.productName}" class="product-image"
                                                 src="${pageContext.request.contextPath}/static/${product.primaryImage != null ? product.primaryImage.imageUrl : 'images/default-product.png'}">
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
                                                            <fmt:formatNumber
                                                                    value="${product.defaultVariant.originalPrice}"
                                                                    type="number"/>&#8363;
                                                        </p>
                                                        <p class="badge-discount">
                                                            -${product.defaultVariant.discountPercent}%</p>
                                                    </c:if>
                                                </c:if>
                                            </div>
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
                        <button class="flash-sale-nav next" id="flash-sale-next" type="button"
                                aria-label="Sản phẩm tiếp theo">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <p>Hiện chưa có sản phẩm trong khung flash sale.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="featured-container section-animate" id="featured-container">
        <div class="section-head">
            <div>
                <p class="section-kicker">Best Sellers</p>
                <h2 class="section-title">Sản phẩm nổi bật cho routine chăm tóc</h2>
                <p class="section-subtitle">
                    Chọn lọc từ những sản phẩm đang có tần suất mua cao và phản hồi tốt.
                </p>
            </div>
            <a class="section-link" href="${pageContext.request.contextPath}/store">
                Xem toàn bộ sản phẩm <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty featuredProducts}">
                <div class="product-grid stagger-fade" id="featured-products">
                    <c:forEach var="product" items="${featuredProducts}">
                        <article class="product-item">
                            <div class="product-img">
                                <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                    <img alt="${product.productName}" class="product-image"
                                         src="${pageContext.request.contextPath}/static/${product.primaryImage != null ? product.primaryImage.imageUrl : 'images/default-product.png'}">
                                </a>
                            </div>

                            <div class="product-body">
                                <div class="product-content">
                                    <h3 class="product-title">
                                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                                ${product.productName}
                                        </a>
                                    </h3>

                                    <div class="product-small-details">
                                        <p>
                                            <span>${product.brand != null ? product.brand.brandName : ''}</span>
                                            <c:if test="${product.category != null}">
                                                &bull; <span>${product.category.categoryName}</span>
                                            </c:if>
                                            <c:if test="${not empty product.origin}">
                                                &bull; <span>${product.origin}</span>
                                            </c:if>
                                        </p>
                                    </div>

                                    <div class="product-rating">
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= product.averageRating}">
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
                                       href="${pageContext.request.contextPath}/product/${product.productSlug}">
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
                    <i class="fas fa-box-open"></i>
                    <p>Chưa có sản phẩm nổi bật.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
    <section class="brands-container section-animate" id="brands-container">
        <div class="section-head section-head-center">
            <p class="section-kicker">Trusted Partners</p>
            <h2 class="section-title">Thương hiệu đồng hành cùng HairGlow</h2>
            <p class="section-subtitle">
                Tuyển chọn các hãng chăm sóc tóc uy tín, đảm bảo chất lượng và nguồn gốc rõ ràng cho mọi sản phẩm.
            </p>
        </div>

        <c:choose>
            <c:when test="${not empty brands}">
                <div class="brands-showcase stagger-fade">
                    <c:forEach var="brand" items="${brands}" varStatus="status">
                        <c:if test="${status.index < 12}">
                            <a class="brand-card"
                               href="${pageContext.request.contextPath}/products?brand=${brand.brandSlug}"
                               title="Xem sản phẩm của ${brand.brandName}">
                                <div class="brand-logo-wrap">
                                    <c:choose>
                                        <c:when test="${not empty brand.logoUrl}">
                                            <img class="brand-logo-img"
                                                 src="${pageContext.request.contextPath}/static/${brand.logoUrl}"
                                                 alt="Logo ${brand.brandName}"
                                                 loading="lazy">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="stylized-brand-name">
                                                <span>${brand.brandName}</span>
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
                            Khám phá tất cả thương hiệu <i class="fas fa-arrow-right" style="margin-left:6px"></i>
                        </a>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-industry"></i>
                    <p>Danh sách thương hiệu đang được cập nhật.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="support-section section-animate">
        <div class="support-card">
            <div class="support-copy">
                <p class="section-kicker">Hair Coaching</p>
                <h2>HairGlow hỗ trợ bạn xây routine chăm tóc rõ ràng và dễ theo dõi</h2>
                <p>
                    Chia sẻ tình trạng tóc hiện tại để nhận gợi ý sản phẩm theo nhu cầu thật, tránh mua dàn trải.
                </p>
            </div>
            <a class="support-action" href="${pageContext.request.contextPath}/support">
                Liên hệ đội ngũ hỗ trợ <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </section>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        (function initBannerSlider() {
            const slidesContainer = document.querySelector('.banner-slides');
            const slides = document.querySelectorAll('.banner-slides .item');
            const dotsContainer = document.querySelector('.slider-dots');
            const prevBtn = document.querySelector('.slider .nav.prev');
            const nextBtn = document.querySelector('.slider .nav.next');

            if (!slidesContainer || !dotsContainer || slides.length === 0) {
                return;
            }

            let currentSlide = 0;
            let autoSlideInterval;
            const totalSlides = slides.length;

            dotsContainer.innerHTML = '';
            slides.forEach(function (_, index) {
                const dot = document.createElement('button');
                dot.classList.add('dot');
                if (index === 0) {
                    dot.classList.add('active');
                }
                dot.addEventListener('click', function () {
                    goToSlide(index);
                    resetAutoSlide();
                });
                dotsContainer.appendChild(dot);
            });

            const dots = dotsContainer.querySelectorAll('.dot');

            function goToSlide(index) {
                dots[currentSlide].classList.remove('active');
                currentSlide = (index + totalSlides) % totalSlides;
                dots[currentSlide].classList.add('active');
                slidesContainer.style.transform = 'translateX(' + (-currentSlide * 100) + '%)';
            }

            function nextSlide() {
                goToSlide(currentSlide + 1);
            }

            function prevSlide() {
                goToSlide(currentSlide - 1);
            }

            if (prevBtn) {
                prevBtn.addEventListener('click', function () {
                    prevSlide();
                    resetAutoSlide();
                });
            }

            if (nextBtn) {
                nextBtn.addEventListener('click', function () {
                    nextSlide();
                    resetAutoSlide();
                });
            }

            function resetAutoSlide() {
                clearInterval(autoSlideInterval);
                autoSlideInterval = setInterval(nextSlide, 4000);
            }

            autoSlideInterval = setInterval(nextSlide, 4000);
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
