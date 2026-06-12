<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý thương hiệu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/branchmanagement.css">
</head>

<body>
<div class="container">

    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="brands"/>
    </jsp:include>

    <main class="content">
        <div class="header">
            <h1>Quản lý thương hiệu</h1>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/brands/form">
                + Thêm thương hiệu
            </a>
        </div>
        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên thương hiệu</th>
                <th>Mô tả</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="b" items="${brands}">
                <tr>
                    <td>${b.brandId}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty b.logoUrl}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(b.logoUrl, 'http')}">
                                        <img class="thumb" src="${b.logoUrl}" alt="${b.brandName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="thumb" src="${pageContext.request.contextPath}/static/${b.logoUrl}" alt="${b.brandName}">
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <div class="thumb-placeholder"></div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${b.brandName}</td>
                    <td>${b.shortDescription}</td>
                    <td class="action-cell">
                        <a class="action-btn edit"
                           href="${pageContext.request.contextPath}/admin/brands/edit?id=${b.brandId}">
                            Sửa
                        </a>

                        <a class="action-btn delete"
                           href="${pageContext.request.contextPath}/admin/brands/delete?id=${b.brandId}"
                           onclick="return confirm('Xóa thương hiệu này?')">
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
