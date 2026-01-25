<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
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

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style_for_product_detail.css">
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
                        <img id="main-product-image" class="product-image"
                             src="${pageContext.request.contextPath}/static/images/${product.primaryImage.imageUrl}"
                             alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <img id="main-product-image" class="product-image"
                             src="${pageContext.request.contextPath}/static/images/default-product.png"
                             alt="${product.productName}">
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty product.images}">
                <div class="thumbnail-images">
                    <c:forEach var="image" items="${product.images}" varStatus="status">
                        <img class="thumbnail ${status.first ? 'active' : ''}"
                             src="${pageContext.request.contextPath}/static/images/${image.imageUrl}"
                             data-full="${pageContext.request.contextPath}/static/images/${image.imageUrl}"
                             alt="${product.productName}"
                             onclick="changeMainImage('${pageContext.request.contextPath}/static/images/${image.imageUrl}', this)">
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
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="product-section-btn">
                <form id="add-to-cart-form" action="${pageContext.request.contextPath}/cart/add" method="post"
                      style="flex:1;">
                    <input type="hidden" name="variantId" id="selectedVariantId"
                           value="${product.defaultVariant.variantId}">
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
                    <c:if test="${not empty product.fullDescription}">
                        <p>${product.fullDescription}</p>
                    </c:if>
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
                                        <c:when test="${product.brand != null && not empty product.brand.origin}">
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
                                            <a href="${pageContext.request.contextPath}/products?category=${product.category.categorySlug}">
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
                                                    <span class="variant-badge">${variant.variantName}</span>
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
                <!-- Review Summary -->
                <div class="review-summary">
                    <div class="rating-overview">
                        <div class="rating-big">
                            <fmt:formatNumber value="${averageRating}" maxFractionDigits="1" minFractionDigits="1"/>
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
                <!-- Write Review Form -->
                <c:if test="${not empty sessionScope.user}">
                    <div class="write-review">
                        <h3>Viết đánh giá của bạn</h3>
                        <form action="${pageContext.request.contextPath}/review" method="post" class="review-form">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <div class="rating-input">
                                <label>Đánh giá:</label>
                                <div class="star-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <input type="radio" name="rating" value="${6-i}" id="star${6-i}" required>
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
                            <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                        </form>
                    </div>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <div class="login-to-review">
                        <p>Vui lòng <a
                                href="${pageContext.request.contextPath}/auth/login?redirect=/product/${product.productSlug}">đăng
                            nhập</a> để viết đánh giá.</p>
                    </div>
                </c:if>

                <!-- Review List -->
                <div class="reviews-list">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-item">
                            <div class="review-header">
                                <div class="reviewer-info">
                                    <span class="reviewer-name">
                                        <c:choose>
                                            <c:when test="${not empty review.reviewerName}">
                                                ${review.reviewerName}
                                            </c:when>
                                            <c:otherwise>Ẩn danh</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="review-date">
                                        <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                                <div class="review-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="star ${i <= review.rating ? 'filled' : ''}">★</span>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="review-content">
                                <p>${review.content}</p>
                            </div>
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

<jsp:include page="/layout/footer.jsp"/>

