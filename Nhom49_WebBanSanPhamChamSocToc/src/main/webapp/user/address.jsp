<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý địa chỉ</title>

    <!-- Bootstrap CSS (BẮT BUỘC) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <!-- CSS của bạn -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/address.css?v=1">
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
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2"
                               href="${pageContext.request.contextPath}/user/profile">
                                Hồ sơ
                            </a>
                        </li>
                        <li>
                            <a class="text-decoration-none d-block px-3 py-2 rounded-2 bg-success-subtle fw-semibold"
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
                            <h3 class="fw-bold mb-1">Địa chỉ giao hàng</h3>
                            <p class="text-muted mb-0">Quản lý các địa chỉ giao hàng của bạn</p>
                        </div>

                        <button class="btn btn-primary"
                                data-bs-toggle="modal"
                                data-bs-target="#addressModal">
                            <i class="fa-solid fa-plus me-1"></i> Thêm địa chỉ mới
                        </button>
                    </div>

                    <hr class="my-4">

                    <!-- Alert -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- LIST -->
                    <c:choose>
                        <c:when test="${empty addresses}">
                            <div class="text-center py-5">
                                <i class="fa-regular fa-map fa-2x text-muted mb-3"></i>
                                <p class="mb-0 text-muted">Bạn chưa có địa chỉ nào. Hãy thêm địa chỉ mới.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-grid gap-3">
                                <c:forEach var="address" items="${addresses}">
                                    <div class="border rounded-3 p-3 d-flex justify-content-between align-items-start gap-3">
                                        <div>
                                            <div class="fw-bold mb-1">${address.fullName}</div>
                                            <div class="text-muted mb-1">${address.phone}</div>
                                            <div class="text-muted">
                                                    ${address.specificAddress},
                                                    ${address.wardName},
                                                    ${address.districtName},
                                                    ${address.provinceName}
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2 flex-shrink-0">
                                            <a href="${pageContext.request.contextPath}/user/address?action=edit&id=${address.addressId}"
                                               class="btn btn-sm btn-outline-primary">
                                                Sửa
                                            </a>

                                            <a href="${pageContext.request.contextPath}/user/address?action=delete&id=${address.addressId}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Bạn chắc chắn muốn xóa địa chỉ này?')">
                                                Xóa
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- MODAL -->
<div class="modal fade" id="addressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Thêm địa chỉ mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form action="${pageContext.request.contextPath}/user/address" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Họ tên</label>
                        <input type="text" class="form-control" name="fullName" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Số điện thoại</label>
                        <input type="text" class="form-control" name="phone" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tỉnh/Thành phố</label>
                        <select class="form-select" name="province" id="province" required>
                            <option value="">Chọn tỉnh/thành phố</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Quận/Huyện</label>
                        <select class="form-select" name="district" id="district" required>
                            <option value="">Chọn quận/huyện</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Phường/Xã</label>
                        <select class="form-select" name="ward" id="ward" required>
                            <option value="">Chọn phường/xã</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Địa chỉ cụ thể</label>
                        <textarea class="form-control" name="specificAddress" rows="3" required></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu địa chỉ</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- JS của bạn -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

</body>
</html>
