<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/authentication/otp-verification.css">
<script src="${pageContext.request.contextPath}/static/js/authentication/otp-verification.js"></script>

<div class="otp-box">
    <h3>Nhập mã OTP</h3>

    <form action="${pageContext.request.contextPath}/verify-otp" method="post" onsubmit="combineOtp()">
        <div class="otp-inputs">
            <input type="text" id="otp1" maxlength="1" oninput="moveNext(this,1)" onkeydown="movePrev(event,1)">
            <input type="text" id="otp2" maxlength="1" oninput="moveNext(this,2)" onkeydown="movePrev(event,2)">
            <input type="text" id="otp3" maxlength="1" oninput="moveNext(this,3)" onkeydown="movePrev(event,3)">
            <input type="text" id="otp4" maxlength="1" oninput="moveNext(this,4)" onkeydown="movePrev(event,4)">
            <input type="text" id="otp5" maxlength="1" oninput="moveNext(this,5)" onkeydown="movePrev(event,5)">
            <input type="text" id="otp6" maxlength="1" oninput="moveNext(this,6)" onkeydown="movePrev(event,6)">
        </div>

        <!-- hidden input để gửi OTP -->
        <input type="hidden" name="otp" id="fullOtp">

        <button type="submit">Xác nhận</button>
    </form>

    <div id="timer" class="timer"></div>

    <form action="${pageContext.request.contextPath}/resend-otp" method="post">
        <button type="submit">Gửi lại OTP</button>
    </form>

</div>

