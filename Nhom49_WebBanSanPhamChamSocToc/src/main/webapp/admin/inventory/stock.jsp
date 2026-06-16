<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tồn kho</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/stock.css">


</head>

<body>

<div class="container">

    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="inventory"/>
    </jsp:include>

    <main class="content">

        <h1>Tồn kho toàn hệ thống</h1>

        <table class="stock-table">

            <thead>
            <tr>
                <th>ID Variant</th>
                <th>Sản phẩm</th>
                <th>Biến thể</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
            </tr>
            </thead>

            <tbody>

            <c:choose>

                <c:when test="${empty stockList}">
                    <tr>
                        <td colspan="5" class="empty">
                            Không có dữ liệu tồn kho
                        </td>
                    </tr>
                </c:when>

                <c:otherwise>

                    <c:forEach var="item" items="${stockList}">
                        <tr>
                            <td>${item.variantId}</td>
                            <td>${item.productName}</td>
                            <td>${item.variantName}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${item.stock == 0}">
                                        <span class="stock-badge stock-out">${item.stock}</span>
                                    </c:when>

                                    <c:when test="${item.stock <= 10}">
                                        <span class="stock-badge stock-low">${item.stock}</span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="stock-badge stock-ok">${item.stock}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <fmt:formatNumber value="${item.price}" type="number"/> đ
                            </td>
                        </tr>
                    </c:forEach>

                </c:otherwise>

            </c:choose>

            </tbody>

        </table>

    </main>
</div>

</body>
</html>