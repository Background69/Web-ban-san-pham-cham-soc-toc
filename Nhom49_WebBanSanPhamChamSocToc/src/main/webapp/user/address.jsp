<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý địa chỉ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/address.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
</head>
<body>

<jsp:include page="/layout/header.jsp" />

<div class="container my-5">
    <div class="row">
        <div class="col-md-3">
            <div class="sidebar">
                <h5>Tài khoản của tôi</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/user/profile">Hồ sơ</a></li>
                    <li><a href="${pageContext.request.contextPath}/user/address" class="active">Địa chỉ</a></li>
                    <li><a href="${pageContext.request.contextPath}/user/orders">Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/user/change-password">Đổi mật khẩu</a></li>
                </ul>
            </div>
        </div>
        <div class="col-md-9">
            <h3>Địa chỉ giao hàng</h3>
            <p>Quản lý các địa chỉ giao hàng của bạn</p>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Danh sách địa chỉ -->
            <div class="address-list">
                <c:forEach var="address" items="${addresses}">
                    <div class="address-item">
                        <div class="address-info">
                            <h5>${address.fullName}</h5>
                            <p>${address.phone}</p>
                            <p>${address.specificAddress}, ${address.wardName}, ${address.districtName}, ${address.provinceName}</p>
                        </div>
                        <div class="address-actions">
                            <a href="${pageContext.request.contextPath}/user/address?action=edit&id=${address.addressId}" class="btn btn-sm btn-primary">Sửa</a>
                            <a href="${pageContext.request.contextPath}/user/address?action=delete&id=${address.addressId}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn chắc chắn muốn xóa địa chỉ này?')">Xóa</a>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <button class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#addressModal">+ Thêm địa chỉ mới</button>
        </div>
    </div>
</div>

<!-- Modal Thêm/Sửa địa chỉ -->
<div class="modal fade" id="addressModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm địa chỉ mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/user/address" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Họ tên</label>
                        <input type="text" class="form-control" name="fullName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-control" name="phone" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tỉnh/Thành phố</label>
                        <select class="form-select" name="province" id="province" required>
                            <option value="">Chọn tỉnh/thành phố</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Quận/Huyện</label>
                        <select class="form-select" name="district" id="district" required>
                            <option value="">Chọn quận/huyện</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phường/Xã</label>
                        <select class="form-select" name="ward" id="ward" required>
                            <option value="">Chọn phường/xã</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Địa chỉ cụ thể</label>
                        <textarea class="form-control" name="specificAddress" required></textarea>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

</body>
</html>
