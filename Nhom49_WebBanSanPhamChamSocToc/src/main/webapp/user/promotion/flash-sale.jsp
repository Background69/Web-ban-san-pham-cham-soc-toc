<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style_for_super-deal.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main>
    <!-- Flash Sale Banner -->
    <div class="flash-sale-banner">
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
            <div class="deals-grid">
                <c:forEach var="product" items="${saleProducts}">
                    <div class="super-deal-item"
                         data-category="${product.defaultVariant != null && product.defaultVariant.discountPercent >= 30 ? 'flash-sale' : 'sale'}">
                        <c:if test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                            <div class="deal-badge">-${product.defaultVariant.discountPercent}%</div>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}" class="deal-image">
                            <c:choose>
                                <c:when test="${product.primaryImage != null}">
                                    <img src="${pageContext.request.contextPath}/static/images/${product.primaryImage.imageUrl}"
                                         alt="${product.productName}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/no-image.png"
                                         alt="${product.productName}">
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <div class="deal-content">
                            <h3>
                                <a href="${pageContext.request.contextPath}/product/${product.productSlug}">${product.productName}</a>
                            </h3>
                            <div class="deal-price">
                                <span class="current-price">
                                    <fmt:formatNumber
                                            value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                            type="number"/>₫
                                </span>
                                <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                    <span class="original-price">
                                        <fmt:formatNumber value="${product.defaultVariant.originalPrice}"
                                                          type="number"/>₫
                                    </span>
                                </c:if>
                            </div>
                            <c:if test="${product.stockQuantity > 0}">
                                <div class="deal-progress">
                                    <div class="progress-bar">
                                        <div class="progress-fill"
                                             style="width: ${product.soldPercent}%"></div>
                                    </div>
                                    <span class="sold-text">
                                        Đã bán ${product.soldQuantity}/${product.stockQuantity}
                                    </span>
                                </div>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="deal-btn">
                                    <i class="fas fa-shopping-cart"></i> Mua ngay
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Empty State -->
            <c:if test="${empty saleProducts}">
                <div class="empty-state">
                    <i class="fas fa-tags"></i>
                    <h3>Chưa có khuyến mãi nào</h3>
                    <p>Hãy quay lại sau để xem các ưu đãi mới nhất!</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-primary">Xem tất cả sản phẩm</a>
                </div>
            </c:if>
        </div>

        <!-- Combo Deals -->
        <c:if test="${not empty comboDeals}">
            <div class="super-deal-section">
                <h2><i class="fas fa-gift"></i> COMBO SIÊU HỜI</h2>
                <div class="combo-grid">
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
                                        <fmt:formatNumber value="${combo.originalPrice}" type="number"/>?
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
    document.querySelectorAll('.super-deal-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.super-deal-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const filter = this.dataset.filter;
            document.querySelectorAll('.super-deal-item').forEach(item => {
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


