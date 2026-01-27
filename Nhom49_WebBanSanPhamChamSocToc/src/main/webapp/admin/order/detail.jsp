<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="activeMenu" value="orders"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
    <link rel="stylesheet" href="<c:url value='/static/css/admin/dashboard.css'/>">
</head>

<body>
<div class="container">
    <jsp:include page="/admin/layout/sidebar.jsp"/>

    <main class="content">
        <div class="header">
            <h1>Chi tiết đơn hàng #${order.id}</h1>
            <a href="<c:url value='/admin/order'/>">← Quay lại</a>
        </div>

        <!-- THÔNG TIN ĐƠN -->
        <div class="order-info">
            <p><b>Khách hàng:</b> ${order.customerName}</p>
            <p><b>Ngày đặt:</b>
                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
            </p>
            <p><b>Trạng thái:</b> ${order.status}</p>
            <p><b>Tổng tiền:</b>
                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
            </p>
        </div>

        <h3>Sản phẩm trong đơn</h3>

        <table class="table">
            <thead>
            <tr>
                <th>Sản phẩm</th>
                <th>Phân loại</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${orderItems}" var="item">
                <tr>
                    <td>${item.productName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty item.variantName}">
                                ${item.variantName}
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${item.quantity}</td>
                    <td>
                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/>
                    </td>
                    <td>
                        <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫"/>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </main>
</div>
</body>
</html>
