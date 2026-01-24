<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HairGlow | Sản phẩm chăm sóc tóc</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&family=Work+Sans:wght@400;500;600&display=swap" rel="stylesheet">

    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style_for_main-page.css">
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<!-- Banner Section -->
<section class="banner-section">
    <div class="banner-container">
        <div class="hero-copy">
            <p class="eyebrow">Chăm sóc tóc chuyên sâu</p>
            <h1>Nuôi dưỡng mái tóc <span>khỏe & mềm mượt</span> mỗi ngày</h1>
            <p class="subtext">Sản phẩm tối ưu cho mọi tình trạng tóc, giao nhanh trong ngày.</p>
            <div class="hero-actions">
                <a class="btn primary" href="${pageContext.request.contextPath}/products">Khám phá sản phẩm</a>
                <a class="btn ghost" href="${pageContext.request.contextPath}/promotion/super-deal">Flash sale hôm nay</a>
            </div>
        </div>
        <div class="slider" id="banner-slider">
            <div class="banner-slides">
                <div class="item active" id="slide-1">
                    <img alt="Banner 1" class="banner-image"
                         src="${pageContext.request.contextPath}/static/assets/images/banner1.png">
                </div>
                <div class="item" id="slide-2">
                    <img alt="Banner 2" class="banner-image"
                         src="${pageContext.request.contextPath}/static/assets/images/banner2.png">
                </div>
                <div class="item" id="slide-3">
                    <img alt="Banner 3" class="banner-image"
                         src="${pageContext.request.contextPath}/static/assets/images/banner3.png">
                </div>
            </div>
            <button aria-label="Trước" class="nav prev">&lsaquo;</button>
            <button aria-label="Sau" class="nav next">&rsaquo;</button>
            <div aria-label="Chuyển slide" class="slider-dots" role="tablist"></div>
        </div>
    </div>
</section>

<!-- Flash Sale Section -->
<section class="flash-sale-section">
    <div class="flash-sale-container">
        <div class="flash-sale-header">
            <div class="flash-sale-title-group">
                <h2><i class="fas fa-bolt"></i> FLASH SALE</h2>
            </div>
            <div class="flash-sale-countdown">
                <div class="countdown-box">
                    <span class="countdown-number" id="flash-sale-hours">00</span>
                    <span class="countdown-label">Giờ</span>
                </div>
                <div class="countdown-box">
                    <span class="countdown-number" id="flash-sale-minutes">00</span>
                    <span class="countdown-label">Phút</span>
                </div>
                <div class="countdown-box">
                    <span class="countdown-number" id="flash-sale-seconds">00</span>
                    <span class="countdown-label">Giây</span>
                </div>
            </div>
        </div>

        <div class="flash-sale-slider-container">
            <button class="flash-sale-nav prev" id="flash-sale-prev"><i class="fas fa-chevron-left"></i></button>
            <div class="flash-sale-slider">
                <div class="flash-sale-track" id="flash-sale-track">
                    <c:forEach var="product" items="${saleProducts}">
                        <div class="product-item">
                            <c:if test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                                <div class="flash-sale-badge">-${product.defaultVariant.discountPercent}%</div>
                            </c:if>
                            <div class="product-img">
                                <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                    <img alt="${product.productName}" class="product-image"
                                         src="${pageContext.request.contextPath}/static/images/${product.primaryImage != null ? product.primaryImage.imageUrl : 'default-product.png'}">
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
                                        <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                            <p class="price-old"><fmt:formatNumber
                                                    value="${product.defaultVariant.originalPrice}" type="number"/>₫</p>
                                            <p class="badge-discount">-${product.defaultVariant.discountPercent}%</p>
                                        </c:if>
                                    </c:if>
                                </div>
                                <div class="product">
                                    <a class="btn"
                                       href="${pageContext.request.contextPath}/product/${product.productSlug}">Xem
                                        thêm</a>
                                    <a class="btn primary add-to-cart" href="#" data-product-id="${product.productId}">Thêm
                                        vào giỏ</a>
                                </div>
                                <div class="sale-progress">
                                    <div class="sale-progress-bar" style="width: 60%;"></div>
                                    <div class="sale-progress-label">Đã bán 60%</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <button class="flash-sale-nav next" id="flash-sale-next"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>
</section>

