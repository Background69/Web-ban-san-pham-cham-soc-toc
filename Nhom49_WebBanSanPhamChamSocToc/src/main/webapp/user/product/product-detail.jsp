<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>
    <title>Serum L'Oreal Sáng Da, Mờ Thâm Mụn & Nám 30ml</title>
    <link href="${pageContext.request.contextPath}/static/css/style_for_product_detail.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/layout/header.jsp" />

<main>
    <!-- Product detail -->
    <div class="product-detail-container">

        <div class="product-detail-left">
            <div class="product-detail-image">
                <img alt="Product 1" class="product-image" src="${pageContext.request.contextPath}/static/assets/product-1-1.jpg">
            </div>
            <div class="thumbnail-images">
                <img alt="img-11" class="thumbnail active" src="${pageContext.request.contextPath}/static/assets/product-1-1.jpg">
                <img alt="img-12" class="thumbnail" src="${pageContext.request.contextPath}/static/assets/product-1-2.jpg">
                <img alt="img-13" class="thumbnail" src="${pageContext.request.contextPath}/static/assets/product-1-3.png">
                <img alt="img-14" class="thumbnail" src="${pageContext.request.contextPath}/static/assets/product-1-4.jpg">
            </div>
        </div>

        <div class="product-detail-right">
            <h1 class="product-title">Serum L'Oreal Sáng Da, Mờ Thâm Mụn & Nám 30ml</h1>
            <div class="product-header-details">
                <div class="product-rating-section">
                    <div class="rating-stars">
                        <a class="stars">★★★★★</a>
                        <span class="rating-number">4.8</span>
                    </div>
                    <p class="rating-count">(423 đánh giá)</p>
                </div>
            </div>

            <div class="product-section-price">
                <div class="price-main">
                    <p class="price-current">220.000₫</p>
                    <p class="price-old">280.000₫</p>
                    <p class="discount-percent">-21%</p>
                </div>
                <div class="price-note">
                    <i class="fas fa-info-circle"></i>
                    <p>Giá đã bao gồm VAT</p>
                </div>
            </div>

            <div class="product-section-info">
                <div class="info-item">
                    <i class="fas fa-certificate"></i>
                    <div>
                        <strong>Thương hiệu:</strong>
                        <span>L'Oréal Professionnel</span>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-globe"></i>
                    <div>
                        <strong>Xuất xứ:</strong>
                        <span>Pháp</span>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-box"></i>
                    <div>
                        <strong>Tình trạng:</strong>
                        <span class="in-stock">Còn hàng</span>
                    </div>
                </div>
            </div>

            <!-- Tình trạng tóc phù hợp - Sử dụng bảng product_hair_conditions -->
            <div class="product-section-hair-conditions">
                <div class="hair-conditions-label">
                    <i class="fas fa-leaf"></i>
                    <strong>Phù hợp với tình trạng tóc:</strong>
                </div>
                <div class="hair-conditions-tags">
                    <a class="condition-tag" href="${pageContext.request.contextPath}/store.jsp?condition=kho-xo">
                        <i class="fas fa-tint-slash"></i> Khô xơ
                    </a>
                    <a class="condition-tag" href="${pageContext.request.contextPath}/store.jsp?condition=hu-ton-nhuom">
                        <i class="fas fa-paint-brush"></i> Hư tổn – Nhuộm
                    </a>
                    <a class="condition-tag" href="${pageContext.request.contextPath}/store.jsp?condition=mong-rung-toc">
                        <i class="fas fa-wind"></i> Mỏng – Rụng tóc
                    </a>
                </div>
            </div>

            <div class="product-section-options">
                <div class="option-group">
                    <label>Dung tích:</label>
                    <div class="option-buttons">
                        <button class="option-btn active" data-old-price="280000" data-price="220000">
                            30ml
                        </button>
                        <button class="option-btn" data-old-price="450000" data-price="380000">
                            50ml
                        </button>
                        <button class="option-btn" data-old-price="750000" data-price="620000">
                            100ml
                        </button>
                    </div>
                </div>

                <div class="option-group">
                    <label>Số lượng:</label>
                    <div class="quantity-selector">
                        <button class="qty-btn">-</button>
                        <input id="quantity" max="99" min="1" type="number" value="1">
                        <button class="qty-btn">+</button>
                    </div>
                </div>
            </div>

            <div class="product-section-btn">
                <button class="btn btn-add-cart">
                    <i class="fas fa-shopping-cart"></i>
                    Thêm vào giỏ hàng
                </button>
                <button class="btn btn-buy-now" onclick="location.href='${pageContext.request.contextPath}/user/cart/cart.jsp'">
                    Mua ngay
                </button>
            </div>
        </div>
    </div>

    <div class="product-main-detail-page">
        <div class="main-detail-header">
            <button class="detail-page-btn active">Mô tả sản phẩm</button>
            <button class="detail-page-btn">Đánh giá (423)</button>
        </div>

        <!-- Description -->
        <div class="detail-page-content active" id="description">
            <h2>Mô tả sản phẩm</h2>

            <div class="description-content">
                <h3>Serum dưỡng tóc L'Oreal Professionnel - Bí quyết cho mái tóc khỏe đẹp chuẩn salon</h3>
                <p>
                    Serum dưỡng tóc L'Oreal Professionnel là giải pháp chuyên sâu giúp phục hồi và nuôi dưỡng mái tóc hư
                    tổn,
                    khô xơ do tác động của hóa chất, nhiệt độ cao và môi trường. Với công thức chứa các dưỡng chất cao
                    cấp,
                    sản phẩm giúp mang lại mái tóc mềm mượt, óng ả và tràn đầy sức sống.
                </p>

                <h4>Công dụng nổi bật:</h4>
                <ul>
                    <li>Phục hồi tóc hư tổn từ sâu bên trong cấu trúc tóc</li>
                    <li>Giúp tóc mềm mượt, giảm xơ rối và gãy rụng</li>
                    <li>Bảo vệ tóc trước tác động của nhiệt độ cao khi sấy, uốn, duỗi, nhuộm</li>
                    <li>Tăng độ bóng khỏe, cho mái tóc suôn mượt tự nhiên</li>
                    <li>Không gây bết dính hay nặng tóc</li>
                </ul>

                <h4>Thành phần chính:</h4>
                <ul>
                    <li><strong>Ceramide:</strong> Giúp phục hồi và củng cố liên kết biểu bì tóc, tăng độ chắc khỏe</li>
                    <li><strong>Vitamin E:</strong> Chống oxy hóa, bảo vệ tóc khỏi tác nhân gây hại từ môi trường</li>
                    <li><strong>Dầu Argan:</strong> Cung cấp độ ẩm, giúp tóc mềm mượt và óng ả</li>
                </ul>

                <h4>Hướng dẫn sử dụng:</h4>
                <ol>
                    <li>Gội sạch và lau khô tóc bằng khăn</li>
                    <li>Lấy một lượng serum vừa đủ (2-3 giọt) ra lòng bàn tay</li>
                    <li>Thoa đều lên thân và ngọn tóc, tránh tiếp xúc với da đầu</li>
                    <li>Có thể sử dụng trước khi sấy hoặc để khô tự nhiên</li>
                </ol>

                <h4>Đối tượng phù hợp:</h4>
                <p>
                    Phù hợp cho mọi loại tóc, đặc biệt là tóc hư tổn, khô xơ, tóc nhuộm, uốn, duỗi thường xuyên.
                </p>

                <h4>Cam kết chất lượng:</h4>
                <ul>
                    <li>Sản phẩm chính hãng 100%</li>
                    <li>Được phân phối bởi nhà cung cấp uy tín</li>
                    <li>Bảo đảm an toàn cho da đầu và sức khỏe người dùng</li>
                </ul>
            </div>
        </div>
        <!-- Reviews -->
        <div class="detail-page-content" id="reviews">
            <h2>Đánh giá từ khách hàng</h2>
            <div class="reviews-list">
                <!-- Review 1 -->
                <div class="review-item">
                    <div class="review-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">N</div>
                            <div class="reviewer-details">
                                <div class="reviewer-name">Nguyễn Thị Mai</div>
                                <div class="review-date">15/10/2024</div>
                            </div>
                        </div>
                        <div class="review-rating">★★★★★</div>
                    </div>
                    <div class="review-content">
                        <p>Sản phẩm rất tuyệt vời! Tóc mình khô và xơ do nhuộm nhiều, sau khi dùng serum này
                            tóc mềm mượt hơn hẳn. Mùi hương cũng rất thơm và sang trọng. Mình sẽ tiếp tục ủng hộ!</p>
                    </div>
                </div>

                <!-- Review 2 -->
                <div class="review-item">
                    <div class="review-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">T</div>
                            <div class="reviewer-details">
                                <div class="reviewer-name">Trần Văn Hoàng</div>
                                <div class="review-date">12/10/2024</div>
                            </div>
                        </div>
                        <div class="review-rating">★★★★★</div>
                    </div>
                    <div class="review-content">
                        <p>Đóng gói cẩn thận, ship nhanh. Sản phẩm chính hãng, dùng thấy hiệu quả sau 1 tuần.
                            Tóc bớt gãy rụng, mềm hơn nhiều. Giá cả hợp lý so với chất lượng.</p>
                    </div>
                </div>

                <!-- Review 3 -->
                <div class="review-item">
                    <div class="review-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">L</div>
                            <div class="reviewer-details">
                                <div class="reviewer-name">Lê Thị Hương</div>
                                <div class="review-date">08/10/2024</div>
                            </div>
                        </div>
                        <div class="review-rating">★★★★☆</div>
                    </div>
                    <div class="review-content">
                        <p>Sản phẩm tốt nhưng mình thấy hơi đắt. Tuy nhiên chất lượng xứng đáng với giá tiền.
                            Tóc mình bị hư tổn do duỗi, dùng serum này giúp phục hồi khá tốt.</p>
                    </div>
                </div>

                <!-- Review 4 -->
                <div class="review-item">
                    <div class="review-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">P</div>
                            <div class="reviewer-details">
                                <div class="reviewer-name">Phạm Minh Tuấn</div>
                                <div class="review-date">05/10/2024</div>
                            </div>
                        </div>
                        <div class="review-rating">★★★★★</div>
                    </div>
                    <div class="review-content">
                        <p>Lần đầu mua hàng ở shop, rất hài lòng! Sản phẩm authentic, date xa, đóng gói kỹ.
                            Dùng thử thấy tóc mềm hơn ngay lần đầu. Sẽ giới thiệu cho bạn bè!</p>
                    </div>
                </div>

                <!-- Review 5 -->
                <div class="review-item">
                    <div class="review-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">H</div>
                            <div class="reviewer-details">
                                <div class="reviewer-name">Hoàng Thị Lan</div>
                                <div class="review-date">01/10/2024</div>
                            </div>
                        </div>
                        <div class="review-rating">★★★★★</div>
                    </div>
                    <div class="review-content">
                        <p>Serum rất thơm, chai đẹp. Dùng ít mà hiệu quả cao, tóc mượt hẳn. Mình hay sử dụng
                            máy sấy nên tóc khô lắm, nhưng dùng serum này thấy cải thiện rõ rệt.</p>
                    </div>
                </div>
            </div>

            <div class="load-more-reviews">
                <button class="btn btn-load-more">Xem thêm đánh giá</button>
            </div>
        </div>

    </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp" />

