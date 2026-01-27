<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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

<jsp:include page="/layout/header.jsp"/>

<!-- Banner -->
<section class="brands-banner section-animate">
    <div class="brands-banner-overlay"></div>
    <div class="brands-banner-content">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span class="separator">›</span>
            <span class="current">Thương hiệu</span>
        </nav>

        <div class="brands-banner-text">
            <h1>Thương Hiệu Chính Hãng</h1>
            <p class="brands-tagline">
                Khám phá các thương hiệu chăm sóc tóc hàng đầu thế giới - 100% chính hãng
            </p>
            <div class="brands-stats-banner">
                <span class="stat-badge"><i class="fas fa-award"></i> ${totalBrands}+ Thương hiệu</span>
                <span class="stat-badge"><i class="fas fa-globe"></i> Đa quốc gia</span>
                <span class="stat-badge"><i class="fas fa-shield-alt"></i> Chính hãng 100%</span>
            </div>
        </div>
    </div>
</section>

<main class="brands-main page-animate">

    <!-- Filter -->
    <div class="filter-section">
        <h3><i class="fas fa-filter"></i> Lọc theo xuất xứ</h3>
        <div class="filter-tags stagger-fade">
            <button class="filter-tag active" data-origin="all">Tất cả</button>
            <c:forEach var="origin" items="${origins}">
                <button class="filter-tag" data-origin="${origin.toLowerCase()}">${origin}</button>
            </c:forEach>
        </div>
    </div>

    <!-- Brands grid -->
    <div class="brands-grid stagger-fade">
        <c:forEach var="brand" items="${brands}">
            <div class="brand-item"
                 data-origin="${not empty brand.origin ? brand.origin.toLowerCase() : 'unknown'}">

                <!-- Logo -->
                <div class="brand-logo">
                    <c:choose>
                        <c:when test="${not empty brand.logoUrl}">
                            <!--
                            DB: images/brands/sunsilk.png
                            Thực tế: /static/assets/images/brands/sunsilk.png
                            -->
                            <img
                                    src="${pageContext.request.contextPath}/static/assets/${brand.logoUrl}"
                                    alt="Logo ${brand.brandName}"
                                    onerror="this.onerror=null;
                                         this.remove();
                                         this.parentElement.innerHTML='<div class=&quot;brand-logo-placeholder&quot;><i class=&quot;fas fa-building&quot;></i></div>';"
                            />
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
                    <div class="brand-origin">
                        <i class="fas fa-map-marker-alt"></i> ${brand.origin}
                    </div>
                </c:if>

                <c:if test="${not empty brand.shortDescription}">
                    <p class="brand-description">${brand.shortDescription}</p>
                </c:if>

                <a class="brand-link"
                   href="${pageContext.request.contextPath}/brand/${brand.brandSlug}">
                    Xem Sản Phẩm
                </a>
            </div>
        </c:forEach>
    </div>

    <!-- Empty -->
    <c:if test="${empty brands}">
        <div class="empty-state">
            <i class="fas fa-box-open"></i>
            <h3>Chưa có thương hiệu nào</h3>
            <p>Vui lòng quay lại sau</p>
        </div>
    </c:if>

</main>

<jsp:include page="/layout/footer.jsp"/>

<script>
    document.querySelectorAll('.filter-tag').forEach(tag => {
        tag.addEventListener('click', function () {
            document.querySelectorAll('.filter-tag').forEach(t => t.classList.remove('active'));
            this.classList.add('active');

            const origin = this.dataset.origin;
            document.querySelectorAll('.brand-item').forEach(card => {
                card.style.display =
                    (origin === 'all' || card.dataset.origin === origin) ? '' : 'none';
            });
        });
    });
</script>

</body>
</html>
