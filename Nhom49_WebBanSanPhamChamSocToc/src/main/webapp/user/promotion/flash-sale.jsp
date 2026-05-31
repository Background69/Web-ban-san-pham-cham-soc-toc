<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flash Sale - HairGlow</title>
    
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/user/style_for_flash-sale.css">
</head>

<body>
<jsp:include page="/layout/header.jsp"/>

<c:set var="saleProductCount" value="${not empty saleProducts ? saleProducts.size() : 0}"/>
<c:set var="displayTotalPages" value="${totalPages != null && totalPages > 0 ? totalPages : 1}"/>

<main class="flash-sale-page">
    <section class="flash-sale-hero flash-sale-section">
        <div class="flash-hero-content">
            <p class="flash-hero-kicker">HairGlow Curated Flash Sale</p>
            <h1>Flash Sale chăm tóc</h1>
            <p class="flash-hero-subtext">
                Deal được chọn lọc cho dầu gội, dầu xả, serum và phục hồi tóc mỗi ngày.
            </p>
            <div class="flash-hero-actions">
                <a class="hero-btn hero-btn-primary" href="#flash-sale-deals">Xem deal đang diễn ra</a>
                <a class="hero-btn hero-btn-ghost"
                   href="${pageContext.request.contextPath}/products">Khám phá sản phẩm</a>
            </div>
        </div>

        <div class="flash-hero-panels">
            <div class="countdown-panel flash-sale-countdown">
                <p class="panel-label">Deal kết thúc trong ngày</p>
                <div class="countdown-clock" aria-live="polite">
                    <div class="time-box">
                        <span id="hours">00</span>
                        <small>Giờ</small>
                    </div>
                    <div class="time-box">
                        <span id="minutes">00</span>
                        <small>Phút</small>
                    </div>
                    <div class="time-box">
                        <span id="seconds">00</span>
                        <small>Giây</small>
                    </div>
                </div>
            </div>

            <div class="flash-stats-panel">
                <div class="flash-stat">
                    <span class="stat-label">Sản phẩm đang sale</span>
                    <strong>${saleProductCount}</strong>
                </div>
                <div class="flash-stat">
                    <span class="stat-label">Trang hiện tại</span>
                    <strong>${currentPage != null ? currentPage : 1}/${displayTotalPages}</strong>
                </div>
                <div class="flash-stat">
                    <span class="stat-label">Nhóm chăm tóc trọng điểm</span>
                    <strong>Khô xơ, da đầu dầu, tóc nhuộm</strong>
                </div>
            </div>
        </div>
    </section>

    <div class="super-deal-container flash-sale-wrapper">
        <section class="curated-needs flash-sale-curated">
            <div class="section-heading">
                <h2>Gợi ý theo nhu cầu tóc</h2>
                <p>Chọn nhanh nhóm deal phù hợp với tình trạng tóc hiện tại.</p>
            </div>
            <div class="needs-grid">
                <article class="need-card">
                    <h3>Tóc khô xơ</h3>
                    <p>Ưu tiên dầu xả phục hồi, mặt nạ ủ tóc và serum khóa ẩm.</p>
                    <span class="need-note">Routine dưỡng ẩm sâu</span>
                </article>
                <article class="need-card">
                    <h3>Da đầu dầu</h3>
                    <p>Tập trung làm sạch dịu nhẹ và cân bằng bã nhờn mỗi ngày.</p>
                    <span class="need-note">Làm sạch và thông thoáng</span>
                </article>
                <article class="need-card">
                    <h3>Tóc nhuộm và phục hồi</h3>
                    <p>Ưu tiên sản phẩm bảo vệ màu, giảm khô và hạn chế xơ rối.</p>
                    <span class="need-note">Bảo vệ màu và cấu trúc tóc</span>
                </article>
                <article class="need-card">
                    <h3>Tóc dễ gãy rụng</h3>
                    <p>Ưu tiên routine làm sạch dịu nhẹ, dưỡng chân tóc và giảm tác động nhiệt.</p>
                    <span class="need-note">Giảm gãy rụng và củng cố sợi tóc</span>
                </article>
            </div>
        </section>

        <section id="flash-sale-deals" class="super-deal-section flash-sale-deals">
            <div class="section-heading">
                <h2>Deal chăm tóc được chọn lọc</h2>
                <p>Giá tốt mỗi ngày với bố cục rõ ràng, dễ so sánh và dễ chọn.</p>
            </div>

            <div class="super-deal-categories flash-sale-tabs" role="tablist" aria-label="Lọc deal theo mức giảm">
                <button type="button" class="super-deal-btn flash-sale-tab active" data-filter="all">Tất cả deal</button>
                <button type="button" class="super-deal-btn flash-sale-tab" data-filter="flash-sale">Giảm từ 30%</button>
                <button type="button" class="super-deal-btn flash-sale-tab" data-filter="sale">Giảm dưới 30%</button>
            </div>

            <c:if test="${not empty saleProducts}">
                <div class="deals-grid flash-sale-grid">
                    <c:forEach var="product" items="${saleProducts}">
                        <article class="product-item flash-sale-card"
                                 data-category="${product.defaultVariant != null && product.defaultVariant.discountPercent >= 30 ? 'flash-sale' : 'sale'}">
                            <c:if test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                                <div class="flash-sale-badge">-${product.defaultVariant.discountPercent}%</div>
                            </c:if>

                            <div class="product-img flash-sale-card-media">
                                <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                    <c:choose>
                                        <c:when test="${not empty product.primaryImageUrl and fn:startsWith(product.primaryImageUrl, 'http')}">
                                            <img alt="${product.productName}" class="product-image"
                                                 loading="lazy"
                                                 src="${product.primaryImageUrl}"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/images/default-product.png';">
                                        </c:when>
                                        <c:when test="${not empty product.primaryImageUrl}">
                                            <img alt="${product.productName}" class="product-image"
                                                 loading="lazy"
                                                 src="${pageContext.request.contextPath}/${product.primaryImageUrl}"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/images/default-product.png';">
                                        </c:when>
                                        <c:otherwise>
                                            <img alt="${product.productName}" class="product-image"
                                                 loading="lazy"
                                                 src="${pageContext.request.contextPath}/static/images/default-product.png">
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>

                            <div class="product-body flash-sale-card-body">
                                <h3 class="product-title">
                                    <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                            ${product.productName}
                                    </a>
                                </h3>

                                <div class="product-meta">
                                    <span>${product.brand != null ? product.brand.brandName : 'HairGlow'}</span>
                                    <span>${product.category != null ? product.category.categoryName : 'Chăm sóc tóc'}</span>
                                    <span>${not empty product.origin ? product.origin : 'Việt Nam'}</span>
                                </div>

                                <div class="product-rating">
                                    <span class="rating-value">
                                        <c:choose>
                                            <c:when test="${product.averageRating != null && product.averageRating > 0}">
                                                ${product.averageRating}/5
                                            </c:when>
                                            <c:otherwise>Chưa có đánh giá</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="review-count">(${product.reviewCount != null ? product.reviewCount : 0})</span>
                                </div>

                                <div class="product-price">
                                    <c:if test="${product.defaultVariant != null}">
                                        <p class="price-current">
                                            <fmt:formatNumber
                                                    value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                                    type="number"/>₫
                                        </p>
                                        <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                            <p class="price-old">
                                                <fmt:formatNumber value="${product.defaultVariant.originalPrice}"
                                                                  type="number"/>₫
                                            </p>
                                            <p class="badge-discount">-${product.defaultVariant.discountPercent}%</p>
                                        </c:if>
                                    </c:if>
                                </div>

                                <c:choose>
                                    <c:when test="${product.stockQuantity != null && product.stockQuantity > 0}">
                                        <div class="stock-progress">
                                            <div class="stock-progress-bar">
                                                <div class="stock-progress-fill"
                                                     style="width: ${product.soldPercent != null ? product.soldPercent : 0}%"></div>
                                            </div>
                                            <div class="stock-progress-text">
                                                Đã bán ${product.soldQuantity != null ? product.soldQuantity : 0}/${product.stockQuantity}
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="stock-progress stock-empty">Tạm hết hàng</div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="product-actions flash-sale-card-actions">
                                    <a class="btn btn-outline"
                                       href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                        Chi tiết
                                    </a>
                                    <c:choose>
                                        <c:when test="${product.stockQuantity != null && product.stockQuantity > 0}">
                                            <a class="btn btn-solid add-to-cart" href="#"
                                               data-product-id="${product.productId}">
                                                Thêm vào giỏ
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-solid btn-disabled" disabled>
                                                Hết hàng
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:if>

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
                <c:set var="nextPage" value="${currentPage < totalPages ? currentPage + 1 : totalPages}"/>

                <nav class="flash-sale-pagination" aria-label="Flash sale pagination">
                    <ul class="flash-pagination-list">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/flash-sale?page=${prevPage}">Trước</a>
                        </li>

                        <c:if test="${startPage > 1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/flash-sale?page=1">1</a>
                            </li>
                            <c:if test="${startPage > 2}">
                                <li class="page-item ellipsis"><span class="page-ellipsis">...</span></li>
                            </c:if>
                        </c:if>

                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/flash-sale?page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <li class="page-item ellipsis"><span class="page-ellipsis">...</span></li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/flash-sale?page=${totalPages}">${totalPages}</a>
                            </li>
                        </c:if>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/flash-sale?page=${nextPage}">Tiếp</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <c:if test="${empty saleProducts}">
                <div class="empty-state">
                    <h3>Chưa có khuyến mãi phù hợp</h3>
                    <p>Vui lòng quay lại sau để xem các deal chăm tóc mới nhất.</p>
                    <a href="${pageContext.request.contextPath}/products" class="empty-state-link">
                        Xem tất cả sản phẩm
                    </a>
                </div>
            </c:if>
        </section>

        <c:if test="${not empty comboDeals}">
            <section class="combo-section flash-sale-combo">
                <div class="section-heading">
                    <h2>Combo chăm tóc tiết kiệm</h2>
                    <p>Kết hợp sẵn các bước gội, xả, dưỡng để tối ưu ngân sách.</p>
                </div>
                <div class="combo-grid flash-sale-combo-grid">
                    <c:forEach var="combo" items="${comboDeals}">
                        <article class="combo-item">
                            <div class="combo-badge">
                                Tiết kiệm <fmt:formatNumber value="${combo.saveAmount}" type="number"/>₫
                            </div>
                            <div class="combo-images">
                                <c:forEach var="item" items="${combo.products}">
                                    <img src="${item.primaryImage}" alt="${item.name}" loading="lazy"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/images/default-product.png';">
                                </c:forEach>
                            </div>
                            <div class="combo-content">
                                <h3>${combo.name}</h3>
                                <p>${combo.description}</p>
                                <div class="combo-price">
                                    <span class="combo-current-price">
                                        <fmt:formatNumber value="${combo.comboPrice}" type="number"/>₫
                                    </span>
                                    <span class="combo-original-price">
                                        <fmt:formatNumber value="${combo.originalPrice}" type="number"/>₫
                                    </span>
                                </div>
                                <button type="button" class="combo-btn">Mua combo</button>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <section class="flash-trust-strip flash-sale-trust" aria-label="Cam kết hỗ trợ">
            <article class="trust-item">
                <h3>Đổi trả minh bạch</h3>
                <p>Thông tin đổi trả rõ ràng, theo dõi trạng thái xử lý dễ dàng.</p>
            </article>
            <article class="trust-item">
                <h3>Tư vấn chọn sản phẩm</h3>
                <p>Đội ngũ hỗ trợ giúp chọn routine phù hợp với tóc và da đầu.</p>
            </article>
            <article class="trust-item">
                <h3>Theo dõi đơn hàng</h3>
                <p>Cập nhật tiến trình giao hàng liên tục ngay trong tài khoản.</p>
            </article>
        </section>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script>
    (function startCountdown() {
        const hoursEl = document.getElementById('hours');
        const minutesEl = document.getElementById('minutes');
        const secondsEl = document.getElementById('seconds');
        if (!hoursEl || !minutesEl || !secondsEl) {
            return;
        }

        function updateCountdown() {
            const now = new Date();
            const endOfDay = new Date();
            endOfDay.setHours(23, 59, 59, 999);
            const diff = endOfDay - now;

            if (diff <= 0) {
                hoursEl.textContent = '00';
                minutesEl.textContent = '00';
                secondsEl.textContent = '00';
                return;
            }

            const hours = Math.floor(diff / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

            hoursEl.textContent = hours.toString().padStart(2, '0');
            minutesEl.textContent = minutes.toString().padStart(2, '0');
            secondsEl.textContent = seconds.toString().padStart(2, '0');
        }

        updateCountdown();
        setInterval(updateCountdown, 1000);
    })();

    (function bindDealFilter() {
        const dealItems = document.querySelectorAll('.deals-grid .product-item');
        const filterButtons = document.querySelectorAll('.super-deal-btn');
        if (!dealItems.length || !filterButtons.length) {
            return;
        }

        filterButtons.forEach(function (button) {
            button.addEventListener('click', function () {
                filterButtons.forEach(function (btn) {
                    btn.classList.remove('active');
                });
                this.classList.add('active');

                const filter = this.dataset.filter;
                dealItems.forEach(function (item) {
                    item.style.display = (filter === 'all' || item.dataset.category === filter) ? '' : 'none';
                });
            });
        });
    })();
</script>
</body>

</html>


