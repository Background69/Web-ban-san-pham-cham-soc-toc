<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HairGlow | Sản phẩm chăm sóc tóc</title>

    <!-- Google Fonts -->
    <link
            href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&family=Work+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">

    <!-- Font Awesome 6 -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/animation.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/user/style_for_main-page.css?v=20260322-2">
</head>


<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<!-- Banner Section -->
<section class="banner-section">
    <div class="banner-container">
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
            <button aria-label="Trước" class="nav prev">&#10094;</button>
            <button aria-label="Sau" class="nav next">&#10095;</button>
            <div aria-label="Chuyển slide" class="slider-dots" role="tablist"></div>
        </div>
    </div>
</section>

<!-- Flash Sale Section -->
<section class="flash-sale-section section-animate">
    <div class="flash-sale-container">
        <div class="flash-sale-header">
            <div class="flash-sale-title-group">
                <h2><i class="fas fa-bolt"></i> FLASH SALE</h2>
            </div>
        </div>

        <div class="flash-sale-slider-container">
            <button class="flash-sale-nav prev" id="flash-sale-prev"><i
                    class="fas fa-chevron-left"></i></button>
            <div class="flash-sale-slider">
                <div class="flash-sale-track stagger-fade" id="flash-sale-track">
                    <c:forEach var="product" items="${saleProducts}">
                        <div class="product-item flash-sale-item">
                            <div class="product-img">
                                <c:if
                                        test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                                    <div class="flash-sale-badge">
                                        -${product.defaultVariant.discountPercent}%
                                    </div>
                                </c:if>
                                <a
                                        href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                    <img alt="${product.productName}" class="product-image"
                                         src="${pageContext.request.contextPath}/static/${product.primaryImage != null ? product.primaryImage.imageUrl : 'images/default-product.png'}">
                                </a>
                            </div>
                            <div class="product-body">
                                <h3 class="product-title">
                                    <a
                                            href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                            ${product.productName}
                                    </a>
                                </h3>
                                <div class="product-footer">
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
                                    <c:if test="${product.stockQuantity > 0}">
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
                                    <form class="action-buttons"
                                          action="${pageContext.request.contextPath}/cart/add"
                                          method="post">
                                        <input type="hidden" name="productId"
                                               value="${product.productId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" name="action" value="add_to_cart"
                                                class="btn btn-outline-cart">
                                            <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                        </button>
                                        <button type="submit" name="action" value="buy_now"
                                                class="btn btn-buy-now">
                                            Mua ngay
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <button class="flash-sale-nav next" id="flash-sale-next"><i
                    class="fas fa-chevron-right"></i></button>
        </div>
    </div>
</section>

