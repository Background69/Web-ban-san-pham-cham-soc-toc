<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP - HairGlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/authentication/otp-verification.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/login.css">

</head>
<body class="login-page">

<%@ include file="/layout/header.jsp" %>

<main>
    <div class="login-container">
        <div class="login-box">

            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png"
                     class="logo" alt="HairGlow Logo">
            </div>

            <h2>Xác thực OTP</h2>
            <p>Mã xác thực đã được gửi đến email của bạn</p>

            <div class="otp-box"
                 data-otp-expiry-at="${sessionScope.otpExpiryAt}"
                 data-otp-last-sent-at="${sessionScope.otpLastSentAt}"
                 data-resend-cooldown-seconds="45">

                <c:if test="${not empty error}">
                    <div class="error-msg">${error}</div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="success-msg">${message}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/auth/verify-otp" method="post"
                      onsubmit="return combineOtp(event)">
                    <div class="otp-inputs">
                        <input type="text" id="otp1" maxlength="1" inputmode="numeric" autocomplete="one-time-code">
                        <input type="text" id="otp2" maxlength="1" inputmode="numeric">
                        <input type="text" id="otp3" maxlength="1" inputmode="numeric">
                        <input type="text" id="otp4" maxlength="1" inputmode="numeric">
                        <input type="text" id="otp5" maxlength="1" inputmode="numeric">
                        <input type="text" id="otp6" maxlength="1" inputmode="numeric">
                    </div>
                    <input type="hidden" name="otp" id="fullOtp">
                    <button type="submit" class="btn-primary">Xác nhận</button>
                </form>

                <div id="otpExpiryTimer" class="timer"></div>
                <div id="resendCooldownTimer" class="timer"></div>

                <form action="${pageContext.request.contextPath}/auth/resend-otp" method="post">
                    <button type="submit" id="resendBtn" class="btn-resend">Gửi lại OTP</button>
                </form>

                <p class="spam-hint">
                    <i class="fa-solid fa-circle-info"></i>
                    Nếu chưa thấy mã gửi đến hòm thư chính sau 30 giây,
                    hãy kiểm tra cả hộp thư rác (Spam) hoặc thư quảng cáo.
                </p>

            </div>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>

<script src="${pageContext.request.contextPath}/static/js/authentication/otp-verification.js"></script>
<script>
(function () {
    // Loading spinner cho nút "Gửi lại OTP"
    var resendForm = document.querySelector('form[action$="/auth/resend-otp"]');
    if (!resendForm) return;

    resendForm.addEventListener("submit", function () {
        var btn = document.getElementById("resendBtn");
        if (btn && !btn.disabled) {
            btn.classList.add("btn-loading");
            btn.disabled = true;
        }
    });
})();
</script>
</body>
</html>