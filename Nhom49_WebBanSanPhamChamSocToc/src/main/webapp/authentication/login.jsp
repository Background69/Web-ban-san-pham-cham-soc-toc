<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - HairGlow</title>

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

            <h1>Đăng nhập</h1>
            <p class="subtitle">Tiếp tục để mua sắm</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>
            <c:if test="${not empty sessionScope.success}">
                <div class="success-msg">${sessionScope.success}</div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <%
                String redirect = request.getParameter("redirect");
                if (redirect == null) redirect = "";
            %>

            <form action="${pageContext.request.contextPath}/auth/login" method="post" autocomplete="on">
                <c:if test="${not empty param.redirect}">
                    <input type="hidden" name="redirect" value="${param.redirect}">
                </c:if>
                <div class="form-group">
                    <label for="email">Email hoặc Username</label>
                    <!-- backend của bạn lấy param "email" -->
                    <input type="text" id="email" name="email"
                           placeholder="Nhập email hoặc username" required autocomplete="username">
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="password-field">
                        <input type="password" id="password" name="password"
                               placeholder="Nhập mật khẩu" required autocomplete="current-password">
                        <i class="fas fa-eye toggle-password" data-target="password"></i>
                    </div>
                </div>

                <div class="options">
                    <a href="${pageContext.request.contextPath}/auth/forgot-password">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-login">Đăng nhập</button>

                <div class="or-divider"><span>Hoặc</span></div>

                <div class="social-login">
                    <a class="google-btn"
                       href="${pageContext.request.contextPath}/auth/google<%=
        redirect.isEmpty() ? "" : "?redirect=" + java.net.URLEncoder.encode(redirect, StandardCharsets.UTF_8)
   %>">
                        <img src="${pageContext.request.contextPath}/static/assets/icons/Google.png" alt="Google">
                        <span>Đăng nhập bằng Google</span>
                    </a>

                </div>
            </form>

            <p class="signup-text">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/auth/register">Đăng ký</a>

            </p>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.toggle-password').forEach(icon => {
        icon.addEventListener('click', function () {
            const input = document.getElementById(this.dataset.target);
            if (!input) return;

            if (input.type === 'password') {
                input.type = 'text';
                this.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                input.type = 'password';
                this.classList.replace('fa-eye-slash', 'fa-eye');
            }
        });
    });
</script>

</body>
</html>
