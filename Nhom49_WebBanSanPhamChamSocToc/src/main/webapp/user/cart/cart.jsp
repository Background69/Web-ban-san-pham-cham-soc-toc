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
                <!-- Empty Cart State -->
                <div class="cart-empty">
                    <div class="cart-empty-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <h2 class="cart-empty-title">Giỏ hàng trống</h2>
                    <p class="cart-empty-text">
                        Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy khám phá các sản phẩm chăm sóc tóc
                        tuyệt vời của
                        chúng tôi!
                    </p>
                    <a href="${pageContext.request.contextPath}/store" class="cart-empty-btn">
                        <i class="fas fa-shopping-bag"></i> Khám phá sản phẩm
                    </a>
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
                                  style="display: inline;">
                                <button type="submit" class="cart-clear-btn"
                                        onclick="return confirm('Bạn có chắc muốn xóa tất cả sản phẩm?')">
                                    <i class="fas fa-trash-alt"></i> Xóa tất cả
                                </button>
                            </form>
                        </div>

                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item" data-variant-id="${item.variant.variantId}">
                                <div class="cart-item-image">
                                    <img src="${pageContext.request.contextPath}/static/${not empty item.imageUrl ? item.imageUrl : 'images/default-product.png'}"
                                         alt="${item.product.productName}"
                                         onerror="this.src='${pageContext.request.contextPath}/static/images/default-product.png'">
                                </div>
                                <div class="cart-item-details">
                                    <h3 class="cart-item-name">
                                        <a
                                                href="${pageContext.request.contextPath}/product/${item.product.productId}">
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
                                          method="post" style="display: inline;">
                                        <input type="hidden" name="variantId"
                                               value="${item.variant.variantId}">
                                        <button type="submit" class="cart-item-remove"
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

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';

    // Show toast notification
    function showToast(message, type) {
        type = type || 'success';
        const container = document.getElementById('toastContainer');
        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;

        let iconClass = 'check';
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

    // Update quantity
    function updateQuantity(variantId, quantity) {
        if (quantity < 1) {
            if (confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
                document.querySelector('form[action*="remove"] input[value="' + variantId + '"]').closest('form').submit();
            }
            return;
        }

        showLoading();

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/cart/update';

        const variantInput = document.createElement('input');
        variantInput.type = 'hidden';
        variantInput.name = 'variantId';
        variantInput.value = variantId;

        const quantityInput = document.createElement('input');
        quantityInput.type = 'hidden';
        quantityInput.name = 'quantity';
        quantityInput.value = quantity;

        form.appendChild(variantInput);
        form.appendChild(quantityInput);
        document.body.appendChild(form);
        form.submit();
    }


    // Check for messages from server
    <c:if test="${not empty sessionScope.cartMessage}">
    showToast('${sessionScope.cartMessage}', 'success');
    </c:if>

    <c:if test="${not empty sessionScope.cartError}">
    showToast('${sessionScope.cartError}', 'error');
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
    showToast('${sessionScope.errorMessage}', 'error');
    </c:if>
</script>
</body>

</html>
