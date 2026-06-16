<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/ordermanagement.css">

</head>

<body>
<div class="container">

    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="orders"/>
    </jsp:include>
    <!-- CONTENT -->
    <main class="content">
        <div class="header">
            <h1>Quản lý đơn hàng</h1>
            <div class="toolbar">
                <form action="${pageContext.request.contextPath}/admin/orders" method="get">
                    <input type="text"
                           name="keyword"
                           placeholder="Tìm theo mã đơn hoặc khách hàng..."
                           value="${param.keyword}">

                    <select name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="pending"
                        ${param.status == 'pending' ? 'selected' : ''}>
                            Chờ xác nhận
                        </option>

                        <option value="confirmed"
                        ${param.status == 'confirmed' ? 'selected' : ''}>
                            Đã xác nhận
                        </option>

                        <option value="shipping"
                        ${param.status == 'shipping' ? 'selected' : ''}>
                            Đang giao
                        </option>

                        <option value="completed"
                        ${param.status == 'completed' ? 'selected' : ''}>
                            Hoàn thành
                        </option>

                        <option value="cancelled"
                        ${param.status == 'cancelled' ? 'selected' : ''}>
                            Đã hủy
                        </option>
                    </select>

                    <button type="submit" class="btn-add">
                        Tìm kiếm
                    </button>
                </form>
            </div>
        </div>

        <table class="product-table">
            <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${orders}" var="o">
                <tr>
                    <td>${o.orderCode}</td>
                    <td>${o.shippingFullName}</td>

                    <td>
                        <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                          currencySymbol="&#8363;"/>
                    </td>

                    <td>
                        <form action="${pageContext.request.contextPath}/admin/orders" method="get">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="${o.orderId}">
                            <select name="status" onchange="this.form.submit()" class="status-select status-${o.orderStatus}">
                                <option value="pending" ${o.orderStatus=='pending' ? 'selected' : ''
                                        }>
                                    Chờ xác nhận
                                </option>
                                <option value="confirmed" ${o.orderStatus=='confirmed' ? 'selected'
                                        : '' }>
                                    Đã xác nhận
                                </option>
                                <option value="shipping" ${o.orderStatus=='shipping' ? 'selected'
                                        : '' }>
                                    Đang giao
                                </option>
                                <option value="completed" ${o.orderStatus=='completed' ? 'selected'
                                        : '' }>
                                    Hoàn thành
                                </option>
                                <option value="cancelled" ${o.orderStatus=='cancelled' ? 'selected'
                                        : '' }>
                                    Đã hủy
                                </option>
                            </select>
                        </form>
                    </td>

                    <td class="action-cell">
                        <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.orderId}" class="btn-action btn-detail">
                            Chi tiết
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders?action=delete&id=${o.orderId}"
                                class="btn-action btn-delete"
                                onclick="return confirm('Xóa đơn này?')">

                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty orders}">
                <tr>
                    <td colspan="5" style="text-align:center">Không có đơn hàng</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </main>
</div>
</body>

</html>
