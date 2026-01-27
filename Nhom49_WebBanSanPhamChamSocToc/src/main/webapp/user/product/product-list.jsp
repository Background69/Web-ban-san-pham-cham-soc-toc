<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Sản phẩm'} - HairGlow</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/store.css">
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="store-container page-animate">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <span>/</span>
        <c:choose>
            <c:when test="${not empty currentCategory}">
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <span>/</span>
                <span>${currentCategory.categoryName}</span>
            </c:when>
            <c:when test="${not empty currentBrand}">
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <span>/</span>
                <span>${currentBrand.brandName}</span>
            </c:when>
            <c:otherwise>
                <span>Sản phẩm</span>
            </c:otherwise>
        </c:choose>
    </nav>

    <c:set var="searchTerm" value="${not empty param.search ? param.search : param.q}"/>

    <div class="store-layout">
        <!-- Sidebar Filters -->
        <aside class="store-sidebar">
            <form action="${pageContext.request.contextPath}/products" method="get" id="filterForm">
                <!-- Search -->
                <c:if test="${not empty searchTerm}">
                    <input type="hidden" name="search" value="${searchTerm}">
                </c:if>

                <!-- Category Filter -->
                <div class="filter-section">
                    <h3><i class="fas fa-list"></i> Danh mục</h3>
                    <ul class="filter-list">
                        <li>
                            <a href="${pageContext.request.contextPath}/products"
                               class="${empty param.category ? 'active' : ''}">Tất cả</a>
                        </li>
                        <c:forEach var="cat" items="${categories}">
                            <li>
                                <a href="${pageContext.request.contextPath}/products?category=${cat.categorySlug}"
                                   class="${param.category == cat.categorySlug ? 'active' : ''}">${cat.categoryName}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <!-- Brand Filter -->
                <div class="filter-section">
                    <h3><i class="fas fa-tags"></i> Thương hiệu</h3>
                    <ul class="filter-list brand-list">
                        <c:forEach var="brand" items="${brands}">
                            <li>
                                <label>
                                    <input type="checkbox" name="brand" value="${brand.brandSlug}"
                                        ${param.brand == brand.brandSlug ? 'checked' : ''}
                                           onchange="document.getElementById('filterForm').submit()">
                                        ${brand.brandName}
                                </label>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <!-- Price Filter -->
                <div class="filter-section">
                    <h3><i class="fas fa-money-bill"></i> Khoảng giá</h3>
                    <div class="price-range">
                        <select name="priceRange" onchange="document.getElementById('filterForm').submit()">
                            <option value="">Tất cả</option>
                            <option value="0-200000" ${param.priceRange == '0-200000' ? 'selected' : ''}>Dưới 200.000₫</option>
                            <option value="200000-500000" ${param.priceRange == '200000-500000' ? 'selected' : ''}>
                                200.000₫ - 500.000₫
                            </option>
                            <option value="500000-1000000" ${param.priceRange == '500000-1000000' ? 'selected' : ''}>
                                500.000₫ - 1.000.000₫
                            </option>
                            <option value="1000000-" ${param.priceRange == '1000000-' ? 'selected' : ''}>Trên 1.000.000₫</option>
                        </select>
                    </div>
                </div>

            </form>
        </aside>

        <!-- Product Grid -->
        <div class="store-main">
            <!-- Header with sort -->
            <div class="store-header">
                <div class="result-count">
                    <c:choose>
                        <c:when test="${not empty searchTerm}">
                            <h2>Kết quả tìm kiếm: "${searchTerm}"</h2>
                            <p>Tìm thấy ${totalProducts} sản phẩm</p>
                        </c:when>
                        <c:when test="${not empty currentCategory}">
                            <h2>${currentCategory.categoryName}</h2>
                            <p>${totalProducts} sản phẩm</p>
                        </c:when>
                        <c:when test="${not empty currentBrand}">
                            <h2>${currentBrand.brandName}</h2>
                            <p>${totalProducts} sản phẩm</p>
                        </c:when>
                        <c:otherwise>
                            <h2>Tất cả sản phẩm</h2>
                            <p>${totalProducts} sản phẩm</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sort-options">
                    <label>Sắp xếp:</label>
                    <select name="sort" onchange="window.location.href=this.value">
                        <option value="${pageContext.request.contextPath}/products?${queryString}&sort=newest"
                        ${param.sort == 'newest' || empty param.sort ? 'selected' : ''}>Mới nhất</option>
                        <option value="${pageContext.request.contextPath}/products?${queryString}&sort=price-asc"
                        ${param.sort == 'price-asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                        <option value="${pageContext.request.contextPath}/products?${queryString}&sort=price-desc"
                        ${param.sort == 'price-desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                        <option value="${pageContext.request.contextPath}/products?${queryString}&sort=rating"
                        ${param.sort == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                        <option value="${pageContext.request.contextPath}/products?${queryString}&sort=bestseller"
                        ${param.sort == 'bestseller' ? 'selected' : ''}>Bán chạy</option>
                    </select>
                </div>
            </div>

            <!-- Products -->
            <c:choose>
                <c:when test="${not empty products}">
                    <div class="product-grid stagger-fade">
                        <c:forEach var="product" items="${products}">
                            <div class="product-item">
                                <c:if test="${product.defaultVariant != null && product.defaultVariant.discountPercent > 0}">
                                    <div class="product-badge">-${product.defaultVariant.discountPercent}%</div>
                                </c:if>

                                <div class="product-img">
                                    <a href="${pageContext.request.contextPath}/product/${product.productSlug}">
                                        <img alt="${product.productName}" class="product-image"
                                             src="${pageContext.request.contextPath}/static/${not empty product.primaryImageUrl ? product.primaryImageUrl : 'images/default-product.png'}">
                                    </a>
                                </div>

                                <div class="product-body">
                                    <h3 class="product-title">
                                        <a href="${pageContext.request.contextPath}/product/${product.productSlug}">${product.productName}</a>
                                    </h3>

                                    <div class="product-small-details">
                                        <p>
                                            <span>${product.brand != null ? product.brand.brandName : ''}</span>
                                            •
                                            <span>${product.category != null ? product.category.categoryName : ''}</span>
                                            <c:if test="${not empty product.origin}"> • ${product.origin}</c:if>
                                        </p>
                                    </div>

                                    <div class="product-rating">
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <span class="star ${i <= product.averageRating ? 'filled' : ''}">★</span>
                                            </c:forEach>
                                        </div>
                                        <span class="review-count">(${product.reviewCount})</span>
                                    </div>

                                    <div class="product-price">
                                        <c:if test="${product.defaultVariant != null}">
                                            <span class="price-current">
                                                <fmt:formatNumber
                                                        value="${product.defaultVariant.salePrice != null ? product.defaultVariant.salePrice : product.defaultVariant.originalPrice}"
                                                        type="number"/>₫
                                            </span>
                                            <c:if test="${product.defaultVariant.salePrice != null && product.defaultVariant.salePrice < product.defaultVariant.originalPrice}">
                                                <span class="price-old">
                                                    <fmt:formatNumber value="${product.defaultVariant.originalPrice}" type="number"/>₫
                                                </span>
                                            </c:if>
                                        </c:if>
                                    </div>

                                    <c:if test="${product.onSale && product.stockQuantity > 0}">
                                        <div class="stock-progress">
                                            <div class="stock-progress-bar">
                                                <div class="stock-progress-fill" style="width: ${product.soldPercent}%"></div>
                                            </div>
                                            <div class="stock-progress-text">
                                                Đã bán ${product.soldQuantity}/${product.stockQuantity}
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="product-actions">
                                        <a class="btn btn-outline"
                                           href="${pageContext.request.contextPath}/product/${product.productSlug}">Xem thêm</a>
                                        <button class="btn btn-primary add-to-cart" data-product-id="${product.productId}">
                                            <i class="fas fa-cart-plus"></i> Thêm
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <jsp:include page="/layout/pagination.jsp"/>
                </c:when>
                <c:otherwise>
                    <div class="no-products">
                        <i class="fas fa-search"></i>
                        <h3>Không tìm thấy sản phẩm</h3>
                        <p>Vui lòng thử lại với từ khóa khác hoặc xóa bộ lọc</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Xem tất cả sản phẩm</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    // Add to cart
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
