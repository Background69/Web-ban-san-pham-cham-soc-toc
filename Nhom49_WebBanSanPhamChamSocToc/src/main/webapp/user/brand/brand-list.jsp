<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thương hiệu - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style_for_brands.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<!-- Brands Banner -->
<section class="brands-banner">
    <div class="brands-banner-overlay"></div>
    <div class="brands-banner-content">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span class="separator">›</span>
            <span class="current">Thương hiệu</span>
        </nav>
        <div class="brands-banner-text">
            <h1>Thương Hiệu Chính Hãng</h1>
            <p class="brands-tagline">Khám phá các thương hiệu chăm sóc tóc hàng đầu thế giới - 100% chính hãng</p>
            <div class="brands-stats-banner">
                <span class="stat-badge"><i class="fas fa-award"></i> ${totalBrands}+ Thương hiệu</span>
                <span class="stat-badge"><i class="fas fa-globe"></i> Đa quốc gia</span>
                <span class="stat-badge"><i class="fas fa-shield-alt"></i> Chính hãng 100%</span>
            </div>
        </div>
    </div>
</section>

<main class="brands-main">
    <!-- Filter Section -->
    <div class="filter-section">
        <h3><i class="fas fa-filter"></i> Lọc theo xuất xứ</h3>
        <div class="filter-tags">
            <button class="filter-tag active" data-origin="all">Tất cả</button>
            <c:forEach var="origin" items="${origins}">
                <button class="filter-tag" data-origin="${origin.toLowerCase()}">${origin}</button>
            </c:forEach>
        </div>
    </div>

    <!-- Brands Grid -->
    <div class="brands-grid">
        <c:forEach var="brand" items="${brands}">
            <div class="brand-item" data-origin="${brand.origin.toLowerCase()}">
                <div class="brand-logo">
                    <c:choose>
                        <c:when test="${not empty brand.logoUrl}">
                            <img src="${brand.logoUrl}" alt="Logo ${brand.brandName}">
                        </c:when>
                        <c:otherwise>
                            <div class="brand-logo-placeholder">
                                <i class="fas fa-building"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="brand-logo-text">${brand.brandName}</div>
                <c:if test="${not empty brand.origin}">
                    <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> ${brand.origin}</div>
                </c:if>
                <c:if test="${not empty brand.shortDescription}">
                    <p class="brand-description">${brand.shortDescription}</p>
                </c:if>
                <a class="brand-link" href="${pageContext.request.contextPath}/brand/${brand.brandSlug}">Xem Sản
                    Phẩm</a>
            </div>
        </c:forEach>
    </div>

    <!-- Empty State -->
    <c:if test="${empty brands}">
        <div class="empty-state">
            <i class="fas fa-box-open"></i>
            <h3>Chưa có thương hiệu nào</h3>
            <p>Vui lòng quay lại sau</p>
        </div>
    </c:if>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    // Filter by origin
    document.querySelectorAll('.filter-tag').forEach(tag => {
        tag.addEventListener('click', function () {
            document.querySelectorAll('.filter-tag').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            const origin = this.dataset.origin;
            document.querySelectorAll('.brand-item').forEach(card => {
                if (origin === 'all' || card.dataset.origin === origin) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });
</script>
</body>
</html>
