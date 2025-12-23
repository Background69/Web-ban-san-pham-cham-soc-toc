<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 22/12/2025
  Time: 2:40 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết sản phẩm</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style_for_product_detail.css">
  <script src="<%= request.getContextPath() %>/static/js/login.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>
</head>
<body>

<main>

  <div class="product-detail-container">

    <!-- Hình ảnh sản phẩm -->
    <div class="product-detail-left">
      <div class="product-detail-image">
        <img src="images/product-1-1.jpg" alt="Product image" class="product-image">
      </div>

      <div class="thumbnail-images">
        <img src="images/product-1-1.jpg" class="thumbnail active">
        <img src="images/product-1-2.jpg" class="thumbnail">
        <img src="images/product-1-3.png" class="thumbnail">
        <img src="images/product-1-4.jpg" class="thumbnail">
      </div>
    </div>

    <!-- Thông tin sản phẩm -->
    <div class="product-detail-right">

      <h1 class="product-title">
        Serum L'Oreal Sáng Da, Mờ Thâm Mụn & Nám 30ml
      </h1>

      <div class="product-rating-section">
        <span class="stars">★★★★★</span>
        <span>4.8 (423 đánh giá)</span>
      </div>

      <div class="product-section-price">
        <p class="price-current">220.000₫</p>
        <p class="price-old">280.000₫</p>
        <p class="discount-percent">-21%</p>
      </div>

      <div class="product-section-info">
        <p><strong>Thương hiệu:</strong> L'Oréal Professionnel</p>
        <p><strong>Xuất xứ:</strong> Pháp</p>
        <p><strong>Tình trạng:</strong> <span class="in-stock">Còn hàng</span></p>
      </div>

      <!-- Dung tích -->
      <div class="product-section-options">
        <div class="option-group">
          <label>Dung tích:</label>
          <div class="option-buttons">
            <button class="option-btn active">30ml</button>
            <button class="option-btn">50ml</button>
            <button class="option-btn">100ml</button>
          </div>
        </div>

        <div class="option-group">
          <label>Số lượng:</label>
          <input type="number" value="1" min="1" max="99">
        </div>
      </div>

      <!-- Nút -->
      <div class="product-section-btn">
        <button class="btn btn-add-cart">
          <i class="fas fa-shopping-cart"></i>
          Thêm vào giỏ hàng
        </button>

        <a href="cart.jsp" class="btn btn-buy-now">
          Mua ngay
        </a>
      </div>

    </div>
  </div>

  <!-- Chi tiết & đánh giá -->
  <div class="product-main-detail-page">

    <div class="main-detail-header">
      <button class="detail-page-btn active">Mô tả sản phẩm</button>
      <button class="detail-page-btn">Đánh giá</button>
    </div>

    <div class="detail-page-content active">
      <h2>Mô tả sản phẩm</h2>
      <p>
        Serum dưỡng tóc L'Oreal Professionnel giúp phục hồi tóc hư tổn,
        khô xơ, mang lại mái tóc mềm mượt và chắc khỏe.
      </p>
    </div>

    <div class="detail-page-content">
      <h2>Đánh giá từ khách hàng</h2>

      <div class="review-item">
        <strong>Nguyễn Thị Mai</strong> ★★★★★
        <p>Tóc mềm mượt rõ rệt sau khi dùng.</p>
      </div>

      <div class="review-item">
        <strong>Trần Văn Hoàng</strong> ★★★★★
        <p>Sản phẩm chính hãng, rất hài lòng.</p>
      </div>

    </div>
  </div>

</main>

</body>
</html>

