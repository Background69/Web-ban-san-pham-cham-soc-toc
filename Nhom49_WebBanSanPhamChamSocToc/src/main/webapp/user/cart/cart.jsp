<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - HairGlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/cart.css">
</head>
<body>
<jsp:include page="/layout/header.jsp"/>
<main class="cart-page">
    <div class="cart-container">
        <!-- Cart Header -->
        <div class="cart-header">
            <h1 class="cart-title">
                <i class="fas fa-shopping-cart"></i>
                Giỏ hàng của bạn
                <c:if test="${cartCount > 0}">
                    <span class="cart-count-badge">${cartCount} sản phẩm</span>
                </c:if>
            </h1>
        </div>

        <c:choose>
            <c:when test="${empty cartItems || cartCount == 0}">
                <div class="cart-empty-wrapper">
                    <div class="cart-empty">
                        <div class="cart-empty-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round" class="cart-empty-svg">
                                <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
                                <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                            </svg>
                        </div>
                        <h2 class="cart-empty-title">Giỏ hàng của bạn đang trống</h2>
                        <p class="cart-empty-text">
                            Hãy lấp đầy bằng những sản phẩm tốt nhất từ <strong>HairGlow</strong>!
                            Khám phá bộ sưu tập chăm sóc tóc cao cấp được yêu thích nhất.
                        </p>
                        <a href="${pageContext.request.contextPath}/store" class="cart-empty-btn">
                            <i class="fas fa-shopping-bag"></i> Khám phá cửa hàng
                        </a>
                    </div>

                    <c:if test="${not empty topProducts}">
                        <section class="cart-recommendations">
                            <div class="cart-reco-header">
                                <div class="cart-reco-divider"></div>
                                <h3 class="cart-reco-title">
                                    <i class="fas fa-fire"></i>
                                    Sản phẩm Bán chạy nhất
                                </h3>
                                <p class="cart-reco-subtitle">Được hàng nghìn khách hàng tin tưởng lựa chọn</p>
                            </div>
                            <div class="cart-reco-grid">
                                <c:forEach var="product" items="${topProducts}" end="3">
                                    <div class="cart-reco-card">
                                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}" class="cart-reco-card-image">
                                            <c:choose>
                                                <c:when test="${not empty product.primaryImageUrl}">
                                                    <img src="${product.primaryImageUrl}" alt="${product.productName}" loading="lazy"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/static/images/default-product.png" alt="${product.productName}" loading="lazy"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${product.soldQuantity > 50}">
                                                <span class="cart-reco-badge">
                                                    <i class="fas fa-bolt"></i> Hot
                                                </span>
                                            </c:if>
                                        </a>

                                        <div class="cart-reco-card-body">
                                            <c:if test="${not empty product.brandName}">
                                                <span class="cart-reco-brand">${product.brandName}</span>
                                            </c:if>
                                            <h4 class="cart-reco-name">
                                                <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                                    ${product.productName}
                                                </a>
                                            </h4>

                                            <c:if test="${product.averageRating != null && product.averageRating > 0}">
                                                <div class="cart-reco-rating">
                                                    <div class="cart-reco-stars">
                                                        <c:forEach begin="1" end="5" var="star">
                                                            <i class="fa${star <= product.averageRating ? 's' : (star - 0.5 <= product.averageRating ? 's' : 'r')} fa-star"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="cart-reco-review-count">(${product.reviewCount})</span>
                                                </div>
                                            </c:if>

                                            <div class="cart-reco-price">
                                                <c:choose>
                                                    <c:when test="${product.defaultVariant != null && product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                                        <span class="cart-reco-sale-price">
                                                            <fmt:formatNumber value="${product.defaultVariant.salePrice}" type="number"/>đ
                                                        </span>
                                                        <span class="cart-reco-original-price">
                                                            <fmt:formatNumber value="${product.defaultVariant.originalPrice}" type="number"/>đ
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${product.defaultVariant != null}">
                                                        <span class="cart-reco-current-price">
                                                            <fmt:formatNumber value="${product.defaultVariant.originalPrice}" type="number"/>đ
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="cart-reco-card-footer">
                                            <form action="${pageContext.request.contextPath}/cart/add" method="post" class="cart-reco-form">
                                                <input type="hidden" name="productId" value="${product.productId}"/>
                                                <input type="hidden" name="quantity" value="1"/>
                                                <button type="submit" class="cart-reco-add-btn">
                                                    <i class="fas fa-cart-plus"></i>
                                                    Thêm nhanh vào giỏ
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </section>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Cart Content -->
                <div class="cart-layout">
                    <!-- Cart Items -->
                    <div class="cart-items-section">
                        <div class="cart-items-header">
                            <span class="cart-items-title">Sản phẩm trong giỏ</span>
                            <form action="${pageContext.request.contextPath}/cart/clear" method="post"
                                  style="display: inline;" id="clearCartForm">
                                <button type="submit" class="cart-clear-btn">
                                    <i class="fas fa-trash-alt"></i> Xóa tất cả
                                </button>
                            </form>
                        </div>

                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item" data-variant-id="${item.variant.variantId}">
                                <div class="cart-item-image">
                                    <c:choose>
                                        <c:when test="${not empty item.imageUrl}">
                                            <img src="${item.imageUrl}" alt="${item.product.productName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/static/images/default-product.png"
                                                 alt="${item.product.productName}">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="cart-item-details">
                                    <h3 class="cart-item-name">
                                        <a
                                                href="${pageContext.request.contextPath}/product/${item.productSlug}">
                                                ${item.product.productName}
                                        </a>
                                    </h3>
                                    <p class="cart-item-variant">
                                        <i class="fas fa-cube"></i> ${item.variant.variantName}
                                    </p>
                                    <div class="cart-item-price">
                                                        <span class="cart-item-current-price">
                                                            <fmt:formatNumber
                                                                    value="${item.variant.salePrice != null ? item.variant.salePrice : item.variant.originalPrice}"
                                                                    type="number"/>đ
                                                        </span>
                                        <c:if
                                                test="${item.variant.salePrice != null && item.variant.salePrice < item.variant.originalPrice}">
                                                            <span class="cart-item-original-price">
                                                                <fmt:formatNumber value="${item.variant.originalPrice}"
                                                                                  type="number"/>đ
                                                            </span>
                                            <span class="cart-item-discount">
                                                                -
                                                                <fmt:formatNumber
                                                                        value="${(1 - item.variant.salePrice / item.variant.originalPrice) * 100}"
                                                                        maxFractionDigits="0"/>%
                                                            </span>
                                        </c:if>
                                    </div>
                                    <c:choose>
                                        <c:when test="${item.variant.stockQuantity > 0}">
                                                            <span class="cart-item-stock">
                                                                <i class="fas fa-check-circle"></i> Còn
                                                                ${item.variant.stockQuantity} sản phẩm
                                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                                            <span class="cart-item-stock out-of-stock">
                                                                <i class="fas fa-times-circle"></i> Hết hàng
                                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="cart-item-actions">
                                    <div class="quantity-control">
                                        <button type="button" class="quantity-btn"
                                                onclick="updateQuantity(${item.variant.variantId}, ${item.quantity - 1})">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input type="number" class="quantity-input"
                                               value="${item.quantity}" min="0"
                                               max="${item.variant.stockQuantity}"
                                               onchange="updateQuantity(${item.variant.variantId}, this.value)">
                                        <button type="button" class="quantity-btn"
                                                onclick="updateQuantity(${item.variant.variantId}, ${item.quantity + 1})"
                                            ${item.quantity>= item.variant.stockQuantity ? 'disabled' :
                                                    ''}>
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>
                                    <div class="cart-item-subtotal">
                                        <fmt:formatNumber
                                                value="${(item.variant.salePrice != null ? item.variant.salePrice : item.variant.originalPrice) * item.quantity}"
                                                type="number"/>đ
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart/remove"
                                          method="post" style="display: inline;" class="js-remove-form">
                                        <input type="hidden" name="variantId"
                                               value="${item.variant.variantId}">
                                        <button type="button" class="cart-item-remove js-remove-btn"
                                                title="Xóa sản phẩm">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Order Summary -->
                    <div class="order-summary">
                        <div class="order-summary-header">
                            <h2 class="order-summary-title">Tóm tắt đơn hàng</h2>
                        </div>
                        <div class="order-summary-body">

                            <!-- Price Breakdown -->
                            <div class="price-breakdown">
                                <div class="price-row">
                                    <span class="price-label">Tạm tính (${cartCount} sản phẩm)</span>
                                    <span class="price-value">
                                                        <fmt:formatNumber value="${subtotal}" type="number"/>đ
                                                    </span>
                                </div>
                                <div class="price-row">
                                    <span class="price-label">Phí vận chuyển</span>
                                    <span class="price-value">Tính khi thanh toán</span>
                                </div>
                                <div class="price-row total">
                                    <span class="price-label">Tổng cộng</span>
                                    <span class="price-value">
                                                        <fmt:formatNumber value="${subtotal}" type="number"/>đ
                                                    </span>
                                </div>
                            </div>

                            <!-- Checkout Button -->
                            <a href="${pageContext.request.contextPath}/checkout" class="checkout-btn">
                                <i class="fas fa-lock"></i> Tiến hành thanh toán
                            </a>

                            <!-- Benefits -->
                            <div class="cart-benefits">
                                <div class="benefit-item">
                                    <i class="fas fa-shield-alt"></i>
                                    <span>Thanh toán an toàn & bảo mật</span>
                                </div>
                                <div class="benefit-item">
                                    <i class="fas fa-truck"></i>
                                    <span>Giao hàng nhanh toàn quốc</span>
                                </div>
                                <div class="benefit-item">
                                    <i class="fas fa-undo"></i>
                                    <span>Đổi trả trong 7 ngày</span>
                                </div>
                                <div class="benefit-item">
                                    <i class="fas fa-headset"></i>
                                    <span>Hỗ trợ 24/7</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-spinner"></div>
