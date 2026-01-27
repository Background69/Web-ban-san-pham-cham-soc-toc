<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flash Sale - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/user/style_for_super-deal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/flash-sale-card.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>

<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="page-animate">
    <!-- Flash Sale Banner -->
    <div class="flash-sale-banner section-animate">
        <div class="flash-content">
            <h1>FLASH SALE SIÊU ƯU ĐÃI</h1>
            <p>Giảm đến 70% - Số lượng có hạn</p>
            <div class="countdown" id="countdown">
                <div class="time-box">
                    <span id="hours">02</span>
                    <small>Gi?</small>
                </div>
                <div class="time-box">
                    <span id="minutes">15</span>
                    <small>Phút</small>
                </div>
                <div class="time-box">
                    <span id="seconds">30</span>
                    <small>Giây</small>
                </div>
            </div>
        </div>
    </div>

    <div class="super-deal-container">

        <!-- Deals Section -->
        <div class="super-deal-section">
            <h2><i class="fas fa-fire"></i> DEALS DANG HOT</h2>
            <div class="deals-grid stagger-fade">
                <c:forEach var="product" items="${saleProducts}">
                    <div class="product-item"
                         data-category="${product.defaultVariant != null && product.defaultVariant.discountPercent >= 30 ? 'flash-sale' : 'sale'}">
                        <c:if
                                test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                            <div class="flash-sale-badge">-${product.defaultVariant.discountPercent}%
                            </div>
                        </c:if>

                        <div class="product-img">
                            <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                <img alt="${product.productName}" class="product-image"
                                     src="${pageContext.request.contextPath}/static/${product.primaryImage != null ? product.primaryImage.imageUrl : 'images/default-product.png'}">
                            </a>
                        </div>

                        <div class="product-body">
                            <h3 class="product-title">${product.productName}</h3>

                            <div class="product-price">
                                <c:if test="${product.defaultVariant != null}">
                                    <p class="price-current">
                                        <fmt:formatNumber
                                                value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                                type="number"/>₫
                                    </p>
                                    <c:if
                                            test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                        <p class="price-old">
                                            <fmt:formatNumber
                                                    value="${product.defaultVariant.originalPrice}"
                                                    type="number"/>₫
                                        </p>
                                        <p class="badge-discount">
                                            -${product.defaultVariant.discountPercent}%</p>
                                    </c:if>
                                </c:if>
                            </div>

                            <div class="product">
                                <a class="btn"
                                   href="${pageContext.request.contextPath}/product/${product.productSlug}">Xem
                                    thêm</a>
                                <a class="btn primary add-to-cart" href="#"
                                   data-product-id="${product.productId}">Thêm vào giỏ</a>
                            </div>

                            <c:if test="${product.onSale && product.stockQuantity > 0}">
                                <div class="stock-progress">
                                    <div class="stock-progress-bar">
                                        <div class="stock-progress-fill"
                                             style="width: ${product.soldPercent}%"></div>
                                    </div>
                                    <div class="stock-progress-text">
                                        Đã bán ${product.soldQuantity}/${product.stockQuantity}
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${totalPages > 1}">
                <c:set var="startPage" value="${currentPage - 2}"/>
                <c:set var="endPage" value="${currentPage + 2}"/>
                <c:if test="${startPage < 1}">
                    <c:set var="endPage" value="${endPage + (1 - startPage)}"/>
                    <c:set var="startPage" value="1"/>
                </c:if>
                <c:if test="${endPage > totalPages}">
                    <c:set var="startPage" value="${startPage - (endPage - totalPages)}"/>
                    <c:set var="endPage" value="${totalPages}"/>
                </c:if>
                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1"/>
                </c:if>
                <c:set var="prevPage" value="${currentPage > 1 ? currentPage - 1 : 1}"/>
                <c:set var="nextPage"
                       value="${currentPage < totalPages ? currentPage + 1 : totalPages}"/>
                <nav class="flash-sale-pagination" aria-label="Flash sale pagination">
                    <ul class="flash-pagination-list">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.requestURI}?page=${prevPage}">Previous</a>
                        </li>
                        <c:if test="${startPage > 1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.requestURI}?page=1">1</a>
                            </li>
                            <c:if test="${startPage > 2}">
                                <li class="page-item ellipsis"><span class="page-ellipsis">...</span>
                                </li>
                            </c:if>
                        </c:if>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.requestURI}?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <li class="page-item ellipsis"><span class="page-ellipsis">...</span>
                                </li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.requestURI}?page=${totalPages}">${totalPages}</a>
                            </li>
                        </c:if>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.requestURI}?page=${nextPage}">Next</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <!-- Empty State -->
            <c:if test="${empty saleProducts}">
                <div class="empty-state">
                    <i class="fas fa-tags"></i>
                    <h3>Chưa có khuyến mãi nào</h3>
                    <p>Hãy quay lại sau để xem các ưu đãi mới nhất!</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-primary">Xem tất cả
                        sản phẩm</a>
                </div>
            </c:if>
        </div>

        <!-- Combo Deals -->
        <c:if test="${not empty comboDeals}">
            <div class="super-deal-section">
                <h2><i class="fas fa-gift"></i> COMBO SIÊU HỜI</h2>
                <div class="combo-grid stagger-fade">
                    <c:forEach var="combo" items="${comboDeals}">
                        <div class="combo-item">
                            <div class="combo-badge">Ti?t ki?m ${combo.saveAmount}?</div>
                            <div class="combo-images">
                                <c:forEach var="item" items="${combo.products}">
                                    <img src="${item.primaryImage}" alt="${item.name}">
                                </c:forEach>
                            </div>
                            <div class="combo-content">
                                <h3>${combo.name}</h3>
                                <p>${combo.description}</p>
                                <div class="combo-price">
                                                    <span class="current-price">
                                                        <fmt:formatNumber value="${combo.comboPrice}" type="number"/>?
                                                    </span>
                                    <span class="original-price">
                                                        <fmt:formatNumber value="${combo.originalPrice}"
                                                                          type="number"/>?
                                                    </span>
                                </div>
                                <button class="combo-btn">Mua combo</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    // Countdown timer - đếm ngược đến cuối ngày
    function startCountdown() {
        function updateCountdown() {
            const now = new Date();
            const endOfDay = new Date();
            endOfDay.setHours(23, 59, 59, 999);
            const diff = endOfDay - now;

            if (diff <= 0) {
                document.getElementById('hours').textContent = '00';
                document.getElementById('minutes').textContent = '00';
                document.getElementById('seconds').textContent = '00';
                return;
            }

            const hours = Math.floor(diff / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

            document.getElementById('hours').textContent = hours.toString().padStart(2, '0');
            document.getElementById('minutes').textContent = minutes.toString().padStart(2, '0');
            document.getElementById('seconds').textContent = seconds.toString().padStart(2, '0');
        }

        updateCountdown();
        setInterval(updateCountdown, 1000);
    }

    startCountdown();

    // Filter deals
    const dealItems = document.querySelectorAll('.deals-grid .product-item');
    document.querySelectorAll('.super-deal-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.super-deal-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const filter = this.dataset.filter;
            dealItems.forEach(item => {
                if (filter === 'all' || item.dataset.category === filter) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    });
</script>
</body>

</html>