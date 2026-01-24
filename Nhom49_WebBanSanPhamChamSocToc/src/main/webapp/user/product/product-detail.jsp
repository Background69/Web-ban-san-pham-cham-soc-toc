<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;900&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style_for_product_detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

<jsp:include page="/layout/header.jsp"/>

<main class="product-detail-main">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <span class="separator">›</span>
        <c:if test="${product.category != null}">
            <a href="${pageContext.request.contextPath}/products?category=${product.category.categorySlug}">
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
                        <img id="main-product-image"
                             src="${pageContext.request.contextPath}/static/images/${product.primaryImage.imageUrl}"
                             alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <img id="main-product-image"
                             src="${pageContext.request.contextPath}/static/images/default-product.png"
                             alt="${product.productName}">
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty product.images}">
                <div class="thumbnail-images">
                    <c:forEach var="image" items="${product.images}">
                        <img class="thumbnail"
                             src="${pageContext.request.contextPath}/static/images/${image.imageUrl}"
                             alt="${product.productName}"
                             onclick="changeMainImage('${pageContext.request.contextPath}/static/images/${image.imageUrl}')">
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

                        <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                            <span class="price-old">
                                <fmt:formatNumber value="${product.defaultVariant.originalPrice}" type="number"/>₫
                            </span>
                            <span class="discount-percent">-${product.defaultVariant.discountPercent}%</span>
                        </c:if>
                    </div>
                    <div class="price-note">
                        <i class="fa-solid fa-shield"></i>
                        <span>Giá đã bao gồm VAT (nếu có)</span>
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

            <!-- Quantity -->
            <div class="product-section-options">
                <div class="option-group">
                    <label>Số lượng:</label>
                    <div class="quantity-selector">
                        <button type="button" class="qty-btn minus">-</button>
                        <input type="number" id="quantity" name="quantity" value="1" min="1"
                               max="${product.defaultVariant.stockQuantity}">
                        <button type="button" class="qty-btn plus">+</button>
                    </div>

                    <div class="stock-line">
                        <c:choose>
                            <c:when test="${product.defaultVariant.stockQuantity > 0}">
                                <span class="in-stock">Còn ${product.defaultVariant.stockQuantity} sản phẩm</span>
                            </c:when>
                            <c:otherwise>
                                <span class="out-of-stock">Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Buttons -->
            <div class="product-section-btn">
                <form id="add-to-cart-form" action="${pageContext.request.contextPath}/cart/add" method="post" style="flex:1;">
                    <input type="hidden" name="variantId" id="selectedVariantId" value="${product.defaultVariant.variantId}">
                    <input type="hidden" name="quantity" id="cartQuantity" value="1">

                    <button type="submit" class="btn btn-add-cart"
                            <c:if test="${product.defaultVariant.stockQuantity <= 0}">disabled</c:if>>
                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                    </button>
                </form>

                <button type="button" class="btn btn-buy-now"
                        <c:if test="${product.defaultVariant.stockQuantity <= 0}">disabled</c:if>>
                    <i class="fas fa-bolt"></i> Mua ngay
                </button>
            </div>

            <div class="product-meta">
                <c:if test="${not empty product.origin}">
                    <p><strong>Xuất xứ:</strong> ${product.origin}</p>
                </c:if>
                <c:if test="${not empty product.category}">
                    <p><strong>Danh mục:</strong>
                        <a href="${pageContext.request.contextPath}/products?category=${product.category.categorySlug}">
                                ${product.category.categoryName}
                        </a>
                    </p>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <div class="product-main-detail-page">
        <div class="main-detail-header">
            <button class="detail-page-btn active" data-tab="description">Mô tả sản phẩm</button>
            <button class="detail-page-btn" data-tab="reviews">Đánh giá (${reviewCount})</button>
        </div>

        <div id="description" class="detail-page-content active">
            <c:choose>
                <c:when test="${not empty product.fullDescription}">
                    <div class="description-content">${product.fullDescription}</div>
                </c:when>
                <c:otherwise>
                    <p>Chưa có mô tả chi tiết cho sản phẩm này.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="reviews" class="detail-page-content">
            <div class="reviews-summary">
                <div class="overall-rating">
                    <div class="rating-number-large">${averageRating}</div>
                    <div class="rating-stars-large">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="fas fa-star"></i>
                        </c:forEach>
                    </div>
                    <div class="rating-count-text">${reviewCount} đánh giá</div>
                </div>

                <div class="rating-breakdown">
                    <c:forEach var="entry" items="${ratingStats}">
                        <div class="rating-row">
                            <span class="star-label">${entry.key}★</span>
                            <div class="rating-bar"><div class="rating-fill" style="width:${entry.value}%"></div></div>
                            <span class="rating-percent">${entry.value}%</span>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="reviews-list">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="reviewer-info">
                                        <div class="reviewer-avatar">
                                            <i class="fa-solid fa-user"></i>
                                        </div>
                                        <div>
                                            <div class="reviewer-name">${review.user.username}</div>
                                            <div class="review-date">
                                                <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="review-rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star" style="${i <= review.rating ? '' : 'opacity:.25'}"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="review-content">${review.comment}</div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-reviews">
                            <i class="fas fa-comment-slash"></i>
                            <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script>
    function changeMainImage(src) {
        document.getElementById('main-product-image').src = src;
    }

    const minusBtn = document.querySelector('.qty-btn.minus');
    const plusBtn = document.querySelector('.qty-btn.plus');
    const qtyInput = document.getElementById('quantity');
    const cartQty = document.getElementById('cartQuantity');

    if (minusBtn && plusBtn && qtyInput) {
        minusBtn.addEventListener('click', function() {
            let value = parseInt(qtyInput.value) || 1;
            if (value > 1) {
                qtyInput.value = value - 1;
                cartQty.value = value - 1;
            }
        });

        plusBtn.addEventListener('click', function() {
            let value = parseInt(qtyInput.value) || 1;
            const max = parseInt(qtyInput.getAttribute('max')) || 999;
            if (value < max) {
                qtyInput.value = value + 1;
                cartQty.value = value + 1;
            }
        });

        qtyInput.addEventListener('change', function() {
            cartQty.value = this.value;
        });
    }

    document.querySelectorAll('.variant-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.variant-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            document.getElementById('selectedVariantId').value = this.dataset.variantId;

            const stock = parseInt(this.dataset.stock || "0");
            qtyInput.max = stock;
        });
    });

    document.querySelectorAll('.detail-page-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.detail-page-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.detail-page-content').forEach(p => p.classList.remove('active'));

            this.classList.add('active');
            document.getElementById(this.dataset.tab).classList.add('active');
        });
    });

    const buyNowBtn = document.querySelector('.btn-buy-now');
    if (buyNowBtn) {
        buyNowBtn.addEventListener('click', function() {
            const form = document.getElementById('add-to-cart-form');
            const originalAction = form.action;
            form.action = '${pageContext.request.contextPath}/checkout?buyNow=true';
            form.submit();
            form.action = originalAction;
        });
    }
</script>

</body>
</html>
