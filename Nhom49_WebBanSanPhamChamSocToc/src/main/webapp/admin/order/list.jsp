<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="activeMenu" value="orders"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li ><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li ><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/promotion/flash-sale.jsp">Quản lý giảm giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>
    <!-- CONTENT -->
    <main class="content">
        <div class="header">
            <h1>Quản lý đơn hàng</h1>
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
                        <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/>
                    </td>

                    <td>
                        <form action="${pageContext.request.contextPath}/admin/order/detail.jsp"
                              method="post">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="${o.orderId}">
                            <select name="status" onchange="this.form.submit()">
                                <option value="pending" ${o.orderStatus == 'pending' ? 'selected' : ''}>Đang xử lý</option>
                                <option value="completed" ${o.orderStatus == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="cancelled" ${o.orderStatus == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </form>
                    </td>

                    <td>
                        <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.orderId}">
                            Chi tiết
                        </a>
                        |
                        <a href="${pageContext.request.contextPath}/admin/orders?action=delete&id=${o.orderId}"
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
