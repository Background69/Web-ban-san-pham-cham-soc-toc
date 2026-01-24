<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="activeMenu" value="orders"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <jsp:include page="/admin/layout/sidebar.jsp"/>

    <main class="content">
        <div class="header">
            <h1>Chi tiết đơn hàng</h1>
            <a href="${pageContext.request.contextPath}/admin/orders">← Quay lại</a>
        </div>

        <!-- Thông tin đơn -->
        <div class="order-info">
            <p><b>Mã đơn:</b> ${order.orderCode}</p>
            <p><b>Khách hàng:</b> ${order.shippingFullName}</p>
            <p><b>Địa chỉ:</b> ${order.shippingAddress}</p>
            <p><b>SĐT:</b> ${order.shippingPhone}</p>
            <p><b>Trạng thái:</b> ${order.orderStatus}</p>
            <p><b>Tổng tiền:</b>
                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
            </p>
        </div>

        <!-- Danh sách sản phẩm -->
        <h3>Sản phẩm trong đơn</h3>
        <table>
            <thead>
            <tr>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Giá</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${orderItems}" var="item">
                <tr>
                    <td>${item.productName}</td>
                    <td>${item.quantity}</td>
                    <td>
                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </main>
</div>
</body>
</html>
