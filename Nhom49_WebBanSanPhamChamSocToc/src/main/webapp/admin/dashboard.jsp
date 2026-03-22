<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"  pageEncoding="UTF-8" %>

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
            <li class="active"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/promotion/flash-sale.jsp">Quản lý giảm giá</a></li>

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
                        <td><fmt:formatNumber value="${order.totalAmount}" type="number"/> ₫</td>
                        <td>
                            <span class="status ${order.orderStatus}">
                                ${order.orderStatus}
                            </span>
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
        <!--chart-->
        <div style = "margin-bottom: 20px">
            <select id="filterRevenue" onchange="changeFilter">
                <option value="week" ${type=='week'? 'selected':''} >Theo tuần</option>
                <option value="month" ${type=='month'? 'selected':''} >Theo tháng</option>
                <option value="year" ${type=='year'? 'selected':''} >Theo năm</option>
            </select>
        </div>
        <div class="chart">
            <div class="chartbox">
                <h2>Doanh thu theo
                <c:choose>
                    <c:when test="${type=='month'}">tháng</c:when>
                    <c:when test="${type=='year'}">năm</c:when>
                    <c:otherwise>tuần</c:otherwise>
                </c:choose></h2>
                <canvas id="revenuechart">
                </canvas>
            </div>
            <div class="chartbox">
                <h2>Đơn hàng theo trạng thái</h2>
                <canvas id="orderchart"></canvas>
            </div>
        </div>

    </main>

</div>
<script> function changeFilter(){
    const type = document.getElementById("filterRevenue").value;
    window.location.href ="${pageContext.request.contextPath}/admin/dashboard?type=" + type;

}</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const revenueLabels = ${revenueLabels};
    const revenueData = ${revenueData};

    new Chart(document.getElementById('revenuechart'),{
        type: 'line',
        data: {
            labels: revenueLabels,
            datasets:[{
                label:'Doanh thu',
                data:revenueData,
                borderWidth:2,
                fill:false
            }]
        }
    });
</script>
</body>
</html>

