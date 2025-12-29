<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 29/12/2025
  Time: 12:05 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HairGlow | Sản phẩm chăm sóc tóc</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style_for_main-page.css">
    <script src="<%= request.getContextPath() %>/static/js/Page.js"></script>
</head>

<body>

<!-- ================= BANNER ================= -->
<section class="banner-section">
    <div class="banner-container">
        <div class="slider" id="banner-slider">
            <div class="banner-slides">
                <div class="item">
                    <img src="${pageContext.request.contextPath}static/assets/images/banner1.png"
                         class="banner-image" alt="banner 1">
                </div>
                <div class="item">
                    <img src="${pageContext.request.contextPath}static/assets/images/banner2.png"
                         class="banner-image" alt="banner 2">
                </div>
                <div class="item">
                    <img src="${pageContext.request.contextPath}static/assets/images/banner3.png"
                         class="banner-image" alt="banner 3">
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ================= FLASH SALE ================= -->
<section class="flash-sale-section">
    <div class="flash-sale-container">

        <div class="flash-sale-header">
            <h2><i class="fas fa-bolt"></i> FLASH SALE</h2>

            <div class="flash-sale-countdown">
                <div class="countdown-box">
                    <span class="countdown-number">12</span>
                    <span class="countdown-label">Giờ</span>
                </div>
                <div class="countdown-box">
                    <span class="countdown-number">34</span>
                    <span class="countdown-label">Phút</span>
                </div>
                <div class="countdown-box">
                    <span class="countdown-number">56</span>
                    <span class="countdown-label">Giây</span>
                </div>
            </div>
        </div>

        <div class="flash-sale-slider-container">
            <div class="flash-sale-slider">
                <div class="flash-sale-track">

                    <!-- Sale product -->
                    <div class="product-item">
                        <div class="flash-sale-badge">-50%</div>
                        <div class="product-img">
                            <img src="${pageContext.request.contextPath}/images/dau-goi-can-bang-ph-elgon.png"
                                 class="product-image">
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">
                                Dầu gội Elgon Puifying hỗ trợ trị gàu 1000ml
                            </h3>
                            <div class="product-price">
                                <p class="price-current">350.000₫</p>
                                <p class="price-old">700.000₫</p>
                                <p class="badge-discount">-50%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="ProductDetail.jsp">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="flash-sale-badge">-40%</div>
                        <div class="product-img">
                            <img src="${pageContext.request.contextPath}/images/xakho.png"
                                 class="product-image">
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">
                                Xả khô BambooMiracle phục hồi tóc 178ml
                            </h3>
                            <div class="product-price">
                                <p class="price-current">252.000₫</p>
                                <p class="price-old">420.000₫</p>
                                <p class="badge-discount">-40%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="ProductDetail.jsp">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</section>

<!-- ================= MAIN ================= -->
<main>

    <!-- ===== DANH MỤC ===== -->
    <div class="categories-container">
        <h2 class="container-title">Danh Mục Sản Phẩm</h2>

        <div class="categories-grid">
            <a class="category-item" href="#">
                <div class="category-icon"><i class="fas fa-shower"></i></div>
                <h3>Dầu Gội</h3>
                <p>Làm sạch và nuôi dưỡng tóc</p>
            </a>

            <a class="category-item" href="#">
                <div class="category-icon"><i class="fas fa-spray-can"></i></div>
                <h3>Dầu Xả</h3>
                <p>Mềm mượt, dễ chải</p>
            </a>

            <a class="category-item" href="#">
                <div class="category-icon"><i class="fas fa-flask"></i></div>
                <h3>Serum</h3>
                <p>Dưỡng chất tinh tuý</p>
            </a>

            <a class="category-item" href="#">
                <div class="category-icon"><i class="fas fa-wind"></i></div>
                <h3>Tạo Kiểu</h3>
                <p>Sáp, gel, gôm</p>
            </a>
        </div>
    </div>

    <!-- ===== SẢN PHẨM NỔI BẬT (CÓ GIÁ + % + SAO) ===== -->
    <div class="featured-container">
        <h2 class="container-title">Sản Phẩm Nổi Bật</h2>

        <div class="product-grid">

            <div class="product-item">
                <div class="product-img">
                    <img src="${pageContext.request.contextPath}/images/dau-goi-can-bang-ph-elgon.png"
                         class="product-image">
                </div>
                <div class="product-body">
                    <h3 class="product-title">Dầu gội Elgon Puifying</h3>

                    <div class="product-rating">
                        <span class="stars">★★★★★</span>
                        <span class="review-count">(156)</span>
                    </div>

                    <div class="product-price">
                        <p class="price-current">700.000₫</p>
                        <p class="price-old">850.000₫</p>
                        <p class="badge-discount">-18%</p>
                    </div>

                    <div class="product">
                        <a class="btn" href="ProductDetail.jsp">Xem thêm</a>
                        <a class="btn primary" href="#">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>

            <div class="product-item">
                <div class="product-img">
                    <img src="${pageContext.request.contextPath}/images/xakho.png"
                         class="product-image">
                </div>
                <div class="product-body">
                    <h3 class="product-title">Xả khô BambooMiracle</h3>

                    <div class="product-rating">
                        <span class="stars">★★★★★</span>
                        <span class="review-count">(203)</span>
                    </div>

                    <div class="product-price">
                        <p class="price-current">420.000₫</p>
                        <p class="price-old">520.000₫</p>
                        <p class="badge-discount">-19%</p>
                    </div>

                    <div class="product">
                        <a class="btn" href="ProductDetail.jsp">Xem thêm</a>
                        <a class="btn primary" href="#">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- ===== THƯƠNG HIỆU ===== -->
    <div class="brands-container">
        <h2 class="container-title">Thương Hiệu Uy Tín</h2>
        <div class="brands-grid">
            <div class="brand-item">L'Oréal</div>
            <div class="brand-item">Kérastase</div>
            <div class="brand-item">Davines</div>
            <div class="brand-item">Moroccanoil</div>
            <div class="brand-item">OGX</div>
            <div class="brand-item">TRESemmé</div>
        </div>
    </div>

</main>

</body>
</html>

