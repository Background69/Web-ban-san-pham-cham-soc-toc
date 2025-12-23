<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 22/12/2025
  Time: 2:36 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hỗ trợ khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/support.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
</head>
<body>

<section class="support-banner">
    <div class="overlay"></div>
    <div class="support-content">
        <h2>Xin chào, chúng tôi có thể giúp gì cho bạn?</h2>

        <div class="search-box">
            <input type="text" placeholder="Nhập từ khóa bạn cần hỗ trợ">
            <button><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>

        <div class="banner-contact">
            <p>
                <i class="fa-solid fa-phone"></i>
                <strong>1800 6324</strong> (Miễn phí)
            </p>
        </div>
    </div>
</section>

<section class="support-categories">
    <div class="category">
        <i class="fa-solid fa-user"></i>
        <p>Tài khoản</p>
    </div>
    <div class="category">
        <i class="fa-solid fa-bag-shopping"></i>
        <p>Đặt hàng</p>
    </div>
    <div class="category">
        <i class="fa-solid fa-truck-fast"></i>
        <p>Vận chuyển</p>
    </div>
    <div class="category">
        <i class="fa-solid fa-money-bill-wave"></i>
        <p>Phí vận chuyển</p>
    </div>
    <div class="category">
        <i class="fa-solid fa-rotate-left"></i>
        <p>Trả / Hoàn tiền</p>
    </div>
    <div class="category">
        <i class="fa-solid fa-file-lines"></i>
        <p>Tuyển dụng</p>
    </div>
</section>

<section class="faq">
    <h3>Câu hỏi thường gặp</h3>
    <ul>
        <li>Đăng ký thành viên như thế nào?</li>
        <li>Tại sao tôi không thể đăng nhập vào tài khoản?</li>
        <li>Tôi có thể sử dụng chung tài khoản với người khác không?</li>
        <li>Có cần đặt lịch trước khi đến cửa hàng hay không?</li>
        <li>Đặt dịch vụ như thế nào?</li>
        <li>Dầu gội có tốt cho sức khỏe hay không?</li>
    </ul>
</section>

<section class="support-info">
    <h3>Thông tin hỗ trợ</h3>
    <p>
        Mọi thắc mắc vui lòng liên hệ tổng đài
        <strong>1800 2867</strong>
    </p>
</section>

</body>
</html>

