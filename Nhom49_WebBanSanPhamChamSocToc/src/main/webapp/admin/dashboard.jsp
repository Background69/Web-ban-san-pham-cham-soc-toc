﻿<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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

    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard"/>
    </jsp:include>

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
                            <c:set var="rawStatus" value="${order.orderStatus}"/>
                            <c:set var="normalizedStatus"
                                   value="${rawStatus != null ? rawStatus.toLowerCase() : ''}"/>
                            <c:set var="statusText" value="${rawStatus}"/>
                            <c:set var="statusClass" value="unknown"/>
                            <c:choose>
                                <c:when test="${normalizedStatus eq 'pending'}">
                                    <c:set var="statusText" value="Chờ xử lý"/>
                                    <c:set var="statusClass" value="pending"/>
                                </c:when>
                                <c:when test="${normalizedStatus eq 'confirmed'}">
                                    <c:set var="statusText" value="Đã xác nhận"/>
                                    <c:set var="statusClass" value="confirmed"/>
                                </c:when>
                                <c:when test="${normalizedStatus eq 'processing'}">
                                    <c:set var="statusText" value="Đang xử lý"/>
                                    <c:set var="statusClass" value="processing"/>
                                </c:when>
                                <c:when test="${normalizedStatus eq 'shipping'}">
                                    <c:set var="statusText" value="Đang giao"/>
                                    <c:set var="statusClass" value="shipping"/>
                                </c:when>
                                <c:when
                                        test="${normalizedStatus eq 'delivered'
                                        or normalizedStatus eq 'completed'
                                        or normalizedStatus eq 'done'
                                        or normalizedStatus eq 'hoàn thành'
                                        or normalizedStatus eq 'hoan thanh'}">
                                    <c:set var="statusText" value="Hoàn thành"/>
                                    <c:set var="statusClass" value="completed"/>
                                </c:when>
                                <c:when
                                        test="${normalizedStatus eq 'cancelled'
                                        or normalizedStatus eq 'canceled'}">
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
        <!--chart-->
        <div class="filter-box">
            <select id="filterRevenue" onchange="loadChart()">
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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let chart;
    let piechart;
    function ichart(labels,data) {
        const ctx = document.getElementById('revenuechart').getContext('2d');
        if (chart) chart.destroy();
        const gradient = ctx.createLinearGradient(0, 0, 0, 300);
        gradient.addColorStop(0, "rgba(75, 192, 192, 0.5)");
        gradient.addColorStop(1, "rgba(75, 192, 192, 0)");

        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu',
                    data: data,
                    borderWidth: 2,
                    borderColor: "#4bc0c0",
                    backgroundColor: gradient,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointBackgroundColor: "#4bc0c0"
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return value.toLocaleString() + " ₫";
                            }
                        }
                    }
                }
            }
        });
    }
    function iPieChart(labels, data){
        const ctx = document.getElementById('orderchart').getContext('2d');
        if (piechart){
            piechart.destroy()
        }
        piechart = new Chart(ctx,{
            type:'pie',
            data:{
                labels:labels,
                datasets:[{
                    data:data,
                    backgroundColor:["#4caf50", "#f44336", "#ff9800"]
                }]
            },
            options: {
                responsive:true,
                maintainAspectRadio: false,
                animation: {
                    duration: 800
                },
                plugins: {
                    legend:{
                        position:"bottom"
                    }
                }
            }
        });
    }
    function loadChart() {
        const type = document.getElementById("filterRevenue").value;
        fetch("${pageContext.request.contextPath}/admin/dashboard-data?type=" + type)
        .then(res => res.json())
        .then(data => {
                ichart(data.labels, data.values);
                iPieChart(data.statusLabels, data.statusValues)
    });
    }
    window.onload= function (){
        loadChart();
    }

</script>
</body>

</html>
