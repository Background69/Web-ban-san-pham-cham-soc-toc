<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container">

    <%@ include file="../layout/sidebar.jsp" %>

    <main class="content">
        <div>
        <h2>Quản lý thương hiệu</h2>
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
        <a href="${pageContext.request.contextPath}/admin/brand/form.jsp"
           class="btn-add">
            + Thêm thương hiệu
        </a>
        </div>
        <table class="product-table">
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
                        <a class="edit"
                           href="${pageContext.request.contextPath}/admin/brand/edit?id=${b.id}">
                            Sửa
                        </a>
                        <a class="delete"
                           href="${pageContext.request.contextPath}/admin/brand/delete?id=${b.id}"
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
