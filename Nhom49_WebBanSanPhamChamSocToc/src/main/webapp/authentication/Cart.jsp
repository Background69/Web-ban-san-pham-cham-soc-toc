<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 27/12/2025
  Time: 4:54 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/cart.css">
    <script src="<%= request.getContextPath() %>/static/js/Cart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
</head>
<body>

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

        <div class="cart-header-table">
            <span>Sản phẩm</span>
            <span>Tên sản phẩm</span>
            <span>Loại</span>
            <span>Số lượng</span>
            <span>Giá tiền</span>
            <span>Xóa</span>
        </div>

        <div class="cart-product">

            <!-- SẢN PHẨM (demo – sau này render bằng JSTL) -->
            <div class="cart-product-item">
                <div class="cart-product-image">
                    <img src="${pageContext.request.contextPath}/images/daugoihead.png" alt="sp">
                </div>
                <div class="cart-product-name">
                    Dầu gội Head & Shoulders Ngăn Gàu Dưỡng Ẩm 625ml
                </div>
                <div class="cart-product-type">625ml</div>
                <div class="cart-product-quantity">
                    <input type="number" value="1" min="1">
                </div>
                <div class="cart-product-price">147.000₫</div>
                <div class="cart-product-remove">
                    <i class="fa-solid fa-trash"></i>
                </div>
            </div>

            <div class="cart-product-item">
                <div class="cart-product-image">
                    <img src="${pageContext.request.contextPath}/images/dauxalove.jpeg" alt="sp">
                </div>
                <div class="cart-product-name">
                    Dầu xả Love Beauty & Planet Murumuru Butter 400ml
                </div>
                <div class="cart-product-type">400ml</div>
                <div class="cart-product-quantity">
                    <input type="number" value="1" min="1">
                </div>
                <div class="cart-product-price">220.000₫</div>
                <div class="cart-product-remove">
                    <i class="fa-solid fa-trash"></i>
                </div>
            </div>

        </div>

        <h3>Phương thức giao hàng</h3>

        <label class="shipping-option">
            <input type="radio" name="shipping" checked>
            <span>Giao hàng tiêu chuẩn (30.000 VNĐ)</span>
        </label>

        <label class="shipping-option">
            <input type="radio" name="shipping">
            <span>Giao hàng nhanh (40.000 VNĐ)</span>
        </label>

    </div>

    <!-- BÊN PHẢI -->
    <div class="cart-right">
        <h3>Thanh toán</h3>

        <div class="cart-checkout">
            <span>Tạm tính:</span>
            <span>667.000đ</span>
        </div>

        <div class="cart-summary-item">
            <span>Phí vận chuyển:</span>
            <span>30.000đ</span>
        </div>

        <div class="cart-summary-item total">
            <span>Tổng cộng:</span>
            <span>697.000đ</span>
        </div>

        <form action="${pageContext.request.contextPath}/Checkout" method="post">
            <button type="submit" class="checkout-btn">Tiếp theo</button>
        </form>
    </div>

</div>

</body>
</html>

