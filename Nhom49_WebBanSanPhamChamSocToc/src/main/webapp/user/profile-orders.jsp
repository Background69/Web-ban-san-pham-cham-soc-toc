<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
          rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/profile.css">
</head>

<body class="profile-page">

<jsp:include page="/layout/header.jsp"/>

<main class="profile-container">
    <!-- Tab Navigation -->
    <div class="tab-navigation">
        <a href="${pageContext.request.contextPath}/profile" class="tab-link">
            <i class="fas fa-home"></i>
            <span>Tổng quan</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/orders" class="tab-link active">
            <i class="fas fa-box"></i>
            <span>Đơn hàng</span>
            <c:if test="${orderCounts != null && orderCounts.ALL > 0}">
                <span class="tab-count">${orderCounts.ALL}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/profile/addresses" class="tab-link">
            <i class="fas fa-map-marker-alt"></i>
            <span>Địa chỉ</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/reviews" class="tab-link">
            <i class="fas fa-star"></i>
            <span>Đánh giá</span>
        </a>
        <a href="${pageContext.request.contextPath}/profile/change-password" class="tab-link">
            <i class="fas fa-lock"></i>
            <span>Bảo mật</span>
        </a>
    </div>

    <!-- Tab Content -->
    <div class="tab-content">
        <div class="tab-content-header">
            <h3 class="tab-content-title">
                <i class="fas fa-box"></i> Đơn hàng của tôi
            </h3>
        </div>

        <!-- Order Filter Tabs -->
        <div class="order-filter-tabs">
            <a href="${pageContext.request.contextPath}/profile/orders"
               class="order-filter-btn ${empty status || status == 'ALL' ? 'active' : ''}">
                Tất cả
                <c:if test="${orderCounts != null}">
                    <span class="count">${orderCounts.ALL}</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/profile/orders?status=pending"
               class="order-filter-btn ${status == 'pending' ? 'active' : ''}">
                <i class="fas fa-clock"></i> Chờ xác nhận
                <c:if test="${orderCounts != null && orderCounts.PENDING > 0}">
                    <span class="count">${orderCounts.PENDING}</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/profile/orders?status=confirmed"
               class="order-filter-btn ${status == 'confirmed' ? 'active' : ''}">
                <i class="fas fa-check"></i> Đã xác nhận
                <c:if test="${orderCounts != null && orderCounts.CONFIRMED > 0}">
                    <span class="count">${orderCounts.CONFIRMED}</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/profile/orders?status=shipping"
               class="order-filter-btn ${status == 'shipping' ? 'active' : ''}">
                <i class="fas fa-truck"></i> Đang giao
                <c:if test="${orderCounts != null && orderCounts.SHIPPING > 0}">
                    <span class="count">${orderCounts.SHIPPING}</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/profile/orders?status=completed"
               class="order-filter-btn ${status == 'completed' ? 'active' : ''}">
                <i class="fas fa-check-circle"></i> Hoàn thành
                <c:if test="${orderCounts != null && orderCounts.COMPLETED > 0}">
                    <span class="count">${orderCounts.COMPLETED}</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/profile/orders?status=cancelled"
               class="order-filter-btn ${status == 'cancelled' ? 'active' : ''}">
                <i class="fas fa-times-circle"></i> Đã hủy
                <c:if test="${orderCounts != null && orderCounts.CANCELLED > 0}">
                    <span class="count">${orderCounts.CANCELLED}</span>
                </c:if>
            </a>
        </div>

        <!-- Orders List -->
        <div class="orders-list">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-card-header">
                                <div class="order-info">
                                    <span class="order-id">Đơn hàng #${order.orderCode}</span>
                                    <span class="order-date">
                                                        <i class="far fa-clock"></i>
                                                        <fmt:formatDate value="${order.createdAt}"
                                                                        pattern="dd/MM/yyyy HH:mm"/>
                                                    </span>
                                    <span class="order-payment">
                                                        <i class="fas fa-credit-card"></i>
                                                        <c:choose>
                                                            <c:when test="${order.paymentMethod == 'cod'}">COD</c:when>
                                                            <c:when test="${order.paymentMethod == 'bank_transfer'}">
                                                                Chuyển khoản</c:when>
                                                            <c:when test="${order.paymentMethod == 'momo'}">MoMo
                                                            </c:when>
                                                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                </div>
                                <span
                                        class="order-status status-${order.orderStatus != null ? order.orderStatus.toLowerCase() : 'pending'}">
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus == 'PENDING'}"><i
                                                                class="fas fa-clock"></i> Chờ xác nhận</c:when>
                                                        <c:when test="${order.orderStatus == 'CONFIRMED'}"><i
                                                                class="fas fa-check"></i> Đã xác nhận</c:when>
                                                        <c:when test="${order.orderStatus == 'SHIPPING'}"><i
                                                                class="fas fa-truck"></i> Đang giao hàng</c:when>
                                                        <c:when test="${order.orderStatus == 'COMPLETED'}"><i
                                                                class="fas fa-check-circle"></i> Hoàn thành</c:when>
                                                        <c:when test="${order.orderStatus == 'CANCELLED'}"><i
                                                                class="fas fa-times-circle"></i> Đã hủy</c:when>
                                                        <c:otherwise>${order.orderStatus}</c:otherwise>
                                                    </c:choose>
                                                </span>
                            </div>

                            <div class="order-card-body">
                                <c:forEach var="item" items="${order.orderItems}" varStatus="loop">
                                    <c:if test="${loop.index < 2}">
                                        <div class="order-item">
                                            <div class="order-item-image">
                                                <c:choose>
                                                    <c:when test="${empty item.productImage}">
                                                        <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png"
                                                             alt="${item.productName}">
                                                    </c:when>
                                                    <c:when
                                                            test="${item.productImage.startsWith('http')}">
                                                        <img src="${item.productImage}"
                                                             alt="${item.productName}"
                                                             onerror="this.src='${pageContext.request.contextPath}/static/assets/icons/LOGO.png'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/static/${item.productImage}"
                                                             alt="${item.productName}"
                                                             onerror="this.src='${pageContext.request.contextPath}/static/assets/icons/LOGO.png'">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="order-item-info">
                                                <span class="order-item-name">${item.productName}</span>
                                                <span
                                                        class="order-item-variant">${item.variantName}</span>
                                                <span class="order-item-qty">x${item.quantity}</span>
                                            </div>
                                            <span class="order-item-price">
                                                                <fmt:formatNumber value="${item.totalPrice}"
                                                                                  type="number"/>đ
                                                            </span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${order.orderItems != null && order.orderItems.size() > 2}">
                                    <p class="order-more-items">+ ${order.orderItems.size() - 2} sản
                                        phẩm khác</p>
                                </c:if>
                            </div>

                            <div class="order-card-footer">
                                <div class="order-total">
                                    Tổng tiền: <span>
                                                        <fmt:formatNumber value="${order.totalAmount}" type="number"/>đ
                                                    </span>
                                </div>
                                <div class="order-actions">
                                    <a href="${pageContext.request.contextPath}/orders/${order.orderId}"
                                       class="btn-order btn-order-primary">
                                        <i class="fas fa-eye"></i> Xem chi tiết
                                    </a>
                                    <c:if test="${order.orderStatus == 'PENDING'}">
                                        <form
                                                action="${pageContext.request.contextPath}/orders/${order.orderId}/cancel"
                                                method="post" style="display: inline;">
                                            <button type="submit" class="btn-order btn-order-danger"
                                                    onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                                <i class="fas fa-times"></i> Hủy đơn
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.orderStatus == 'COMPLETED'}">
                                        <a href="${pageContext.request.contextPath}/store"
                                           class="btn-order btn-order-outline">
                                            <i class="fas fa-redo"></i> Mua lại
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-box-open"></i>
                        </div>
                        <h4 class="empty-state-title">Chưa có đơn hàng nào</h4>
                        <p class="empty-state-text">
                            <c:choose>
                                <c:when test="${not empty status && status != 'ALL'}">
                                    Không có đơn hàng nào ở trạng thái này
                                </c:when>
                                <c:otherwise>
                                    Hãy mua sắm để có đơn hàng đầu tiên!
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <a href="${pageContext.request.contextPath}/store"
                           class="btn-profile btn-profile-primary">
                            <i class="fas fa-shopping-bag"></i> Khám phá sản phẩm
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>