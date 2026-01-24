<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../layout/header.jsp" %>
<%@ include file="../layout/sidebar.jsp" %>

<div class="main-content">
    <h2>Quản lý thương hiệu</h2>

    <a href="${pageContext.request.contextPath}/admin/brand/form" class="btn btn-primary">
        + Thêm thương hiệu
    </a>

    <table border="1" width="100%" cellpadding="8" cellspacing="0" style="margin-top: 15px">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên thương hiệu</th>
            <th>Mô tả</th>
            <th>Thao tác</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="b" items="${brands}">
            <tr>
                <td>${b.id}</td>
                <td>${b.name}</td>
                <td>${b.description}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/brand/edit?id=${b.id}">
                        Sửa
                    </a>
                    |
                    <a href="${pageContext.request.contextPath}/admin/brand/delete?id=${b.id}"
                       onclick="return confirm('Xóa thương hiệu này?')">
                        Xóa
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="../layout/footer.jsp" %>
