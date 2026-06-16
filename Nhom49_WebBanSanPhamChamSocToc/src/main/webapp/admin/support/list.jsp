<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hỗ trợ khách hàng — HairGlow Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/support.css">
</head>
<body>
<div class="container">
    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="support"/>
    </jsp:include>
    <main class="content admin-support-page">

        <c:url var="supportAllUrl" value="/admin/support">
            <c:param name="keyword" value="${filterKeyword}"/>
            <c:param name="category" value="${filterCategory}"/>
        </c:url>
        <c:url var="supportReceivedUrl" value="/admin/support">
            <c:param name="status" value="RECEIVED"/>
            <c:param name="keyword" value="${filterKeyword}"/>
            <c:param name="category" value="${filterCategory}"/>
        </c:url>
        <c:url var="supportProcessingUrl" value="/admin/support">
            <c:param name="status" value="PROCESSING"/>
            <c:param name="keyword" value="${filterKeyword}"/>
            <c:param name="category" value="${filterCategory}"/>
        </c:url>

        <form class="as-filter-bar" method="get" action="${pageContext.request.contextPath}/admin/support" id="filterForm">
            <input type="text"
                   name="keyword"
                   class="as-search-input"
                   placeholder="Tìm theo mã ticket, email, tên khách hàng, tiêu đề..."
                   value="${fn:escapeXml(filterKeyword)}"
                   autocomplete="off">

            <select name="status" onchange="this.form.submit()">
                <option value="">— Trạng thái —</option>
                <option value="RECEIVED" ${filterStatus == 'RECEIVED' ? 'selected' : ''}>Đã tiếp nhận</option>
                <option value="PROCESSING" ${filterStatus == 'PROCESSING' ? 'selected' : ''}>Đang xử lý</option>
                <option value="RESOLVED" ${filterStatus == 'RESOLVED' ? 'selected' : ''}>Đã giải quyết</option>
                <option value="CLOSED" ${filterStatus == 'CLOSED' ? 'selected' : ''}>Đã đóng</option>
            </select>

            <select name="category" onchange="this.form.submit()">
                <option value="">— Chủ đề —</option>
                <option value="SYSTEM_ERROR" ${filterCategory == 'SYSTEM_ERROR' ? 'selected' : ''}>Lỗi hệ thống</option>
                <option value="SHIPPING" ${filterCategory == 'SHIPPING' ? 'selected' : ''}>Vận chuyển</option>
                <option value="PRODUCT_QUALITY" ${filterCategory == 'PRODUCT_QUALITY' ? 'selected' : ''}>Chất lượng SP</option>
                <option value="SHOPPING_GUIDE" ${filterCategory == 'SHOPPING_GUIDE' ? 'selected' : ''}>Hướng dẫn mua</option>
                <option value="OTHER" ${filterCategory == 'OTHER' ? 'selected' : ''}>Khác</option>
            </select>

            <div class="as-ticket-filter-tabs" aria-label="Lọc nhanh ticket">
                <a href="${supportAllUrl}"
                   class="as-filter-chip ${empty filterStatus ? 'active' : ''}">
                    <i class="fas fa-list"></i> Tất cả ticket
                </a>
                <a href="${supportReceivedUrl}"
                   class="as-filter-chip ${filterStatus == 'RECEIVED' ? 'active' : ''}">
                    <i class="fas fa-inbox"></i> Chưa xử lý
                </a>
                <a href="${supportProcessingUrl}"
                   class="as-filter-chip ${filterStatus == 'PROCESSING' ? 'active' : ''}">
                    <i class="fas fa-spinner"></i> Đang xử lý
                </a>
            </div>

            <button type="submit" class="as-btn-reset" style="background:var(--support-primary);color:#fff;border-color:var(--support-primary);">
                <i class="fas fa-search"></i> Tìm
            </button>
            <a href="${pageContext.request.contextPath}/admin/support" class="as-btn-reset">
                <i class="fas fa-redo"></i> Đặt lại
            </a>
        </form>

        <c:if test="${not empty error}">
            <div class="as-alert as-alert--error">
                <i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(error)}
            </div>
        </c:if>

        <div class="as-table-card">
            <c:choose>
                <c:when test="${not empty tickets}">
                    <table class="as-table">
                        <thead>
                        <tr>
                            <th>Mã ticket</th>
                            <th>Khách hàng</th>
                            <th>Chủ đề</th>
                            <th>Tiêu đề</th>
                            <th>Trạng thái</th>
                            <th>Ngày gửi</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ticket" items="${tickets}">
                            <tr onclick="window.location='${pageContext.request.contextPath}/admin/support?action=detail&id=${ticket.feedbackId}'">
                                <td>
                                    <span class="as-ticket-code">${fn:escapeXml(ticket.ticketCode)}</span>
                                </td>
                                <td>
                                    <div class="as-customer-name">${fn:escapeXml(ticket.customerName)}</div>
                                    <div class="as-customer-email">${fn:escapeXml(ticket.customerEmail)}</div>
                                </td>
                                <td>
                                    <c:set var="catClass" value="" />
                                    <c:set var="catLabel" value="${fn:escapeXml(ticket.category)}" />
                                    <c:choose>
                                        <c:when test="${ticket.category == 'SYSTEM_ERROR'}">
                                            <c:set var="catClass" value="as-category--system_error" />
                                            <c:set var="catLabel" value="Lỗi hệ thống" />
                                        </c:when>
                                        <c:when test="${ticket.category == 'SHIPPING'}">
                                            <c:set var="catClass" value="as-category--shipping" />
                                            <c:set var="catLabel" value="Vận chuyển" />
                                        </c:when>
                                        <c:when test="${ticket.category == 'PRODUCT_QUALITY'}">
                                            <c:set var="catClass" value="as-category--product_quality" />
                                            <c:set var="catLabel" value="Chất lượng SP" />
                                        </c:when>
                                        <c:when test="${ticket.category == 'SHOPPING_GUIDE'}">
                                            <c:set var="catLabel" value="Hướng dẫn mua" />
                                        </c:when>
                                        <c:when test="${ticket.category == 'OTHER'}">
                                            <c:set var="catLabel" value="Khác" />
                                        </c:when>
                                    </c:choose>
                                    <span class="as-category ${catClass}">${catLabel}</span>
                                </td>
                                <td>
                                    <span class="as-ticket-title" title="${fn:escapeXml(ticket.title)}">${fn:escapeXml(ticket.title)}</span>
                                </td>
                                <td>
                                    <c:set var="statusClass" value="" />
                                    <c:set var="statusLabel" value="" />
                                    <c:choose>
                                        <c:when test="${ticket.status == 'RECEIVED'}">
                                            <c:set var="statusClass" value="as-status--received" />
                                            <c:set var="statusLabel" value="Đã tiếp nhận" />
                                        </c:when>
                                        <c:when test="${ticket.status == 'PROCESSING'}">
                                            <c:set var="statusClass" value="as-status--processing" />
                                            <c:set var="statusLabel" value="Đang xử lý" />
                                        </c:when>
                                        <c:when test="${ticket.status == 'RESOLVED'}">
                                            <c:set var="statusClass" value="as-status--resolved" />
                                            <c:set var="statusLabel" value="Đã giải quyết" />
                                        </c:when>
                                        <c:when test="${ticket.status == 'CLOSED'}">
                                            <c:set var="statusClass" value="as-status--closed" />
                                            <c:set var="statusLabel" value="Đã đóng" />
                                        </c:when>
                                    </c:choose>
                                    <span class="as-status ${statusClass}">${statusLabel}</span>
                                </td>
                                <td>
                                    <span class="as-ticket-date">
                                        <fmt:formatDate value="${ticket.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/support?action=detail&id=${ticket.feedbackId}"
                                       class="as-btn-detail" onclick="event.stopPropagation()">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${totalPages > 1}">
                        <div class="as-pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/admin/support?page=${currentPage - 1}&keyword=${fn:escapeXml(filterKeyword)}&status=${fn:escapeXml(filterStatus)}&category=${fn:escapeXml(filterCategory)}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/support?page=${i}&keyword=${fn:escapeXml(filterKeyword)}&status=${fn:escapeXml(filterStatus)}&category=${fn:escapeXml(filterCategory)}">
                                            ${i}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/admin/support?page=${currentPage + 1}&keyword=${fn:escapeXml(filterKeyword)}&status=${fn:escapeXml(filterStatus)}&category=${fn:escapeXml(filterCategory)}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="as-empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>Chưa có ticket nào</h3>
                        <p>Khi khách hàng gửi yêu cầu hỗ trợ, ticket sẽ hiển thị tại đây.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>
</body>
</html>
