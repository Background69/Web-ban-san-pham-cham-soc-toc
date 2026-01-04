<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 29/12/2025
  Time: 12:46 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style_for_brands.css">
<script src="<%= request.getContextPath() %>/static/js/Brands.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

<section class="brands-banner">
  <div class="brands-banner-overlay"></div>
  <div class="brands-banner-content">
    <nav class="breadcrumb">
      <a href="MainPage.jsp">Trang chủ</a>
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
    <div class="filter-tags">
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
        <img alt="Logo L'Oréal Professionnel" src="images/brands/loreal-professionnel.svg">
      </div>
      <div class="brand-logo-text">L'Oréal Professionnel</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Pháp</div>
      <p class="brand-description">
        Thương hiệu chăm sóc tóc chuyên nghiệp hàng đầu thế giới với hơn 100 năm kinh nghiệm.
        Sản phẩm cao cấp được tin dùng bởi các salon tóc.
      </p>
      <a class="brand-link" href="brand_loreal_professionnel.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="france">
      <div class="brand-logo">
        <img alt="Logo Kérastase" src="images/brands/kerastase.svg">
      </div>
      <div class="brand-logo-text">Kérastase</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Pháp</div>
      <p class="brand-description">
        Thương hiệu xa xỉ đến từ L'Oréal Group, chuyên cung cấp các liệu trình chăm sóc tóc
        cao cấp với công nghệ tiên tiến nhất.
      </p>
      <a class="brand-link" href="brand_kerastase.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="italy">
      <div class="brand-logo">
        <img alt="Logo Davines" src="images/brands/davines.svg">
      </div>
      <div class="brand-logo-text">Davines</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Ý</div>
      <p class="brand-description">
        Thương hiệu Italy với triết lý bền vững, sử dụng thành phần tự nhiên và thân thiện
        với môi trường. Được yêu thích bởi giới chuyên gia.
      </p>
      <a class="brand-link" href="brand_davines.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="usa">
      <div class="brand-logo">
        <img alt="Logo Moroccanoil" src="images/brands/moroccanoil.png">
      </div>
      <div class="brand-logo-text">Moroccanoil</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
      <p class="brand-description">
        Thương hiệu nổi tiếng với dầu argan Morocco nguyên chất. Sản phẩm giúp phục hồi
        và nuôi dưỡng tóc hiệu quả.
      </p>
      <a class="brand-link" href="brand_moroccanoil.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="usa">
      <div class="brand-logo">
        <img alt="Logo OGX" src="images/brands/ogx.png">
      </div>
      <div class="brand-logo-text">OGX</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
      <p class="brand-description">
        Thương hiệu Mỹ với các dòng sản phẩm đa dạng từ thiên nhiên. Không chứa sulfate,
        an toàn cho mọi loại tóc.
      </p>
      <a class="brand-link" href="brand_ogx.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="usa">
      <div class="brand-logo">
        <img alt="Logo Head &amp; Shoulders" src="images/brands/head-shoulders.svg">
      </div>
      <div class="brand-logo-text">Head &amp; Shoulders</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
      <p class="brand-description">
        Thương hiệu số 1 thế giới về dầu gội trị gàu. Công thức được kiểm chứng lâm sàng,
        giúp loại bỏ gàu hiệu quả.
      </p>
      <a class="brand-link" href="brand_head_shoulders.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="korea">
      <div class="brand-logo">
        <img alt="Logo Mise En Scène" src="images/brands/mise-en-scene.png">
      </div>
      <div class="brand-logo-text">Mise En Scène</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Hàn Quốc</div>
      <p class="brand-description">
        Thương hiệu K-Beauty nổi tiếng với dầu dưỡng tóc Perfect Serum. Công thức Hàn Quốc
        giúp tóc mềm mượt, óng ả.
      </p>
      <a class="brand-link" href="brand_mise_en_scene.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="korea">
      <div class="brand-logo">
        <img alt="Logo Innisfree" src="images/brands/innisfree.svg">
      </div>
      <div class="brand-logo-text">Innisfree</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Hàn Quốc</div>
      <p class="brand-description">
        Thương hiệu thiên nhiên từ đảo Jeju. Sản phẩm chăm sóc tóc với thành phần organic,
        không hóa chất độc hại.
      </p>
      <a class="brand-link" href="brand_innisfree.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="japan">
      <div class="brand-logo">
        <img alt="Logo Kaminomoto" src="images/brands/kaminomoto.png">
      </div>
      <div class="brand-logo-text">Kaminomoto</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Nhật Bản</div>
      <p class="brand-description">
        Thương hiệu Nhật Bản chuyên về sản phẩm kích thích mọc tóc. Công nghệ tiên tiến
        giúp ngăn rụng tóc hiệu quả.
      </p>
      <a class="brand-link" href="brand_kaminomoto.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="usa">
      <div class="brand-logo">
        <img alt="Logo TRESemmé" src="images/brands/tresemme.svg">
      </div>
      <div class="brand-logo-text">TRESemmé</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
      <p class="brand-description">
        Chất lượng salon chuyên nghiệp với giá cả phải chăng. Sản phẩm được các nhà tạo
        mẫu tóc chuyên nghiệp tin dùng.
      </p>
      <a class="brand-link" href="brand_tresemme.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="usa">
      <div class="brand-logo">
        <img alt="Logo Nizoral" src="images/brands/nizoral.svg">
      </div>
      <div class="brand-logo-text">Nizoral</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Mỹ</div>
      <p class="brand-description">
        Dầu gội trị gàu và nấm da đầu chuyên sâu. Thành phần Ketoconazole giúp điều trị
        hiệu quả các vấn đề da đầu.
      </p>
      <a class="brand-link" href="brand_nizoral.html">Xem Sản Phẩm</a>
    </div>

    <div class="brand-item" data-origin="france">
      <div class="brand-logo">
        <img alt="Logo L'Oréal Paris" src="images/brands/loreal-paris.svg">
      </div>
      <div class="brand-logo-text">L'Oréal Paris</div>
      <div class="brand-origin"><i class="fas fa-map-marker-alt"></i> Pháp</div>
      <p class="brand-description">
        Dòng sản phẩm chăm sóc tóc đại chúng từ tập đoàn L'Oréal. Chất lượng tốt với
        mức giá phù hợp cho mọi người.
      </p>
      <a class="brand-link" href="brand_loreal_paris.html">Xem Sản Phẩm</a>
    </div>
  </div>
</main>


