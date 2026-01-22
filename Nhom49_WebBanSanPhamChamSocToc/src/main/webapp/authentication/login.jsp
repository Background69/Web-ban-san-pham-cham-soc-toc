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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        main {
            background: #7ca454;
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            width: 100%;
            max-width: 350px;
            padding: 20px;
        }
        
        .login-box {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            padding: 40px 30px;
            text-align: center;
        }
        
        .logo {
            height: 130px;
            width: 120px;
            margin: 0 auto 5px;
            display: block;
        }
        
        .login-box h1 {
            font-size: 24px;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        
        .subtitle {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #333;
            font-weight: bold;
            font-size: 14px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            height: 42px;
            font-family: 'Times New Roman', Times, serif;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #00d90b;
        }
        
        .password-field {
            position: relative;
        }
        
        .password-field input {
            padding-right: 40px;
        }
        
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #777;
            font-size: 18px;
        }
        
        .toggle-password:hover {
            color: #000;
        }
        
        .options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            margin-bottom: 20px;
        }
        
        .options a {
            color: #1f3d2a;
            text-decoration: none;
            margin-left: auto;
        }
        
        .btn-login {
            width: 100%;
            padding: 12px;
            background-color: #1f3d2a;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            margin-bottom: 15px;
            font-size: 15px;
            font-family: 'Times New Roman', Times, serif;
        }
        
        .btn-login:hover {
            background-color: #2c5940;
        }
        
        .or-divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
            color: #888;
            font-size: 14px;
        }
        
        .or-divider::before,
        .or-divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background: #ddd;
        }
        
        .or-divider span {
            padding: 0 12px;
            font-weight: 600;
            color: #777;
        }
        
        .social-login {
            margin-top: 15px;
        }
        
        .google-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px;
            border-radius: 6px;
            background: #f2f2f2;
            border: 1px solid #ddd;
            text-decoration: none;
            font-weight: 600;
            color: #333;
            width: 100%;
            cursor: pointer;
        }
        
        .google-btn:hover {
            background: #e8e8e8;
        }
        
        .google-btn img {
            width: 20px;
        }
        
        .signup-text {
            font-size: 14px;
            color: #666;
            margin-top: 15px;
        }
        
        .signup-text a {
            color: #4b7af3;
            text-decoration: none;
            font-weight: 600;
        }
        
        .signup-text a:hover {
            text-decoration: underline;
        }
        
        .error-msg {
            background: #fee;
            color: #c33;
            padding: 12px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
            font-size: 14px;
        }
    </style>
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
                        <svg width="18" height="18" viewBox="0 0 24 24">
                            <text x="0" y="0" font-size="20" font-weight="bold" fill="#4285F4">G</text>
                        </svg>
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
