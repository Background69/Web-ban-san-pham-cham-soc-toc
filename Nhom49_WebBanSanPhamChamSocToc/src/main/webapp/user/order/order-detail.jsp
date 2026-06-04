<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.orderId} - HairGlow</title>
    <meta name="description" content="Chi tiết đơn hàng #${order.orderId} tại HairGlow - Mỹ phẩm chăm sóc tóc cao cấp">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/order-detail.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">
</head>

<body>
<jsp:include page="/layout/header.jsp"/>

<main class="od-main">
    <div class="od-container od-fade-in-up">
        <c:choose>
            <c:when test="${order.orderStatus == 'cancelled'}">
                <div class="od-hero od-hero--cancelled">
                    <div class="od-hero__icon od-hero__icon--cancelled">
                        <i class="fas fa-times"></i>
                    </div>
                    <h1 class="od-hero__title od-hero__title--cancelled">Đơn hàng đã bị hủy</h1>
                    <p class="od-hero__subtitle">
                        Đơn hàng <strong>#${order.orderId}</strong> đã được hủy bỏ.
                        Chúng tôi rất tiếc vì sự bất tiện này.
                    </p>
                </div>
            </c:when>

            <c:when test="${order.orderStatus == 'completed'}">
                <div class="od-hero od-hero--completed">
                    <div class="od-hero__icon od-hero__icon--completed">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h1 class="od-hero__title">Đơn hàng đã hoàn thành</h1>
                    <p class="od-hero__subtitle">
                        Cảm ơn bạn đã tin chọn <strong>HairGlow</strong>!
                        Hy vọng bạn hài lòng với sản phẩm.
                    </p>
                </div>
            </c:when>

            <c:otherwise>
                <div class="od-hero">
                    <div class="od-hero__icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <h1 class="od-hero__title">Cảm ơn bạn đã tin chọn HairGlow</h1>
                    <p class="od-hero__subtitle">
                        Đơn hàng <strong>#${order.orderId}</strong> đã được ghi nhận.
                        Chúng tôi sẽ sớm xử lý cho bạn!
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
        <c:if test="${not empty success}">
            <div class="od-alert od-alert--success">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="od-alert od-alert--error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>
        <c:set var="currentStatus" value="${order.orderStatus != null ? order.orderStatus : 'pending'}"/>

        <c:if test="${currentStatus != 'cancelled'}">
            <c:set var="stepIndex" value="0"/>
            <c:if test="${currentStatus == 'confirmed'}"><c:set var="stepIndex" value="1"/></c:if>
            <c:if test="${currentStatus == 'shipping'}"><c:set var="stepIndex" value="2"/></c:if>
            <c:if test="${currentStatus == 'completed'}"><c:set var="stepIndex" value="3"/></c:if>

            <div class="od-stepper">
                <div class="od-stepper__step ${stepIndex > 0 ? 'is-done' : ''} ${stepIndex == 0 ? 'is-active' : ''}">
                    <div class="od-stepper__connector"></div>
                    <div class="od-stepper__circle">
                        <c:choose>
                            <c:when test="${stepIndex > 0}"><i class="fas fa-check"></i></c:when>
                            <c:otherwise><i class="fas fa-clock"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <span class="od-stepper__label">
                        <c:choose>
                            <c:when test="${currentStatus == 'pending_payment'}">Chờ thanh toán</c:when>
                            <c:otherwise>Chờ xác nhận</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="od-stepper__step ${stepIndex > 1 ? 'is-done' : ''} ${stepIndex == 1 ? 'is-active' : ''}">
                    <div class="od-stepper__connector"></div>
                    <div class="od-stepper__circle">
                        <c:choose>
                            <c:when test="${stepIndex > 1}"><i class="fas fa-check"></i></c:when>
                            <c:otherwise><i class="fas fa-gear"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <span class="od-stepper__label">Đang xử lý</span>
                </div>

                <div class="od-stepper__step ${stepIndex > 2 ? 'is-done' : ''} ${stepIndex == 2 ? 'is-active' : ''}">
                    <div class="od-stepper__connector"></div>
                    <div class="od-stepper__circle">
                        <c:choose>
                            <c:when test="${stepIndex > 2}"><i class="fas fa-check"></i></c:when>
                            <c:otherwise><i class="fas fa-truck"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <span class="od-stepper__label">Đang giao hàng</span>
                </div>

                <div class="od-stepper__step ${stepIndex == 3 ? 'is-done' : ''}">
                    <div class="od-stepper__connector"></div>
                    <div class="od-stepper__circle">
                        <c:choose>
                            <c:when test="${stepIndex == 3}"><i class="fas fa-check"></i></c:when>
                            <c:otherwise><i class="fas fa-circle-check"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <span class="od-stepper__label">Đã giao thành công</span>
                </div>
            </div>
        </c:if>

        <div class="od-invoice-meta">
            <div class="od-invoice-meta__left">
                <i class="far fa-calendar-alt"></i>
                <span>Ngày đặt: <strong><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></strong></span>
            </div>
            <span class="od-badge od-badge--${currentStatus}">
                ${order.statusDisplayName}
            </span>
        </div>

        <div class="od-info-grid">
            <%-- Card: Shipping Info --%>
            <div class="od-info-card od-info-card--mint">
                <div class="od-info-card__header">
                    <div class="od-info-card__icon">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <h3 class="od-info-card__title">Thông tin nhận hàng</h3>
                </div>
                <div class="od-info-card__body">
                    <div class="od-info-row">
                        <span class="od-info-row__label">Người nhận</span>
                        <span class="od-info-row__value">${order.shippingFullName}</span>
                    </div>
                    <div class="od-info-row">
                        <span class="od-info-row__label">Điện thoại</span>
                        <span class="od-info-row__value">${order.shippingPhone}</span>
                    </div>
                    <div class="od-info-row">
                        <span class="od-info-row__label">Địa chỉ</span>
                        <span class="od-info-row__value">${order.shippingAddress}</span>
                    </div>
                </div>
            </div>

            <div class="od-info-card od-info-card--rose">
                <div class="od-info-card__header">
                    <div class="od-info-card__icon">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <h3 class="od-info-card__title">Thanh toán & vận chuyển</h3>
                </div>
                <div class="od-info-card__body">
                    <div class="od-info-row">
                        <span class="od-info-row__label">Phương thức</span>
                        <span class="od-info-row__value">${order.paymentMethodDisplayName}</span>
                    </div>
                    <div class="od-info-row">
                        <span class="od-info-row__label">Giao hàng</span>
                        <span class="od-info-row__value">${order.shippingMethodDisplayName}</span>
                    </div>
                    <div class="od-info-row">
                        <span class="od-info-row__label">Phí ship</span>
                        <span class="od-info-row__value od-info-row__value--price">
                            <fmt:formatNumber value="${order.shippingFee}" type="number"/>₫
                        </span>
                    </div>
                </div>
            </div>

            <c:if test="${not empty paymentTransaction}">
                <div class="od-info-card od-info-card--lavender">
                    <div class="od-info-card__header">
                        <div class="od-info-card__icon">
                            <i class="fas fa-university"></i>
                        </div>
                        <h3 class="od-info-card__title">Thông tin chuyển khoản</h3>
                    </div>
                    <div class="od-info-card__body">
                        <div class="od-info-row">
                            <span class="od-info-row__label">Trạng thái</span>
                            <span class="od-info-row__value">${paymentTransaction.status}</span>
                        </div>
                        <div class="od-info-row">
                            <span class="od-info-row__label">Số tiền</span>
                            <span class="od-info-row__value od-info-row__value--price">
                                <fmt:formatNumber value="${paymentTransaction.amount}" type="number"/>₫
                            </span>
                        </div>
                        <div class="od-info-row">
                            <span class="od-info-row__label">Nội dung CK</span>
                            <span class="od-info-row__value">${paymentTransaction.transferContent}</span>
                        </div>
                        <div class="od-info-row">
                            <span class="od-info-row__label">Ngân hàng</span>
                            <span class="od-info-row__value">${paymentTransaction.bankName}</span>
                        </div>
                        <c:if test="${not empty paymentTransaction.expiresAt}">
                            <div class="od-info-row">
                                <span class="od-info-row__label">Hết hạn</span>
                                <span class="od-info-row__value">
                                    <fmt:formatDate value="${paymentTransaction.expiresAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </span>
                            </div>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/payment/bank-transfer?transactionId=${paymentTransaction.transactionId}"
                           class="od-btn od-btn--primary od-btn--sm" style="margin-top: 12px;">
                            <i class="fas fa-external-link-alt"></i> Mở trang thanh toán
                        </a>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="od-products">
            <div class="od-products__header">
                <i class="fas fa-shopping-bag"></i>
                <h2 class="od-products__title">Sản phẩm đã đặt</h2>
                <span class="od-products__count">${fn:length(order.orderItems)} sản phẩm</span>
            </div>

            <div class="od-products__list">
                <c:forEach var="item" items="${order.orderItems}">
                    <div class="od-product-item">
                        <div class="od-product-item__img-wrap">
                            <c:choose>
                                <c:when test="${empty item.productImage}">
                                    <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png"
                                         alt="${item.productName}"
                                         class="od-product-item__img">
                                </c:when>
                                <c:when test="${fn:startsWith(item.productImage, 'http')}">
                                    <img src="${item.productImage}"
                                         alt="${item.productName}"
                                         class="od-product-item__img"
                                         onerror="this.src='${pageContext.request.contextPath}/static/assets/icons/LOGO.png'">
                                </c:when>
                                <c:when test="${fn:startsWith(item.productImage, '/static/')}">
                                    <img src="${pageContext.request.contextPath}${item.productImage}"
                                         alt="${item.productName}"
                                         class="od-product-item__img"
                                         onerror="this.src='${pageContext.request.contextPath}/static/assets/icons/LOGO.png'">
                                </c:when>
                                <c:when test="${fn:startsWith(item.productImage, '/')}">
                                    <img src="${pageContext.request.contextPath}${item.productImage}"
                                         alt="${item.productName}"
                                         class="od-product-item__img"
                                         onerror="this.src='${pageContext.request.contextPath}/static/assets/icons/LOGO.png'">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${item.productImage}"
                                         alt="${item.productName}"
                                         class="od-product-item__img"
                                         onerror="this.src='${pageContext.request.contextPath}/static/assets/icons/LOGO.png'">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="od-product-item__info">
                            <span class="od-product-item__name">${item.productName}</span>
                            <c:if test="${not empty item.variantName}">
                                <span class="od-product-item__variant">${item.variantName}</span>
                            </c:if>
                            <div class="od-product-item__meta">
                                <span class="od-product-item__unit-price">
                                    <fmt:formatNumber value="${item.unitPrice}" type="number"/>₫
                                </span>
                                <span class="od-product-item__qty">× ${item.quantity}</span>
                            </div>
                        </div>

                        <span class="od-product-item__total">
                            <fmt:formatNumber value="${item.totalPrice}" type="number"/>₫
                        </span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="od-summary">
            <div class="od-summary__breakdown">
                <div class="od-summary__row">
                    <span>Tạm tính</span>
                    <span><fmt:formatNumber value="${order.subtotal}" type="number"/>₫</span>
                </div>
                <div class="od-summary__row">
                    <span>Phí vận chuyển</span>
                    <span><fmt:formatNumber value="${order.shippingFee}" type="number"/>₫</span>
                </div>
                <div class="od-summary__row od-summary__row--total">
                    <span>Tổng cộng</span>
                    <span class="od-summary__total-price">
                        <fmt:formatNumber value="${order.totalAmount}" type="number"/>₫
                    </span>
                </div>
            </div>

            <div class="od-summary__actions">
                <a href="${pageContext.request.contextPath}/profile/orders" class="od-btn od-btn--outline">
                    <i class="fas fa-arrow-left"></i> Đơn hàng của tôi
                </a>

                <c:if test="${not empty paymentTransaction && paymentTransaction.status == 'PENDING'}">
                    <a href="${pageContext.request.contextPath}/payment/bank-transfer?transactionId=${paymentTransaction.transactionId}"
                       class="od-btn od-btn--primary">
                        <i class="fas fa-wallet"></i> Tiếp tục thanh toán
                    </a>
                </c:if>

                <c:if test="${canCancelOrder}">
                    <form action="${pageContext.request.contextPath}/orders/${order.orderId}/cancel"
                          method="post" style="display:inline;">
                        <button type="submit" class="od-btn od-btn--danger"
                                onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                            <i class="fas fa-times-circle"></i> Hủy đơn hàng
                        </button>
                    </form>
                </c:if>

                <a href="${pageContext.request.contextPath}/store" class="od-btn od-btn--success">
                    <i class="fas fa-shopping-bag"></i> Tiếp tục mua sắm
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>
</body>

</html>
