<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <title>HairGlow | Sản phẩm chăm sóc tóc</title>
    <link href="${pageContext.request.contextPath}/static/css/user/style_for_store.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/layout/header.jsp" />

<section class="banner-section">
    <div class="banner-container">
        <!-- Banner / Slider -->
        <div class="slider" id="banner-slider">

            <div class="banner-slides">
                <!-- Slide 1 -->
                <div class="item" id="slide-1">
                    <img alt="banner 1" class="banner-image" src="${pageContext.request.contextPath}/static/assets/images/banner1.png">
                </div>
                <!-- Slide 2 -->
                <div class="item" id="slide-2">
                    <img alt="banner 2" class="banner-image" src="${pageContext.request.contextPath}/static/assets/images/banner2.png">
                </div>
                <!-- Slide 3 -->
                <div class="item" id="slide-3">
                    <img alt="banner 3" class="banner-image" src="${pageContext.request.contextPath}/static/assets/images/banner3.png">
                </div>
            </div>

            <button aria-label="Trước" class="nav prev">&lsaquo;</button>
            <button aria-label="Sau" class="nav next">&rsaquo;</button>
            <div aria-label="Chuyển slide" class="slider-dots" role="tablist"></div>
        </div>
    </div>
</section>
<main>
    <div class="main-container">
        <!-- Filter -->
        <div class="left-col filter">
            <aside class="filter-sidebar">
                <div class="filter-title">
                    <h3>Bộ lọc tìm kiếm</h3>
                </div>

                <form action="/search" class="filter-form" method="get">

                    <div class="filter-block">
                        <!-- Filter price -->
                        <h4 class="filter-title" id="filter-price-title">Khoảng giá</h4>
                        <div class="price-inputs" id="filter-price" role="group">
                            <label class="checkbox" for="price-1">
                                <input id="price-1" name="price" type="checkbox" value="1"><span>0 -
                                        100.000₫</span></label>
                            <label class="checkbox" for="price-2">
                                <input id="price-2" name="price" type="checkbox" value="2"><span>100.000₫ -
                                        200.000₫</span></label>
                            <label class="checkbox" for="price-3">
                                <input id="price-3" name="price" type="checkbox" value="3"><span>200.000₫ -
                                        300.000₫</span></label>
                            <label class="checkbox" for="price-4">
                                <input id="price-4" name="price" type="checkbox" value="4"><span>300.000₫ -
                                        400.000₫</span></label>
                            <label class="checkbox" for="price-5">
                                <input id="price-5" name="price" type="checkbox" value="5"><span>400.000₫ -
                                        500.000₫</span></label>
                            <label class="checkbox" for="price-6">
                                <input id="price-6" name="price" type="checkbox" value="6"><span>Trên
                                        500.000₫</span></label>
                        </div>
                    </div>

                    <div class="filter-block">
                        <!-- Filter category -->
                        <h4 class="filter-title" id="filter-category-title">Danh mục</h4>
                        <div class="filter-list" id="filter-category" role="group">
                            <label class="checkbox" for="cat-1">
                                <input id="cat-1" name="category" type="checkbox" value="Dầu gội"><span>Dầu
                                        gội</span></label>
                            <label class="checkbox" for="cat-2">
                                <input id="cat-2" name="category" type="checkbox" value="Dầu xả"><span>Dầu
                                        xả</span></label>
                            <label class="checkbox" for="cat-3">
                                <input id="cat-3" name="category" type="checkbox"
                                       value="Kem ủ – Mặt nạ tóc"><span>Kem ủ – Mặt nạ tóc</span></label>
                            <label class="checkbox" for="cat-4">
                                <input id="cat-4" name="category" type="checkbox"
                                       value="Serum – Dầu dưỡng tóc"><span>Serum – Dầu dưỡng tóc</span></label>
                            <label class="checkbox" for="cat-5">
                                <input id="cat-5" name="category" type="checkbox"
                                       value="Xịt dưỡng – Tinh chất dưỡng"><span>Xịt dưỡng – Tinh chất
                                        dưỡng</span></label>
                            <label class="checkbox" for="cat-6">
                                <input id="cat-6" name="category" type="checkbox"
                                       value="Thuốc uốn – Duỗi – Nhuộm"><span>Thuốc uốn – Duỗi – Nhuộm</span></label>
                            <label class="checkbox" for="cat-7">
                                <input id="cat-7" name="category" type="checkbox"
                                       value="Gôm – Sáp – Gel tạo kiểu"><span>Gôm – Sáp – Gel tạo kiểu</span></label>
                            <label class="checkbox" for="cat-8">
                                <input id="cat-8" name="category" type="checkbox" value="Dầu gội khô"><span>Dầu gội
                                        khô</span></label>
                            <label class="checkbox" for="cat-9">
                                <input id="cat-9" name="category" type="checkbox"
                                       value="Tinh chất mọc tóc – kích thích nang tóc"><span>Tinh chất mọc tóc – kích
                                        thích nang tóc</span></label>
                            <label class="checkbox" for="cat-10">
                                <input id="cat-10" name="category" type="checkbox"
                                       value="Sản phẩm trị gàu / nấm / rụng tóc"><span>Sản phẩm trị gàu / nấm / rụng
                                        tóc</span></label>
                            <label class="checkbox" for="cat-11">
                                <input id="cat-11" name="category" type="checkbox" value="Dụng cụ tóc"><span>Dụng cụ
                                        tóc</span></label>
                        </div>
                    </div>

                    <div class="filter-block">
                        <!-- Filter hair condition -->
                        <h4 class="filter-title" id="filter-hair-condition-title">Tình trạng tóc</h4>
                        <div class="filter-list" id="filter-hair-condition" role="group">
                            <label class="checkbox" for="con-1">
                                <input id="con-1" name="concern" type="checkbox" value="Dầu – Gàu"><span>Dầu –
                                        Gàu</span></label>
                            <label class="checkbox" for="con-2">
                                <input id="con-2" name="concern" type="checkbox" value="Khô xơ"><span>Khô
                                        xơ</span></label>
                            <label class="checkbox" for="con-3">
                                <input id="con-3" name="concern" type="checkbox" value="Hư tổn – Nhuộm"><span>Hư tổn
                                        – Nhuộm</span></label>
                            <label class="checkbox" for="con-4">
                                <input id="con-4" name="concern" type="checkbox" value="Mỏng – Rụng tóc"><span>Mỏng
                                        – Rụng tóc</span></label>
                            <label class="checkbox" for="con-5">
                                <input id="con-5" name="concern" type="checkbox" value="Da đầu nhạy cảm"><span>Da
                                        đầu nhạy cảm</span></label>
                            <label class="checkbox" for="con-6">
                                <input id="con-6" name="concern" type="checkbox" value="Tóc xoăn / uốn"><span>Tóc
                                        xoăn / uốn</span></label>
                            <label class="checkbox" for="con-7">
                                <input id="con-7" name="concern" type="checkbox" value="Xoăn / xù"><span>Xoăn /
                                        xù</span></label>
                        </div>
                    </div>

                    <div class="filter-block">
                        <!-- Filter brand -->
                        <h4 class="filter-title" id="filter-brand-title">Thương hiệu</h4>
                        <div class="filter-list" id="filter-brand" role="group">
                            <label class="checkbox" for="brand-1">
                                <input id="brand-1" name="brand" type="checkbox"
                                       value="Head and Shoulders"><span>Head &amp; Shoulders</span></label>
                            <label class="checkbox" for="brand-2">
                                <input id="brand-2" name="brand" type="checkbox"
                                       value="Sunsilk"><span>Sunsilk</span></label>
                            <label class="checkbox" for="brand-3">
                                <input id="brand-3" name="brand" type="checkbox"
                                       value="Moroccanoil"><span>Moroccanoil</span></label>
                            <label class="checkbox" for="brand-4">
                                <input id="brand-4" name="brand" type="checkbox"
                                       value="Kérastase"><span>Kérastase</span></label>
                            <label class="checkbox" for="brand-5">
                                <input id="brand-5" name="brand" type="checkbox"
                                       value="TRESemmé"><span>TRESemmé</span></label>
                            <label class="checkbox" for="brand-6">
                                <input id="brand-6" name="brand" type="checkbox"
                                       value="L'Oréal Professionnel"><span>L'Oréal Professionnel</span></label>
                            <label class="checkbox" for="brand-7">
                                <input id="brand-7" name="brand" type="checkbox"
                                       value="Davines"><span>Davines</span></label>
                            <label class="checkbox" for="brand-8">
                                <input id="brand-8" name="brand" type="checkbox"
                                       value="OGX"><span>OGX</span></label>
                            <label class="checkbox" for="brand-9">
                                <input id="brand-9" name="brand" type="checkbox"
                                       value="Kaminomoto"><span>Kaminomoto</span></label>
                            <label class="checkbox" for="brand-10">
                                <input id="brand-10" name="brand" type="checkbox"
                                       value="Nizoral"><span>Nizoral</span></label>
                            <label class="checkbox" for="brand-11">
                                <input id="brand-11" name="brand" type="checkbox"
                                       value="Innisfree"><span>Innisfree</span></label>
                            <label class="checkbox" for="brand-12">
                                <input id="brand-12" name="brand" type="checkbox" value="Mise En Scène"><span>Mise
                                        En Scène</span></label>
                            <label class="checkbox" for="brand-13">
                                <input id="brand-13" name="brand" type="checkbox"
                                       value="L'Oréal Paris"><span>L'Oréal Paris</span></label>
                        </div>
                    </div>

                    <div class="filter-block">
                        <!-- Filter origin -->
                        <h4 class="filter-title" id="filter-origin-title">Xuất xứ</h4>
                        <div class="filter-list" id="filter-origin" role="group">
                            <label class="checkbox" for="origin-1">
                                <input id="origin-1" name="origin" type="checkbox"
                                       value="Mỹ"><span>Mỹ</span></label>
                            <label class="checkbox" for="origin-2">
                                <input id="origin-2" name="origin" type="checkbox" value="Việt Nam"><span>Việt
                                        Nam</span></label>
                            <label class="checkbox" for="origin-3">
                                <input id="origin-3" name="origin" type="checkbox"
                                       value="Pháp"><span>Pháp</span></label>
                            <label class="checkbox" for="origin-4">
                                <input id="origin-4" name="origin" type="checkbox" value="Ý"><span>Ý</span></label>
                            <label class="checkbox" for="origin-5">
                                <input id="origin-5" name="origin" type="checkbox"
                                       value="Nhật"><span>Nhật</span></label>
                            <label class="checkbox" for="origin-6">
                                <input id="origin-6" name="origin" type="checkbox" value="Hàn Quốc"><span>Hàn
                                        Quốc</span></label>
                        </div>
                    </div>

                    <div class="filter-block">
                        <!-- Filter rating -->
                        <h4 class="filter-title" id="filter-rating-title">Đánh giá</h4>
                        <div class="filter-list" id="filter-rating" role="group">
                            <label class="radio" for="rating-1">
                                <input checked id="rating-1" name="rating" type="radio" value="all"><span>Tất
                                        cả</span></label>
                            <label class="radio" for="rating-2">
                                <input id="rating-2" name="rating" type="radio" value="4"><span>Từ 4★</span></label>
                            <label class="radio" for="rating-3">
                                <input id="rating-3" name="rating" type="radio" value="4.5"><span>Từ
                                        4.5★</span></label>
                            <label class="radio" for="rating-4">
                                <input id="rating-4" name="rating" type="radio" value="5"><span>5★</span></label>

                        </div>
                    </div>
                </form>
            </aside>
        </div>

        <!-- Product place-->
        <div class="right-col main-content">
            <!-- Product toolbar -->
            <div class="product-toolbar">
                <div class="toolbar-left">
                    <label class="sort-dropdown" for="sort-by">
                        <select aria-label="Sắp xếp" id="sort-by">
                            <option value="popular">Thứ tự mặc định</option>
                            <option value="price-asc">Giá Thấp đến Cao</option>
                            <option value="price-desc">Giá Cao đến Thấp</option>
                            <option value="new-products">Mới nhất</option>
                            <option value="best-selling">Bán chạy</option>
                            <option value="price-discount">Ưu đãi sâu</option>
                            <option value="rating-desc">Đánh giá cao nhất</option>
                        </select>
                    </label>
                </div>

                <div class="toolbar-right">
                    <span class="results-summary" id="results">Hiển thị kết quả 0–0 trong số 0</span>
                </div>
            </div>

            <!-- Product list -->
            <div class="product-list">
                <div class="product-grid" id="grid-products">

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 1" class="product-image" src="${pageContext.request.contextPath}/static/assets/duongtoccocoon.png">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xịt dưỡng tóc Cocoon Tinh dầu Bưởi</h3>
                            <div class="product-small-details">
                                <p><span>Cocoon</span> • <span>Xịt dưỡng – Giảm gãy rụng – Dưỡng óng mượt</span> •
                                    Việt Nam</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(345)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">150.000₫</p>
                                <p class="price-old">190.000₫</p>
                                <p class="badge-discount">-21%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 2" class="product-image" src="${pageContext.request.contextPath}/static/assets/xitduongtsubaki.webp">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xịt dưỡng Tsubaki Premium Repair Hair Water</h3>
                            <div class="product-small-details">
                                <p><span>Tsubaki</span> • <span>Xịt dưỡng – Phục hồi tóc – Dưỡng ẩm</span> • Nhật
                                    Bản</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(412)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">210.000₫</p>
                                <p class="price-old">260.000₫</p>
                                <p class="badge-discount">-19%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 3" class="product-image" src="${pageContext.request.contextPath}/static/assets/xitduongtresemme.png">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xịt dưỡng Tresemmé Keratin Smooth Heat Protect Spray</h3>
                            <div class="product-small-details">
                                <p><span>Tresemmé</span> • <span>Xịt dưỡng – Chống nhiệt 230°C – Giảm xơ rối</span>
                                    • Mỹ</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(550)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">130.000₫</p>
                                <p class="price-old">170.000₫</p>
                                <p class="badge-discount">-24%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 4" class="product-image" src="${pageContext.request.contextPath}/static/assets/xitduongdavines.webp">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xịt dưỡng Davines OI All In One Milk</h3>
                            <div class="product-small-details">
                                <p><span>Davines</span> • <span>Xịt sữa – Gỡ rối – Dưỡng ẩm</span> • Ý</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(289)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">600.000₫</p>
                                <p class="price-old">710.000₫</p>
                                <p class="badge-discount">-15%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 5" class="product-image" src="${pageContext.request.contextPath}/static/assets/xitduongMoroccanoil.webp">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xịt dưỡng Moroccanoil All in One Leave-in Conditioner</h3>
                            <div class="product-small-details">
                                <p><span>Moroccanoil</span> • <span>Xịt dưỡng – Gỡ rối – Dưỡng ẩm nhẹ</span> •
                                    Israel / Canada</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(498)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">650.000₫</p>
                                <p class="price-old">820.000₫</p>
                                <p class="badge-discount">-21%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 6" class="product-image" src="${pageContext.request.contextPath}/static/assets/xitduong10miracle.jpg">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xịt dưỡng It's a 10 Miracle Leave-In Product</h3>
                            <div class="product-small-details">
                                <p><span>It's a 10</span> • <span>Xịt dưỡng – Phục hồi – Gỡ rối</span> • Mỹ</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(515)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">450.000₫</p>
                                <p class="price-old">600.000₫</p>
                                <p class="badge-discount">-25%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 7" class="product-image" src="${pageContext.request.contextPath}/static/assets/xitduongloreal.jpg">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Xịt dưỡng L'Oréal Elseve 8-in-1 Oil Spray</h3>
                            <div class="product-small-details">
                                <p><span>L'Oréal</span> • <span>Xịt dưỡng – Bóng mượt – Chống nhiệt</span> • Pháp
                                </p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(322)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">190.000₫</p>
                                <p class="price-old">240.000₫</p>
                                <p class="badge-discount">-21%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 8" class="product-image" src="${pageContext.request.contextPath}/static/assets/tinhchatLoẻal.jpg">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Tinh chất L'Oréal Serioxyl Denser Hair</h3>
                            <div class="product-small-details">
                                <p><span>L'Oréal</span> • <span>Tinh chất – Kích thích mọc tóc – Làm dày tóc</span>
                                    • Pháp</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(456)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">850.000₫</p>
                                <p class="price-old">1.000.000₫</p>
                                <p class="badge-discount">-15%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 9" class="product-image" src="${pageContext.request.contextPath}/static/assets/serumKẻastase.webp">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Tinh chất Kérastase Genesis Serum Anti-Chute</h3>
                            <div class="product-small-details">
                                <p><span>Kérastase</span> • <span>Tinh chất – Giảm rụng tóc – Tăng cường nang
                                            tóc</span> • Pháp</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(580)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">1.300.000₫</p>
                                <p class="price-old">1.600.000₫</p>
                                <p class="badge-discount">-19%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 10" class="product-image" src="${pageContext.request.contextPath}/static/assets/theordinary.jpg">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Tinh chất The Ordinary Multi-Peptide Hair Density</h3>
                            <div class="product-small-details">
                                <p><span>The Ordinary</span> • <span>Tinh chất – Làm dày tóc – Cải thiện mật độ
                                            tóc</span> • Canada</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(420)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">550.000₫</p>
                                <p class="price-old">710.000₫</p>
                                <p class="badge-discount">-23%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 11" class="product-image" src="${pageContext.request.contextPath}/static/assets/drforc.webp">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Dr. For C Folligen Tonic</h3>
                            <div class="product-small-details">
                                <p><span>Dr. For C</span> • <span>Nước dưỡng – Giảm rụng – Làm khỏe da đầu</span> •
                                    Hàn Quốc</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(310)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">400.000₫</p>
                                <p class="price-old">500.000₫</p>
                                <p class="badge-discount">-20%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                    <div class="product-item">
                        <div class="product-img">
                            <a href="#">
                                <img alt="Product 12" class="product-image" src="${pageContext.request.contextPath}/static/assets/alpecinCafeine.jpg">
                            </a>
                        </div>
                        <div class="product-body">
                            <h3 class="product-title">Tinh chất Alpecin Caffeine Liquid</h3>
                            <div class="product-small-details">
                                <p><span>Alpecin</span> • <span>Tinh chất – Kích thích nang tóc – Giảm rụng</span> •
                                    Đức</p>
                            </div>
                            <div class="product-rating">
                                <div class="rating-stars">
                                    <a class="background-stars" href="#">★★★★★</a>
                                    <a class="foreground-stars" href="#">★★★★★</a>
                                </div>
                                <p class="review-count">(488)</p>
                            </div>
                            <div class="product-price">
                                <p class="price-current">280.000₫</p>
                                <p class="price-old">370.000₫</p>
                                <p class="badge-discount">-24%</p>
                            </div>
                            <div class="product">
                                <a class="btn" href="#">Xem thêm</a>
                                <a class="btn primary" href="#">Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <nav class="pagination">
                        <a class="prev disabled" href="#">
                            <i class="fas fa-chevron-left"></i> Trước
                        </a>
                        <span class="active">1</span>
                        <a href="#">2</a>
                        <a href="#">3</a>
                        <a href="#">4</a>
                        <a href="#">5</a>
                        <span class="ellipsis">...</span>
                        <a href="#">13</a>
                        <a class="next" href="#">
                            Sau <i class="fas fa-chevron-right"></i>
                        </a>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp" />

