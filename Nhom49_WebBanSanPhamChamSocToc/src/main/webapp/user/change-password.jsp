<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/user.css?v=1">
</head>
<body>

<jsp:include page="/layout/header.jsp"/>

<main class="py-5" style="background:#f5f5f5;">
    <div class="container">
        <div class="row g-4">
            <!-- SIDEBAR -->
            <div class="col-12 col-md-3">
                <div class="p-3 bg-white rounded-3 shadow-sm">
                    <h5 class="mb-3 fw-bold">Tài khoản của tôi</h5>
                    <ul class="list-unstyled mb-0 d-grid gap-2">
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
                               href="${pageContext.request.contextPath}/profile">
                                Hồ sơ
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
                               href="${pageContext.request.contextPath}/profile/addresses">
                                Địa chỉ
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
                               href="${pageContext.request.contextPath}/orders">
                                Đơn hàng
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2 bg-success-subtle fw-semibold"
                               href="${pageContext.request.contextPath}/profile/change-password">
                                Đổi mật khẩu
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- CONTENT -->
            <div class="col-12 col-md-9">
                <div class="bg-white rounded-3 shadow-sm p-4">
                    <div class="d-flex align-items-start justify-content-between flex-wrap gap-2">
                        <div>
                            <h3 class="fw-bold mb-1">Đổi mật khẩu</h3>
                            <p class="text-muted mb-0">Cập nhật mật khẩu để bảo vệ tài khoản của bạn</p>
                        </div>
                    </div>

                    <hr class="my-4">

                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/profile/change-password" method="post">
                        <div class="row g-3">
                            <div class="col-12">
                                <label for="currentPassword" class="form-label fw-semibold">Mật khẩu hiện tại</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>
                            <div class="col-12">
                                <label for="newPassword" class="form-label fw-semibold">Mật khẩu mới</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            </div>
                            <div class="col-12">
                                <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu mới</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 pt-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-shield-halved me-1"></i> Cập nhật mật khẩu
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

</body>
</html>

