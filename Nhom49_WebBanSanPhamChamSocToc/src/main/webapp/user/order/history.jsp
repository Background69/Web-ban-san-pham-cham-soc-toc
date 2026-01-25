<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/order.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="order-history-main">
    <div class="order-history-container">
        <h1><i class="fas fa-history"></i> Lịch sử đơn hàng</h1>

        <!-- Filter tabs -->
        <div class="order-tabs">
            <a href="${pageContext.request.contextPath}/orders"
               class="tab-btn ${empty status ? 'active' : ''}">Tất cả</a>
            <a href="${pageContext.request.contextPath}/orders?status=pending"
               class="tab-btn ${status == 'pending' ? 'active' : ''}">
                Chờ xác nhận
            </a>
            <a href="${pageContext.request.contextPath}/orders?status=confirmed"
               class="tab-btn ${status == 'confirmed' ? 'active' : ''}">
                Đã xác nhận
            </a>
            <a href="${pageContext.request.contextPath}/orders?status=shipping"
               class="tab-btn ${status == 'shipping' ? 'active' : ''}">
                Đang giao
            </a>
            <a href="${pageContext.request.contextPath}/orders?status=completed"
               class="tab-btn ${status == 'completed' ? 'active' : ''}">
                Hoàn thành
            </a>
            <a href="${pageContext.request.contextPath}/orders?status=cancelled"
               class="tab-btn ${status == 'cancelled' ? 'active' : ''}">
                Đã hủy
            </a>
        </div>

        <!-- Orders list -->
        <div class="orders-list">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <span class="order-id">Đơn hàng #${order.orderId}</span>
                                <span class="order-date">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                                <span class="order-status status-${order.orderStatus != null ? order.orderStatus : 'pending'}">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'pending'}">Chờ xác nhận</c:when>
                                        <c:when test="${order.orderStatus == 'confirmed'}">Đã xác nhận</c:when>
                                        <c:when test="${order.orderStatus == 'shipping'}">Đang giao hàng</c:when>
                                        <c:when test="${order.orderStatus == 'completed'}">Hoàn thành</c:when>
                                        <c:when test="${order.orderStatus == 'cancelled'}">Đã hủy</c:when>
                                        <c:otherwise>${order.orderStatus}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="order-items">
                                <c:forEach var="item" items="${order.orderItems}" varStatus="loop">
                                    <c:if test="${loop.index < 2}">
                                        <div class="order-item">
                                            <img src="${pageContext.request.contextPath}/static/images/default-product.png"
                                                 alt="${item.productName}">
                                            <div class="item-info">
                                                <span class="item-name">${item.productName}</span>
                                                <span class="item-variant">${item.variantName}</span>
                                                <span class="item-qty">x${item.quantity}</span>
                                            </div>
                                            <span class="item-price">
                                                <fmt:formatNumber value="${item.totalPrice}" type="number"/>₫
                                            </span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${order.orderItems != null && order.orderItems.size() > 2}">
                                    <p class="more-items">+ ${order.orderItems.size() - 2} sản phẩm khác</p>
                                </c:if>
                            </div>

                            <div class="order-footer">
                                <div class="order-total">
                                    Tổng tiền: <span><fmt:formatNumber value="${order.totalAmount}" type="number"/>₫</span>
                                </div>
                                <div class="order-actions">
                                    <a href="${pageContext.request.contextPath}/orders/${order.orderId}" class="btn-detail">
                                        Xem chi tiết
                                    </a>
                                    <c:if test="${order.orderStatus == 'pending'}">
                                        <form action="${pageContext.request.contextPath}/orders/${order.orderId}/cancel" method="post" style="display: inline;">
                                            <button type="submit" class="btn-cancel"
                                                    onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                                Hủy đơn
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-orders">
                        <i class="fas fa-box-open"></i>
                        <h3>Chưa có đơn hàng nào</h3>
                        <p>Hãy mua sắm để có đơn hàng đầu tiên!</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn-shop">
                            Khám phá sản phẩm
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>
</body>
</html>