<main>
    <!-- Categories Container -->
    <div class="categories-container" id="categories-container">
        <h2 class="container-title">Danh Mục Sản Phẩm</h2>
        <div class="categories-grid">
            <a class="category-item" href="${pageContext.request.contextPath}/products?category=dau-goi">
                <div class="category-icon"><i class="fas fa-shower"></i></div>
                <h3>Dầu Gội</h3>
                <p>Làm sạch và nuôi dưỡng tóc từ gốc</p>
            </a>
            <a class="category-item" href="${pageContext.request.contextPath}/products?category=dau-xa">
                <div class="category-icon"><i class="fas fa-spray-can"></i></div>
                <h3>Dầu Xả</h3>
                <p>Mềm mượt, dễ chải</p>
            </a>
            <a class="category-item" href="${pageContext.request.contextPath}/products?category=kem-u">
                <div class="category-icon"><i class="fas fa-heart"></i></div>
                <h3>Kem Ủ Tóc</h3>
                <p>Phục hồi tóc hư tổn sâu</p>
            </a>
            <a class="category-item" href="${pageContext.request.contextPath}/products?category=serum">
                <div class="category-icon"><i class="fas fa-flask"></i></div>
                <h3>Serum Dưỡng</h3>
                <p>Dưỡng chất tinh tuý cho tóc</p>
            </a>
            <a class="category-item" href="${pageContext.request.contextPath}/products?category=tri-gau">
                <div class="category-icon"><i class="fas fa-shield-alt"></i></div>
                <h3>Trị Gàu & Rụng Tóc</h3>
                <p>Giải pháp toàn diện cho tóc</p>
            </a>
            <a class="category-item" href="${pageContext.request.contextPath}/products?category=sap-gel">
                <div class="category-icon"><i class="fas fa-wind"></i></div>
                <h3>Tạo Kiểu</h3>
                <p>Sáp, gel, gôm tạo kiểu</p>
            </a>
        </div>
    </div>

    <!-- Featured Products Container -->
    <div class="featured-container" id="featured-container">
        <h2 class="container-title">Sản Phẩm Nổi Bật</h2>
        <div class="product-grid" id="featured-products">
            <c:forEach var="product" items="${featuredProducts}">
                <div class="product-item">
                    <div class="product-img">
                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                            <img alt="${product.productName}" class="product-image"
                                 src="${pageContext.request.contextPath}/static/images/${product.primaryImage != null ? product.primaryImage.imageUrl : 'default-product.png'}">
                        </a>
                    </div>
                    <div class="product-body">
                        <h3 class="product-title">${product.productName}</h3>
                        <div class="product-small-details">
                            <p>
                                <span>${product.brand != null ? product.brand.brandName : ''}</span>
                                • <span>${product.category != null ? product.category.categoryName : ''}</span>
                                • ${product.origin}
                            </p>
                        </div>
                        <div class="product-rating">
                            <div class="rating-stars">
                                <span class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= product.averageRating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                            </div>
                            <p class="review-count">(${product.reviewCount})</p>
                        </div>
                        <div class="product-price">
                            <c:if test="${product.defaultVariant != null}">
                                <p class="price-current">
                                    <fmt:formatNumber
                                            value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                            type="number"/>₫
                                </p>
                                <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                    <p class="price-old"><fmt:formatNumber
                                            value="${product.defaultVariant.originalPrice}" type="number"/>₫</p>
                                    <p class="badge-discount">-${product.defaultVariant.discountPercent}%</p>
                                </c:if>
                            </c:if>
                        </div>
                        <div class="product">
                            <a class="btn" href="${pageContext.request.contextPath}/product/${product.productSlug}">Xem
                                thêm</a>
                            <a class="btn primary add-to-cart" href="#" data-product-id="${product.productId}">Thêm vào
                                giỏ</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Brands Container -->
    <div class="brands-container" id="brands-container">
        <h2 class="container-title">Thương Hiệu Uy Tín</h2>
        <div class="brands-grid">
            <c:forEach var="brand" items="${brands}">
                <a class="brand-item" href="${pageContext.request.contextPath}/products?brand=${brand.brandSlug}">
                    <c:choose>
                        <c:when test="${not empty brand.logoUrl}">
                            <img src="${pageContext.request.contextPath}/static/images/${brand.logoUrl}"
                                 alt="${brand.brandName}">
                        </c:when>
                        <c:otherwise>
                            ${brand.brandName}
                        </c:otherwise>
                    </c:choose>
                </a>
            </c:forEach>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    // Banner Slider
    (function () {
        const slides = document.querySelectorAll('.banner-slides .item');
        const dotsContainer = document.querySelector('.slider-dots');
        const prevBtn = document.querySelector('.slider .nav.prev');
        const nextBtn = document.querySelector('.slider .nav.next');
        let currentSlide = 0;
        let autoSlideInterval;

        if (slides.length === 0) return;

        // Create dots
        slides.forEach((_, index) => {
            const dot = document.createElement('button');
            dot.classList.add('dot');
            if (index === 0) dot.classList.add('active');
            dot.addEventListener('click', () => goToSlide(index));
            dotsContainer.appendChild(dot);
        });

        const dots = document.querySelectorAll('.slider-dots .dot');

        function goToSlide(index) {
            slides[currentSlide].classList.remove('active');
            dots[currentSlide].classList.remove('active');
            currentSlide = (index + slides.length) % slides.length;
            slides[currentSlide].classList.add('active');
            dots[currentSlide].classList.add('active');
        }

        function nextSlide() {
            goToSlide(currentSlide + 1);
        }

        function prevSlide() {
            goToSlide(currentSlide - 1);
        }

        prevBtn.addEventListener('click', () => {
            prevSlide();
            resetAutoSlide();
        });
        nextBtn.addEventListener('click', () => {
            nextSlide();
            resetAutoSlide();
        });

        function resetAutoSlide() {
            clearInterval(autoSlideInterval);
            autoSlideInterval = setInterval(nextSlide, 5000);
        }

        autoSlideInterval = setInterval(nextSlide, 5000);
    })();

    // Flash Sale Countdown
    (function () {
        const hoursEl = document.getElementById('flash-sale-hours');
        const minutesEl = document.getElementById('flash-sale-minutes');
        const secondsEl = document.getElementById('flash-sale-seconds');

        if (!hoursEl || !minutesEl || !secondsEl) return;

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

            hoursEl.textContent = String(hours).padStart(2, '0');
            minutesEl.textContent = String(minutes).padStart(2, '0');
            secondsEl.textContent = String(seconds).padStart(2, '0');
        }

        updateCountdown();
        setInterval(updateCountdown, 1000);
    })();

    // Add to cart functionality
    document.querySelectorAll('.add-to-cart').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            const productId = this.dataset.productId;
            fetch('${pageContext.request.contextPath}/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                },
                body: 'productId=' + productId + '&quantity=1'
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.querySelector('.cart-count').textContent = data.cartCount;
                        alert('Đã thêm vào giỏ hàng!');
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                })
                .catch(() => alert('Có lỗi xảy ra!'));
        });
    });
</script>
</body>
</html>