<script>

    function changeMainImage(src, thumbnailEl) {
        const mainImg = document.getElementById('main-product-image');
        if (mainImg) {
            mainImg.src = src;
        }
        // Update active thumbnail
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
            // Remove active from all variants
            document.querySelectorAll('.variant-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            // Get variant data
            const variantId = this.dataset.variantId;
            const salePrice = parseFloat(this.dataset.salePrice);
            const originalPrice = parseFloat(this.dataset.originalPrice);
            const stock = parseInt(this.dataset.stock || "0");

            // Calculate discount percent
            let discountPercent = 0;
            if (originalPrice > salePrice) {
                discountPercent = Math.round(((originalPrice - salePrice) / originalPrice) * 100);
            }

            // Update hidden input
            const selectedVariantInput = document.getElementById('selectedVariantId');
            if (selectedVariantInput) {
                selectedVariantInput.value = variantId;
            }

            // ===== UPDATE PRICE DISPLAY =====
            updatePriceDisplay(salePrice, originalPrice, discountPercent);

            // ===== UPDATE STOCK =====
            updateStockDisplay(stock);

            // ===== UPDATE QUANTITY INPUT =====
            updateQuantityControls(stock);

            // ===== UPDATE BUTTONS STATE =====
            updateButtonsState(stock);
        });
    });

    function updatePriceDisplay(salePrice, originalPrice, discountPercent) {
        const priceCurrentEl = document.querySelector('.price-current');
        const priceOldEl = document.querySelector('.price-old');
        const discountEl = document.querySelector('.discount-percent');

        if (priceCurrentEl) {
            priceCurrentEl.textContent = formatNumber(salePrice) + '₫';
        }

        // Show/hide old price and discount
        if (originalPrice > salePrice) {
            // Có giảm giá
            if (priceOldEl) {
                priceOldEl.textContent = formatNumber(originalPrice) + '₫';
                priceOldEl.style.display = 'inline';
            }
            if (discountEl) {
                discountEl.textContent = '-' + discountPercent + '%';
                discountEl.style.display = 'inline';
            }
        } else {
            // Không giảm giá
            if (priceOldEl) {
                priceOldEl.style.display = 'none';
            }
            if (discountEl) {
                discountEl.style.display = 'none';
            }
        }
    }

    function updateStockDisplay(stock) {
        const stockLine = document.querySelector('.stock-line');
        if (stockLine) {
            if (stock > 0) {
                stockLine.innerHTML = '<span class="in-stock">Còn ' + stock + ' sản phẩm</span>';
            } else {
                stockLine.innerHTML = '<span class="out-of-stock">Hết hàng</span>';
            }
        }
    }

    function updateQuantityControls(stock) {
        if (qtyInput) {
            qtyInput.setAttribute('max', stock);

            // Reset quantity về 1 nếu stock mới < quantity hiện tại
            const currentQty = parseInt(qtyInput.value) || 1;
            if (currentQty > stock) {
                qtyInput.value = stock > 0 ? 1 : 0;
                if (cartQty) cartQty.value = qtyInput.value;
            }

            // Disable/enable quantity buttons
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

    const tabButtons = document.querySelectorAll('.detail-page-btn');
    const tabContents = document.querySelectorAll('.detail-page-content');

    function setActiveTab(tabId) {
        tabButtons.forEach(button => button.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));

        const activeButton = document.querySelector('.detail-page-btn[data-tab="' + tabId + '"]');
        const activeContent = document.getElementById(tabId);

        if (activeButton) {
            activeButton.classList.add('active');
        }
        if (activeContent) {
            activeContent.classList.add('active');
        }
    }

    if (tabButtons.length && tabContents.length) {
        tabButtons.forEach(button => {
            button.addEventListener('click', function () {
                const tabId = this.dataset.tab;
                if (tabId) {
                    setActiveTab(tabId);
                    if (history.replaceState) {
                        history.replaceState(null, '', '#' + tabId);
                    } else {
                        window.location.hash = tabId;
                    }
                }
            });
        });

        const hashTab = window.location.hash ? window.location.hash.substring(1) : '';
        if (hashTab) {
            setActiveTab(hashTab);
        } else {
            const defaultActive = document.querySelector('.detail-page-btn.active');
            if (!defaultActive) {
                const firstTab = tabButtons[0];
                if (firstTab && firstTab.dataset.tab) {
                    setActiveTab(firstTab.dataset.tab);
                }
            }
        }
    }

    const buyNowBtn = document.querySelector('.btn-buy-now');
    if (buyNowBtn) {
        buyNowBtn.addEventListener('click', function () {
            if (this.disabled) return;

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

