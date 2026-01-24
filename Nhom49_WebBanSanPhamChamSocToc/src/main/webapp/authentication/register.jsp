<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/register.css">
</head>
<body>

<%@ include file="/layout/header.jsp" %>

<main>
    <div class="login-container">
        <div class="login-box">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo" alt="HairGlow Logo">
            </div>

            <h2>Đăng ký</h2>
            <p>Tạo tài khoản mới để tiếp tục</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/register" method="post">

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Nhập email" required
                           value="${email}">
                </div>

                <div class="form-group">
                    <label for="username">Họ tên / Username</label>
                    <input type="text" id="username" name="username" placeholder="Nhập username" required
                           value="${username}">
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" id="phone" name="phone" placeholder="Nhập số điện thoại" required
                           value="${phone}">
                </div>

                <div class="password-wrapper">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    <i class="fas fa-eye toggle-password" data-target="password"></i>
                </div>

                <div class="password-wrapper">
                    <label for="confirm">Xác nhận mật khẩu</label>
                    <input type="password" id="confirm" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                    <i class="fas fa-eye toggle-password" data-target="confirm"></i>
                </div>

                <button type="submit" class="btn-primary">Đăng ký</button>

                <div class="or-divider"><span>Hoặc</span></div>

                <div class="social-login">
                    <a class="google-btn" href="${pageContext.request.contextPath}/auth/google">
                        <img src="${pageContext.request.contextPath}/static/assets/icons/Google.png" alt="Google">
                        <span>Google</span>
                    </a>
                </div>

                <p class="signup-text">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
                </p>
            </form>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
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
