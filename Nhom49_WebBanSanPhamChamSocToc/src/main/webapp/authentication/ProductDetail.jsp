<meta charset="UTF-8">


<!DOCTYPE html>

<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết sản phẩm</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style_for_product_detail.css">
  <script src="<%= request.getContextPath() %>/static/js/ProductDetail.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>
  <%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
</head>
<body>

<main>

  <div class="product-detail-container">

    ```
    <!-- LEFT: IMAGE -->
    <div class="product-detail-left">
      <div class="product-detail-image">
        <img src="${pageContext.request.contextPath}/static/images/product-default.jpg" class="product-image">
      </div>
    </div>

    <!-- RIGHT: INFO -->
    <div class="product-detail-right">

      <h1 class="product-title">
        Sản phẩm #${productId}
      </h1>

      <!-- PRICE (variant mặc định) -->
      <c:forEach var="v" items="${variants}" varStatus="st">
        <c:if test="${v.default}">
          <div class="product-section-price">
            <p class="price-current">${v.salePrice} ₫</p>
            <p class="price-old">${v.originalPrice} ₫</p>
            <p class="discount-percent">-${v.discountPercent}%</p>
          </div>
        </c:if>
      </c:forEach>

      <!-- VARIANTS -->
      <div class="product-section-options">
        <div class="option-group">
          <label>Dung tích:</label>
          <div class="option-buttons">
            <c:forEach var="variant" items="${variants}">
              <button class="option-btn ${variant.default ? 'active' : ''}">
                  ${variant.variantName}
              </button>
            </c:forEach>
          </div>
        </div>

        <div class="option-group">
          <label>Số lượng:</label>
          <input type="number" name="quantity" value="1" min="1" max="99">
        </div>
      </div>

      <!-- BUTTON -->
      <div class="product-section-btn">
        <button class="btn btn-add-cart">
          <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
        </button>
      </div>

    </div>
    ```

  </div>

  <!-- DETAIL & REVIEW -->

  <div class="product-main-detail-page">

    ```
    <div class="main-detail-header">
      <button class="detail-page-btn active">Mô tả</button>
      <button class="detail-page-btn">Đánh giá</button>
    </div>

    <div class="detail-page-content active">
      <h2>Mô tả sản phẩm</h2>
      <p>Thông tin mô tả sản phẩm sẽ được cập nhật từ database.</p>
    </div>

    <div class="detail-page-content">
      <h2>Đánh giá từ khách hàng</h2>

      <c:if test="${empty reviews}">
        <p>Chưa có đánh giá nào.</p>
      </c:if>

      <c:forEach var="review" items="${reviews}">
        <div class="review-item">
          <strong>${review.reviewerName}</strong>
          <span>
                <c:forEach begin="1" end="${review.rating}">★</c:forEach>
            </span>
          <p>${review.content}</p>
        </div>
      </c:forEach>
    </div>
    ```

  </div>

</main>

</body>
</html>
