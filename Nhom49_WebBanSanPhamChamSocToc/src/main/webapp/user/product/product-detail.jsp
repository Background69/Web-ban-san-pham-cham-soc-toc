<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style_for_product_detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="product-detail-main">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <span class="separator">›</span>
        <c:if test="${product.category != null}">
            <a href="${pageContext.request.contextPath}/products?category=${product.category.categorySlug}">${product.category.categoryName}</a>
            <span class="separator">›</span>
        </c:if>
        <span class="current">${product.productName}</span>
    </nav>

    <div class="product-detail-container">
        <!-- Product Images -->
        <div class="product-images">
            <div class="main-image">
                <c:choose>
                    <c:when test="${not empty product.primaryImage}">
                        <img id="main-product-image" src="${pageContext.request.contextPath}/static/images/${product.primaryImage.imageUrl}"
                             alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <img id="main-product-image" src="${pageContext.request.contextPath}/static/images/default-product.png"
                             alt="${product.productName}">
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${not empty product.images}">
                <div class="thumbnail-images">
                    <c:forEach var="image" items="${product.images}">
                        <img src="${pageContext.request.contextPath}/static/images/${image.imageUrl}"
                             alt="${product.productName}"
                             onclick="changeMainImage('${pageContext.request.contextPath}/static/images/${image.imageUrl}')"
                             class="thumbnail">
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <!-- Product Info -->
        <div class="product-info">
            <h1 class="product-title">${product.productName}</h1>

            <!-- Brand -->
            <c:if test="${not empty product.brand}">
                <p class="product-brand">
                    <span>Thương hiệu:</span>
                    <a href="${pageContext.request.contextPath}/brand/${product.brand.brandSlug}">${product.brand.brandName}</a>
                </p>
            </c:if>

            <!-- Rating -->
            <div class="product-rating">
                <div class="rating-stars">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= averageRating}">
                                <i class="fas fa-star"></i>
                            </c:when>
                            <c:when test="${i - 0.5 <= averageRating}">
                                <i class="fas fa-star-half-alt"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="far fa-star"></i>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <span class="rating-text">${averageRating}/5</span>
                <span class="review-count">(${reviewCount} đánh giá)</span>
            </div>

            <!-- Price -->
            <div class="product-price">
                <c:if test="${not empty product.defaultVariant}">
                    <span class="current-price">
                        <fmt:formatNumber value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}" type="number"/>₫
                    </span>
                    <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                        <span class="original-price">
                            <fmt:formatNumber value="${product.defaultVariant.originalPrice}" type="number"/>₫
                        </span>
                        <span class="discount-badge">-${product.defaultVariant.discountPercent}%</span>
                    </c:if>
                </c:if>
            </div>

            <!-- Short Description -->
            <c:if test="${not empty product.shortDescription}">
                <div class="product-short-desc">
                    <p>${product.shortDescription}</p>
                </div>
            </c:if>

            <!-- Variants -->
            <c:if test="${not empty product.variants && product.variants.size() > 1}">
                <div class="product-variants">
                    <h4>Chọn loại:</h4>
                    <div class="variant-options">
                        <c:forEach var="variant" items="${product.variants}">
                            <button class="variant-btn ${variant.variantId == product.defaultVariant.variantId ? 'active' : ''}"
                                    data-variant-id="${variant.variantId}"
                                    data-original-price="${variant.originalPrice}"
                                    data-sale-price="${variant.salePrice != null ? variant.salePrice : variant.originalPrice}"
                                    data-stock="${variant.stockQuantity}">
                                    ${variant.variantName}
                            </button>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- Quantity -->
            <div class="quantity-section">
                <label>Số lượng:</label>
                <div class="quantity-control">
                    <button type="button" class="qty-btn minus">-</button>
                    <input type="number" id="quantity" name="quantity" value="1" min="1"
                           max="${product.defaultVariant.stockQuantity}">
                    <button type="button" class="qty-btn plus">+</button>
                </div>
                <span class="stock-info">
                    <c:choose>
                        <c:when test="${product.defaultVariant.stockQuantity > 0}">
                            Còn ${product.defaultVariant.stockQuantity} sản phẩm
                        </c:when>
                        <c:otherwise>
                            <span class="out-of-stock">Hết hàng</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <!-- Add to Cart -->
            <div class="product-actions">
                <form id="add-to-cart-form" action="${pageContext.request.contextPath}/cart/add" method="post">
                    <input type="hidden" name="variantId" id="selectedVariantId"
                           value="${product.defaultVariant.variantId}">
                    <input type="hidden" name="quantity" id="cartQuantity" value="1">
                    <button type="submit" class="btn-add-cart" ${product.defaultVariant.stockQuantity <= 0 ? 'disabled' : ''}>
                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                    </button>
                </form>
                <button class="btn-buy-now" ${product.defaultVariant.stockQuantity <= 0 ? 'disabled' : ''}>
                    <i class="fas fa-bolt"></i> Mua ngay
                </button>
            </div>

            <!-- Product Meta -->
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

    <!-- Product Description Tabs -->
    <div class="product-tabs">
        <div class="tab-buttons">
            <button class="tab-btn active" data-tab="description">Mô tả sản phẩm</button>
            <button class="tab-btn" data-tab="reviews">Đánh giá (${reviewCount})</button>
        </div>

        <div class="tab-content">
            <div id="description" class="tab-pane active">
                <c:choose>
                    <c:when test="${not empty product.fullDescription}">
                        ${product.fullDescription}
                    </c:when>
                    <c:otherwise>
                        <p>Chưa có mô tả chi tiết cho sản phẩm này.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div id="reviews" class="tab-pane">
                <!-- Rating Summary -->
                <div class="rating-summary">
                    <div class="rating-average">
                        <span class="big-number">${averageRating}</span>
                        <span class="out-of">/5</span>
                        <div class="total-reviews">${reviewCount} đánh giá</div>
                    </div>
                    <div class="rating-bars">
                        <c:forEach var="entry" items="${ratingStats}">
                            <div class="rating-bar-row">
                                <span>${entry.key} <i class="fas fa-star"></i></span>
                                <div class="bar">
                                    <div class="fill" style="width: ${entry.value}%"></div>
                                </div>
                                <span>${entry.value}%</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Reviews List -->
                <div class="reviews-list">
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach var="review" items="${reviews}">
                                <div class="review-item">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <img src="${pageContext.request.contextPath}/static/images/${not empty review.user.avatar ? review.user.avatar : 'avatar/avatar.jpg'}"
                                                 alt="${review.user.username}" class="reviewer-avatar">
                                            <span class="reviewer-name">${review.user.username}</span>
                                        </div>
                                        <div class="review-rating">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= review.rating ? 'active' : ''}"></i>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="review-date">
                                        <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                                    </div>
                                    <p class="review-content">${review.comment}</p>
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
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    // Change main image
    function changeMainImage(src) {
        document.getElementById('main-product-image').src = src;
    }

    // Quantity control
    document.querySelector('.qty-btn.minus').addEventListener('click', function() {
        const input = document.getElementById('quantity');
        let value = parseInt(input.value) || 1;
        if (value > 1) {
            input.value = value - 1;
            document.getElementById('cartQuantity').value = value - 1;
        }
    });

    document.querySelector('.qty-btn.plus').addEventListener('click', function() {
        const input = document.getElementById('quantity');
        let value = parseInt(input.value) || 1;
        const max = parseInt(input.getAttribute('max')) || 999;
        if (value < max) {
            input.value = value + 1;
            document.getElementById('cartQuantity').value = value + 1;
        }
    });

    document.getElementById('quantity').addEventListener('change', function() {
        document.getElementById('cartQuantity').value = this.value;
    });

    // Variant selection
    document.querySelectorAll('.variant-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.variant-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            document.getElementById('selectedVariantId').value = this.dataset.variantId;

            // Update price display
            const salePrice = this.dataset.salePrice;
            const originalPrice = this.dataset.originalPrice;
            const stock = this.dataset.stock;

            // Update stock info
            document.getElementById('quantity').max = stock;
            const stockInfo = document.querySelector('.stock-info');
            if (stock > 0) {
                stockInfo.innerHTML = 'Còn ' + stock + ' sản phẩm';
            } else {
                stockInfo.innerHTML = '<span class="out-of-stock">Hết hàng</span>';
            }
        });
    });

    // Tab switching
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));

            this.classList.add('active');
            document.getElementById(this.dataset.tab).classList.add('active');
        });
    });

    // Buy now
    document.querySelector('.btn-buy-now').addEventListener('click', function() {
        const form = document.getElementById('add-to-cart-form');
        const originalAction = form.action;
        form.action = '${pageContext.request.contextPath}/checkout?buyNow=true';
        form.submit();
        form.action = originalAction;
    });
</script>
</body>
</html>
