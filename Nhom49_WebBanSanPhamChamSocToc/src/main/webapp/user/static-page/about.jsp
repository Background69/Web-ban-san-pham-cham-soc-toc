<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về chúng tôi - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
            position: relative;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .hero-subtitle {
            font-size: 1.3rem;
            opacity: 0.9;
        }

        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 60px;
            margin-top: 40px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        .section {
            padding: 80px 0;
        }

        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c5940;
            text-align: center;
            margin-bottom: 20px;
        }

        .section-subtitle {
            font-size: 1.1rem;
            color: #666;
            text-align: center;
            margin-bottom: 60px;
            max-width: 600px;
            margin: 0 auto 60px;
        }

        .story-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        .story-text {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #555;
        }

        .story-text p {
            margin-bottom: 20px;
        }

        .story-image {
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .story-image img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .story-image:hover img {
            transform: scale(1.05);
        }

        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
        }

        .value-card {
            background: white;
            padding: 40px 30px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .value-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
        }

        .value-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #89af63, #2c5940);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            font-size: 35px;
            color: white;
        }

        .value-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c5940;
            margin-bottom: 15px;
        }

        .value-description {
            color: #666;
            line-height: 1.6;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
        }

        .team-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .team-card:hover {
            transform: translateY(-10px);
        }

        .team-image {
            height: 200px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .team-image i {
            font-size: 80px;
            color: rgba(255, 255, 255, 0.8);
        }

        .team-info {
            padding: 25px;
            text-align: center;
        }

        .team-name {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c5940;
            margin-bottom: 8px;
        }

        .team-position {
            color: #89af63;
            font-weight: 500;
            margin-bottom: 15px;
        }

        .cta-section {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 80px 0;
            text-align: center;
        }

        .cta-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2c5940;
            margin-bottom: 20px;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #89af63, #2c5940);
            border: none;
            padding: 15px 40px;
            border-radius: 30px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(44, 89, 64, 0.3);
            color: white;
        }

        @media (max-width: 768px) {
            .story-content {
                grid-template-columns: 1fr;
            }

            .hero-stats {
                flex-direction: column;
                gap: 30px;
            }

            .hero-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <h1 class="hero-title">Về HairGlow</h1>
        <p class="hero-subtitle">Đồng hành cùng bạn trên hành trình chăm sóc mái tóc khỏe đẹp</p>
        <div class="hero-stats">
            <div class="stat-item">
                <span class="stat-number">5+</span>
                <span class="stat-label">Năm kinh nghiệm</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">10,000+</span>
                <span class="stat-label">Khách hàng tin tưởng</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">500+</span>
                <span class="stat-label">Sản phẩm chính hãng</span>
            </div>
        </div>
    </div>
</section>

<!-- Story Section -->
<section class="section">
    <div class="container">
        <h2 class="section-title">Câu chuyện của chúng tôi</h2>
        <p class="section-subtitle">Từ niềm đam mê đến sứ mệnh mang đến vẻ đẹp cho mái tóc Việt</p>
        <div class="story-content">
            <div class="story-text">
                <p>HairGlow được thành lập với mong muốn mang đến cho người Việt Nam những sản phẩm chăm sóc tóc chất
                    lượng cao, an toàn và hiệu quả.</p>
                <p>Chúng tôi hiểu rằng mái tóc không chỉ là một phần của vẻ ngoài, mà còn là biểu tượng của sự tự tin và
                    phong cách cá nhân. Vì vậy, mỗi sản phẩm tại HairGlow đều được chọn lọc kỹ càng từ các thương hiệu
                    uy tín trên thế giới.</p>
                <p>Với đội ngũ chuyên gia tư vấn giàu kinh nghiệm, chúng tôi cam kết đồng hành cùng bạn trong việc tìm
                    ra giải pháp chăm sóc tóc phù hợp nhất.</p>
            </div>
            <div class="story-image">
                <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?w=600" alt="HairGlow Story">
            </div>
        </div>
    </div>
</section>

<!-- Values Section -->
<section class="section" style="background: #f8f9fa;">
    <div class="container">
        <h2 class="section-title">Giá trị cốt lõi</h2>
        <p class="section-subtitle">Những nguyên tắc định hướng mọi hoạt động của chúng tôi</p>
        <div class="values-grid">
            <div class="value-card">
                <div class="value-icon"><i class="fas fa-certificate"></i></div>
                <h3 class="value-title">Chất lượng</h3>
                <p class="value-description">100% sản phẩm chính hãng, được nhập khẩu trực tiếp từ các thương hiệu uy
                    tín toàn cầu.</p>
            </div>
            <div class="value-card">
                <div class="value-icon"><i class="fas fa-heart"></i></div>
                <h3 class="value-title">Tận tâm</h3>
                <p class="value-description">Đội ngũ tư vấn chuyên nghiệp, luôn sẵn sàng hỗ trợ và giải đáp mọi thắc mắc
                    của khách hàng.</p>
            </div>
            <div class="value-card">
                <div class="value-icon"><i class="fas fa-leaf"></i></div>
                <h3 class="value-title">An toàn</h3>
                <p class="value-description">Ưu tiên các sản phẩm có thành phần tự nhiên, an toàn cho sức khỏe và thân
                    thiện với môi trường.</p>
            </div>
        </div>
    </div>
</section>

<!-- Team Section -->
<section class="section">
    <div class="container">
        <h2 class="section-title">Đội ngũ của chúng tôi</h2>
        <p class="section-subtitle">Những con người tâm huyết đứng sau thành công của HairGlow</p>
        <div class="team-grid">
            <div class="team-card">
                <div class="team-image"><i class="fas fa-user"></i></div>
                <div class="team-info">
                    <h4 class="team-name">Nguyễn Văn Thăng</h4>
                    <p class="team-position">Founder & CEO</p>
                </div>
            </div>
            <div class="team-card">
                <div class="team-image"><i class="fas fa-user"></i></div>
                <div class="team-info">
                    <h4 class="team-name">Lương Văn Thắng</h4>
                    <p class="team-position">Chuyên gia tư vấn và Chăm sóc khách hàng</p>
                </div>
            </div>
            <div class="team-card">
                <div class="team-image"><i class="fas fa-user"></i></div>
                <div class="team-info">
                    <h4 class="team-name">Nguyễn Doãn Thu Phương</h4>
                    <p class="team-position">Quản lý sản phẩm</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <h2 class="cta-title">Bắt đầu hành trình chăm sóc tóc cùng HairGlow</h2>
        <p style="color: #666; margin-bottom: 30px;">Khám phá bộ sưu tập sản phẩm chăm sóc tóc cao cấp của chúng tôi</p>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary-custom">Khám phá ngay</a>
    </div>
</section>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

