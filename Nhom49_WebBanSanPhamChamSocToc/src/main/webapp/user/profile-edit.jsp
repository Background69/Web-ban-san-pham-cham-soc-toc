<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user.css">
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
                    <li><a href="${pageContext.request.contextPath}/user/profile" class="active">Hồ sơ</a></li>
                    <li><a href="${pageContext.request.contextPath}/user/address">Địa chỉ</a></li>
                    <li><a href="${pageContext.request.contextPath}/user/orders">Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/user/change-password">Đổi mật khẩu</a></li>
                </ul>
            </div>
        </div>
        <div class="col-md-9">
            <h3>Chỉnh sửa hồ sơ</h3>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/profile" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" disabled>
                </div>

                <div class="mb-3">
                    <label for="fullName" class="form-label">Họ tên</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}" required>
                </div>

                <div class="mb-3">
                    <label for="gender" class="form-label">Giới tính</label>
                    <select class="form-select" id="gender" name="gender">
                        <option value="">Chọn giới tính</option>
                        <option value="Nam" <c:if test="${user.gender == 'Nam'}">selected</c:if>>Nam</option>
                        <option value="Nữ" <c:if test="${user.gender == 'Nữ'}">selected</c:if>>Nữ</option>
                        <option value="Khác" <c:if test="${user.gender == 'Khác'}">selected</c:if>>Khác</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="avatar" class="form-label">Ảnh đại diện</label>
                    <input type="file" class="form-control" id="avatar" name="avatar" accept="image/*">
                    <c:if test="${not empty user.avatar}">
                        <p class="mt-2">Ảnh hiện tại: <img src="${user.avatar}" alt="Avatar" style="max-width: 100px;"></p>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="${user.dateOfBirth}">
                </div>

                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

</body>
</html>