<script>
    const slides = document.querySelectorAll('.banner-slides .item');
    const slideContainer = document.querySelector('.banner-slides');
    const prevButton = document.querySelector('.nav.prev');
    const nextButton = document.querySelector('.nav.next');
    const dotsContainer = document.querySelector('.slider-dots');

    let currentSlide = 0;
    let autoSlide;

    // 👉 Tạo dots theo số slide
    slides.forEach((_, index) => {
        const dot = document.createElement('button');
        dot.addEventListener('click', () => goToSlide(index));
        dotsContainer.appendChild(dot);
    });
    const dots = dotsContainer.querySelectorAll('button');

    function updateSlide() {
        const offset = -currentSlide * 100;
        slideContainer.style.transform = `translateX(${offset}%)`;
        dots.forEach(dot => dot.classList.remove('active'));
        dots[currentSlide].classList.add('active');
    }

    function prevSlide() {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
        updateSlide();
    }

    function nextSlide() {
        currentSlide = (currentSlide + 1) % slides.length;
        updateSlide();
    }

    function goToSlide(index) {
        currentSlide = index;
        updateSlide();
    }

    function startAutoSlide() {
        autoSlide = setInterval(nextSlide, 4000);
    }

    function stopAutoSlide() {
        clearInterval(autoSlide);
    }

    // 👉 Event listeners
    prevButton.addEventListener('click', () => {
        prevSlide();
        stopAutoSlide();
        startAutoSlide();
    });

    nextButton.addEventListener('click', () => {
        nextSlide();
        stopAutoSlide();
        startAutoSlide();
    });

    slideContainer.addEventListener('mouseenter', stopAutoSlide);
    slideContainer.addEventListener('mouseleave', startAutoSlide);

    // 👉 Khởi động
    updateSlide();
    startAutoSlide();


    //tùy chỉnh đánh giá sao
    const products = document.querySelectorAll('.product-item');

    products.forEach(item => {
        // Tìm phần tử .foreground-stars trong item
        const stars = item.querySelector('.foreground-stars');
        if (stars) {
            const starCount = stars.textContent.trim().length; // số lượng "★"

            // Xác định phần trăm chiều rộng dựa theo số sao
            let widthPercent = (starCount / 5) * 100;

            // Gán lại style width
            stars.style.width = widthPercent + '%';
        }
    });
</script>

</body>
</html>
