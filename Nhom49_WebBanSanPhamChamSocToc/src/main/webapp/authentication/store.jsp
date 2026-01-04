<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 29/12/2025
  Time: 11:47 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>HairGlow | Sản phẩm chăm sóc tóc</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style_for_store.css">
  <script src="<%= request.getContextPath() %>/static/js/store.js"></script>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</head>
<body>
<section class="banner-section">
  <div class="banner-container">
    <div class="slider" id="banner-slider">
      <div class="banner-slides">
        <div class="item">
          <img class="banner-image"
               src="${pageContext.request.contextPath}static/assets/images/banner1.png" alt="">
        </div>
        <div class="item">
          <img class="banner-image"
               src="${pageContext.request.contextPath}static/assets/images/banner1.png" alt="">
        </div>
        <div class="item">
          <img class="banner-image"
               src="${pageContext.request.contextPath}static/assets/images/banner1.png" alt="">
        </div>
      </div>

      <button class="nav prev">&lsaquo;</button>
      <button class="nav next">&rsaquo;</button>
      <div class="slider-dots"></div>
    </div>
  </div>
</section>

<!-- ================= MAIN ================= -->
<main>
  <div class="main-container">

    <!-- FILTER -->
    <div class="left-col filter">
      <aside class="filter-sidebar">

        <h3>Bộ lọc tìm kiếm</h3>

        <form method="get"
              action="${pageContext.request.contextPath}/store">

          <!-- Khoảng giá -->
          <div class="filter-block">
            <h4>Khoảng giá</h4>
            <label><input type="checkbox" name="price" value="1"> 0 – 100.000₫</label>
            <label><input type="checkbox" name="price" value="2"> 100 – 200.000₫</label>
            <label><input type="checkbox" name="price" value="3"> 200 – 300.000₫</label>
            <label><input type="checkbox" name="price" value="4"> 300 – 400.000₫</label>
            <label><input type="checkbox" name="price" value="5"> Trên 400.000₫</label>
          </div>

          <!-- Danh mục -->
          <div class="filter-block">
            <h4>Danh mục</h4>
            <label><input type="checkbox" name="category" value="Dầu gội"> Dầu gội</label>
            <label><input type="checkbox" name="category" value="Dầu xả"> Dầu xả</label>
            <label><input type="checkbox" name="category" value="Serum"> Serum</label>
            <label><input type="checkbox" name="category" value="Dụng cụ tóc"> Dụng cụ tóc</label>
          </div>

        </form>
      </aside>
    </div>

    <!-- PRODUCT LIST -->
    <div class="right-col main-content">

      <!-- Toolbar -->
      <div class="product-toolbar">
        <select name="sort">
          <option value="default">Thứ tự mặc định</option>
          <option value="price-asc">Giá thấp đến cao</option>
          <option value="price-desc">Giá cao đến thấp</option>
          <option value="new">Mới nhất</option>
        </select>
      </div>

      <!-- Grid -->
      <div class="product-grid">

        <!-- SAU NÀY DÙNG JSTL -->
        <c:forEach var="p" items="${products}">
          <div class="product-item">
            <img src="${pageContext.request.contextPath}/${p.image}"
                 alt="${p.name}">
            <h3>${p.name}</h3>
            <p>${p.brand} • ${p.origin}</p>

            <div class="product-price">
              <span class="price-current">${p.price}₫</span>
              <c:if test="${p.oldPrice != null}">
                <span class="price-old">${p.oldPrice}₫</span>
              </c:if>
            </div>

            <div class="product-actions">
              <a href="${pageContext.request.contextPath}/product?id=${p.id}"
                 class="btn">Xem thêm</a>
              <a href="${pageContext.request.contextPath}/cart/add?id=${p.id}"
                 class="btn primary">Thêm vào giỏ</a>
            </div>
          </div>
        </c:forEach>

      </div>
    </div>

  </div>
</main>


</body>
</html>

