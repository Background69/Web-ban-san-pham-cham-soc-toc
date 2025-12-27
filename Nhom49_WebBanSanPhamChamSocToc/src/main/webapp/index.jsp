<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HairGlow | Sản phẩm chăm sóc tóc</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style_for_main-page.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<!-- Header -->
<%@ include file="layout/header.jsp" %>
<section class="banner-section">
    <div class="banner-container">
        <!-- Banner / Slider -->
        <div class="slider" id="banner-slider">

            <div class="banner-slides">
                <!-- Slide 1 -->
                <div class="item" id="slide-1">
                    <img alt="banner 1" class="banner-image" src="images/banner1.png">
                </div>
                <!-- Slide 2 -->
                <div class="item" id="slide-2">
                    <img alt="banner 2" class="banner-image" src="images/banner2.png">
                </div>
                <!-- Slide 3 -->
                <div class="item" id="slide-3">
                    <img alt="banner 3" class="banner-image" src="images/banner3.png">
                </div>
            </div>

            <button aria-label="Trước" class="nav prev">&lsaquo;</button>
            <button aria-label="Sau" class="nav next">&rsaquo;</button>
            <div aria-label="Chuyển slide" class="slider-dots" role="tablist"></div>
        </div>
    </div>
</section>
<section class="flash-sale-section">
    <div class="flash-sale-container">
        <div class="flash-sale-header">
            <div class="flash-sale-title-group">
                <h2><i class="fas fa-bolt"></i> FLASH SALE</h2>
            </div>
            <div class="flash-sale-countdown">
                <div class="countdown-box">
                    <span class="countdown-number" id="flash-sale-hours">12</span>
                    <span class="countdown-label">Giờ</span>
                </div>
                <div class="countdown-box">
                    <span class="countdown-number" id="flash-sale-minutes">34</span>
                    <span class="countdown-label">Phút</span>
                </div>
                <div class="countdown-box">
                    <span class="countdown-number" id="flash-sale-seconds">56</span>
                    <span class="countdown-label">Giây</span>
                </div>
            </div>
        </div>

        <div class="flash-sale-slider-container">

            <div class="flash-sale-slider">
                <div class="flash-sale-track" id="flash-sale-track">
                    <!-- Sale 1 -->
                    <div class="product-item">
                        <div class="flash-sale-badge">-50%</div>
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 1" class="product-image"
                                     src="images/dau-goi-can-bang-ph-elgon.png">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Dầu gội Elgon Puifying hỗ trợ trị gàu 1000ml</h3>
                            <div class="product-price">
                                <p class="price-current">350.000₫</p>
                                <p class="price-old">700.000₫</p>
                                <p class="badge-discount">-50%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="ProductDetail.html">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>
                    <!-- Sale 2 -->
                    <div class="product-item">
                        <div class="flash-sale-badge">-50%</div>
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 1" class="product-image" src="images/super-deal-product-1.jpg">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Serum L'Oreal Sáng Da, Mờ Thâm Mụn & Nám 30ml</h3>
                            <div class="product-price">
                                <p class="price-current">220.000₫</p>
                                <p class="price-old">280.000₫</p>
                                <p class="badge-discount">-21%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="ProductDetail.html">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>
                    <!-- Sale 3 -->
                    <div class="product-item">
                        <div class="flash-sale-badge">-40%</div>
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 1" class="product-image" src="images/xakho.png">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xả khô BambooMiracle phục hồi tóc 178ml</h3>
                            <div class="product-price">
                                <p class="price-current">252.000₫</p>
                                <p class="price-old">420.000₫</p>
                                <p class="badge-discount">-40%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="ProductDetail.html">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>
                    <!-- Sale 4 -->
                    <div class="product-item">
                        <div class="flash-sale-badge">-50%</div>
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 1" class="product-image" src="images/Collagen.webp">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Serum L'Oreal Sáng Da, Mờ Thâm Mụn & Nám 30ml</h3>
                            <div class="product-price">
                                <p class="price-current">220.000₫</p>
                                <p class="price-old">280.000₫</p>
                                <p class="badge-discount">-21%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="ProductDetail.html">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<main>
    <!-- Categories Container -->
    <div class="categories-container" id="categories-container">
        <h2 class="container-title">Danh Mục Sản Phẩm</h2>
        <div class="categories-grid">
            <a class="category-item" href="store.html?category=dau-goi">
                <div class="category-icon"><i class="fas fa-shower"></i></div>
                <h3>Dầu Gội</h3>
                <p>Làm sạch và nuôi dưỡng tóc từ gốc</p>
            </a>

            <a class="category-item" href="store.html?category=dau-xa">
                <div class="category-icon"><i class="fas fa-spray-can"></i></div>
                <h3>Dầu Xả</h3>
                <p>Mềm mượt, dễ chải</p>
            </a>

            <a class="category-item" href="store.html?category=kem-u">
                <div class="category-icon"><i class="fas fa-heart"></i></div>
                <h3>Kem Ủ Tóc</h3>
                <p>Phục hồi tóc hư tổn sâu</p>
            </a>

            <a class="category-item" href="store.html?category=serum">
                <div class="category-icon"><i class="fas fa-flask"></i></div>
                <h3>Serum Dưỡng</h3>
                <p>Dưỡng chất tinh tuý cho tóc</p>
            </a>

            <a class="category-item" href="store.html?category=tri-gau">
                <div class="category-icon"><i class="fas fa-shield-alt"></i></div>
                <h3>Trị Gàu & Rụng Tóc</h3>
                <p>Giải pháp toàn diện cho tóc</p>
            </a>

            <a class="category-item" href="store.html?category=sap-gel">
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
            <div class="product-item">
                <div class="product-img">
                    <a href="ProductDetail.html">
                        <img alt="Serum L'Oreal" class="product-image" src="images/dau-goi-can-bang-ph-elgon.png">
                    </a>
                </div>
                <div class="product-body">
                    <h3 class="product-title">Dầu gội Elgon Puifying hỗ trợ trị gàu</h3>
                    <div class="product-small-details">
                        <p><span>Elgon</span> • <span>Dầu gội</span> • Ý</p>
                    </div>
                    <div class="product-rating">
                        <div class="rating-stars">
                            <span class="stars">★★★★★</span>
                        </div>
                        <p class="review-count">(156)</p>
                    </div>
                    <div class="product-price">
                        <p class="price-current">700.000₫</p>
                        <p class="price-old">850.000₫</p>
                        <p class="badge-discount">-18%</p>
                    </div>
                    <div class="product">
                        <a class="btn" href="ProductDetail.html">Xem thêm</a>
                        <a class="btn primary" href="Cart.html">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>

            <div class="product-item">
                <div class="product-img">
                    <a href="ProductDetail.html">
                        <img alt="Xả khô BambooMiracle" class="product-image" src="images/xakho.png">
                    </a>
                </div>
                <div class="product-body">
                    <h3 class="product-title">Xả khô BambooMiracle phục hồi tóc</h3>
                    <div class="product-small-details">
                        <p><span>BambooMiracle</span> • <span>Xịt dưỡng</span> • Mỹ</p>
                    </div>
                    <div class="product-rating">
                        <div class="rating-stars">
                            <span class="stars">★★★★★</span>
                        </div>
                        <p class="review-count">(203)</p>
                    </div>
                    <div class="product-price">
                        <p class="price-current">420.000₫</p>
                        <p class="price-old">520.000₫</p>
                        <p class="badge-discount">-19%</p>
                    </div>
                    <div class="product">
                        <a class="btn" href="ProductDetail.html">Xem thêm</a>
                        <a class="btn primary" href="Cart.html">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>

            <div class="product-item">
                <div class="product-img">
                    <a href="ProductDetail.html">
                        <img alt="Serum L'Oreal" class="product-image" src="images/dau-goi-can-bang-ph-elgon.png">
                    </a>
                </div>
                <div class="product-body">
                    <h3 class="product-title">Serum L'Oreal Sáng Da, Mờ Thâm Mụn & Nám 30ml</h3>
                    <div class="product-small-details">
                        <p><span>L'Oréal Professionnel</span> • <span>Serum</span> • Pháp</p>
                    </div>
                    <div class="product-rating">
                        <div class="rating-stars">
                            <span class="stars">★★★★★</span>
                        </div>
                        <p class="review-count">(423)</p>
                    </div>
                    <div class="product-price">
                        <p class="price-current">220.000₫</p>
                        <p class="price-old">280.000₫</p>
                        <p class="badge-discount">-21%</p>
                    </div>
                    <div class="product">
                        <a class="btn" href="ProductDetail.html">Xem thêm</a>
                        <a class="btn primary" href="Cart.html">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>

            <div class="product-item">
                <div class="product-img">
                    <a href="ProductDetail.html">
                        <img alt="Dầu gội Cehko" class="product-image" src="images/dau-goi-can-bang-ph-elgon.png">
                    </a>
                </div>
                <div class="product-body">
                    <h3 class="product-title">Dầu gội Cehko Vital chống rụng tóc</h3>
                    <div class="product-small-details">
                        <p><span>Cehko</span> • <span>Dầu gội</span> • Đức</p>
                    </div>
                    <div class="product-rating">
                        <div class="rating-stars">
                            <span class="stars">★★★★☆</span>
                        </div>
                        <p class="review-count">(98)</p>
                    </div>
                    <div class="product-price">
                        <p class="price-current">250.000₫</p>
                        <p class="price-old">320.000₫</p>
                        <p class="badge-discount">-22%</p>
                    </div>
                    <div class="product">
                        <a class="btn" href="ProductDetail.html">Xem thêm</a>
                        <a class="btn primary" href="Cart.html">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Brands Container -->
    <div class="brands-container" id="brands-container">
        <h2 class="container-title">Thương Hiệu Uy Tín</h2>
        <div class="brands-grid">
            <div class="brand-item">L'Oréal</div>
            <div class="brand-item">Kérastase</div>
            <div class="brand-item">Davines</div>
            <div class="brand-item">Moroccanoil</div>
            <div class="brand-item">Head &<br>Shoulders</div>
            <div class="brand-item">Sunsilk</div>
            <div class="brand-item">TRESemmé</div>
            <div class="brand-item">OGX</div>
        </div>
    </div>
</main>
<--!- Footer -->
<%@ include file="layout/footer.jsp" %>


</body>
</html>