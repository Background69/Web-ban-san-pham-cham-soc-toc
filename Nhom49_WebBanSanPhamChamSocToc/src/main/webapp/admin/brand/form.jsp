<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../layout/header.jsp" %>
<%@ include file="../layout/sidebar.jsp" %>

<div class="main-content">
    <h2>
        <c:choose>
            <c:when test="${brand != null}">Cập nhật thương hiệu</c:when>
            <c:otherwise>Thêm thương hiệu</c:otherwise>
        </c:choose>
    </h2>

    <form action="${pageContext.request.contextPath}/admin/brand/save" method="post">

        <!-- Khi edit -->
        <c:if test="${brand != null}">
            <input type="hidden" name="id" value="${brand.id}">
        </c:if>

        <div>
            <label>Tên thương hiệu</label><br>
            <input type="text" name="name" value="${brand.name}" required>
        </div>

        <br>

        <div>
            <label>Mô tả</label><br>
            <textarea name="description" rows="4">${brand.description}</textarea>
        </div>

        <br>

        <button type="submit">Lưu</button>
        <a href="${pageContext.request.contextPath}/admin/brand">Hủy</a>
    </form>
</div>

<%@ include file="../layout/footer.jsp" %>
