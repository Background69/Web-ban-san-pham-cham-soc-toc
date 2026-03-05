<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết người dùng</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">

    <style>
        .form-card {
            background: #fff;
            border-radius: 14px;
            padding: 20px;
            max-width: 720px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, .06)
        }

        .form-row {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 14px
        }

        .form-row label {
            font-weight: 700
        }

        .form-row input,
        .form-row select {
            padding: 10px 12px;
            border: 1px solid #cfcfcf;
            border-radius: 10px
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 14px;
            flex-wrap: wrap
        }

        .btn {
            border: none;
            border-radius: 10px;
            padding: 10px 14px;
            font-weight: 700;
            cursor: pointer
        }

        .btn-primary {
            background: #2e7d32;
            color: #fff
        }

        .btn-soft {
            background: #eeeeee;
            color: #000;
            text-decoration: none
        }

        .btn-danger {
            background: #ffebee;
            color: #b71c1c
        }

        .note {
            font-size: 13px;
            color: #666;
            margin-top: 6px
        }
    </style>
</head>

<body>
<div class="container">

    <jsp:include page="/admin/layout/sidebar.jsp"/>

    <main class="content">
        <div class="header">
            <h1>Chi tiết người dùng</h1>
        </div>

        <c:if test="${user == null}">
            <div class="form-card">
                Không tìm thấy người dùng.
                <div class="actions">
                    <a class="btn btn-soft" href="${pageContext.request.contextPath}/admin/users">← Quay lại</a>
                </div>
            </div>
        </c:if>

        <c:if test="${user != null}">
            <div class="form-card">
                <form action="${pageContext.request.contextPath}/admin/users" method="post">
                    <input type="hidden" name="action" value="update-profile">
                    <input type="hidden" name="id" value="${user.userId}">

                    <p><b>ID:</b> #U${user.userId}</p>

                    <div class="form-row">
                        <label>Tên người dùng</label>
                        <input type="text" name="username" value="${user.username}" required>
                    </div>

                    <div class="form-row">
                        <label>Email</label>
                        <input type="email" name="email" value="${user.email}" required>
                    </div>

                    <div class="form-row">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" value="${user.phone}">
                    </div>

                    <div class="form-row">
                        <label>Vai trò</label>
                        <select name="role">
                            <option value="Khách hàng" ${user.role == 'Khách hàng' ? 'selected' : ''}>Khách hàng
                            </option>
                            <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                        </select>
                        <div class="note">Đổi vai trò sẽ ảnh hưởng quyền truy cập.</div>
                    </div>

                    <div class="actions">
                        <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
                        <a class="btn btn-soft" href="${pageContext.request.contextPath}/admin/users">← Quay lại</a>
                    </div>
                </form>

                <form action="${pageContext.request.contextPath}/admin/users"
                      method="post"
                      onsubmit="return confirm('Khóa/mở khóa người dùng này?')"
                      style="margin-top:12px">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${user.userId}">
                    <button class="btn btn-danger" type="submit">
                        Khóa / Mở khóa người dùng
                    </button>
                </form>
            </div>
        </c:if>

    </main>
</div>
</body>
</html>
