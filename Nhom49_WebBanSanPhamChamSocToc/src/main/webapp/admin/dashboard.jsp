<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" alt="logo">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li class="active"><a
                    href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/flash-sale">Quản lý giảm giá</a></li>

        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/">Quay lại Website</a>
    </aside>

    <!-- Main content -->
    <main class="content">
        <div class="header">
            <h1>Dashboard</h1>
        </div>

        <!-- Cards -->
        <div class="cards">
            <div class="card">
                <h3>Tổng Sản Phẩm</h3>
                <p class="number">${totalProducts}</p>
            </div>
            <div class="card">
                <h3>Tổng Người Dùng</h3>
                <p class="number">${totalUsers}</p>
            </div>
            <div class="card">
                <h3>Tổng Đơn Hàng</h3>
                <p class="number">${totalOrders}</p>
            </div>
            <div class="card">
                <h3>Doanh Thu</h3>
                <p class="number">
                    <fmt:formatNumber value="${totalRevenue}" type="number"/> ₫
                </p>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="recent-orders">
            <h2>Đơn hàng gần nhất</h2>
            <table>
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                </tr>
                <c:forEach var="order" items="${recentOrders}">
                    <tr>
                        <td>#HD${order.orderId}</td>
                        <td>${order.shippingFullName}</td>
                        <td>
                            <fmt:formatNumber value="${order.totalAmount}" type="number"/> ₫
                        </td>
                        <td>
                            <c:set var="statusText" value="${order.orderStatus}"/>
                            <c:set var="statusClass" value="${order.orderStatus}"/>
                            <c:choose>
                                <c:when
                                        test="${order.orderStatus eq 'pending' or order.orderStatus eq 'PENDING'}">
                                    <c:set var="statusText" value="Chờ xử lý"/>
                                    <c:set var="statusClass" value="pending"/>
                                </c:when>
                                <c:when
                                        test="${order.orderStatus eq 'confirmed' or order.orderStatus eq 'CONFIRMED'}">
                                    <c:set var="statusText" value="Đã xác nhận"/>
                                    <c:set var="statusClass" value="confirmed"/>
                                </c:when>
                                <c:when
                                        test="${order.orderStatus eq 'processing' or order.orderStatus eq 'PROCESSING'}">
                                    <c:set var="statusText" value="Đang xử lý"/>
                                    <c:set var="statusClass" value="processing"/>
                                </c:when>
                                <c:when
                                        test="${order.orderStatus eq 'shipping' or order.orderStatus eq 'SHIPPING'}">
                                    <c:set var="statusText" value="Đang giao"/>
                                    <c:set var="statusClass" value="shipping"/>
                                </c:when>
                                <c:when
                                        test="${order.orderStatus eq 'delivered' or order.orderStatus eq 'DELIVERED' or order.orderStatus eq 'completed' or order.orderStatus eq 'COMPLETED'}">
                                    <c:set var="statusText" value="Hoàn thành"/>
                                    <c:set var="statusClass" value="delivered"/>
                                </c:when>
                                <c:when
                                        test="${order.orderStatus eq 'cancelled' or order.orderStatus eq 'CANCELLED'}">
                                    <c:set var="statusText" value="Đã hủy"/>
                                    <c:set var="statusClass" value="cancelled"/>
                                </c:when>
                            </c:choose>
                            <span class="status ${statusClass}">${statusText}</span>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentOrders}">
                    <tr>
                        <td colspan="4">Chưa có đơn hàng nào</td>
                    </tr>
                </c:if>
            </table>
        </div>

    </main>

</div>
</body>

</html>