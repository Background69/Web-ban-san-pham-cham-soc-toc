<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - HairGlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/checkout.css">
</head>

<body>
<jsp:include page="/layout/header.jsp"/>

<main class="checkout-page">
    <div class="cart-container">
        <div class="checkout-heading">
            <h1 class="checkout-title">Thanh toán</h1>
            <p class="checkout-subtitle">Hoàn tất đơn hàng HairGlow nhanh chóng và an toàn.</p>
        </div>

        <div class="checkout-progress" aria-label="Tiến trình thanh toán">
            <div class="progress-step completed">
                <span class="step-number">1</span>
                <span class="step-label">Giỏ hàng</span>
            </div>
            <div class="progress-line completed"></div>
            <div class="progress-step active">
                <span class="step-number">2</span>
                <span class="step-label">Thanh toán</span>
            </div>
            <div class="progress-line"></div>
            <div class="progress-step">
                <span class="step-number">3</span>
                <span class="step-label">Hoàn tất</span>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
            <div class="checkout-layout">
                <div class="checkout-main">
                    <c:if test="${not empty error}">
                        <div class="checkout-alert checkout-alert-danger">${error}</div>
                    </c:if>

                    <section class="checkout-section">
                        <div class="checkout-section-header">
                            <h2 class="checkout-section-title">Địa chỉ giao hàng</h2>
                            <p class="checkout-section-subtitle">Chọn địa chỉ có sẵn hoặc thêm địa chỉ mới.</p>
                        </div>
                        <div class="checkout-section-body">
                            <c:choose>
                                <c:when test="${not empty addresses}">
                                    <div class="address-list">
                                        <c:forEach var="address" items="${addresses}" varStatus="loop">
                                            <div class="address-card ${address.defaultAddress || loop.first ? 'selected' : ''}"
                                                 onclick="selectAddress(this, ${address.addressId})">
                                                <div class="address-card-top">
                                                    <div class="address-card-name">${address.fullName}</div>
                                                    <c:if test="${address.defaultAddress}">
                                                        <span class="address-default-badge">Mặc định</span>
                                                    </c:if>
                                                </div>
                                                <div class="address-card-phone">${address.phone}</div>
                                                <div class="address-card-detail">
                                                        ${address.specificAddress}, ${address.wardName},
                                                        ${address.districtName}, ${address.provinceName}
                                                </div>
                                                <div class="address-card-radio"></div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <input type="hidden" name="addressId" id="selectedAddressId"
                                           value="${defaultAddress != null ? defaultAddress.addressId : addresses[0].addressId}">
                                </c:when>
                                <c:otherwise>
                                    <div class="checkout-alert checkout-alert-warning">
                                        Bạn chưa có địa chỉ giao hàng. Vui lòng thêm địa chỉ mới bên dưới.
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <button type="button" class="new-address-toggle" onclick="toggleNewAddressForm()">
                                + Thêm địa chỉ mới
                            </button>

                            <div class="new-address-form ${empty addresses ? 'show' : ''}" id="newAddressForm">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="fullName"
                                               placeholder="Nhập họ tên" ${empty addresses ? 'required' : '' }>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control" name="phone"
                                               placeholder="Nhập số điện thoại" ${empty addresses ? 'required' : '' }>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                                        <select class="form-select" name="provinceCode" id="province"
                                        ${empty addresses ? 'required' : '' }>
                                            <option value="">-- Chọn Tỉnh/Thành phố --</option>
                                        </select>
                                        <input type="hidden" name="provinceName" id="provinceName">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Quận/Huyện <span class="text-danger">*</span></label>
                                        <select class="form-select" name="districtCode" id="district"
                                                disabled ${empty addresses ? 'required' : '' }>
                                            <option value="">-- Chọn Quận/Huyện --</option>
                                        </select>
                                        <input type="hidden" name="districtName" id="districtName">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Phường/Xã <span class="text-danger">*</span></label>
                                        <select class="form-select" name="wardCode" id="ward" disabled
                                        ${empty addresses ? 'required' : '' }>
                                            <option value="">-- Chọn Phường/Xã --</option>
                                        </select>
                                        <input type="hidden" name="wardName" id="wardName">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Địa chỉ cụ thể <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="specificAddress" rows="2"
                                                  placeholder="Số nhà, tên đường..." ${empty addresses ? 'required' : '' }></textarea>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Ghi chú</label>
                                        <textarea class="form-control" name="note" rows="2"
                                                  placeholder="Ghi chú cho người giao hàng..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="checkout-section">
                        <div class="checkout-section-header">
                            <h2 class="checkout-section-title">Phương thức vận chuyển</h2>
                            <p class="checkout-section-subtitle">Chọn thời gian giao hàng phù hợp nhu cầu.</p>
                        </div>
                        <div class="checkout-section-body">
                            <div class="shipping-methods">
                                <div class="shipping-method selected" onclick="selectShipping(this, 'standard')">
                                    <div class="shipping-method-info">
                                        <div class="shipping-method-name">Giao hàng tiêu chuẩn</div>
                                        <div class="shipping-method-desc">Nhận hàng trong 3-5 ngày làm việc</div>
                                    </div>
                                    <div class="shipping-method-meta">
                                        <span class="shipping-method-badge">Phổ biến</span>
                                        <div class="shipping-method-price">30,000đ</div>
                                    </div>
                                </div>
                                <div class="shipping-method" onclick="selectShipping(this, 'express')">
                                    <div class="shipping-method-info">
                                        <div class="shipping-method-name">Giao hàng nhanh</div>
                                        <div class="shipping-method-desc">Nhận hàng trong 1-2 ngày làm việc</div>
                                    </div>
                                    <div class="shipping-method-meta">
                                        <span class="shipping-method-badge">Ưu tiên</span>
                                        <div class="shipping-method-price">50,000đ</div>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="shippingMethod" id="shippingMethod" value="standard">
                        </div>
                    </section>

                    <section class="checkout-section">
                        <div class="checkout-section-header">
                            <h2 class="checkout-section-title">Phương thức thanh toán</h2>
                            <p class="checkout-section-subtitle">Chọn cách thanh toán thuận tiện nhất cho bạn.</p>
                        </div>
                        <div class="checkout-section-body">
                            <div class="payment-methods">
                                <div class="payment-method selected" onclick="selectPayment(this, 'cod')">
                                    <div class="payment-method-info">
                                        <div class="payment-method-name">Thanh toán khi nhận hàng (COD)</div>
                                        <div class="payment-method-desc">Thanh toán tiền mặt cho đơn vị vận chuyển.</div>
                                    </div>
                                </div>
                                <div class="payment-method" onclick="selectPayment(this, 'bank_transfer')">
                                    <div class="payment-method-info">
                                        <div class="payment-method-name">Chuyển khoản ngân hàng</div>
                                        <div class="payment-method-desc">Xác nhận đơn hàng sau khi nhận được giao dịch.</div>
                                    </div>
                                </div>
                                <div class="payment-method" onclick="selectPayment(this, 'momo')">
                                    <div class="payment-method-info">
                                        <div class="payment-method-name">Ví MoMo</div>
                                        <div class="payment-method-desc">Thanh toán nhanh qua ví điện tử MoMo.</div>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="paymentMethod" id="paymentMethod" value="cod">
                        </div>
                    </section>
                </div>

                <aside class="checkout-summary">
                    <div class="checkout-summary-header">
                        <h2 class="checkout-summary-title">Đơn hàng của bạn</h2>
                    </div>
                    <div class="checkout-summary-body">
                        <div class="checkout-items">
                            <c:forEach var="item" items="${cartItems}">
                                <div class="checkout-item">
                                    <div class="checkout-item-image">
                                        <img src="${not empty item.imageUrl ? item.imageUrl : pageContext.request.contextPath.concat('/static/images/default-product.png')}"
                                             alt="${item.product.productName}"
                                             onerror="this.src='${pageContext.request.contextPath}/static/images/default-product.png'">
                                    </div>
                                    <div class="checkout-item-info">
                                        <div class="checkout-item-name">${item.product.productName}</div>
                                        <div class="checkout-item-variant">${item.variant.variantName}</div>
                                        <div class="checkout-item-qty">SL: ${item.quantity}</div>
                                    </div>
                                    <div class="checkout-item-price">
                                        <fmt:formatNumber
                                                value="${(item.variant.salePrice != null ? item.variant.salePrice : item.variant.originalPrice) * item.quantity}"
                                                type="number"/>đ
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="price-breakdown">
                            <div class="price-row">
                                <span class="price-label">Tạm tính</span>
                                <span class="price-value">
                                    <fmt:formatNumber value="${subtotal}" type="number"/>đ
                                </span>
                            </div>
                            <div class="price-row">
                                <span class="price-label">Phí vận chuyển</span>
                                <span class="price-value" id="shippingFeeDisplay">30,000đ</span>
                            </div>
                            <div class="price-row total">
                                <span class="price-label">Tổng cộng</span>
                                <span class="price-value" id="totalDisplay">
                                    <fmt:formatNumber value="${subtotal + 30000}" type="number"/>đ
                                </span>
                            </div>
                        </div>

                        <p class="checkout-summary-note">HairGlow sẽ xác nhận đơn hàng trước khi giao.</p>

                        <button type="submit" class="place-order-btn">Đặt hàng</button>

                        <div class="checkout-back-link-wrap">
                            <a href="${pageContext.request.contextPath}/cart" class="checkout-back-link">
                                Quay lại giỏ hàng
                            </a>
                        </div>
                    </div>
                </aside>
            </div>
        </form>
    </div>
