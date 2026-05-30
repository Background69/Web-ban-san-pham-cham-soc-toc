<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - HairGlow</title>

    <!-- Roboto -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;900&display=swap"
          rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/user/style_for_product_detail.css">

    <style>
        .description-content {
            padding: 24px;
            background: #ffffff;
            border: 1px solid #dbe6df;
            border-radius: 14px;
        }

        .description-layout {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .description-rendered {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .description-section {
            background: #fcfefd;
            border: 1px solid #e1ebe4;
            border-left: 5px solid #1f3f2f;
            border-radius: 10px;
            padding: 16px 18px;
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.3s ease, transform 0.3s ease;
        }

        .description-section.is-visible {
            opacity: 1;
            transform: translateY(0);
        }

        .description-section + .description-section {
            margin-top: 2px;
        }

        .description-section-title {
            margin: 0;
            font-size: 17px;
            line-height: 1.4;
            font-weight: 700;
            color: #1f3f2f;
            letter-spacing: 0.01em;
        }

        .description-section-body {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 10px;
        }

        .description-section-body p {
            margin: 0;
            color: #253340;
            font-size: 15px;
            line-height: 1.82;
            text-align: left;
            word-break: break-word;
        }

        .description-section-body strong {
            color: #1f3f2f;
            font-weight: 700;
        }

        .description-list {
            margin: 0;
            padding-left: 22px;
            list-style-type: disc;
            list-style-position: outside;
            display: grid;
            gap: 8px;
            color: #253340;
        }

        .description-list-item {
            font-size: 15px;
            line-height: 1.8;
            padding-left: 2px;
            word-break: break-word;
        }

        .description-list-item::marker {
            color: #1f3f2f;
        }

        .description-toggle-wrap {
            display: flex;
            justify-content: center;
            padding-top: 4px;
        }

        .description-toggle-wrap[hidden] {
            display: none;
        }

        .description-toggle-btn {
            border: 1px solid #1f3f2f;
            background: #ffffff;
            color: #1f3f2f;
            border-radius: 999px;
            padding: 9px 18px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .description-toggle-btn:hover {
            background: #1f3f2f;
            color: #ffffff;
        }

        .description-toggle-btn:focus-visible {
            outline: 2px solid #8eb7a0;
            outline-offset: 2px;
        }

        .description-fallback {
            background: #ffffff;
            border: 1px solid #dbe6df;
            border-radius: 10px;
            padding: 16px 18px;
        }

        .description-fallback p {
            margin: 0;
            color: #253340;
            font-size: 15px;
            line-height: 1.8;
            white-space: pre-line;
            word-break: break-word;
        }

        .description-empty {
            background: #ffffff;
            border: 1px dashed #c7d7cd;
            border-radius: 10px;
            padding: 16px 18px;
            color: #4b5563;
            font-size: 14px;
            line-height: 1.6;
        }

        .description-raw {
            display: none;
        }

        @media (max-width: 768px) {
            .description-content {
                padding: 18px;
            }

            .description-section,
            .description-fallback,
            .description-empty {
                padding: 14px;
            }

            .description-section-title {
                font-size: 15px;
            }

            .description-section-body p,
            .description-list-item,
            .description-fallback p {
                font-size: 14px;
                line-height: 1.7;
            }

            .description-list {
                gap: 7px;
                padding-left: 18px;
            }

            .description-toggle-btn {
                width: 100%;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .description-section {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/layout/header.jsp"/>

<main class="product-detail-main">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <span class="separator">›</span>
        <c:if test="${product.category != null}">
            <a
                    href="${pageContext.request.contextPath}/products?category=${product.category.categorySlug}">
                    ${product.category.categoryName}
            </a>
            <span class="separator">›</span>
        </c:if>
        <span class="current">${product.productName}</span>
    </nav>

    <div class="product-detail-container">
        <!-- LEFT: Images -->
        <div class="product-detail-left">
            <div class="product-detail-image">
                <c:choose>
                    <c:when test="${not empty product.primaryImage}">
                        <img id="main-product-image" class="product-image"
                             src="${pageContext.request.contextPath}/static/${product.primaryImage.imageUrl}"
                             alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <img id="main-product-image" class="product-image"
                             src="${pageContext.request.contextPath}/static/assets/images/default-product.png"
                             alt="${product.productName}">
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty product.images}">
                <div class="thumbnail-images">
                    <c:forEach var="image" items="${product.images}" varStatus="status">
                        <img class="thumbnail ${status.first ? 'active' : ''}"
                             src="${pageContext.request.contextPath}/static/${image.imageUrl}"
                             data-full="${pageContext.request.contextPath}/static/${image.imageUrl}"
                             alt="${product.productName}"
                             onclick="changeMainImage('${pageContext.request.contextPath}/static/${image.imageUrl}', this)">
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <!-- RIGHT: Info -->
        <div class="product-detail-right">
            <h1 class="product-title">${product.productName}</h1>

            <c:if test="${not empty product.brand}">
                <p class="product-brand">
                    <span>Thương hiệu:</span>
                    <a href="${pageContext.request.contextPath}/brand/${product.brand.brandSlug}">
                            ${product.brand.brandName}
                    </a>
                </p>
            </c:if>

            <!-- Rating -->
            <div class="product-rating-section">
                <div class="rating-stars">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= averageRating}">
                                <i class="fas fa-star stars"></i>
                            </c:when>
                            <c:when test="${i - 0.5 <= averageRating}">
                                <i class="fas fa-star-half-alt stars"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="far fa-star stars"></i>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <span class="rating-number">${averageRating}/5</span>
                <span class="rating-count">(${reviewCount} đánh giá)</span>
            </div>

            <!-- Price -->
            <c:if test="${not empty product.defaultVariant}">
                <div class="product-section-price">
                    <div class="price-main">
                                        <span class="price-current">
                                            <fmt:formatNumber
                                                    value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                                    type="number"/>₫
                                        </span>

                        <c:if
                                test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                            <span class="price-old">
                                                <fmt:formatNumber value="${product.defaultVariant.originalPrice}"
                                                                  type="number"/>₫
                                            </span>
                            <span
                                    class="discount-percent">-${product.defaultVariant.discountPercent}%</span>
                        </c:if>
                    </div>
                    <div class="price-note">
                        <i class="fa-solid fa-shield"></i>
                        <span>Giá đã bao gồm VAT</span>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty product.shortDescription}">
                <div class="product-short-desc">
                    <p>${product.shortDescription}</p>
                </div>
            </c:if>

            <!-- Variants -->
            <c:if test="${not empty product.variants && product.variants.size() > 1}">
                <div class="product-section-options">
                    <div class="option-group">
                        <label>Chọn loại:</label>
                        <div class="option-buttons">
                            <c:forEach var="variant" items="${product.variants}">
                                <button type="button"
                                        class="option-btn variant-btn ${variant.variantId == product.defaultVariant.variantId ? 'active' : ''}"
                                        data-variant-id="${variant.variantId}"
                                        data-original-price="${variant.originalPrice}"
                                        data-sale-price="${variant.salePrice != null ? variant.salePrice : variant.originalPrice}"
                                        data-stock="${variant.stockQuantity}">
                                        ${variant.variantName}
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Quantity Section -->
            <div class="product-section-options">
                <div class="option-group">
                    <label>Số lượng:</label>
                    <div class="quantity-selector">
                        <button type="button" class="qty-btn minus">-</button>
                        <input type="number" id="quantity" name="quantity" value="1" min="1"
                               max="${product.defaultVariant.stockQuantity}">
                        <button type="button" class="qty-btn plus">+</button>
                    </div>

                    <c:if test="${product.onSale}">
                        <div class="stock-line">
                            <c:choose>
                                <c:when test="${product.defaultVariant.stockQuantity > 0}">
                                                <span class="in-stock">Còn ${product.defaultVariant.stockQuantity} sản
                                                    phẩm</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="out-of-stock">Hết hàng</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${product.stockQuantity > 0}">
                            <div class="stock-progress">
                                <div class="stock-progress-bar">
                                    <div class="stock-progress-fill" style="width: ${product.soldPercent}%">
                                    </div>
                                </div>
                                <div class="stock-progress-text">
                                    Đã bán ${product.soldQuantity}/${product.stockQuantity}
                                </div>
                            </div>
                        </c:if>
                    </c:if>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="product-section-btn">
                <form id="add-to-cart-form" action="${pageContext.request.contextPath}/cart/add"
                      method="post" style="flex:1;">
                    <input type="hidden" name="variantId" id="selectedVariantId"
                           value="${product.defaultVariant.variantId}">
                    <input type="hidden" name="quantity" id="cartQuantity" value="1">
                    <input type="hidden" name="action" id="cartAction" value="add_to_cart">

                    <button type="submit" class="btn btn-add-cart" <c:if
                            test="${product.defaultVariant.stockQuantity <= 0}">disabled</c:if>>
                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                    </button>
                </form>

                <button type="button" class="btn btn-buy-now" <c:if
                        test="${product.defaultVariant.stockQuantity <= 0}">disabled</c:if>>
                    <i class="fas fa-bolt"></i> Mua ngay
                </button>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <div class="product-main-detail-page">
        <div class="main-detail-header">
            <button class="detail-page-btn active" data-tab="description">Mô tả sản phẩm</button>
            <button class="detail-page-btn" data-tab="reviews">Đánh giá (${reviewCount})</button>
        </div>

        <div class="tab-content">
            <!-- Description Tab -->
            <div class="detail-page-content active" id="description">
                <div class="description-content">
                    <c:choose>
                        <c:when test="${not empty product.fullDescription}">
                            <div class="description-layout">
                                <div class="description-rendered" id="description-rendered" hidden></div>
                                <div class="description-fallback" id="description-fallback">
                                    <p><c:out value="${product.fullDescription}"/></p>
                                </div>
                                <pre class="description-raw" id="description-raw" hidden><c:out
                                        value="${product.fullDescription}"/></pre>
                                <div class="description-toggle-wrap" id="description-toggle-wrap" hidden>
                                    <button type="button" class="description-toggle-btn" id="description-toggle-btn"
                                            aria-expanded="false"></button>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="description-empty">Thông tin mô tả đang được cập nhật.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="specs-section">
                    <h3>Thông số sản phẩm</h3>
                    <div class="specs-table-wrap">
                        <table class="specs-table">
                            <tr>
                                <th>Thương hiệu</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${product.brand != null}">
                                            ${product.brand.brandName}
                                        </c:when>
                                        <c:when test="${not empty product.brandName}">
                                            ${product.brandName}
                                        </c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Xuất xứ thương hiệu</th>
                                <td>
                                    <c:choose>
                                        <c:when
                                                test="${product.brand != null && not empty product.brand.origin}">
                                            ${product.brand.origin}
                                        </c:when>
                                        <c:when test="${not empty product.origin}">
                                            ${product.origin}
                                        </c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Danh mục</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${product.category != null}">
                                            <a
                                                    href="${pageContext.request.contextPath}/products?category=${product.category.categorySlug}">
                                                    ${product.category.categoryName}
                                            </a>
                                        </c:when>
                                        <c:when test="${not empty product.categoryName}">
                                            ${product.categoryName}
                                        </c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Dung tích</th>
                                <td id="variantSize">
                                    <c:choose>
                                        <c:when test="${not empty product.variants}">
                                            <div class="variant-list">
                                                <c:forEach var="variant" items="${product.variants}">
                                                                    <span
                                                                            class="variant-badge">${variant.variantName}</span>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Reviews Tab -->
            <div class="detail-page-content" id="reviews">
                <div class="review-summary">
                    <div class="rating-overview">
                        <div class="rating-big">
                            <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"
                                              minFractionDigits="1"/>
                        </div>
                        <div class="rating-stars-big">
                            <c:forEach begin="1" end="5" var="i">
                                <span class="star ${i <= averageRating ? 'filled' : ''}">★</span>
                            </c:forEach>
                        </div>
                        <div class="total-reviews">${reviewCount} đánh giá</div>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.reviewSuccess}">
                    <div class="review-alert success">${sessionScope.reviewSuccess}</div>
                    <c:remove var="reviewSuccess" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.reviewError}">
                    <div class="review-alert error">${sessionScope.reviewError}</div>
                    <c:remove var="reviewError" scope="session"/>
                </c:if>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:choose>
                            <c:when test="${canReviewStatus == 'CAN_REVIEW'}">
                                <div class="write-review">
                                    <h3>Viết đánh giá của bạn</h3>
                                    <form action="${pageContext.request.contextPath}/review"
                                          method="post" class="review-form">
                                        <input type="hidden" name="productId"
                                               value="${product.productId}">
                                        <div class="rating-input">
                                            <label>Đánh giá:</label>
                                            <div class="star-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <input type="radio" name="rating" value="${6-i}"
                                                           id="star${6-i}" required>
                                                    <label for="star${6-i}">★</label>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="review-content-input">
                                            <label for="reviewContent">Nội dung:</label>
                                            <textarea name="content" id="reviewContent" rows="4"
                                                      placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."
                                                      required></textarea>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Gửi đánh
                                            giá
                                        </button>
                                    </form>
                                </div>
                            </c:when>
                            <c:when test="${canReviewStatus == 'ALREADY_REVIEWED'}">
                                <div class="login-to-review">
                                    <p><i class="fas fa-check-circle" style="color: #28a745;"></i> Bạn
                                        đã đánh giá sản phẩm này.</p>
                                </div>
                            </c:when>
                            <c:when test="${canReviewStatus == 'ORDER_NOT_COMPLETED'}">
                                <div class="login-to-review">
                                    <p><i class="fas fa-clock" style="color: #ffc107;"></i> Đơn hàng của
                                        bạn đang được xử lý. Vui lòng đợi đơn hàng hoàn thành để đánh
                                        giá.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="login-to-review">
                                    <p><i class="fas fa-shopping-bag" style="color: #6c757d;"></i> Bạn
                                        cần mua sản phẩm này để có thể đánh giá.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div class="login-to-review">
                            <p>Vui lòng <a
                                    href="${pageContext.request.contextPath}/auth/login?redirect=/product/${product.productSlug}">đăng
                                nhập</a> để viết đánh giá.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="reviews-list">
                    <c:forEach var="review" items="${reviews}">
                        <c:set var="reviewerAvatarRaw"
                               value="${review.reviewer != null ? review.reviewer.avatar : ''}"/>
                        <c:set var="reviewerAvatarValue"
                               value="${not empty reviewerAvatarRaw ? reviewerAvatarRaw.trim() : ''}"/>
                        <c:set var="hasReviewerAvatar"
                               value="${not empty reviewerAvatarValue && reviewerAvatarValue != 'avatar/avatar.jpg'}"/>
                        <c:set var="reviewerAvatarSrc" value=""/>
                        <c:if test="${hasReviewerAvatar}">
                            <c:choose>
                                <c:when test="${reviewerAvatarValue.startsWith('http')}">
                                    <c:set var="reviewerAvatarSrc" value="${reviewerAvatarValue}"/>
                                </c:when>
                                <c:when test="${reviewerAvatarValue.startsWith('/static/')}">
                                    <c:set var="reviewerAvatarSrc"
                                           value="${pageContext.request.contextPath}${reviewerAvatarValue}"/>
                                </c:when>
                                <c:when test="${reviewerAvatarValue.startsWith('static/')}">
                                    <c:set var="reviewerAvatarSrc"
                                           value="${pageContext.request.contextPath}/${reviewerAvatarValue}"/>
                                </c:when>
                                <c:when test="${reviewerAvatarValue.startsWith('/')}">
                                    <c:set var="reviewerAvatarSrc"
                                           value="${pageContext.request.contextPath}${reviewerAvatarValue}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="reviewerAvatarSrc"
                                           value="${pageContext.request.contextPath}/static/${reviewerAvatarValue}"/>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <div class="review-item">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">
                                        <c:choose>
                                            <c:when test="${hasReviewerAvatar}">
                                                <img src="${reviewerAvatarSrc}"
                                                     alt="Avatar người đánh giá"
                                                     class="reviewer-avatar-image"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                <div class="reviewer-avatar-fallback" style="display: none;">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="reviewer-avatar-fallback">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="reviewer-meta">
                                                        <span class="reviewer-name">
                                                            <c:choose>
                                                                <c:when test="${not empty review.reviewerName}">
                                                                    ${review.reviewerName}
                                                                </c:when>
                                                                <c:otherwise>Ẩn danh</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                        <span class="review-date">
                                                            <fmt:formatDate value="${review.createdAt}"
                                                                            pattern="dd/MM/yyyy"/>
                                                        </span>
                                    </div>
                                </div>
                                <div class="review-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                                        <span
                                                                class="star ${i <= review.rating ? 'filled' : ''}">★</span>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="review-content">
                                <p>${review.content}</p>
                            </div>
                            <c:if test="${not empty review.images}">
                                <div class="review-images-grid">
                                    <c:forEach var="reviewImg" items="${review.images}">
                                        <div class="review-thumb-item"
                                             onclick="openReviewLightbox('${pageContext.request.contextPath}/static/${reviewImg.imageUrl}')">
                                            <img src="${pageContext.request.contextPath}/static/${reviewImg.imageUrl}"
                                                 alt="Ảnh đánh giá từ khách hàng" loading="lazy">
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                    <c:if test="${empty reviews}">
                        <div class="no-reviews">
                            <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

</main>

<div class="review-lightbox-overlay" id="reviewLightbox" onclick="closeReviewLightbox(event)">
    <button class="review-lightbox-close" id="reviewLightboxClose"
            onclick="closeReviewLightbox(event)" aria-label="Đóng">&times;
    </button>
    <div class="review-lightbox-content">
        <img id="reviewLightboxImg" src="" alt="Ảnh đánh giá phóng to">
    </div>
</div>

<jsp:include page="/layout/footer.jsp"/>

<script>
    function changeMainImage(src, thumbnailEl) {
        const mainImg = document.getElementById('main-product-image');
        if (mainImg) mainImg.src = src;

        if (thumbnailEl) {
            document.querySelectorAll('.thumbnail-images .thumbnail').forEach(t => t.classList.remove('active'));
            thumbnailEl.classList.add('active');
        }
    }

    const minusBtn = document.querySelector('.qty-btn.minus');
    const plusBtn = document.querySelector('.qty-btn.plus');
    const qtyInput = document.getElementById('quantity');
    const cartQty = document.getElementById('cartQuantity');

    if (minusBtn && plusBtn && qtyInput) {
        minusBtn.addEventListener('click', function () {
            let value = parseInt(qtyInput.value) || 1;
            if (value > 1) {
                qtyInput.value = value - 1;
                if (cartQty) cartQty.value = value - 1;
            }
        });

        plusBtn.addEventListener('click', function () {
            let value = parseInt(qtyInput.value) || 1;
            const max = parseInt(qtyInput.getAttribute('max')) || 999;
            if (value < max) {
                qtyInput.value = value + 1;
                if (cartQty) cartQty.value = value + 1;
            }
        });
    }

    document.querySelectorAll('.variant-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.variant-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const variantId = this.dataset.variantId;
            const salePrice = parseFloat(this.dataset.salePrice);
            const originalPrice = parseFloat(this.dataset.originalPrice);
            const stock = parseInt(this.dataset.stock || "0");

            let discountPercent = 0;
            if (originalPrice > salePrice) {
                discountPercent = Math.round(((originalPrice - salePrice) / originalPrice) * 100);
            }

            const selectedVariantInput = document.getElementById('selectedVariantId');
            if (selectedVariantInput) selectedVariantInput.value = variantId;

            updatePriceDisplay(salePrice, originalPrice, discountPercent);
            updateStockDisplay(stock);
            updateQuantityControls(stock);
            updateButtonsState(stock);
        });
    });

    function updatePriceDisplay(salePrice, originalPrice, discountPercent) {
        const priceCurrentEl = document.querySelector('.price-current');
        const priceOldEl = document.querySelector('.price-old');
        const discountEl = document.querySelector('.discount-percent');

        if (priceCurrentEl) priceCurrentEl.textContent = formatNumber(salePrice) + '₫';

        if (originalPrice > salePrice) {
            if (priceOldEl) {
                priceOldEl.textContent = formatNumber(originalPrice) + '₫';
                priceOldEl.style.display = 'inline';
            }
            if (discountEl) {
                discountEl.textContent = '-' + discountPercent + '%';
                discountEl.style.display = 'inline';
            }
        } else {
            if (priceOldEl) priceOldEl.style.display = 'none';
            if (discountEl) discountEl.style.display = 'none';
        }
    }

    function updateStockDisplay(stock) {
        const stockLine = document.querySelector('.stock-line');
        if (stockLine) {
            if (stock > 0) stockLine.innerHTML = '<span class="in-stock">Còn ' + stock + ' sản phẩm</span>';
            else stockLine.innerHTML = '<span class="out-of-stock">Hết hàng</span>';
        }
    }

    function updateQuantityControls(stock) {
        if (!qtyInput) return;

        qtyInput.setAttribute('max', stock);

        const currentQty = parseInt(qtyInput.value) || 1;
        if (currentQty > stock) {
            qtyInput.value = stock > 0 ? 1 : 0;
            if (cartQty) cartQty.value = qtyInput.value;
        }

        if (stock <= 0) {
            qtyInput.disabled = true;
            if (minusBtn) minusBtn.disabled = true;
            if (plusBtn) plusBtn.disabled = true;
        } else {
            qtyInput.disabled = false;
            if (minusBtn) minusBtn.disabled = false;
            if (plusBtn) plusBtn.disabled = false;
        }
    }

    function updateButtonsState(stock) {
        const addToCartBtn = document.querySelector('.btn-add-cart');
        const buyNowBtn = document.querySelector('.btn-buy-now');

        if (stock <= 0) {
            if (addToCartBtn) {
                addToCartBtn.disabled = true;
                addToCartBtn.style.opacity = '0.6';
                addToCartBtn.style.cursor = 'not-allowed';
            }
            if (buyNowBtn) {
                buyNowBtn.disabled = true;
                buyNowBtn.style.opacity = '0.6';
                buyNowBtn.style.cursor = 'not-allowed';
            }
        } else {
            if (addToCartBtn) {
                addToCartBtn.disabled = false;
                addToCartBtn.style.opacity = '1';
                addToCartBtn.style.cursor = 'pointer';
            }
            if (buyNowBtn) {
                buyNowBtn.disabled = false;
                buyNowBtn.style.opacity = '1';
                buyNowBtn.style.cursor = 'pointer';
            }
        }
    }

    function formatNumber(num) {
        return Math.round(num).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function normalizeHeadingLabel(label) {
        const raw = label.replace(/[:：]\s*$/, '').trim();
        if (!raw) return '';

        const upper = raw.toLocaleUpperCase('vi-VN');
        const lower = raw.toLocaleLowerCase('vi-VN');
        if (raw === upper && raw !== lower) {
            return raw
                .toLocaleLowerCase('vi-VN')
                .split(/\s+/)
                .map(word => word.charAt(0).toLocaleUpperCase('vi-VN') + word.slice(1))
                .join(' ');
        }
        return raw.charAt(0).toLocaleUpperCase('vi-VN') + raw.slice(1);
    }

    function isSectionHeading(block) {
        const text = (block || '').replace(/\s+/g, ' ').trim();
        if (!text || text.length > 60) return false;

        const stripped = text.replace(/[:：]\s*$/, '');
        const upper = stripped.toLocaleUpperCase('vi-VN');
        const lower = stripped.toLocaleLowerCase('vi-VN');
        const isUpperHeading = stripped === upper && stripped !== lower;
        const isCommonHeading = /^(mô tả sản phẩm|công dụng nổi bật|lưu ý|thành phần|hướng dẫn sử dụng)$/i.test(stripped);

        return isUpperHeading || isCommonHeading;
    }

    function parseContentBlock(block) {
        const lines = block.split('\n').map(line => line.trim()).filter(Boolean);
        const items = [];
        const bulletPattern = /^[-•*]\s+/;
        let paragraphLines = [];
        let bulletItems = [];

        function flushParagraph() {
            if (!paragraphLines.length) return;
            items.push({
                type: 'paragraph',
                text: paragraphLines.join(' ')
            });
            paragraphLines = [];
        }

        function flushBullets() {
            if (!bulletItems.length) return;
            items.push({
                type: 'list',
                values: bulletItems.slice()
            });
            bulletItems = [];
        }

        lines.forEach(line => {
            if (bulletPattern.test(line)) {
                flushParagraph();
                bulletItems.push(line.replace(bulletPattern, '').trim());
                return;
            }
            flushBullets();
            paragraphLines.push(line);
        });

        flushParagraph();
        flushBullets();
        return items;
    }

    function buildDescriptionSections(rawText) {
        const cleaned = rawText.replace(/\r\n?/g, '\n').trim();
        if (!cleaned) return [];

        const blocks = cleaned.split(/\n{2,}/).map(block => block.trim()).filter(Boolean);
        const sections = [];
        let currentSection = {
            title: 'Mô tả sản phẩm',
            items: []
        };

        blocks.forEach(block => {
            if (isSectionHeading(block)) {
                if (currentSection.items.length) {
                    sections.push(currentSection);
                }
                currentSection = {
                    title: normalizeHeadingLabel(block),
                    items: []
                };
                return;
            }

            const parsedItems = parseContentBlock(block);
            if (parsedItems.length) {
                currentSection.items.push(...parsedItems);
            }
        });

        if (currentSection.items.length) {
            sections.push(currentSection);
        }

        if (!sections.length) {
            sections.push({
                title: 'Mô tả sản phẩm',
                items: [{type: 'paragraph', text: cleaned}]
            });
        }

        return sections;
    }

    function getSectionMeta(title) {
        const normalized = (title || '').toLocaleLowerCase('vi-VN');
        if (normalized.includes('công dụng')) {
            return {key: 'usage'};
        }
        if (normalized.includes('lưu ý')) {
            return {key: 'note'};
        }
        if (normalized.includes('thành phần')) {
            return {key: 'ingredient'};
        }
        if (normalized.includes('hướng dẫn')) {
            return {key: 'guide'};
        }
        return {key: 'overview'};
    }

    function renderDescriptionContent() {
        const rawEl = document.getElementById('description-raw');
        const renderedEl = document.getElementById('description-rendered');
        const fallbackEl = document.getElementById('description-fallback');
        const toggleWrap = document.getElementById('description-toggle-wrap');
        const toggleBtn = document.getElementById('description-toggle-btn');

        if (!rawEl || !renderedEl || !fallbackEl) return;

        const rawText = (rawEl.textContent || '').trim();
        if (!rawText) return;

        const sections = buildDescriptionSections(rawText);
        if (!sections.length) return;

        renderedEl.innerHTML = '';

        function appendEmphasizedText(targetEl, text) {
            const normalized = (text || '').trim();
            if (!normalized) return;

            const headingLikePattern = /^([^:]{2,48}):\s+(.+)$/;
            const matched = normalized.match(headingLikePattern);

            if (!matched) {
                targetEl.textContent = normalized;
                return;
            }

            const label = matched[1].trim();
            const body = matched[2].trim();
            const wordCount = label ? label.split(/\s+/).length : 0;

            if (!label || !body || wordCount > 6) {
                targetEl.textContent = normalized;
                return;
            }

            const strong = document.createElement('strong');
            strong.textContent = label + ': ';
            targetEl.appendChild(strong);
            targetEl.appendChild(document.createTextNode(body));
        }

        const fragment = document.createDocumentFragment();
        const sectionElements = [];
        sections.forEach(section => {
            if (!section.items || !section.items.length) return;
            const sectionMeta = getSectionMeta(section.title);

            const sectionEl = document.createElement('section');
            sectionEl.className = 'description-section section-' + sectionMeta.key;

            const title = document.createElement('h3');
            title.className = 'description-section-title';
            title.textContent = section.title || 'Mô tả sản phẩm';
            sectionEl.appendChild(title);

            const sectionBody = document.createElement('div');
            sectionBody.className = 'description-section-body';

            section.items.forEach(item => {
                if (item.type === 'paragraph' && item.text) {
                    const paragraph = document.createElement('p');
                    appendEmphasizedText(paragraph, item.text);
                    sectionBody.appendChild(paragraph);
                    return;
                }

                if (item.type === 'list' && item.values && item.values.length) {
                    const list = document.createElement('ul');
                    list.className = 'description-list';
                    item.values.forEach(value => {
                        if (!value) return;
                        const listItem = document.createElement('li');
                        listItem.className = 'description-list-item';
                        appendEmphasizedText(listItem, value);
                        list.appendChild(listItem);
                    });
                    if (list.children.length > 0) {
                        sectionBody.appendChild(list);
                    }
                }
            });

            if (sectionBody.children.length > 0) {
                sectionEl.appendChild(sectionBody);
                fragment.appendChild(sectionEl);
                sectionElements.push(sectionEl);
            }
        });

        if (!sectionElements.length) return;

        renderedEl.appendChild(fragment);
        renderedEl.hidden = false;
        fallbackEl.hidden = true;

        const observer = 'IntersectionObserver' in window
            ? new IntersectionObserver((entries, currentObserver) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('is-visible');
                        currentObserver.unobserve(entry.target);
                    }
                });
            }, {threshold: 0.2, rootMargin: '0px 0px -10% 0px'})
            : null;

        function revealSection(sectionEl) {
            if (!sectionEl) return;
            if (observer) observer.observe(sectionEl);
            else sectionEl.classList.add('is-visible');
        }

        const collapseLimit = 3;
        let expanded = sectionElements.length <= collapseLimit;

        function applySectionVisibility() {
            sectionElements.forEach((sectionEl, index) => {
                const shouldShow = expanded || index < collapseLimit;
                sectionEl.hidden = !shouldShow;
                if (shouldShow) revealSection(sectionEl);
            });

            if (toggleBtn) {
                toggleBtn.textContent = expanded ? 'Thu gọn' : 'Xem thêm';
                toggleBtn.setAttribute('aria-expanded', expanded ? 'true' : 'false');
            }
        }

        if (toggleWrap && toggleBtn && sectionElements.length > collapseLimit) {
            toggleWrap.hidden = false;
            toggleBtn.onclick = function () {
                expanded = !expanded;
                applySectionVisibility();
            };
        } else if (toggleWrap) {
            toggleWrap.hidden = true;
            if (toggleBtn) {
                toggleBtn.onclick = null;
                toggleBtn.setAttribute('aria-expanded', 'false');
            }
        }

        applySectionVisibility();
    }

    renderDescriptionContent();

    const tabButtons = document.querySelectorAll('.detail-page-btn');
    const tabContents = document.querySelectorAll('.detail-page-content');

    function setActiveTab(tabId) {
        tabButtons.forEach(button => button.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));

        const activeButton = document.querySelector('.detail-page-btn[data-tab="' + tabId + '"]');
        const activeContent = document.getElementById(tabId);

        if (activeButton) activeButton.classList.add('active');
        if (activeContent) activeContent.classList.add('active');
    }

    if (tabButtons.length && tabContents.length) {
        tabButtons.forEach(button => {
            button.addEventListener('click', function () {
                const tabId = this.dataset.tab;
                if (tabId) {
                    setActiveTab(tabId);
                    if (history.replaceState) history.replaceState(null, '', '#' + tabId);
                    else window.location.hash = tabId;
                }
            });
        });

        const hashTab = window.location.hash ? window.location.hash.substring(1) : '';
        if (hashTab) setActiveTab(hashTab);
        else {
            const defaultActive = document.querySelector('.detail-page-btn.active');
            if (!defaultActive) {
                const firstTab = tabButtons[0];
                if (firstTab && firstTab.dataset.tab) setActiveTab(firstTab.dataset.tab);
            }
        }
    }

    const buyNowBtn = document.querySelector('.btn-buy-now');
    if (buyNowBtn) {
        buyNowBtn.addEventListener('click', function () {
            if (this.disabled) return;

            const form = document.getElementById('add-to-cart-form');
            const actionInput = document.getElementById('cartAction');
            if (!form) return;

            if (actionInput) actionInput.value = 'buy_now';
            form.submit();
            if (actionInput) actionInput.value = 'add_to_cart';
        });
    }

    function openReviewLightbox(src) {
        var overlay = document.getElementById('reviewLightbox');
        var img = document.getElementById('reviewLightboxImg');
        if (!overlay || !img) return;

        img.src = src;
        overlay.classList.add('is-active');
        document.body.style.overflow = 'hidden';
    }

    function closeReviewLightbox(e) {
        if (e && e.target && e.target.id === 'reviewLightboxImg') return;

        var overlay = document.getElementById('reviewLightbox');
        if (!overlay) return;

        overlay.classList.remove('is-active');
        document.body.style.overflow = '';
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeReviewLightbox(null);
    });
</script>
</body>
</html>