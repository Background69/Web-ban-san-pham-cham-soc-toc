<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/12/2025
  Time: 10:01 SA
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>DashBoard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/images/LOGO.png" alt="logo">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li class="active"><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/banners">Quản lý banner</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/index">Quay lại Website</a>
    </aside>

    <!-- Main content -->
    <main class="content">
        <div class="header">
            <h1>Dashboard</h1>
            <button class="btn-add">+ Thêm Sản Phẩm Mới</button>
        </div>

        <!-- Cards -->
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
                <tr>
                    <td>#HD101</td>
                    <td>Nguyễn Lan</td>
                    <td>₫320,000</td>
                    <td><span class="status success">Hoàn thành</span></td>
                </tr>
                <tr>
                    <td>#HD102</td>
                    <td>Phạm Minh</td>
                    <td>₫150,000</td>
                    <td><span class="status pending">Đang xử lý</span></td>
                </tr>
                <tr>
                    <td>#HD103</td>
                    <td>Hoàng Hà</td>
                    <td>₫540,000</td>
                    <td><span class="status cancel">Đã hủy</span></td>
                </tr>
            </table>
        </div>

    </main>

</div>
</body>
</html>

