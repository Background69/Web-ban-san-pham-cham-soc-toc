<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân</title>

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
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2 bg-success-subtle fw-semibold"
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
                               href="${pageContext.request.contextPath}/profile/orders">
                                Đơn hàng
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
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
                            <h3 class="fw-bold mb-1">Hồ sơ cá nhân</h3>
                            <p class="text-muted mb-0">Quản lý thông tin tài khoản của bạn</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/profile/edit" class="btn btn-primary">
                            <i class="fa-solid fa-pen me-1"></i> Chỉnh sửa
                        </a>
                    </div>

                    <hr class="my-4">

                    <div class="row g-4">
                        <div class="col-12 col-lg-6">
                            <h6 class="text-uppercase text-muted">Thông tin tài khoản</h6>
                            <div class="mt-3">
                                <div class="mb-2"><strong>Email:</strong> ${sessionScope.currentUser.email}</div>
                                <div class="mb-2"><strong>Tên đăng nhập:</strong> ${sessionScope.currentUser.username}</div>
                                <div class="mb-2"><strong>Số điện thoại:</strong> ${sessionScope.currentUser.phone}</div>
                            </div>
                        </div>

                        <div class="col-12 col-lg-6">
                            <h6 class="text-uppercase text-muted">Địa chỉ mặc định</h6>
                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${not empty defaultAddress}">
                                        <div class="mb-2"><strong>${defaultAddress.fullName}</strong></div>
                                        <div class="mb-2">${defaultAddress.phone}</div>
                                        <div class="text-muted">
                                                ${defaultAddress.specificAddress},
                                                ${defaultAddress.wardName},
                                                ${defaultAddress.districtName},
                                                ${defaultAddress.provinceName}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted mb-0">Bạn chưa có địa chỉ giao hàng.</p>
                                        <a href="${pageContext.request.contextPath}/profile/addresses"
                                           class="btn btn-outline-primary btn-sm mt-2">Thêm địa chỉ</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>