</main>

<div class="toast-container" id="toastContainer"></div>

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    const subtotal = ${subtotal != null ? subtotal : 0};

    function selectAddress(element, addressId) {
        document.querySelectorAll('.address-card').forEach(card => card.classList.remove('selected'));
        element.classList.add('selected');
        const addressInput = document.getElementById('selectedAddressId');
        if (addressInput) {
            addressInput.value = addressId;
        }

        document.getElementById('newAddressForm').classList.remove('show');
    }

    function toggleNewAddressForm() {
        const form = document.getElementById('newAddressForm');
        form.classList.toggle('show');

        if (form.classList.contains('show')) {
            document.querySelectorAll('.address-card').forEach(card => card.classList.remove('selected'));
            const addressIdInput = document.getElementById('selectedAddressId');
            if (addressIdInput) {
                addressIdInput.value = '';
            }
            loadProvinces();
        }
    }

    function selectShipping(element, method) {
        document.querySelectorAll('.shipping-method').forEach(m => m.classList.remove('selected'));
        element.classList.add('selected');
        document.getElementById('shippingMethod').value = method;
        updateTotal();
    }

    function selectPayment(element, method) {
        document.querySelectorAll('.payment-method').forEach(m => m.classList.remove('selected'));
        element.classList.add('selected');
        document.getElementById('paymentMethod').value = method;
    }

    function updateTotal() {
        const shippingMethod = document.getElementById('shippingMethod').value;
        const shippingFee = shippingMethod === 'express' ? 50000 : 30000;
        const total = subtotal + shippingFee;

        document.getElementById('shippingFeeDisplay').textContent = formatNumber(shippingFee) + 'đ';
        document.getElementById('totalDisplay').textContent = formatNumber(total) + 'đ';
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    const API_URL = 'https://provinces.open-api.vn/api';

    async function loadProvinces() {
        try {
            const response = await fetch(API_URL + '/p/');
            const provinces = await response.json();
            const select = document.getElementById('province');
            select.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';
            provinces.forEach(p => {
                const option = document.createElement('option');
                option.value = p.code;
                option.textContent = p.name;
                option.dataset.name = p.name;
                select.appendChild(option);
            });
        } catch (error) {
            console.error('Error loading provinces:', error);
        }
    }

    document.getElementById('province').addEventListener('change', async function () {
        const provinceCode = this.value;
        const provinceName = this.options[this.selectedIndex].dataset?.name || '';
        document.getElementById('provinceName').value = provinceName;

        const districtSelect = document.getElementById('district');
        const wardSelect = document.getElementById('ward');

        districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        districtSelect.disabled = true;
        wardSelect.disabled = true;

        if (provinceCode) {
            try {
                const response = await fetch(API_URL + '/p/' + provinceCode + '?depth=2');
                const data = await response.json();
                data.districts.forEach(d => {
                    const option = document.createElement('option');
                    option.value = d.code;
                    option.textContent = d.name;
                    option.dataset.name = d.name;
                    districtSelect.appendChild(option);
                });
                districtSelect.disabled = false;
            } catch (error) {
                console.error('Error loading districts:', error);
            }
        }
    });

    document.getElementById('district').addEventListener('change', async function () {
        const districtCode = this.value;
        const districtName = this.options[this.selectedIndex].dataset?.name || '';
        document.getElementById('districtName').value = districtName;

        const wardSelect = document.getElementById('ward');
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;

        if (districtCode) {
            try {
                const response = await fetch(API_URL + '/d/' + districtCode + '?depth=2');
                const data = await response.json();
                data.wards.forEach(w => {
                    const option = document.createElement('option');
                    option.value = w.code;
                    option.textContent = w.name;
                    option.dataset.name = w.name;
                    wardSelect.appendChild(option);
                });
                wardSelect.disabled = false;
            } catch (error) {
                console.error('Error loading wards:', error);
            }
        }
    });

    document.getElementById('ward').addEventListener('change', function () {
        const wardName = this.options[this.selectedIndex].dataset?.name || '';
        document.getElementById('wardName').value = wardName;
    });

    document.addEventListener('DOMContentLoaded', function () {
        updateTotal();
        <c:if test="${empty addresses}">
        loadProvinces();
        </c:if>
    });
</script>
</body>

</html>
