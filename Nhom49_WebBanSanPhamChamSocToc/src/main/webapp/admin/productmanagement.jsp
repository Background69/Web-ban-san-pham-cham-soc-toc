<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:01 SA
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/images/logo.png"
                 alt="Logo HairGlow">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
        </ul>

        <a class="view-site"
           href="${pageContext.request.contextPath}/index">
            Quay lại Website
        </a>
    </aside>

    <!-- Main content -->
    <main class="content">

        <div class="header">
            <h1>Quản lý sản phẩm</h1>
            <a class="btn-add"
               href="${pageContext.request.contextPath}/admin/products?action=create">
                + Thêm Sản Phẩm Mới
            </a>
        </div>

        <!-- Product Table -->
        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Danh mục</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>#P${p.productId}</td>

                    <td>
                        <img class="thumb"
                             src="${pageContext.request.contextPath}/uploads/${p.image}"
                             alt="${p.name}">
                    </td>

                    <td>${p.name}</td>

                    <td>
                        <fmt:formatNumber value="${p.price}" type="currency"/>
                    </td>

                    <td>${p.categoryName}</td>

                    <td>
                        <a class="edit"
                           href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}">
                            Sửa
                        </a>
                        |
                        <a class="delete"
                           onclick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?')"
                           href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty products}">
                <tr>
                    <td colspan="6" style="text-align:center">
                        Không có sản phẩm nào
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>

    </main>
</div>
</body>
</html>
 Cards -->
        <div class="cards">
            <div class="card">
                <h3>Tổng Sản Phẩm</h3>
                <p class="number">${productCount}</p>
            </div>
            <div class="card">
                <h3>Tổng Người Dùng</h3>
                <p class="number" >${userCount}</p>
            </div>
            <div class="card">
                <h3>Tổng Đơn Hàng</h3>
                <p class="number">${orderCount}</p>
            </div>
            <div class="card">
                <h3>Doanh Thu</h3>
                <p class="number">${totalRevenue}</p>
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
                        <td>${order.customerName}</td>
                        <td> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                        <td> <span class="status ${order.status}">
                                ${order.status}
                        </span></td>
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