<main class="page-animate">
    <!-- Categories Container -->
    <div class="categories-container" id="categories-container">
        <h2 class="container-title">Danh Mục Sản Phẩm</h2>
        <div class="categories-grid stagger-fade">
            <c:forEach var="category" items="${topCategories}">
                <a class="category-item"
                   href="${pageContext.request.contextPath}/products?category=${category.categorySlug}">
                    <div class="category-icon">
                        <c:choose>
                            <c:when test="${category.categorySlug == 'dau-goi'}"><i
                                    class="fas fa-shower"></i></c:when>
                            <c:when test="${category.categorySlug == 'dau-xa'}"><i
                                    class="fas fa-spray-can"></i></c:when>
                            <c:when test="${category.categorySlug == 'kem-u'}"><i
                                    class="fas fa-heart"></i></c:when>
                            <c:when test="${category.categorySlug == 'serum'}"><i
                                    class="fas fa-flask"></i></c:when>
                            <c:when test="${category.categorySlug == 'tri-gau'}"><i
                                    class="fas fa-shield-alt"></i></c:when>
                            <c:when test="${category.categorySlug == 'sap-gel'}"><i
                                    class="fas fa-wind"></i></c:when>
                            <c:when test="${category.categorySlug == 'tinh-dau'}"><i
                                    class="fas fa-tint"></i></c:when>
                            <c:when test="${category.categorySlug == 'phu-kien'}"><i
                                    class="fas fa-tools"></i></c:when>
                            <c:when test="${category.categorySlug == 'may-say'}"><i
                                    class="fas fa-fan"></i></c:when>
                            <c:when test="${category.categorySlug == 'may-uon'}"><i
                                    class="fas fa-magic"></i></c:when>
                            <c:otherwise><i class="fas fa-box"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <h3>${category.categoryName}</h3>
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- Featured Products Container -->
    <div class="featured-container" id="featured-container">
        <h2 class="container-title">Sản Phẩm Nổi Bật</h2>
        <div class="product-grid stagger-fade" id="featured-products">
            <c:forEach var="product" items="${featuredProducts}">
                <div class="product-item">
                    <div class="product-img">
                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                            <img alt="${product.productName}" class="product-image"
                                 src="${pageContext.request.contextPath}/static/${product.primaryImage != null ? product.primaryImage.imageUrl : 'images/default-product.png'}">
                        </a>
                    </div>
                    <div class="product-body">
                        <h3 class="product-title">${product.productName}</h3>
                        <div class="product-small-details">
                            <p>
                                <span>${product.brand != null ? product.brand.brandName : ''}</span>
                                • <span>${product.category != null ? product.category.categoryName :
                                    ''}</span>
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
                        <div class="product product-actions">
                            <a class="btn"
                               href="${pageContext.request.contextPath}/product/${product.productSlug}">Xem
                                thêm</a>
                            <a class="btn primary add-to-cart" href="#"
                               data-product-id="${product.productId}">Thêm vào
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
        <div class="brands-grid brands-grid-compact stagger-fade">
            <c:forEach var="brand" items="${brands}" varStatus="status">
                <c:if test="${status.index < 12}">
                    <a class="brand-item"
                       href="${pageContext.request.contextPath}/products?brand=${brand.brandSlug}">
                        <c:choose>
                            <c:when test="${not empty brand.logoUrl}">
                                <img src="${pageContext.request.contextPath}/static/${brand.logoUrl}"
                                     alt="${brand.brandName}">
                            </c:when>
                            <c:otherwise>
                                ${brand.brandName}
                            </c:otherwise>
                        </c:choose>
                    </a>
                </c:if>
            </c:forEach>
        </div>
        <c:if test="${brands.size() > 12}">
            <div class="brands-view-more">
                <a href="${pageContext.request.contextPath}/brands" class="btn btn-outline-primary">
                    <i class="fas fa-th-large"></i> Xem tất cả thương hiệu
                </a>
            </div>
        </c:if>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function () {

        // ===== BANNER SLIDER (Slide left-right effect) =====
        (function () {
            const slidesContainer = document.querySelector('.banner-slides');
            const slides = document.querySelectorAll('.banner-slides .item');
            const dotsContainer = document.querySelector('.slider-dots');
            const prevBtn = document.querySelector('.slider .nav.prev');
            const nextBtn = document.querySelector('.slider .nav.next');
            let currentSlide = 0;
            let autoSlideInterval;
            const totalSlides = slides.length;

            console.log('Banner slides found:', totalSlides);

            if (totalSlides === 0) {
                console.log('No slides found!');
                return;
            }

            // Create dots
            slides.forEach(function (_, index) {
                const dot = document.createElement('button');
                dot.classList.add('dot');
                if (index === 0) dot.classList.add('active');
                dot.addEventListener('click', function () {
                    goToSlide(index);
                    resetAutoSlide();
                });
                dotsContainer.appendChild(dot);
            });

            const dots = document.querySelectorAll('.slider-dots .dot');

            function goToSlide(index) {
                // Update dots
                dots[currentSlide].classList.remove('active');
                currentSlide = (index + totalSlides) % totalSlides;
                dots[currentSlide].classList.add('active');

                // Move slides container - mỗi slide là 100% viewport width
                const translateValue = -currentSlide * 100;
                slidesContainer.style.transform = 'translateX(' + translateValue + '%)';

                console.log('Going to slide:', currentSlide, 'translateX:', translateValue + '%');
            }

            function nextSlide() {
                goToSlide(currentSlide + 1);
            }

            function prevSlide() {
                goToSlide(currentSlide - 1);
            }

            if (prevBtn) {
                prevBtn.addEventListener('click', function () {
                    prevSlide();
                    resetAutoSlide();
                });
            }

            if (nextBtn) {
                nextBtn.addEventListener('click', function () {
                    nextSlide();
                    resetAutoSlide();
                });
            }

            function resetAutoSlide() {
                clearInterval(autoSlideInterval);
                autoSlideInterval = setInterval(nextSlide, 5000);
            }

            // Start auto slide every 5 seconds
            console.log('Starting auto slide...');
            autoSlideInterval = setInterval(nextSlide, 5000);
        })();


        // ===== FLASH SALE SLIDER =====
        (function () {
            const track = document.getElementById('flash-sale-track');
            const prevBtn = document.getElementById('flash-sale-prev');
            const nextBtn = document.getElementById('flash-sale-next');

            if (!track || !prevBtn || !nextBtn) return;

            const items = track.querySelectorAll('.product-item');
            if (items.length === 0) return;

            let currentPosition = 0;
            const itemWidth = 260;
            const visibleItems = Math.floor(track.parentElement.offsetWidth / itemWidth) || 4;
            const maxPosition = Math.max(0, (items.length - visibleItems) * itemWidth);

            function updateSliderPosition() {
                track.style.transform = 'translateX(' + (-currentPosition) + 'px)';
            }

            prevBtn.addEventListener('click', function () {
                currentPosition = Math.max(0, currentPosition - itemWidth);
                updateSliderPosition();
            });

            nextBtn.addEventListener('click', function () {
                currentPosition = Math.min(maxPosition, currentPosition + itemWidth);
                updateSliderPosition();
            });

            // Mouse drag support
            let isDragging = false;
            let startX = 0;
            let scrollLeft = 0;

            track.addEventListener('mousedown', function (e) {
                isDragging = true;
                startX = e.pageX;
                scrollLeft = currentPosition;
                track.style.cursor = 'grabbing';
            });

            track.addEventListener('mouseleave', function () {
                isDragging = false;
                track.style.cursor = 'grab';
            });

            track.addEventListener('mouseup', function () {
                isDragging = false;
                track.style.cursor = 'grab';
            });

            track.addEventListener('mousemove', function (e) {
                if (!isDragging) return;
                e.preventDefault();
                const x = e.pageX;
                const walk = (startX - x) * 1.5;
                currentPosition = Math.max(0, Math.min(maxPosition, scrollLeft + walk));
                updateSliderPosition();
            });

            // Touch events for mobile
            track.addEventListener('touchstart', function (e) {
                startX = e.touches[0].pageX;
                scrollLeft = currentPosition;
            });

            track.addEventListener('touchmove', function (e) {
                const x = e.touches[0].pageX;
                const walk = (startX - x) * 1.5;
                currentPosition = Math.max(0, Math.min(maxPosition, scrollLeft + walk));
                updateSliderPosition();
            });
        })();

        // ===== FLASH SALE COUNTDOWN =====
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

        // ===== ADD TO CART =====
        document.querySelectorAll('.add-to-cart').forEach(function (btn) {
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
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (data.success) {
                            document.querySelector('.cart-count').textContent = data.cartCount;
                            alert('Đã thêm vào giỏ hàng!');
                        } else {
                            alert(data.message || 'Có lỗi xảy ra!');
                        }
                    })
                    .catch(function () {
                        alert('Có lỗi xảy ra!');
                    });
            });
        });

    }); // End DOMContentLoaded
</script>
</body>

</html>
