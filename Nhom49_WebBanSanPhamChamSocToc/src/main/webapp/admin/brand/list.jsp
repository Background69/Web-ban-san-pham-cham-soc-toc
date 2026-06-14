<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý thương hiệu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/brandmanagement.css">

    <style>
        .thumb {
            width: 52px;
            height: 52px;
            object-fit: contain;
            border-radius: 8px;
            border: 1px solid #eee;
            background: #f9f9f9;
        }

        .thumb-placeholder {
            width: 52px;
            height: 52px;
            border-radius: 8px;
            background: #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #9ca3af;
        }
    </style>
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
                        <c:set var="brandLogoUrl" value="${b.logoUrl}"/>
                        <c:set var="brandLogoSrc" value=""/>
                        <c:if test="${not empty brandLogoUrl}">
                            <c:choose>
                                <c:when test="${fn:startsWith(brandLogoUrl, 'http://') || fn:startsWith(brandLogoUrl, 'https://')}">
                                    <c:set var="brandLogoSrc" value="${brandLogoUrl}"/>
                                </c:when>
                                <c:when test="${fn:startsWith(brandLogoUrl, '/')}">
                                    <c:set var="brandLogoSrc" value="${pageContext.request.contextPath}${brandLogoUrl}"/>
                                </c:when>
                                <c:when test="${fn:contains(brandLogoUrl, '/')}">
                                    <c:set var="brandLogoSrc" value="${pageContext.request.contextPath}/${brandLogoUrl}"/>
                                </c:when>
                            </c:choose>
                        </c:if>
                        <c:choose>
                            <c:when test="${not empty brandLogoSrc}">
                                <img class="thumb" src="${brandLogoSrc}" alt="${fn:escapeXml(b.brandName)}"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="thumb-placeholder" style="display:none"></div>
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
