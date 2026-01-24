<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Giỏ hàng</title>
    <link href="${pageContext.request.contextPath}/static/css/user/cart.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/cart.css">
</head>
<body>

<jsp:include page="/layout/header.jsp"/>

<div class="cart-process">
    <div class="cart-checkout-process active">
        <i class="fa-solid fa-cart-shopping"></i>
    </div>
    <div class="cart-checkout-process">
        <i class="fa-solid fa-location-dot"></i>
    </div>
    <div class="cart-checkout-process">
        <i class="fa-solid fa-credit-card"></i>
    </div>
</div>

<div class="cart-container">

    <!-- BÊN TRÁI -->
    <div class="cart-left">
        <h3>Giỏ hàng của bạn</h3>

        <!-- Tiêu đề bảng -->
        <div class="cart-header-table">
            <span>Sản phẩm</span>
            <span>Tên sản phẩm</span>
            <span>Loại</span>
            <span>Số lượng</span>
            <span>Giá tiền</span>
            <span>Xóa</span>
        </div>

        <!-- Danh sách sản phẩm -->
        <div class="cart-product">
            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="empty-cart">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <p>Giỏ hàng của bạn đang trống</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn-continue">Tiếp tục mua sắm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-product-item" data-price="${item.unitPrice}" data-variant-id="${item.variantId}">
                            <div class="cart-product-image">
                                <a href="${pageContext.request.contextPath}/product/${item.productSlug}">
                                    <img alt="${item.productName}"
                                         src="${pageContext.request.contextPath}/static/images/${not empty item.imageUrl ? item.imageUrl : 'default-product.png'}">
                                </a>
                            </div>
                            <div class="cart-product-name">${item.productName}</div>
                            <div class="cart-product-type">${item.variantName}</div>
                            <div class="cart-product-quantity">
                                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="quantity-form">
                                    <input type="hidden" name="variantId" value="${item.variantId}">
                                    <button type="button" class="minus">-</button>
                                    <input name="quantity" min="1" max="${item.stockQuantity}" type="number" value="${item.quantity}">
                                    <button type="button" class="plus">+</button>
                                </form>
                            </div>
                            <div class="cart-product-price"><fmt:formatNumber value="${item.totalPrice}" type="number"/>₫</div>
                            <div class="cart-product-remove">
                                <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                    <input type="hidden" name="variantId" value="${item.variantId}">
                                    <button type="submit" class="remove-btn"><i class="fa-solid fa-trash"></i></button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        <h3>Phương thức giao hàng</h3>

        <label class="shipping-option">
            <input checked name="shipping" type="radio" value="standard">
            <span>Giao hàng tiêu chuẩn (30.000 VNĐ) - Dự kiến nhận hàng trong 5-7 ngày</span>
        </label>

        <label class="shipping-option">
            <input name="shipping" type="radio" value="express">
            <span>Giao hàng nhanh (40.000 VNĐ) - Dự kiến nhận hàng trong 1-3 ngày</span>
        </label>

    </div>


    <!-- BÊN PHẢI -->
    <div class="cart-right">
        <h3>Thanh toán</h3>
        <div class="cart-checkout">
            <span>Tạm tính:</span>
            <span class="cart-subtotal"><fmt:formatNumber value="${subtotal}" type="number"/>₫</span>
        </div>
        <div class="cart-summary-item">
            <span>Phí vận chuyển:</span>
            <span class="cart-shipping-fee">30.000₫</span>
        </div>
        <div class="cart-summary-item total">
            <span>Tổng cộng:</span>
            <span class="cart-total-amount">0₫</span>
        </div>
        <c:if test="${not empty cartItems}">
            <a href="${pageContext.request.contextPath}/checkout" class="checkout-btn">Tiếp tục thanh toán</a>
            <form action="${pageContext.request.contextPath}/cart/clear" method="post" style="margin-top: 10px;">
                <button type="submit" class="clear-cart-btn" onclick="return confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')">
                    Xóa toàn bộ giỏ hàng
                </button>
            </form>
        </c:if>
    </div>
</div>

<jsp:include page="/layout/footer.jsp"/>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const subtotalFromServer = ${subtotal != null ? subtotal : 0};

    function calculateSubtotal() {
        let subtotal = 0;
        document.querySelectorAll('.cart-product-item').forEach(item => {
            const price = parseFloat(item.getAttribute('data-price')) || 0;
            const quantityInput = item.querySelector('input[name="quantity"]');
            const quantity = quantityInput ? parseInt(quantityInput.value) || 1 : 1;
            subtotal += price * quantity;
        });
        document.querySelector('.cart-subtotal').textContent = subtotal.toLocaleString('vi-VN') + '₫';
        return subtotal;
    }

    // CẬP NHẬT PHÍ SHIP + TỔNG TIỀN
    function updateTotal() {
        const shippingRadio = document.querySelector('input[name="shipping"]:checked');
        let shippingFee = 30000; // Mặc định giao hàng tiêu chuẩn

        if (shippingRadio) {
            const shipping = shippingRadio.value;
            if (shipping === 'standard') shippingFee = 30000;
            if (shipping === 'express') shippingFee = 40000;
        }

        document.querySelector('.cart-shipping-fee').textContent = shippingFee.toLocaleString('vi-VN') + '₫';

        const subtotal = calculateSubtotal();
        const total = subtotal + shippingFee;
        document.querySelector('.cart-total-amount').textContent = total.toLocaleString('vi-VN') + '₫';
    }

    // LẮNG NGHE SỰ KIỆN THAY ĐỔI PHƯƠNG THỨC VẬN CHUYỂN
    document.querySelectorAll('input[name="shipping"]').forEach(radio => {
        radio.addEventListener('change', updateTotal);
    });

    // Xử lý nút tăng/giảm số lượng
    document.querySelectorAll('.cart-product-item').forEach(item => {
        const minusBtn = item.querySelector('.minus');
        const plusBtn = item.querySelector('.plus');
        const quantityInput = item.querySelector('input[name="quantity"]');
        const form = item.querySelector('.quantity-form');

        if (minusBtn && quantityInput) {
            minusBtn.addEventListener('click', function() {
                let value = parseInt(quantityInput.value) || 1;
                if (value > 1) {
                    quantityInput.value = value - 1;
                    updateTotal();
                    // Auto submit form sau khi thay đổi
                    if (form) form.submit();
                }
            });
        }

        if (plusBtn && quantityInput) {
            plusBtn.addEventListener('click', function() {
                let value = parseInt(quantityInput.value) || 1;
                const max = parseInt(quantityInput.getAttribute('max')) || 999;
                if (value < max) {
                    quantityInput.value = value + 1;
                    updateTotal();
                    // Auto submit form sau khi thay đổi
                    if (form) form.submit();
                }
            });
        }

        if (quantityInput) {
            quantityInput.addEventListener('change', function() {
                updateTotal();
                if (form) form.submit();
            });
        }
    });

    // LẦN ĐẦU TẢI TRANG -> TÍNH LUÔN
    updateTotal();
</script>
</body>
</html>
