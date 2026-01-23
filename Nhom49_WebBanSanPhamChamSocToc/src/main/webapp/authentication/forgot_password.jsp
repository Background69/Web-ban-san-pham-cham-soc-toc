<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - HairGlow</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    
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
        
        .logo-container {
            text-align: center;
        }
        
        .login-box h2 {
            font-size: 24px;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        
        .login-box p {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        .login-box form input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            height: 42px;
            font-family: 'Times New Roman', Times, serif;
            margin-bottom: 20px;
        }
        
        .login-box form input[type="email"]:focus {
            outline: none;
            border-color: #00d90b;
        }
        
        .login-box form input[type="email"]::placeholder {
            color: #999;
        }
        
        .btn-primary {
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
        
        .btn-primary:hover {
            background-color: #2c5940;
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
        
        .success-msg {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 12px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #2e7d32;
            font-size: 14px;
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
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo" alt="HairGlow Logo">
            </div>

            <h2>Quên mật khẩu</h2>
            <p>Nhập địa chỉ Email đã liên kết với tài khoản</p>

            <!-- Hiển thị thông báo thành công -->
            <%
                String message = (String) request.getAttribute("message");
                if (message != null) {
            %>
            <div class="success-msg"><%= message %></div>
            <%
                }

                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="error-msg"><%= error %></div>
            <%
                }
            %>

            <!-- Form gửi reset password -->
            <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post">
                <input type="email" name="email" placeholder="Nhập email của bạn" required>
                <button type="submit" class="btn-primary">
                    Gửi link đặt lại mật khẩu
                </button>
            </form>

            <p class="signup-text">
                Còn nhớ mật khẩu? <a href="${pageContext.request.contextPath}/authentication/login.jsp">Đăng nhập ngay!</a>
            </p>
        </div>
    </div>
</main>

<!-- Footer -->
<%@ include file="/layout/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

