<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${totalPages > 1}">
    <%-- Base URL for products --%>
    <c:set var="baseUrl" value="${pageContext.request.contextPath}/products"/>
    <c:set var="hasQuery" value="${not empty paginationQueryString}"/>

    <nav class="pagination">
            <%-- Previous Button --%>
        <c:choose>
            <c:when test="${currentPage > 1}">
                <a href="${baseUrl}?${paginationQueryString}${hasQuery ? '&' : ''}page=${currentPage - 1}"
                   class="page-link page-prev">
                    <i class="fa-solid fa-chevron-left"></i> <span>Trước</span>
                </a>
            </c:when>
            <c:otherwise>
        <span class="page-link disabled page-prev">
          <i class="fa-solid fa-chevron-left"></i> <span>Trước</span>
        </span>
            </c:otherwise>
        </c:choose>

            <%-- Page Numbers --%>
        <div class="page-numbers">
            <c:choose>
                <%-- Case 1: totalPages <= 7 --%>
                <c:when test="${totalPages <= 7}">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="page-link active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${baseUrl}?${paginationQueryString}${hasQuery ? '&' : ''}page=${i}"
                                   class="page-link">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>

                <%-- Case 2: totalPages > 7 (ellipsis window) --%>
                <c:otherwise>
                    <%-- Page 1 --%>
                    <c:choose>
                        <c:when test="${currentPage == 1}">
                            <span class="page-link active">1</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${baseUrl}?${paginationQueryString}${hasQuery ? '&' : ''}page=1" class="page-link">1</a>
                        </c:otherwise>
                    </c:choose>

                    <%-- Leading ellipsis --%>
                    <c:if test="${currentPage > 4}">
                        <span class="pagination-ellipsis">...</span>
                    </c:if>

                    <%-- Window around current page --%>
                    <c:set var="windowStart" value="${currentPage - 2}"/>
                    <c:set var="windowEnd" value="${currentPage + 2}"/>
                    <c:if test="${windowStart < 2}">
                        <c:set var="windowStart" value="2"/>
                    </c:if>
                    <c:if test="${windowEnd > totalPages - 1}">
                        <c:set var="windowEnd" value="${totalPages - 1}"/>
                    </c:if>

                    <c:forEach begin="${windowStart}" end="${windowEnd}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="page-link active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${baseUrl}?${paginationQueryString}${hasQuery ? '&' : ''}page=${i}"
                                   class="page-link">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Trailing ellipsis --%>
                    <c:if test="${currentPage < totalPages - 3}">
                        <span class="pagination-ellipsis">...</span>
                    </c:if>

                    <%-- Last page --%>
                    <c:choose>
                        <c:when test="${currentPage == totalPages}">
                            <span class="page-link active">${totalPages}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${baseUrl}?${paginationQueryString}${hasQuery ? '&' : ''}page=${totalPages}"
                               class="page-link">${totalPages}</a>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </div>

            <%-- Next Button --%>
        <c:choose>
            <c:when test="${currentPage < totalPages}">
                <a href="${baseUrl}?${paginationQueryString}${hasQuery ? '&' : ''}page=${currentPage + 1}"
                   class="page-link page-next">
                    <span>Sau</span> <i class="fa-solid fa-chevron-right"></i>
                </a>
            </c:when>
            <c:otherwise>
        <span class="page-link disabled page-next">
          <span>Sau</span> <i class="fa-solid fa-chevron-right"></i>
        </span>
            </c:otherwise>
        </c:choose>
    </nav>
</c:if>
