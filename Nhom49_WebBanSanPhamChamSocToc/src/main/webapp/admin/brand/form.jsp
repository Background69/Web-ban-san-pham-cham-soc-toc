<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="../layout/sidebar.jsp" %>
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">

<div class="main-content">
    <h2>
        <c:choose>
            <c:when test="${brand != null}">Cập nhật thương hiệu</c:when>
            <c:otherwise>Thêm thương hiệu</c:otherwise>
        </c:choose>
    </h2>

    <form action="${pageContext.request.contextPath}/admin/brands/save" method="post">

        <!-- Khi edit -->
        <c:if test="${brand != null}">
            <input type="hidden" name="id" value="${brand.brandId}">
        </c:if>

        <div>
            <label>Tên thương hiệu</label><br>
            <input type="text" name="brandName"
                   value="${brand.brandName}" required>
        </div>

        <br>

        <div>
            <label>Slug</label><br>
            <input type="text" name="brandSlug"
                   value="${brand.brandSlug}">
        </div>

        <br>

        <div>
            <label>Mô tả ngắn</label><br>
            <textarea name="shortDescription" rows="3">
                ${brand.shortDescription}
            </textarea>
        </div>

        <br>

        <div>
            <label>Mô tả chi tiết</label><br>
            <textarea name="fullDescription" rows="5">
                ${brand.fullDescription}
            </textarea>
        </div>

        <br>

        <button type="submit">Lưu</button>
        <a href="${pageContext.request.contextPath}/admin/brands">Hủy</a>
    </form>
</div>
