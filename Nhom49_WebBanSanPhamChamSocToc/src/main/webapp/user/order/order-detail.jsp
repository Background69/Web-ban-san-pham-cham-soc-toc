<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/order.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>

<body>
<jsp:include page="/layout/header.jsp"/>

<main class="order-history-main">
    <div class="order-history-container">
        <div class="order-detail-header">
            <h1><i class="fas fa-receipt"></i> Chi tiết đơn hàng #${order.orderId}</h1>
            <a href="${pageContext.request.contextPath}/orders" class="btn-detail">Quay lại</a>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <div class="order-card">
            <div class="order-header">
                                <span class="order-date">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                <span
                        class="order-status status-${order.orderStatus != null ? order.orderStatus : 'pending'}">
                    ${order.statusDisplayName}
                </span>
            </div>

            <div class="order-detail-grid">
                <div class="order-detail-box">
                    <h3>Thông tin giao hàng</h3>
                    <p><strong>Người nhận:</strong> ${order.shippingFullName}</p>
                    <p><strong>Điện thoại:</strong> ${order.shippingPhone}</p>
                    <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                </div>
                <div class="order-detail-box">
                    <h3>Thanh toán & vận chuyển</h3>
                    <p><strong>Phương thức:</strong> ${order.paymentMethodDisplayName}</p>
                    <p><strong>Giao hàng:</strong> ${order.shippingMethodDisplayName}</p>
                    <p><strong>Phí ship:</strong>
                        <fmt:formatNumber value="${order.shippingFee}" type="number"/>₫
                    </p>
                </div>

                <c:if test="${not empty paymentTransaction}">
                    <div class="order-detail-box">
                        <h3>Thông tin chuyển khoản</h3>
                        <p><strong>Trạng thái giao dịch:</strong> ${paymentTransaction.status}</p>
                        <p><strong>Số tiền:</strong>
                            <fmt:formatNumber value="${paymentTransaction.amount}" type="number"/>₫
                        </p>
                        <p><strong>Nội dung CK:</strong> ${paymentTransaction.transferContent}</p>
                        <p><strong>Ngân hàng:</strong> ${paymentTransaction.bankName}</p>
                        <c:if test="${not empty paymentTransaction.expiresAt}">
                            <p><strong>Hết hạn:</strong>
                                <fmt:formatDate value="${paymentTransaction.expiresAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </p>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/payment/bank-transfer?transactionId=${paymentTransaction.transactionId}"
                           class="btn-detail">
                            Mở trang thanh toán chuyển khoản
                        </a>
                    </div>
                </c:if>
            </div>

            <div class="order-items">
                <c:forEach var="item" items="${order.orderItems}">
                    <div class="order-item">
                        <img src="${pageContext.request.contextPath}/static/${not empty item.productImage ? item.productImage : 'assets/icons/LOGO.png'}"
                             alt="${item.productName}"
                             onerror="this.src='${pageContext.request.contextPath}/static/assets/icons/LOGO.png'">
                        <div class="item-info">
                            <span class="item-name">${item.productName}</span>
                            <span class="item-variant">${item.variantName}</span>
                            <span class="item-qty">x${item.quantity}</span>
                        </div>
                        <span class="item-price">
                                            <fmt:formatNumber value="${item.totalPrice}" type="number"/>₫
                                        </span>
                    </div>
                </c:forEach>
            </div>

            <div class="order-footer">
                <div class="order-total">
                    Tổng tiền: <span>
                                        <fmt:formatNumber value="${order.totalAmount}" type="number"/>₫
                                    </span>
                </div>
                <div class="order-actions">
                    <c:if test="${canCancelOrder}">
                        <form action="${pageContext.request.contextPath}/orders/${order.orderId}/cancel"
                              method="post">
                            <button type="submit" class="btn-cancel"
                                    onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                Hủy đơn
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${not empty paymentTransaction && paymentTransaction.status == 'PENDING'}">
                        <a href="${pageContext.request.contextPath}/payment/bank-transfer?transactionId=${paymentTransaction.transactionId}"
                           class="btn-detail">
                            Tiếp tục thanh toán
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>
</body>

</html>
