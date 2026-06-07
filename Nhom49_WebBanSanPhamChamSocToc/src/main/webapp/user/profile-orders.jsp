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
    <c:set var="activeTab" value="orders" scope="request"/>

    <div class="account-layout">
        <jsp:include page="/user/layout/account-sidebar.jsp"/>

        <div class="account-main">
            <div class="tab-content">
                <div class="tab-content-header">
                    <h3 class="tab-content-title">
                        <i class="fas fa-box"></i> Đơn hàng của tôi
                    </h3>
                </div>

        <nav class="order-tabs-nav" id="orderFilterTabs">
            <button type="button" class="order-tab ${empty status || status == 'all' ? 'active' : ''}"
                    data-target="all">
                <span class="order-tab__label">Tất cả</span>
                <c:if test="${orderCounts != null}">
                    <span class="order-tab__count">${orderCounts.all}</span>
                </c:if>
            </button>
            <button type="button" class="order-tab ${status == 'pending' ? 'active' : ''}"
                    data-target="pending">
                <span class="order-tab__label">Chờ xác nhận</span>
                <c:if test="${orderCounts != null && orderCounts.pending > 0}">
                    <span class="order-tab__count">${orderCounts.pending}</span>
                </c:if>
            </button>
            <button type="button" class="order-tab ${status == 'confirmed' ? 'active' : ''}"
                    data-target="confirmed">
                <span class="order-tab__label">Đã xác nhận</span>
                <c:if test="${orderCounts != null && orderCounts.confirmed > 0}">
                    <span class="order-tab__count">${orderCounts.confirmed}</span>
                </c:if>
            </button>
            <button type="button" class="order-tab ${status == 'shipping' ? 'active' : ''}"
                    data-target="shipping">
                <span class="order-tab__label">Đang giao</span>
                <c:if test="${orderCounts != null && orderCounts.shipping > 0}">
                    <span class="order-tab__count">${orderCounts.shipping}</span>
                </c:if>
            </button>
            <button type="button" class="order-tab ${status == 'completed' ? 'active' : ''}"
                    data-target="completed">
                <span class="order-tab__label">Hoàn thành</span>
                <c:if test="${orderCounts != null && orderCounts.completed > 0}">
                    <span class="order-tab__count">${orderCounts.completed}</span>
                </c:if>
            </button>
            <button type="button" class="order-tab ${status == 'cancelled' ? 'active' : ''}"
                    data-target="cancelled">
                <span class="order-tab__label">Đã hủy</span>
                <c:if test="${orderCounts != null && orderCounts.cancelled > 0}">
                    <span class="order-tab__count">${orderCounts.cancelled}</span>
                </c:if>
            </button>
            <!-- Sliding Indicator -->
            <div class="tab-indicator"></div>
        </nav>

        <!-- Orders List -->
        <div class="orders-list" id="ordersListContainer">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card" data-order-status="${order.orderStatus != null ? order.orderStatus.toLowerCase() : 'pending'}">
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
                                                        <c:when test="${order.orderStatus == 'pending'}"><i
                                                                class="fas fa-clock"></i> Chờ xác nhận</c:when>
                                                        <c:when test="${order.orderStatus == 'confirmed'}"><i
                                                                class="fas fa-check"></i> Đã xác nhận</c:when>
                                                        <c:when test="${order.orderStatus == 'shipping'}"><i
                                                                class="fas fa-truck"></i> Đang giao hàng</c:when>
                                                        <c:when test="${order.orderStatus == 'completed'}"><i
                                                                class="fas fa-check-circle"></i> Hoàn thành</c:when>
                                                        <c:when test="${order.orderStatus == 'cancelled'}"><i
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
                                    <c:if test="${order.orderStatus == 'pending'}">
                                        <form
                                                action="${pageContext.request.contextPath}/orders/${order.orderId}/cancel"
                                                method="post" style="display: inline;">
                                            <button type="submit" class="btn-order btn-order-danger"
                                                    onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                                <i class="fas fa-times"></i> Hủy đơn
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.orderStatus == 'completed'}">
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
                            Hãy mua sắm để có đơn hàng đầu tiên!
                        </p>
                        <a href="${pageContext.request.contextPath}/store"
                           class="btn-profile btn-profile-primary">
                            <i class="fas fa-shopping-bag"></i> Khám phá sản phẩm
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Empty state khi filter không có kết quả (ẩn mặc định) -->
            <div class="empty-state empty-state-filtered" id="emptyStateFiltered" style="display: none;">
                <div class="empty-state-icon">
                    <i class="fas fa-search"></i>
                </div>
                <h4 class="empty-state-title">Không tìm thấy đơn hàng</h4>
                <p class="empty-state-text">
                    Không có đơn hàng nào ở trạng thái này
                </p>
            </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/order-history-tabs.js"></script>

</body>

</html>

