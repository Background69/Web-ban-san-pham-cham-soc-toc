<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xac thuc dang ky - HairGlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/login.css">
</head>
<body class="login-page">

<%@ include file="/layout/header.jsp" %>

<main>
    <div class="login-container">
        <div class="login-box">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png"
                 class="logo" alt="HairGlow Logo">

            <h1>Xac thuc OTP</h1>
            <p class="subtitle">Nhap ma OTP da gui den email cua ban</p>

            <c:if test="${not empty message}">
                <div class="success-msg">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/verify-registration" method="post">
                <input type="hidden" name="action" value="verify">

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required
                           value="${email}" readonly>
                </div>

                <div class="form-group">
                    <label for="otp">Ma OTP</label>
                    <input type="text" id="otp" name="otp" required maxlength="6" pattern="\\d{6}"
                           value="${otp}" placeholder="Nhap ma OTP 6 chu so">
                </div>

                <button type="submit" class="btn-login">Xac thuc tai khoan</button>
            </form>

            <form action="${pageContext.request.contextPath}/auth/verify-registration" method="post" style="margin-top: 12px;">
                <input type="hidden" name="action" value="resend">
                <input type="hidden" name="email" value="${email}">
                <button type="submit" class="btn-login" style="background: #334155;">Gui lai OTP</button>
            </form>

            <p class="signup-text">
                Chua co OTP? <a href="${pageContext.request.contextPath}/auth/register">Dang ky lai</a>
            </p>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>

</body>
</html>
