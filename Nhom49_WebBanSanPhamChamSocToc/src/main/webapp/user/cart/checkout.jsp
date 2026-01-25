<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/payment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

<jsp:include page="/layout/header.jsp"/>

<div class="cart-process">
    <div class="cart-checkout-process">
        <i class="fa-solid fa-cart-shopping"></i>
    </div>
    <div class="cart-checkout-process active">
        <i class="fa-solid fa-location-dot"></i>
    </div>
    <div class="cart-checkout-process">
        <i class="fa-solid fa-credit-card"></i>
    </div>
</div>

<main class="payment">
    <h3>Thanh toán đơn hàng</h3>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <section>
            <h4>Địa chỉ giao hàng</h4>
            <c:choose>
                <c:when test="${not empty addresses}">
                    <div class="payment-methods">
                        <c:forEach var="address" items="${addresses}">
                            <label>
                                <input type="radio" name="addressId" value="${address.addressId}"
                                    ${defaultAddress != null && address.addressId == defaultAddress.addressId ? 'checked' : ''}>
                                <span>
                                    <strong>${address.fullName}</strong> - ${address.phone}<br>
                                    ${address.specificAddress}, ${address.wardName}, ${address.districtName}, ${address.provinceName}
                                </span>
                            </label>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>Bạn chưa có địa chỉ lưu. Vui lòng nhập địa chỉ mới.</p>
                </c:otherwise>
            </c:choose>

            <div class="mt-4">
                <h5>Nhập địa chỉ mới (nếu cần)</h5>
                <div class="row" style="gap: 12px;">
                    <input type="text" name="fullName" placeholder="Họ tên">
                    <input type="text" name="phone" placeholder="Số điện thoại">
                    <input type="email" name="email" placeholder="Email (tùy chọn)">
                </div>
                <div class="row" style="gap: 12px; margin-top: 12px;">
                    <select name="provinceCode" id="province">
                        <option value="">Chọn tỉnh/thành phố</option>
                    </select>
                    <input type="hidden" name="provinceName" id="provinceName">
                </div>
                <div class="row" style="gap: 12px; margin-top: 12px;">
                    <select name="districtCode" id="district">
                        <option value="">Chọn quận/huyện</option>
                    </select>
                    <input type="hidden" name="districtName" id="districtName">
                </div>
                <div class="row" style="gap: 12px; margin-top: 12px;">
                    <select name="wardCode" id="ward">
                        <option value="">Chọn phường/xã</option>
                    </select>
                    <input type="hidden" name="wardName" id="wardName">
                </div>
                <div class="row" style="gap: 12px; margin-top: 12px;">
                    <textarea name="specificAddress" rows="3" placeholder="Địa chỉ cụ thể"></textarea>
                    <textarea name="note" rows="2" placeholder="Ghi chú (tùy chọn)"></textarea>
                </div>
            </div>
        </section>

        <section>
            <h4>Phương thức giao hàng</h4>
            <div class="payment-methods">
                <label>
                    <input type="radio" name="shippingMethod" value="standard" checked>
                    Giao hàng tiêu chuẩn (30.000₫)
                </label>
                <label>
                    <input type="radio" name="shippingMethod" value="express">
                    Giao hàng nhanh (50.000₫)
                </label>
            </div>
        </section>

        <section>
            <h4>Phương thức thanh toán</h4>
            <div class="payment-methods">
                <label>
                    <input type="radio" name="paymentMethod" value="cod" checked>
                    Thanh toán khi nhận hàng
                </label>
                <label>
                    <input type="radio" name="paymentMethod" value="bank">
                    Chuyển khoản ngân hàng
                </label>
                <label>
                    <input type="radio" name="paymentMethod" value="momo">
                    Ví MoMo
                </label>
            </div>
        </section>

        <section id="order-items">
            <h4>Sản phẩm</h4>
            <c:forEach var="item" items="${cartItems}">
                <div class="order-item">
                    <span>${item.productName} (${item.variantName}) x${item.quantity}</span>
                    <span><fmt:formatNumber value="${item.totalPrice}" type="number"/>₫</span>
                </div>
            </c:forEach>
            <div class="total-amount">
                Tạm tính: <fmt:formatNumber value="${subtotal}" type="number"/>₫
            </div>
        </section>

        <button type="submit" class="btn-confirm">Đặt hàng</button>
    </form>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="${pageContext.request.contextPath}/static/js/address.js"></script>
</body>
</html>

