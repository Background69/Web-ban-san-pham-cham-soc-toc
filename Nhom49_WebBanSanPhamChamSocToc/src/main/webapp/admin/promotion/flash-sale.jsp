<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý Flash Sale | HairGlow Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/promotionmanagement.css">

</head>

<body>
<div class="container">
    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="flash-sale"/>
    </jsp:include>

    <main class="content">
        <div class="flash-header">
            <h1> Quản lý Flash Sale</h1>
            <div style="display:flex;gap:10px">
                <form action="${pageContext.request.contextPath}/admin/flash-sale"
                      method="post">

                    <input type="hidden"
                           name="action"
                           value="bulkDiscount">

                    <input type="number"
                           name="discountPercent"
                           min="1"
                           max="90"
                           placeholder="% giảm"
                           required>

                    <button type="submit" class="btn-add">
                        Áp dụng hàng loạt
                    </button>

                </form>
                <button class="btn-add" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Thêm sản phẩm vào Sale
                </button>
            </div>
        </div>

        <div class="section-title">

            Sản phẩm đang Sale
            <span class="count">${saleProducts.size()} sản phẩm</span>
        </div>

        <c:choose>
            <c:when test="${not empty saleProducts}">
                <table class="sale-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá gốc</th>
                        <th>Giá sale</th>
                        <th>Tồn kho</th>
                        <th>Thương hiệu</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${saleProducts}">
                        <tr>
                            <td>#P${p.productId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.primaryImageUrl}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(p.primaryImageUrl, 'http')}">
                                                <img class="thumb" src="${p.primaryImageUrl}" alt="">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="thumb"
                                                     src="${pageContext.request.contextPath}/${p.primaryImageUrl}"
                                                     alt="">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <img class="thumb"
                                             src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png"
                                             alt="">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <strong>
                                    <c:out value="${p.productName}"/>
                                </strong>
                                <span class="sale-badge">SALE</span>
                            </td>
                            <td>
                                <c:if
                                        test="${p.defaultVariant != null && p.defaultVariant.originalPrice != null}">
                                    <fmt:formatNumber value="${p.defaultVariant.originalPrice}"
                                                      type="number"/> ₫
                                </c:if>
                            </td>
                            <td style="color:#ff5722;font-weight:700">
                                <c:if
                                        test="${p.defaultVariant != null && p.defaultVariant.salePrice != null && p.defaultVariant.salePrice > 0}">
                                    <fmt:formatNumber value="${p.defaultVariant.salePrice}"
                                                      type="number"/> ₫
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.remainingStock <= 5}">
                                        <span class="stock-low">${p.remainingStock}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-ok">${p.remainingStock}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:out value="${p.brandName}"/>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/flash-sale"
                                      method="post" style="display:inline"
                                      onsubmit="return confirm('Xóa sản phẩm này khỏi Flash Sale?')">
                                    <input type="hidden" name="action" value="removeFromSale">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-times"></i> Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <p>Chưa có sản phẩm nào trong Flash Sale</p>
                    <button class="btn btn-primary" onclick="openAddModal()" style="margin-top:16px">
                        <i class="fas fa-plus"></i> Thêm sản phẩm ngay
                    </button>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<!-- Add Products Modal -->
<div id="addModal" class="modal" onclick="backdropClose(event)">
    <div class="modal-content" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h2 class="modal-title"> Thêm sản phẩm vào Flash Sale</h2>
            <button class="modal-close" onclick="closeModal()">X</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/flash-sale" method="post">
            <input type="hidden" name="action" value="addToSale">
            <div class="modal-body">
                <c:choose>
                    <c:when test="${not empty nonSaleProducts}">
                        <p style="margin-bottom:16px;color:#666">Chọn sản phẩm để thêm vào Flash Sale:
                        </p>
                        <div class="product-list">
                            <c:forEach var="p" items="${nonSaleProducts}">
                                <label class="product-item">
                                    <input type="checkbox" name="productIds" value="${p.productId}">
                                <c:choose>
                                    <c:when test="${not empty p.primaryImageUrl}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(p.primaryImageUrl, 'http')}">
                                                <img class="thumb" src="${p.primaryImageUrl}" alt="">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="thumb"
                                                     src="${pageContext.request.contextPath}/${p.primaryImageUrl}"
                                                     alt="">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                        <c:otherwise>
                                            <img class="thumb"
                                                 src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png"
                                                 alt="">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="info">
                                        <div class="name">
                                            <c:out value="${p.productName}"/>
                                            <c:if test="${requestScope['promotionConflict_'.concat(p.productId)]}">
                                            <span class="conflict-badge">Có khuyến mãi khác</span>
                                            </c:if>
                                        </div>
                                        <div class="price">
                                            <c:if
                                                    test="${p.defaultVariant != null && p.defaultVariant.originalPrice != null}">
                                                <fmt:formatNumber
                                                        value="${p.defaultVariant.originalPrice}"
                                                        type="number"/> ₫
                                            </c:if>
                                        </div>
                                    </div>
                                </label>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-check-circle" style="color:#4caf50"></i>
                            <p>Tất cả sản phẩm đã được thêm vào Flash Sale!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                <c:if test="${not empty nonSaleProducts}">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Thêm vào Sale
                    </button>
                </c:if>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('addModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('addModal').style.display = 'none';
    }

    function backdropClose(e) {
        if (e.target.classList.contains('modal')) {
            closeModal();
        }
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeModal();
    });
</script>

</body>

</html>
