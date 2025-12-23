<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 22/12/2025
  Time: 2:38 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment.css">
    <script src="<%= request.getContextPath() %>/static/js/login.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<div class="cart-process">
    <div class="cart-checkout-process">
        <i class="fa-solid fa-cart-shopping"></i>
    </div>
    <div class="cart-checkout-process">
        <i class="fa-solid fa-location-dot"></i>
    </div>
    <div class="cart-checkout-process active">
        <i class="fa-solid fa-credit-card"></i>
    </div>
</div>

<div class="cart-container">

    <div class="payment">
        <h3>Thanh toán</h3>

        <!-- Thông tin giao hàng -->
        <section id="shipping-information">
            <h4>Thông tin giao hàng</h4>
            <p><strong>Họ và tên:</strong> Nguyễn Văn A</p>
            <p><strong>Địa chỉ:</strong> 123 Nguyễn Trãi, TP.HCM</p>
            <p><strong>Số điện thoại:</strong> 0123456789</p>
            <p><strong>Phương thức giao hàng:</strong> Giao hàng nhanh</p>

            <div class="edit-address">
                <a class="btn-edit" href="address.jsp">
                    <i class="fa-solid fa-pen-to-square"></i> Sửa địa chỉ
                </a>
            </div>
        </section>

        <!-- Đơn hàng -->
        <section class="order-summary">
            <h4>Đơn hàng của bạn</h4>

            <div class="order-item">
                <span class="item-name">Dầu gội Head & Shoulders Ngăn Gàu Dưỡng Ẩm 625ml</span>
                <span class="item-quantity">1</span>
                <span class="item-price">147.000₫</span>
            </div>

            <div class="order-item">
                <span class="item-name">Dầu xả Love Beauty & Planet Murumuru Butter 400ml</span>
                <span class="item-quantity">1</span>
                <span class="item-price">220.000₫</span>
            </div>

            <div class="order-item">
                <span class="item-name">Kéo cắt tóc</span>
                <span class="item-quantity">1</span>
                <span class="item-price">300.000₫</span>
            </div>

            <div class="total-amount">
                <p><strong>Tổng cộng:</strong> 697.000₫</p>
            </div>
        </section>

        <!-- Phương thức thanh toán -->
        <section class="payment-methods">
            <h4>Phương thức thanh toán</h4>

            <label>
                <input type="radio" name="payment" checked>
                Thanh toán khi nhận hàng (COD)
            </label><br>

            <label>
                <input type="radio" name="payment">
                Thanh toán qua ngân hàng
            </label><br>

            <label>
                <input type="radio" name="payment">
                Thanh toán qua MoMo
            </label>
        </section>

        <!-- Nút đặt hàng -->
        <button class="btn-confirm">
            <i class="fa-solid fa-check"></i> Đặt hàng
        </button>

    </div>
</div>

</body>
</html>

