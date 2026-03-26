<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="activeMenu" value="flash-sale"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý Flash Sale | HairGlow Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .flash-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .flash-header h1 {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .flash-header h1 i {
            color: #ff5722;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            margin: 24px 0 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title .count {
            background: #4caf50;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        /* Product Table */
        .sale-table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }

        .sale-table th,
        .sale-table td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .sale-table th {
            background: #f8f9fa;
            font-weight: 700;
            color: #333;
        }

        .sale-table .thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #eee;
        }

        .sale-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            background: #ff5722;
            color: white;
        }

        .stock-low {
            color: #f44336;
            font-weight: 600;
        }

        .stock-ok {
            color: #4caf50;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background: #fff;
            width: min(700px, 92vw);
            max-height: 80vh;
            margin: 60px auto;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            border-bottom: 1px solid #eee;
            background: linear-gradient(135deg, #ff5722, #ff9800);
            color: white;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 700;
            margin: 0;
        }

        .modal-close {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            font-size: 20px;
            cursor: pointer;
        }

        .modal-body {
            padding: 20px 24px;
            max-height: 50vh;
            overflow-y: auto;
        }

        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        /* Product checkbox list */
        .product-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .product-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .product-item:hover {
            background: #fff3e0;
            border-color: #ff9800;
        }

        .product-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }

        .product-item .thumb {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 6px;
        }

        .product-item .info {
            flex: 1;
        }

        .product-item .name {
            font-weight: 600;
            color: #333;
        }

        .product-item .price {
            font-size: 13px;
            color: #666;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff5722, #ff9800);
            color: white;
        }

        .btn-secondary {
            background: #e0e0e0;
            color: #333;
        }

        .btn-danger {
            background: #ffebee;
            color: #c62828;
        }

        .btn-add {
            background: linear-gradient(135deg, #ff5722, #ff9800);
            color: white;
            padding: 12px 20px;
            border-radius: 12px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state i {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 16px;
        }

        @media (max-width: 768px) {

            .sale-table th:nth-child(4),
            .sale-table td:nth-child(4),
            .sale-table th:nth-child(5),
            .sale-table td:nth-child(5) {
                display: none;
            }
        }
    </style>
</head>

<body>
<div class="container">
    <jsp:include page="/admin/layout/sidebar.jsp"/>

    <main class="content">
        <div class="flash-header">
            <h1> Quản lý Flash Sale</h1>
            <button class="btn-add" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Thêm sản phẩm vào Sale
            </button>
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
                                        <img class="thumb"
                                             src="${pageContext.request.contextPath}/static/${p.primaryImageUrl}"
                                             alt="">
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
            <button class="modal-close" onclick="closeModal()">×</button>
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
                                            <img class="thumb"
                                                 src="${pageContext.request.contextPath}/static/${p.primaryImageUrl}"
                                                 alt="">
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