<!-- Change Images Script -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const mainImg = document.querySelector('.product-detail-image .product-image');
        const thumbWrap = document.querySelector('.thumbnail-images');
        const thumbs = Array.from(document.querySelectorAll('.thumbnail-images .thumbnail'));
        if (!mainImg || !thumbWrap || thumbs.length === 0) return;

        function setActiveThumb(thumb, animate = true) {
            if (!thumb) return;
            // đổi viền xanh
            thumbs.forEach(t => t.classList.remove('active'));
            thumb.classList.add('active');

            const newSrc = thumb.getAttribute('data-full') || thumb.getAttribute('src');
            const newAlt = thumb.getAttribute('alt') || 'Product image';
            if (!newSrc) return;

            if (animate) {
                mainImg.classList.add('is-fading');
                setTimeout(() => {
                    mainImg.src = newSrc;
                    mainImg.alt = newAlt;
                    mainImg.classList.remove('is-fading');
                }, 120);
            } else {
                mainImg.src = newSrc;
                mainImg.alt = newAlt;
            }
        }

        // khi tải trang ưu tiên ảnh đang active
        setActiveThumb(thumbWrap.querySelector('.thumbnail.active') || thumbs[0], false);

        // nhấn ảnh (dùng event delegation)
        thumbWrap.addEventListener('click', function (e) {
            const thumb = e.target.closest('.thumbnail');
            if (!thumb) return;
            setActiveThumb(thumb, true);
        });
    });
