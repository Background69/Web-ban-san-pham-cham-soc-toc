<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/authentication/otp-verification.css">
</head>
<body>
<div class="otp-box"
     data-otp-expiry-at="${sessionScope.otpExpiryAt}"
     data-otp-last-sent-at="${sessionScope.otpLastSentAt}"
     data-resend-cooldown-seconds="45">

    <h3>Nhập mã OTP</h3>

    <c:if test="${not empty error}">
        <div class="error-msg">${error}</div>
    </c:if>

    <c:if test="${not empty message}">
        <div class="success-msg">${message}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth/verify-otp" method="post" onsubmit="combineOtp()">
        <div class="otp-inputs">
            <input type="text" id="otp1" maxlength="1" inputmode="numeric" autocomplete="one-time-code">
            <input type="text" id="otp2" maxlength="1" inputmode="numeric">
            <input type="text" id="otp3" maxlength="1" inputmode="numeric">
            <input type="text" id="otp4" maxlength="1" inputmode="numeric">
            <input type="text" id="otp5" maxlength="1" inputmode="numeric">
            <input type="text" id="otp6" maxlength="1" inputmode="numeric">
        </div>
        <input type="hidden" name="otp" id="fullOtp">
        <button type="submit">Xác nhận</button>
    </form>

    <div id="otpExpiryTimer" class="timer"></div>
    <div id="resendCooldownTimer" class="timer"></div>

    <form action="${pageContext.request.contextPath}/auth/resend-otp" method="post">
        <button type="submit" id="resendBtn">Gửi lại OTP</button>
    </form>

</div>
<script src="${pageContext.request.contextPath}/static/js/authentication/otp-verification.js"></script>
</body>
