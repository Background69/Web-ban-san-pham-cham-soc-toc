<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - HairGlow</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
</head>
<body>

<%@ include file="/layout/header.jsp" %>

<main class="py-5">
    <div class="container" style="max-width: 520px;">
        <div class="card shadow-sm">
            <div class="card-body p-4">

                <h3 class="mb-2">Đặt lại mật khẩu</h3>
                <p class="text-muted">Nhập mật khẩu mới cho tài khoản của bạn.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/reset-password" method="post">
                    <!-- token từ controller setAttribute("token", token) -->
                    <input type="hidden" name="token" value="${token}" />

                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" name="newPassword" required minlength="6"
                               placeholder="Nhập mật khẩu mới">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" class="form-control" name="confirmPassword" required minlength="6"
                               placeholder="Nhập lại mật khẩu">
                    </div>

                    <button type="submit" class="btn btn-success w-100">
                        Cập nhật mật khẩu
                    </button>
                </form>

                <div class="mt-3 text-center">
                    <a href="${pageContext.request.contextPath}/authentication/login.jsp">Quay lại đăng nhập</a>
                </div>

            </div>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