</script>
<!-- Main Script cho phần product-detail-right-->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // format tiền VND đúng chuẩn
        function formatCurrency(value) {
            if (typeof value !== 'number' || isNaN(value)) return '';
            return value.toLocaleString('vi-VN') + '₫';
        }

        // Tự chọn dung tích & cập nhật giá
        const optionButtons = document.querySelectorAll('.product-section-options .option-btn');
        const priceCurrentEl = document.querySelector('.product-section-price .price-current');
        const priceOldEl = document.querySelector('.product-section-price .price-old');
        const discountEl = document.querySelector('.product-section-price .discount-percent');

        if (optionButtons.length && priceCurrentEl && priceOldEl && discountEl) {
            optionButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    optionButtons.forEach(function (b) {
                        b.classList.remove('active');
                    });
                    btn.classList.add('active');

                    const price = parseInt(btn.dataset.price, 10);
                    const oldPrice = parseInt(btn.dataset.oldPrice, 10);

                    if (!isNaN(price)) {
                        priceCurrentEl.textContent = formatCurrency(price);
                    }
                    if (!isNaN(oldPrice)) {
                        priceOldEl.textContent = formatCurrency(oldPrice);
                    }

                    if (!isNaN(price) && !isNaN(oldPrice) && oldPrice > 0) {
                        const discount = Math.round((1 - price / oldPrice) * 100);
                        if (discount > 0) {
                            discountEl.textContent = '-' + discount + '%';
                            discountEl.style.display = '';
                        } else {
                            discountEl.textContent = '';
                            discountEl.style.display = 'none';
                        }
                    }
                });
            });
        }
        // Tăng / giảm số lượng mua
        const qtyInput = document.getElementById('quantity');
        const qtyButtons = document.querySelectorAll('.quantity-selector .qty-btn');

        if (qtyInput) {
            const min = parseInt(qtyInput.min || '1', 10);
            const max = parseInt(qtyInput.max || '99', 10);

            function clampQty(value) {
                if (isNaN(value)) return min;
                return Math.max(min, Math.min(max, value));
            }

            qtyButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    let current = clampQty(parseInt(qtyInput.value, 10));
                    if (btn.textContent.trim() === '-') {
                        current = clampQty(current - 1);
                    } else {
                        current = clampQty(current + 1);
                    }
                    qtyInput.value = current;
                });
            });

            qtyInput.addEventListener('input', function () {
                qtyInput.value = clampQty(parseInt(qtyInput.value, 10));
            });
        }
        // Hiệu ứng & cộng số khi bấm Thêm vào giỏ
        const addCartBtn = document.querySelector('.btn btn-add-cart, .btn-add-cart');
        const cartCountEl = document.querySelector('.cart-count');

        if (addCartBtn) {
            addCartBtn.addEventListener('click', function () {
                // số lượng muốn thêm
                let quantityToAdd = 1;
                if (qtyInput) {
                    quantityToAdd = parseInt(qtyInput.value, 10);
                    if (isNaN(quantityToAdd) || quantityToAdd < 1) quantityToAdd = 1;
                }

                // cộng vào số trên icon giỏ hàng
                if (cartCountEl) {
                    const currentCount = parseInt(cartCountEl.textContent, 10) || 0;
                    cartCountEl.textContent = currentCount + quantityToAdd;
                }

                // hiệu ứng nút
                const originalHTML = addCartBtn.innerHTML;
                addCartBtn.classList.add('added');
                addCartBtn.disabled = true;
                addCartBtn.innerHTML = '<i class="fas fa-check"></i> Đã thêm vào giỏ';

                setTimeout(function () {
                    addCartBtn.classList.remove('added');
                    addCartBtn.disabled = false;
                    addCartBtn.innerHTML = originalHTML;
                }, 2000);
            });
        }
    });
</script>
<!-- Review Header Script -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const tabButtons = document.querySelectorAll('.main-detail-header .detail-page-btn');
        const tabContents = document.querySelectorAll('.product-main-detail-page .detail-page-content');
        const header = document.querySelector('header');

        function getHeaderOffset() {
            return header ? header.offsetHeight + 20 : 0;
        }

        function activateTab(index) {
            if (!tabButtons[index] || !tabContents[index]) return;

            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));

            const btn = tabButtons[index];
            const content = tabContents[index];

            btn.classList.add('active');
            content.classList.add('active');

            const headerOffset = getHeaderOffset();
            const top = content.getBoundingClientRect().top + window.pageYOffset - headerOffset;

            window.scrollTo({
                top: top,
                behavior: 'smooth'
            });
        }

        // Click nút tab
        tabButtons.forEach((btn, index) => {
            btn.addEventListener('click', function () {
                activateTab(index);
            });
        });

        // Click h2 của từng khối detail-page-content để chuyển
        const headings = document.querySelectorAll('.detail-page-content > h2');
        headings.forEach((heading, index) => {
            heading.style.cursor = 'pointer';
            heading.addEventListener('click', function () {
                activateTab(index);
            });
        });
    });
</script>
</body>
</html>
