<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Giỏ hàng</title>
    <link href="${pageContext.request.contextPath}/static/css/cart.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/cart.css">
</head>
<body>

<jsp:include page="/layout/header.jsp" />

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
            <!-- Sản phẩm 1 -->
            <div class="cart-product-item" data-price="147000">
                <div class="cart-product-image">
                    <img alt="Hình ảnh sản phẩm" src="${pageContext.request.contextPath}/static/assets/daugoihead.png">
                </div>
                <div class="cart-product-name">Dầu gội Head & Shoulders Ngăn Gàu Dưỡng Ẩm 625ml</div>
                <div class="cart-product-type">625ml</div>
                <div class="cart-product-quantity">
                    <button class="minus">-</button>
                    <input min="1" type="number" value="1">
                    <button class="plus">+</button>
                </div>
                <div class="cart-product-price">147.000₫</div>
                <div class="cart-product-remove">
                    <button class="remove-btn"><i class="fa-solid fa-trash"></i></button>
                </div>
            </div>

            <!-- Sản phẩm 2 -->
            <div class="cart-product-item" data-price="220000">
                <div class="cart-product-image">
                    <img alt="Hình ảnh sản phẩm" src="${pageContext.request.contextPath}/static/assets/dauxalove.jpeg">
                </div>
                <div class="cart-product-name">Dầu xả Love Beauty & Planet Murumuru Butter 400ml</div>
                <div class="cart-product-type">400ml</div>
                <div class="cart-product-quantity">
                    <button class="minus">-</button>
                    <input min="1" type="number" value="1">
                    <button class="plus">+</button>
                </div>
                <div class="cart-product-price">220.000₫</div>
                <div class="cart-product-remove">
                    <button class="remove-btn"><i class="fa-solid fa-trash"></i></button>
                </div>
            </div>
            <!-- Sản phẩm 3 -->
            <div class="cart-product-item" data-price="300000">
                <div class="cart-product-image">
                    <img alt="Hình ảnh sản phẩm" src="${pageContext.request.contextPath}/static/assets/Kéo.jpg">
                </div>
                <div class="cart-product-name">Kéo cắt tóc</div>
                <div class="cart-product-type"></div>
                <div class="cart-product-quantity">
                    <button class="minus">-</button>
                    <input min="1" type="number" value="1">
                    <button class="plus">+</button>
                </div>
                <div class="cart-product-price">300.000₫</div>
                <div class="cart-product-remove">
                    <button class="remove-btn"><i class="fa-solid fa-trash"></i></button>
                </div>

            </div>

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
            <span class="cart-subtotal">667.000đ</span>
        </div>
        <div class="cart-summary-item">
            <span>Phí vận chuyển:</span>
            <span class="cart-shipping-fee">0 VNĐ</span>
        </div>
        <div class="cart-summary-item total">
            <span>Tổng cộng:</span>
            <span class="cart-total-amount">0 VNĐ</span>
        </div>
        <button class="checkout-btn">Tiếp theo</button>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />

<script>
    function calculateSubtotal() {
        let subtotal = 0;
        document.querySelectorAll('.cart-product-item').forEach(item => {
            const price = parseInt(item.getAttribute('data-price'));
            const quantity = parseInt(item.querySelector('input').value);
            subtotal += price * quantity;
        });
        document.querySelector('.cart-subtotal').textContent = subtotal.toLocaleString() + 'đ';
        return subtotal;
    }

    // CẬP NHẬT PHÍ SHIP + TỔNG TIỀN
    function updateTotal() {
        const shipping = document.querySelector('input[name="shipping"]:checked').value;

        let shippingFee = 0;
        if (shipping === 'standard') shippingFee = 30000;
        if (shipping === 'express') shippingFee = 40000;

        document.querySelector('.cart-shipping-fee').textContent = shippingFee.toLocaleString() + 'đ';

        const subtotal = calculateSubtotal();
        const total = subtotal + shippingFee;
        document.querySelector('.cart-total-amount').textContent = total.toLocaleString() + 'đ';
    }

    // LẮNG NGHE SỰ KIỆN THAY ĐỔI PHƯƠNG THỨC VẬN CHUYỂN
    document.querySelectorAll('input[name="shipping"]').forEach(radio => {
        radio.addEventListener('change', updateTotal);
    });

    // LẦN ĐẦU TẢI TRANG -> TÍNH LUÔN
    updateTotal();

    document.querySelector('.checkout-btn').addEventListener('click', function () {
        window.location.href = '${pageContext.request.contextPath}/user/address.jsp';
    });
</script>
</body>
</html>
