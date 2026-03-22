<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/authentication/otp-verification.css">
<script src="${pageContext.request.contextPath}/static/js/authentication/otp-verification.js"></script>

<div class="otp-box">
    <h3>Nhập mã OTP</h3>

    <form action="${pageContext.request.contextPath}/auth/verify-otp" method="post" onsubmit="combineOtp()">
        <div class="otp-inputs">
            <input type="text" id="otp1" maxlength="1">
            <input type="text" id="otp2" maxlength="1">
            <input type="text" id="otp3" maxlength="1">
            <input type="text" id="otp4" maxlength="1">
            <input type="text" id="otp5" maxlength="1">
            <input type="text" id="otp6" maxlength="1">
        </div>

        <!-- hidden input để gửi OTP -->
        <input type="hidden" name="otp" id="fullOtp">

        <button type="submit">Xác nhận</button>
    </form>

    <div id="timer" class="timer"></div>

    <form action="${pageContext.request.contextPath}/auth/resend-otp" method="post">
        <button type="submit">Gửi lại OTP</button>
    </form>

</div>

