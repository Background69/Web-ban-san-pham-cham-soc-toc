<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 29/12/2025
  Time: 12:17 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HairGlow || Địa chỉ</title>

  <!-- CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/address.css">
  <script src="<%= request.getContextPath() %>/static/js/address.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
<body>



<div class="cart-process">
  <div class="cart-checkout-process">
    <i class="fa-solid fa-cart-shopping"></i>
  </div>
  <div class="cart-checkout-process active">
    <i class="fa-solid fa-location-dot"></i>
  </div>
  <div class="cart-checkout-process">
    <i class="fa-solid fa-credit-card"></i>
  </div>
</div>

<!-- ===== FORM ĐỊA CHỈ ===== -->
<div class="address-container">
  <div class="address-left">
    <h3>Địa chỉ giao hàng</h3>

    <form class="address-form" method="post" action="address">
      <label>Họ và tên</label>
      <input type="text" name="fullname" required>

      <label>Số điện thoại</label>
      <input type="number" name="phonenumber" required>

      <label>Email</label>
      <input type="email" name="email" required>

      <label>Tỉnh/Thành phố</label>
      <select name="province" required></select>

      <label>Quận/Huyện</label>
      <select name="district" required disabled></select>

      <label>Phường/Xã</label>
      <select name="ward" required disabled></select>

      <label>Địa chỉ cụ thể (Tên đường, khu phố)</label>
      <input type="text" name="specificaddress" required>

      <label>Ghi chú</label>
      <textarea name="note" rows="4"></textarea>

      <div style="display: flex; gap: 5px;">
        <input type="checkbox" name="saveAddress">
        <p>Lưu thông tin địa chỉ cho lần sau</p>
      </div>

      <div class="address-buttons">
        <a href="Cart.jsp" class="btn-back">
          <i class="fa-solid fa-arrow-left"></i> Quay về giỏ hàng
        </a>

        <button type="submit" class="btn-next">
          Tiếp theo <i class="fa-solid fa-arrow-right"></i>
        </button>
      </div>
    </form>
  </div>
</div>





</body>
</html>

