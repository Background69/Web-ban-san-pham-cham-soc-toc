<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="activeMenu" value="orders"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.orderId} | HairGlow Admin</title>
    <link rel="stylesheet" href="<c:url value='/static/css/admin/dashboard.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            box-sizing: border-box;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .page-header h1 {
            margin: 0;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .order-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .badge-pending {
            background: #fef3c7;
            color: #d97706;
        }

        .badge-confirmed {
            background: #dbeafe;
            color: #2563eb;
        }

        .badge-shipping {
            background: #e0e7ff;
            color: #4f46e5;
        }

        .badge-completed {
            background: #d1fae5;
            color: #059669;
        }

        .badge-cancelled {
            background: #fee2e2;
            color: #dc2626;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            background: #f3f4f6;
            color: #374151;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-back:hover {
            background: #e5e7eb;
        }

        /* Info Cards Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }

        .info-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
        }

        .info-card h3 {
            margin: 0 0 20px 0;
            font-size: 16px;
            font-weight: 700;
            color: #111;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-card h3 .icon {
            font-size: 20px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f3f4f6;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #6b7280;
            font-size: 14px;
        }

        .info-value {
            font-weight: 600;
            color: #111;
            font-size: 14px;
            text-align: right;
        }

        .info-value.highlight {
            color: #059669;
            font-size: 18px;
        }

        /* Products Table */
        .products-section {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            overflow: hidden;
        }

        .section-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .section-header h3 {
            margin: 0;
            font-size: 16px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .item-count {
            background: #f3f4f6;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
        }

        .products-table {
            width: 100%;
            border-collapse: collapse;
        }

        .products-table thead th {
            text-align: left;
            padding: 14px 20px;
            font-size: 12px;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #fafafa;
            border-bottom: 1px solid #f3f4f6;
        }

        .products-table tbody tr {
            transition: background 0.15s;
        }

        .products-table tbody tr:hover {
            background: #f9fafb;
        }

        .products-table tbody td {
            padding: 16px 20px;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }

        .product-cell {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .product-img {
            width: 56px;
            height: 56px;
            border-radius: 10px;
            object-fit: cover;
            background: #f3f4f6;
            border: 2px solid #f3f4f6;
        }

        .product-img-placeholder {
            width: 56px;
            height: 56px;
            border-radius: 10px;
            background: linear-gradient(135deg, #f3f4f6, #e5e7eb);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .product-info h4 {
            margin: 0 0 4px 0;
            font-size: 14px;
            font-weight: 600;
            color: #111;
        }

        .variant-badge {
            display: inline-block;
            padding: 4px 10px;
            background: #ede9fe;
            color: #7c3aed;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .quantity-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            background: #f3f4f6;
            border-radius: 8px;
            font-weight: 700;
            color: #374151;
        }

        .price {
            font-weight: 600;
            color: #111;
        }

        .price-total {
            font-weight: 700;
            color: #059669;
            font-size: 15px;
        }

        /* Summary */
        .order-summary {
            padding: 20px 24px;
            background: #fafafa;
            border-top: 1px solid #f3f4f6;
        }

        .summary-row {
            display: flex;
            justify-content: flex-end;
            gap: 40px;
            padding: 8px 0;
        }

        .summary-row .label {
            color: #6b7280;
            font-size: 14px;
            min-width: 120px;
            text-align: right;
        }

        .summary-row .value {
            font-weight: 600;
            color: #111;
            min-width: 120px;
            text-align: right;
        }

        .summary-row.total {
            padding-top: 16px;
            margin-top: 8px;
            border-top: 2px solid #e5e7eb;
        }

        .summary-row.total .label {
            font-weight: 700;
            color: #111;
            font-size: 16px;
        }

        .summary-row.total .value {
            font-size: 20px;
            color: #059669;
            font-weight: 800;
        }

        /* Actions */
        .actions-bar {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4b6b3c, #5d8a47);
            color: #fff;
            box-shadow: 0 4px 12px rgba(75, 107, 60, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(75, 107, 60, 0.4);
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        .btn-danger {
            background: #fee2e2;
            color: #dc2626;
        }

        .btn-danger:hover {
            background: #fecaca;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }

        .empty-state .icon {
            font-size: 48px;
            margin-bottom: 12px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
        }
    </style>
</head>

<body>
<div class="container">
    <jsp:include page="/admin/layout/sidebar.jsp"/>

    <main class="content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                Chi tiết đơn hàng #${order.orderId}
                <c:choose>
                    <c:when test="${order.orderStatus == 'pending'}">
                        <span class="order-badge badge-pending"> Chờ xác nhận</span>
                    </c:when>
                    <c:when test="${order.orderStatus == 'confirmed'}">
                        <span class="order-badge badge-confirmed"> Đã xác nhận</span>
                    </c:when>
                    <c:when test="${order.orderStatus == 'shipping'}">
                        <span class="order-badge badge-shipping"> Đang giao</span>
                    </c:when>
                    <c:when test="${order.orderStatus == 'completed'}">
                        <span class="order-badge badge-completed"> Hoàn thành</span>
                    </c:when>
                    <c:when test="${order.orderStatus == 'cancelled'}">
                        <span class="order-badge badge-cancelled"> Đã hủy</span>
                    </c:when>
                </c:choose>
            </h1>
            <a href="<c:url value='/admin/orders'/>" class="btn-back">
                ← Quay lại danh sách
            </a>
        </div>

        <c:if test="${not empty success}">
            <div style="background: #d1fae5; color: #065f46; border-radius: 10px; padding: 12px 14px; margin-bottom: 16px;">
                ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="background: #fee2e2; color: #991b1b; border-radius: 10px; padding: 12px 14px; margin-bottom: 16px;">
                ${error}
            </div>
        </c:if>

        <!-- Info Cards -->
        <div class="info-grid">
            <!-- Customer Info -->
            <div class="info-card">
                <h3>Thông tin khách hàng</h3>
                <div class="info-row">
                    <span class="info-label">Họ tên</span>
                    <span class="info-value">${order.shippingFullName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số điện thoại</span>
                    <span class="info-value">${order.shippingPhone}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Địa chỉ</span>
                    <span class="info-value">${order.shippingAddress}</span>
                </div>
            </div>

            <!-- Order Info -->
            <div class="info-card">
                <h3> Thông tin đơn hàng</h3>
                <div class="info-row">
                    <span class="info-label">Mã đơn</span>
                    <span class="info-value">${order.orderCode}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Ngày đặt</span>
                    <span class="info-value">
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Phương thức vận chuyển</span>
                    <span class="info-value">${order.shippingMethodDisplayName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Thanh toán</span>
                    <span class="info-value">${order.paymentMethodDisplayName}</span>
                </div>
            </div>

            <c:if test="${not empty paymentTransaction}">
                <div class="info-card">
                    <h3>Giao dịch chuyển khoản</h3>
                    <div class="info-row">
                        <span class="info-label">Mã giao dịch</span>
                        <span class="info-value">#${paymentTransaction.transactionId}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Trạng thái</span>
                        <span class="info-value">${paymentTransaction.status}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Số tiền</span>
                        <span class="info-value">
                            <fmt:formatNumber value="${paymentTransaction.amount}" type="number"/>₫
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Nội dung CK</span>
                        <span class="info-value">${paymentTransaction.transferContent}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Ngân hàng</span>
                        <span class="info-value">${paymentTransaction.bankName}</span>
                    </div>
                    <c:if test="${not empty paymentTransaction.expiresAt}">
                        <div class="info-row">
                            <span class="info-label">Hạn thanh toán</span>
                            <span class="info-value">
                                <fmt:formatDate value="${paymentTransaction.expiresAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${not empty paymentTransaction.confirmedAt}">
                        <div class="info-row">
                            <span class="info-label">Đã xác nhận lúc</span>
                            <span class="info-value">
                                <fmt:formatDate value="${paymentTransaction.confirmedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${paymentTransaction.status == 'PENDING'}">
                        <div style="margin-top: 14px;">
                            <a href="<c:url value='/admin/orders?action=confirmPayment&transactionId=${paymentTransaction.transactionId}'/>"
                               class="btn btn-primary"
                               onclick="return confirm('Xác nhận đã nhận tiền cho giao dịch này?')">
                                Xác nhận đã nhận tiền
                            </a>
                        </div>
                    </c:if>
                </div>
            </c:if>
        </div>

        <!-- Products Table -->
        <div class="products-section">
            <div class="section-header">
                <h3><span class="icon">🛒</span> Sản phẩm trong đơn</h3>
                <span class="item-count">${orderItems.size()} sản phẩm</span>
            </div>

            <c:choose>
                <c:when test="${not empty orderItems}">
                    <table class="products-table">
                        <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Phân loại</th>
                            <th style="text-align: center">Số lượng</th>
                            <th style="text-align: right">Đơn giá</th>
                            <th style="text-align: right">Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${orderItems}" var="item">
                            <tr>
                                <td>
                                    <div class="product-cell">
                                        <c:choose>
                                            <c:when test="${not empty item.productImage}">
                                                <img class="product-img"
                                                     src="${item.productImage}"
                                                     alt="${item.productName}"
                                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-img-placeholder"></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="product-info">
                                            <h4>${item.productName}</h4>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.variantName}">
                                            <span class="variant-badge">${item.variantName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #9ca3af">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center">
                                    <span class="quantity-badge">${item.quantity}</span>
                                </td>
                                <td style="text-align: right">
                                                        <span class="price">
                                                            <fmt:formatNumber value="${item.unitPrice}" type="number"/>
                                                            ₫
                                                        </span>
                                </td>
                                <td style="text-align: right">
                                                        <span class="price-total">
                                                            <fmt:formatNumber value="${item.totalPrice}"
                                                                              type="number"/>₫
                                                        </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <!-- Order Summary -->
                    <div class="order-summary">
                        <div class="summary-row">
                            <span class="label">Tạm tính</span>
                            <span class="value">
                                                <fmt:formatNumber value="${order.subtotal}" type="number"/>₫
                                            </span>
                        </div>
                        <div class="summary-row">
                            <span class="label">Phí vận chuyển</span>
                            <span class="value">
                                                <fmt:formatNumber value="${order.shippingFee}" type="number"/>₫
                                            </span>
                        </div>
                        <div class="summary-row total">
                            <span class="label">Tổng cộng</span>
                            <span class="value">
                                                <fmt:formatNumber value="${order.totalAmount}" type="number"/>₫
                                            </span>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>Không có sản phẩm trong đơn hàng này</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Actions -->
        <div class="actions-bar">
            <c:if test="${order.orderStatus == 'pending' && (order.paymentMethod != 'bank_transfer' || (not empty paymentTransaction && paymentTransaction.status == 'SUCCESS'))}">
                <a href="<c:url value='/admin/orders?action=updateStatus&id=${order.orderId}&status=confirmed&from=detail'/>"
                   class="btn btn-primary">
                    Xác nhận đơn
                </a>
            </c:if>
            <c:if test="${order.orderStatus == 'pending' && order.paymentMethod == 'bank_transfer' && (empty paymentTransaction || paymentTransaction.status != 'SUCCESS')}">
                <span class="btn btn-secondary">Chờ xác nhận thanh toán chuyển khoản</span>
            </c:if>
            <c:if test="${order.orderStatus == 'confirmed'}">
                <a href="<c:url value='/admin/orders?action=updateStatus&id=${order.orderId}&status=shipping&from=detail'/>"
                   class="btn btn-primary">
                    Giao hàng
                </a>
            </c:if>
            <c:if test="${order.orderStatus == 'shipping'}">
                <a href="<c:url value='/admin/orders?action=updateStatus&id=${order.orderId}&status=completed&from=detail'/>"
                   class="btn btn-primary">
                    Hoàn thành
                </a>
            </c:if>
            <c:if test="${order.orderStatus != 'cancelled' && order.orderStatus != 'completed'}">
                <a href="<c:url value='/admin/orders?action=updateStatus&id=${order.orderId}&status=cancelled&from=detail'/>"
                   class="btn btn-danger"
                   onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                    Hủy đơn
                </a>
            </c:if>
            <a href="javascript:window.print()" class="btn btn-secondary">
                In đơn hàng
            </a>
        </div>
    </main>
</div>
</body>

</html>
