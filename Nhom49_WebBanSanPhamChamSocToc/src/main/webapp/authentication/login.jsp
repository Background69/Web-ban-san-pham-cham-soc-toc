<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - HairGlow</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/login.css">
</head>
<body>

<!-- Header -->
<%@ include file="/layout/header.jsp" %>

<main>
    <div class="login-container">
        <div class="login-box">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo" alt="HairGlow Logo">
            
            <h1>Đăng nhập</h1>
            <p class="subtitle">Tiếp tục để mua sắm</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/login" method="post">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="password-field">
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                        <i class="fas fa-eye toggle-password" data-target="password"></i>
                    </div>
                </div>

                <div class="options">
                    <a href="${pageContext.request.contextPath}/authentication/forgot_password.jsp">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-login">Đăng nhập</button>

                <div class="or-divider"><span>Hoặc</span></div>

                <div class="social-login">
                    <a class="google-btn" href="${pageContext.request.contextPath}/auth/google">
                        <img src="${pageContext.request.contextPath}/static/assets/icons/Google.png" alt="Google">
                        <span>Google</span>
                    </a>
                </div>

            </form>

            <p class="signup-text">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/authentication/register.jsp">Đăng ký ngay</a>
            </p>
        </div>
    </div>
</main>

<!-- Footer -->
<%@ include file="/layout/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle password visibility
    document.querySelectorAll('.toggle-password').forEach(icon => {
        icon.addEventListener('click', function () {
            const targetId = this.getAttribute('data-target');
            const input = document.getElementById(targetId);
            if (input.type === 'password') {
                input.type = 'text';
                this.classList.remove('fa-eye');
                this.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                this.classList.remove('fa-eye-slash');
                this.classList.add('fa-eye');
            }
        });
    });
</script>

</body>
</html>