</div>

<div class="hg-modal-overlay" id="hgConfirmModal">
    <div class="hg-modal-dialog">
        <div class="hg-modal-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <h3 class="hg-modal-title" id="hgModalTitle">Xóa sản phẩm?</h3>
        <p class="hg-modal-text" id="hgModalText">Bạn có chắc chắn muốn bỏ sản phẩm này khỏi giỏ hàng không?</p>
        <div class="hg-modal-actions">
            <button type="button" class="hg-modal-btn hg-modal-btn--cancel" id="hgModalCancel">Hủy</button>
            <button type="button" class="hg-modal-btn hg-modal-btn--confirm" id="hgModalConfirm">Xóa ngay</button>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';

    // Show toast notification
    function showToast(message, type) {
        type = type || 'success';
        var container = document.getElementById('toastContainer');
        var toast = document.createElement('div');
        toast.className = 'toast toast-' + type;

        var iconClass = 'check';
        if (type === 'error') iconClass = 'times';
        else if (type === 'warning') iconClass = 'exclamation';

        toast.innerHTML = '<div class="toast-icon"><i class="fas fa-' + iconClass + '"></i></div>' +
            '<span class="toast-message">' + message + '</span>' +
            '<button class="toast-close" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>';
        container.appendChild(toast);
        setTimeout(function () {
            toast.remove();
        }, 4000);
    }

    // Show/hide loading
    function showLoading() {
        document.getElementById('loadingOverlay').classList.add('show');
    }

    function hideLoading() {
        document.getElementById('loadingOverlay').classList.remove('show');
    }

    var hgModal = (function () {
        var overlay = document.getElementById('hgConfirmModal');
        var titleEl = document.getElementById('hgModalTitle');
        var textEl = document.getElementById('hgModalText');
        var cancelBtn = document.getElementById('hgModalCancel');
        var confirmBtn = document.getElementById('hgModalConfirm');
        var pendingAction = null;

        function open(options) {
            titleEl.textContent = options.title || 'Xóa sản phẩm?';
            textEl.textContent = options.text || 'Bạn có chắc chắn muốn bỏ sản phẩm này khỏi giỏ hàng không?';
            confirmBtn.textContent = options.confirmLabel || 'Xóa ngay';
            pendingAction = options.onConfirm || null;
            overlay.classList.add('is-active');
        }

        function close() {
            overlay.classList.remove('is-active');
            pendingAction = null;
        }

        cancelBtn.addEventListener('click', function () {
            close();
        });

        confirmBtn.addEventListener('click', function () {
            if (typeof pendingAction === 'function') {
                pendingAction();
            }
            close();
        });

        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                close();
            }
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && overlay.classList.contains('is-active')) {
                close();
            }
        });

        return { open: open, close: close };
    })();

    document.querySelectorAll('.js-remove-btn').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            var form = btn.closest('.js-remove-form');
            hgModal.open({
                title: 'Xóa sản phẩm?',
                text: 'Bạn có chắc chắn muốn bỏ sản phẩm này khỏi giỏ hàng không?',
                confirmLabel: 'Xóa ngay',
                onConfirm: function () {
                    form.submit();
                }
            });
        });
    });

    var clearForm = document.getElementById('clearCartForm');
    if (clearForm) {
        clearForm.addEventListener('submit', function (e) {
            e.preventDefault();
            hgModal.open({
                title: 'Xóa tất cả sản phẩm?',
                text: 'Toàn bộ sản phẩm trong giỏ hàng sẽ bị xóa. Bạn có chắc chắn?',
                confirmLabel: 'Xóa tất cả',
                onConfirm: function () {
                    clearForm.submit();
                }
            });
        });
    }

    function updateQuantity(variantId, quantity) {
        if (quantity < 1) {
            var removeForm = document.querySelector('.js-remove-form input[value="' + variantId + '"]');
            if (removeForm) {
                removeForm = removeForm.closest('form');
            }
            hgModal.open({
                title: 'Xóa sản phẩm?',
                text: 'Số lượng sẽ về 0. Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?',
                confirmLabel: 'Xóa ngay',
                onConfirm: function () {
                    if (removeForm) {
                        removeForm.submit();
                    }
                }
            });
            return;
        }

        showLoading();

        var form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/cart/update';

        var variantInput = document.createElement('input');
        variantInput.type = 'hidden';
        variantInput.name = 'variantId';
        variantInput.value = variantId;

        var quantityInput = document.createElement('input');
        quantityInput.type = 'hidden';
        quantityInput.name = 'quantity';
        quantityInput.value = quantity;

        form.appendChild(variantInput);
        form.appendChild(quantityInput);
        document.body.appendChild(form);
        form.submit();
    }

    <c:if test="${not empty successMessage}">
    showToast('${successMessage}', 'success');
    </c:if>

    <c:if test="${not empty errorMessage}">
    showToast('${errorMessage}', 'error');
    </c:if>
</script>
</body>
</html>