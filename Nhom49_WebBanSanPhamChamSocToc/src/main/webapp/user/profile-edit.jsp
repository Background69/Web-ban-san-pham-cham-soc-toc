<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ</title>

    <!-- Bootstrap CSS (BẮT BUỘC) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <!-- CSS của bạn -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user.css?v=1">
</head>
<body>

<jsp:include page="/layout/header.jsp" />

<main class="py-5" style="background:#f5f5f5;">
    <div class="container">
        <div class="row g-4">
            <!-- SIDEBAR -->
            <div class="col-12 col-md-3">
                <div class="p-3 bg-white rounded-3 shadow-sm">
                    <h5 class="mb-3 fw-bold">Tài khoản của tôi</h5>
                    <ul class="list-unstyled mb-0 d-grid gap-2">
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2 bg-success-subtle fw-semibold"
                               href="${pageContext.request.contextPath}/user/profile">
                                Hồ sơ
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
                               href="${pageContext.request.contextPath}/user/address">
                                Địa chỉ
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
                               href="${pageContext.request.contextPath}/user/orders">
                                Đơn hàng
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
                               href="${pageContext.request.contextPath}/user/change-password">
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
                            <h3 class="fw-bold mb-1">Chỉnh sửa hồ sơ</h3>
                            <p class="text-muted mb-0">Cập nhật thông tin cá nhân của bạn</p>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Alert -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/user/profile" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="update">

                        <div class="row g-3">
                            <div class="col-12">
                                <label for="email" class="form-label fw-semibold">Email</label>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="${user.email}" disabled>
                            </div>

                            <div class="col-12 col-md-6">
                                <label for="fullName" class="form-label fw-semibold">Họ tên</label>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                       value="${user.fullName}" required>
                            </div>

                            <div class="col-12 col-md-6">
                                <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                                <input type="text" class="form-control" id="phone" name="phone"
                                       value="${user.phone}" required>
                            </div>

                            <div class="col-12 col-md-6">
                                <label for="gender" class="form-label fw-semibold">Giới tính</label>
                                <select class="form-select" id="gender" name="gender">
                                    <option value="">Chọn giới tính</option>
                                    <option value="Nam" <c:if test="${user.gender == 'Nam'}">selected</c:if>>Nam</option>
                                    <option value="Nữ" <c:if test="${user.gender == 'Nữ'}">selected</c:if>>Nữ</option>
                                    <option value="Khác" <c:if test="${user.gender == 'Khác'}">selected</c:if>>Khác</option>
                                </select>
                            </div>

                            <div class="col-12 col-md-6">
                                <label for="dateOfBirth" class="form-label fw-semibold">Ngày sinh</label>
                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                       value="${user.dateOfBirth}">
                            </div>

                            <div class="col-12">
                                <label for="avatar" class="form-label fw-semibold">Ảnh đại diện</label>
                                <input type="file" class="form-control" id="avatar" name="avatar" accept="image/*">

                                <c:if test="${not empty user.avatar}">
                                    <div class="mt-3 d-flex align-items-center gap-3">
                                        <span class="text-muted">Ảnh hiện tại:</span>
                                        <img src="${user.avatar}" alt="Avatar"
                                             style="width: 70px; height: 70px; object-fit: cover; border-radius: 10px; border: 1px solid #ddd;">
                                    </div>
                                </c:if>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 pt-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-floppy-disk me-1"></i> Lưu thay đổi
                                </button>
                                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary">
                                    Hủy
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp" />

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

</body>
</html>
