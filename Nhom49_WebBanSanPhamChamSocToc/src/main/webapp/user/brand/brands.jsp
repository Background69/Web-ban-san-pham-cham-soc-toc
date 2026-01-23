<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>
    <title>HairGlow | Thương hiệu</title>
    <link href="${pageContext.request.contextPath}/static/css/style_for_brands.css" rel="stylesheet">

</head>
<body>

<jsp:include page="/layout/header.jsp" />

<!-- Brands Banner Full Width -->
<section class="brands-banner">
    <div class="brands-banner-overlay"></div>
    <div class="brands-banner-content">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
            <span class="separator">›</span>
            <span class="current">Thương hiệu</span>
        </nav>
        <div class="brands-banner-text">
            <h1>Thương Hiệu Chính Hãng</h1>
            <p class="brands-tagline">Khám phá các thương hiệu chăm sóc tóc hàng đầu thế giới - 100% chính hãng</p>
            <div class="brands-stats-banner">
                <span class="stat-badge"><i class="fas fa-award"></i> 12+ Thương hiệu</span>
                <span class="stat-badge"><i class="fas fa-globe"></i> 5 Quốc gia</span>
                <span class="stat-badge"><i class="fas fa-shield-alt"></i> Chính hãng 100%</span>
            </div>
        </div>
    </div>
</section>

