<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../layout/sidebar.jsp"/>

<h2>Flash Sale Management</h2>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Product</th>
        <th>Discount (%)</th>
        <th>Start</th>
        <th>End</th>
    </tr>

    <c:forEach var="f" items="${flashSales}">
        <tr>
            <td>${f.id}</td>
            <td>${f.productName}</td>
            <td>${f.discountPercent}</td>
            <td>${f.startTime}</td>
            <td>${f.endTime}</td>
        </tr>
    </c:forEach>
</table>
