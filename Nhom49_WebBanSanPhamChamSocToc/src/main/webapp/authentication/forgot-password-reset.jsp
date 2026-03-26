<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu - HairGlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h3 class="mb-3">Đặt lại mật khẩu</h3>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/reset-password" method="post">
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu mới</label>
                            <input type="password" class="form-control" name="newPassword" minlength="6" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Nhập lại mật khẩu mới</label>
                            <input type="password" class="form-control" name="confirmPassword" minlength="6" required>
                        </div>

                        <button class="btn btn-success w-100" type="submit">Cập nhật mật khẩu</button>
                    </form>

                    <div class="mt-3 text-center">
                        <a href="${pageContext.request.contextPath}/auth/forgot-password">Gửi lại OTP</a>
                        <span class="mx-2">|</span>
                        <a href="${pageContext.request.contextPath}/auth/login">Quay về đăng nhập</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
