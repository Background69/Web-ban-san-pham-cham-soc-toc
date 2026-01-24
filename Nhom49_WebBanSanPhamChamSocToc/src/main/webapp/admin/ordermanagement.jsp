<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/images/logo.PNG" alt="Logo HairGlow">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/UserManagementController">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/ProductManagementController">Quản lý sản phẩm</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/OrderManagementController">Quản lý đơn hàng</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/home">Quay lại Website</a>
    </aside>

    <!-- Main content -->
    <main class="content">
        <div class="header">
            <h1>Quản lý đơn hàng</h1>
        </div>

        <!-- Orders Table -->
        <table class="orders-table">
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
                        <span class="status ${o.orderStatus}">
                            ${o.orderStatus}
                        </span>
                    </td>

                    <td>
                        <!-- UPDATE STATUS -->
                        <form action="${pageContext.request.contextPath}/OrderManagementController"
                              method="get" style="display:inline">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="${o.orderId}">
                            <select name="status" onchange="this.form.submit()">
                                <option value="pending" ${o.orderStatus == 'pending' ? 'selected' : ''}>Đang xử lý</option>
                                <option value="completed" ${o.orderStatus == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="cancelled" ${o.orderStatus == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </form>

                        <!-- DELETE -->
                        <a class="action-btn delete"
                           href="${pageContext.request.contextPath}/OrderManagementController?action=delete&id=${o.orderId}"
                           onclick="return confirm('Bạn có chắc muốn xóa đơn này?')">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </main>
</div>
</body>
</html>