<main>
    <div class="filter-section">
        <h3><i class="fas fa-filter"></i> Lọc theo xuất xứ</h3>
        <div class="filter-tags"></div>
        <button class="filter-tag active" data-origin="all">Tất cả</button>
        <button class="filter-tag" data-origin="france">Pháp</button>
        <button class="filter-tag" data-origin="usa">Mỹ</button>
        <button class="filter-tag" data-origin="italy">Ý</button>
        <button class="filter-tag" data-origin="korea">Hàn Quốc</button>
        <button class="filter-tag" data-origin="japan">Nhật Bản</button>
    </div>
    </div>
    <div class="brands-grid">
        <div class="brand-item" data-origin="france">
            <div class="brand-logo">
                <img alt="Logo L'Oréal Professionnel" src="${pageContext.request.contextPath}/static/assets/brands/loreal-professionnel.svg">
            </div>
            <div class="brand-logo-text">L'Oréal Professionnel</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Pháp</div>
            <p class="brand-description">
                Thương hiệu chăm sóc tóc chuyên nghiệp hàng đầu thế giới với hơn 100 năm kinh nghiệm.
                Sản phẩm cao cấp được tin dùng bởi các salon tóc.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="france">
            <div class="brand-logo">
                <img alt="Logo Kérastase" src="${pageContext.request.contextPath}/static/assets/brands/kerastase.svg">
            </div>
            <div class="brand-logo-text">Kérastase</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Pháp</div>
            <p class="brand-description">
                Thương hiệu xa xỉ đến từ L'Oréal Group, chuyên cung cấp các liệu trình chăm sóc tóc
                cao cấp với công nghệ tiên tiến nhất.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="italy">
            <div class="brand-logo">
                <img alt="Logo Davines" src="${pageContext.request.contextPath}/static/assets/brands/davines.svg">
            </div>
            <div class="brand-logo-text">Davines</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Ý</div>
            <p class="brand-description">
                Thương hiệu Italy với triết lý bền vững, sử dụng thành phần tự nhiên và thân thiện
                với môi trường. Được yêu thích bởi giới chuyên gia.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="usa">
            <div class="brand-logo">
                <img alt="Logo Moroccanoil" src="${pageContext.request.contextPath}/static/assets/brands/moroccanoil.png">
            </div>
            <div class="brand-logo-text">Moroccanoil</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
            <p class="brand-description">
                Thương hiệu nổi tiếng với dầu argan Morocco nguyên chất. Sản phẩm giúp phục hồi
                và nuôi dưỡng tóc hiệu quả.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="usa">
            <div class="brand-logo">
                <img alt="Logo OGX" src="${pageContext.request.contextPath}/static/assets/brands/ogx.png">
            </div>
            <div class="brand-logo-text">OGX</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
            <p class="brand-description">
                Thương hiệu Mỹ với các dòng sản phẩm đa dạng từ thiên nhiên. Không chứa sulfate,
                an toàn cho mọi loại tóc.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="usa">
            <div class="brand-logo">
                <img alt="Logo Head &amp; Shoulders" src="${pageContext.request.contextPath}/static/assets/brands/head-shoulders.svg">
            </div>
            <div class="brand-logo-text">Head &amp; Shoulders</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
            <p class="brand-description">
                Thương hiệu số 1 thế giới về dầu gội trị gàu. Công thức được kiểm chứng lâm sàng,
                giúp loại bỏ gàu hiệu quả.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="korea">
            <div class="brand-logo">
                <img alt="Logo Mise En Scène" src="${pageContext.request.contextPath}/static/assets/brands/mise-en-scene.png">
            </div>
            <div class="brand-logo-text">Mise En Scène</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Hàn Quốc</div>
            <p class="brand-description">
                Thương hiệu K-Beauty nổi tiếng với dầu dưỡng tóc Perfect Serum. Công thức Hàn Quốc
                giúp tóc mềm mượt, óng ả.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="korea">
            <div class="brand-logo">
                <img alt="Logo Innisfree" src="${pageContext.request.contextPath}/static/assets/brands/innisfree.svg">
            </div>
            <div class="brand-logo-text">Innisfree</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Hàn Quốc</div>
            <p class="brand-description">
                Thương hiệu thiên nhiên từ đảo Jeju. Sản phẩm chăm sóc tóc với thành phần organic,
                không hóa chất độc hại.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="japan">
            <div class="brand-logo">
                <img alt="Logo Kaminomoto" src="${pageContext.request.contextPath}/static/assets/brands/kaminomoto.png">
            </div>
            <div class="brand-logo-text">Kaminomoto</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Nhật Bản</div>
            <p class="brand-description">
                Thương hiệu Nhật Bản chuyên về sản phẩm kích thích mọc tóc. Công nghệ tiên tiến
                giúp ngăn rụng tóc hiệu quả.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="usa">
            <div class="brand-logo">
                <img alt="Logo TRESemmé" src="${pageContext.request.contextPath}/static/assets/brands/tresemme.svg">
            </div>
            <div class="brand-logo-text">TRESemmé</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
            <p class="brand-description">
                Chất lượng salon chuyên nghiệp với giá cả phải chăng. Sản phẩm được các nhà tạo
                mẫu tóc chuyên nghiệp tin dùng.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="usa">
            <div class="brand-logo">
                <img alt="Logo Nizoral" src="${pageContext.request.contextPath}/static/assets/brands/nizoral.svg">
            </div>
            <div class="brand-logo-text">Nizoral</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
            <p class="brand-description">
                Dầu gội trị gàu và nấm da đầu chuyên sâu. Thành phần Ketoconazole giúp điều trị
                hiệu quả các vấn đề da đầu.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>

        <div class="brand-item" data-origin="france">
            <div class="brand-logo">
                <img alt="Logo L'Oréal Paris" src="${pageContext.request.contextPath}/static/assets/brands/loreal-paris.svg">
            </div>
            <div class="brand-logo-text">L'Oréal Paris</div>
            <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Pháp</div>
            <p class="brand-description">
                Dòng sản phẩm chăm sóc tóc đại chúng từ tập đoàn L'Oréal. Chất lượng tốt với
                mức giá phù hợp cho mọi người.
            </p>
            <a class="brand-link" href="#">Xem Sản Phẩm</a>
        </div>
    </div>

</main>

<jsp:include page="/layout/footer.jsp" />

<!-- Filter Tag Script -->
<script>
    document.querySelectorAll('.filter-tag').forEach(tag => {
        tag.addEventListener('click', function () {
            document.querySelectorAll('.filter-tag').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            const origin = this.dataset.origin;
            document.querySelectorAll('.brand-item').forEach(card => {
                if (origin === 'all' || card.dataset.origin === origin) {
                    card.style.removeProperty('display');
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });
</script>

</body>
</html>
