<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${totalPages > 1}">
    <div class="pagination">
        <c:set var="baseUrl" value="${pageContext.request.requestURI}"/>
        <c:set var="queryString" value=""/>

        <c:forEach var="param" items="${paramValues}">
            <c:if test="${param.key != 'page'}">
                <c:forEach var="value" items="${param.value}">
                    <c:set var="queryString"
                           value="${queryString}${empty queryString ? '?' : '&'}${param.key}=${value}"/>
                </c:forEach>
            </c:if>
        </c:forEach>

        <c:set var="pageParam" value="${empty queryString ? '?page=' : '&page='}"/>

        <!-- Previous button -->
        <c:choose>
            <c:when test="${currentPage > 1}">
                <a href="${baseUrl}${queryString}${pageParam}${currentPage - 1}" class="page-link prev">
                    <i class="fas fa-chevron-left"></i> Trước
                </a>
            </c:when>
            <c:otherwise>
            <span class="page-link prev disabled">
                <i class="fas fa-chevron-left"></i> Trước
            </span>
            </c:otherwise>
        </c:choose>

        <!-- Page numbers -->
        <div class="page-numbers">
            <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}"/>
            <c:set var="endPage" value="${startPage + 4 > totalPages ? totalPages : startPage + 4}"/>
            <c:if test="${endPage - startPage < 4}">
                <c:set var="startPage" value="${endPage - 4 > 1 ? endPage - 4 : 1}"/>
            </c:if>

            <c:if test="${startPage > 1}">
                <a href="${baseUrl}${queryString}${pageParam}1" class="page-link">1</a>
                <c:if test="${startPage > 2}">
                    <span class="page-ellipsis">...</span>
                </c:if>
            </c:if>

            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="page-link active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${baseUrl}${queryString}${pageParam}${i}" class="page-link">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${endPage < totalPages}">
                <c:if test="${endPage < totalPages - 1}">
                    <span class="page-ellipsis">...</span>
                </c:if>
                <a href="${baseUrl}${queryString}${pageParam}${totalPages}" class="page-link">${totalPages}</a>
            </c:if>
        </div>

        <!-- Next button -->
        <c:choose>
            <c:when test="${currentPage < totalPages}">
                <a href="${baseUrl}${queryString}${pageParam}${currentPage + 1}" class="page-link next">
                    Sau <i class="fas fa-chevron-right"></i>
                </a>
            </c:when>
            <c:otherwise>
            <span class="page-link next disabled">
                Sau <i class="fas fa-chevron-right"></i>
            </span>
            </c:otherwise>
        </c:choose>
    </div>
</c:if>
