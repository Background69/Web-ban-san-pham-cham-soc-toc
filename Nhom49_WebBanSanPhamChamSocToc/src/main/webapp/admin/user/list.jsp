<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/user-list.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>
<div class="container">
    <aside class="sidebar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
        </div>
        <p>HairGlow Admin</p>

        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/users">Quản lý người
                dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/flash-sale">Quản lý giảm giá</a></li>
        </ul>

        <a class="view-site" href="${pageContext.request.contextPath}/">
            Quay lại Website
        </a>
    </aside>

    <!-- Main -->
    <main class="content">
        <div class="header">
            <h1>Quản lý người dùng</h1>

        <div class="toolbar">
            <input
                type="text"
                id="search-input"
                placeholder="Tìm theo tên, email, số điện thoại..."
                onkeyup="filterUsers()">
            <select id="sortselect" onchange="sortUsers()">
                <option value="" selected disabled hidden>Sắp xếp</option>
                <option value="asc">Từ A-Z</option>
                <option value="desc">Từ Z-A</option>
            </select>
        </div>
        </div>
        <table class="product-table user-table-upgraded" id="userTable">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Email</th>
                <th>SĐT</th>
                <th>Vai trò</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody id="userTableBody">
            <c:forEach var="user" items="${users}">
                <tr data-user-id="${user.userId}" data-user-active="${user.active}">
                    <td class="cell-id">#U${user.userId}</td>
                    <td class="cell-name">${user.username}</td>
                    <td class="cell-email">${user.email}</td>
                    <td class="cell-phone">${user.phone}</td>
                    <td>
                        <span class="role-badge ${user.role == 'Admin' ? 'role-admin' : 'role-customer'}">
                            ${user.role}
                        </span>
                    </td>
                    <td>
                        <span class="status-pill-inline ${user.active ? 'status-active': 'status-lock'}">
                            <span class="status-dot"></span>
                            ${user.active ? 'Hoạt động' : 'Đã khoá'}
                        </span>
                    </td>
                    <td>
                        <div class="quick-actions">
                            <button type="button"
                                    class="icon-btn icon-btn--view"
                                    title="Xem nhanh"
                                    onclick="openUserDetail(${user.userId})">
                                <i class="fas fa-eye"></i>
                            </button>
                            <c:choose>
                                <c:when test="${user.active}">
                                    <button type="button"
                                            class="icon-btn icon-btn--unlock"
                                            title="Khoá tài khoản"
                                            data-action="lock"
                                            data-user-id="${user.userId}"
                                            data-username="${user.username}"
                                            onclick="showToggleModal(this)">
                                        <i class="fas fa-lock-open"></i>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button"
                                            class="icon-btn icon-btn--lock"
                                            title="Mở khoá tài khoản"
                                            data-action="unlock"
                                            data-user-id="${user.userId}"
                                            data-username="${user.username}"
                                            onclick="showToggleModal(this)">
                                        <i class="fas fa-lock"></i>
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <button type="button"
                                    class="icon-btn icon-btn--edit"
                                    title="Chỉnh sửa chi tiết"
                                    onclick="openUserDetail(${user.userId})">
                                <i class="fas fa-pen-to-square"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty users}">
                <tr>
                    <td colspan="7" style="text-align:center; padding: 40px 16px; color: #999;">
                        <i class="fas fa-users-slash" style="font-size: 28px; margin-bottom: 10px; display:block; opacity:.4;"></i>
                        Không có dữ liệu
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </main>
</div>
<div id="userModal" class="modal">
    <div class="modal-content user-modal">

        <span class="btn-close" onclick="closeModal()">&times;</span>

        <h2>Chi tiết người dùng</h2>

        <form action="${pageContext.request.contextPath}/admin/users" method="post">

            <input type="hidden" name="action" value="update-profile">
            <input type="hidden" name="id" id="detailUserId">

            <div class="modal-body">
                <div class="user-preview">

                    <div class="avatar-circle">
                        👤
                    </div>

                    <h3 id="previewName">Tên người dùng</h3>

                    <span id="previewStatus" class="status-pill active">
                        ● Hoạt động
                    </span>

                    <div class="preview-info">
                        <p>
                            <strong>ID:</strong>
                            <span id="detailId"></span>
                        </p>

                        <p>
                            <strong>Email:</strong>
                            <span id="previewEmail"></span>
                        </p>

                        <p>
                            <strong>SĐT:</strong>
                            <span id="previewPhone"></span>
                        </p>
                    </div>

                </div>
                <div class="user-form">

                    <div class="form-row">
                        <label>Tên người dùng</label>
                        <input type="text"
                               name="username"
                               id="detailName"
                               required>
                    </div>

                    <div class="form-row">
                        <label>Email</label>
                        <input type="email"
                               name="email"
                               id="detailEmail"
                               required>
                    </div>

                    <div class="form-row">
                        <label>Số điện thoại</label>
                        <input type="text"
                               name="phone"
                               id="detailPhone"
                               required>
                    </div>

                    <div class="form-row">
                        <label>Vai trò</label>

                        <select name="role" id="detailRole">
                            <option value="Khách hàng">Khách hàng</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>

                </div>

            </div>
            <div class="modal-actions">

                <button class="btn btn-primary" type="submit">
                    Lưu thay đổi
                </button>

                <button type="button"
                        id="toggleStatusBtn"
                        class="btn btn-danger">
                    Khoá tài khoản
                </button>

            </div>
        </form>
    </div>
</div>
<div id="toggleConfirmModal" class="confirm-overlay">
    <div class="confirm-box">
        <div class="confirm-icon-wrapper" id="confirmIconWrapper">
            <i class="fas fa-shield-halved"></i>
        </div>
        <h3 class="confirm-title" id="confirmTitle">Xác nhận hành động</h3>
        <p class="confirm-message" id="confirmMessage">Bạn có chắc chắn muốn thay đổi trạng thái tài khoản này?</p>
        <div class="confirm-actions">
            <button type="button" class="confirm-btn confirm-btn--cancel" id="confirmCancelBtn" onclick="closeToggleModal()">
                <i class="fas fa-xmark"></i> Huỷ bỏ
            </button>
            <button type="button" class="confirm-btn confirm-btn--ok" id="confirmOkBtn" onclick="executeToggle()">
                <i class="fas fa-check"></i> Đồng ý
            </button>
        </div>
    </div>
</div>
<form id="toggleStatusForm" method="post" action="${pageContext.request.contextPath}/admin/users" style="display:none;">
    <input type="hidden" name="action" value="toggle-status">
    <input type="hidden" name="id" id="toggleUserId">
</form>
<script>
    let pendingToggleUserId = null;
    function showToggleModal(btn) {
        const action = btn.getAttribute('data-action');
        const userId = btn.getAttribute('data-user-id');
        const username = btn.getAttribute('data-username') || '';
        pendingToggleUserId = userId;

        const overlay = document.getElementById('toggleConfirmModal');
        const iconWrapper = document.getElementById('confirmIconWrapper');
        const title = document.getElementById('confirmTitle');
        const message = document.getElementById('confirmMessage');
        const okBtn = document.getElementById('confirmOkBtn');

        if (action === 'lock') {
            iconWrapper.className = 'confirm-icon-wrapper confirm-icon--lock';
            iconWrapper.innerHTML = '<i class="fas fa-lock"></i>';
            title.textContent = 'Khoá tài khoản';
            message.innerHTML = 'Bạn có chắc chắn muốn <strong>khoá</strong> tài khoản <strong>"' + username + '"</strong> không?';
            okBtn.className = 'confirm-btn confirm-btn--danger';
            okBtn.innerHTML = '<i class="fas fa-lock"></i> Khoá ngay';
        } else {
            iconWrapper.className = 'confirm-icon-wrapper confirm-icon--unlock';
            iconWrapper.innerHTML = '<i class="fas fa-lock-open"></i>';
            title.textContent = 'Mở khoá tài khoản';
            message.innerHTML = 'Bạn có chắc chắn muốn <strong>mở khoá</strong> tài khoản <strong>"' + username + '"</strong> không?';
            okBtn.className = 'confirm-btn confirm-btn--success';
            okBtn.innerHTML = '<i class="fas fa-lock-open"></i> Mở khoá';
        }

        overlay.classList.add('active');

        setTimeout(function() {
            overlay.querySelector('.confirm-box').classList.add('show');
        }, 10);
    }

    function closeToggleModal() {
        const overlay = document.getElementById('toggleConfirmModal');
        const box = overlay.querySelector('.confirm-box');
        box.classList.remove('show');
        setTimeout(function() {
            overlay.classList.remove('active');
        }, 200);
        pendingToggleUserId = null;
    }

    function executeToggle() {
        if (!pendingToggleUserId) return;
        document.getElementById('toggleUserId').value = pendingToggleUserId;
        document.getElementById('toggleStatusForm').submit();
    }

    document.getElementById('toggleConfirmModal').addEventListener('click', function(e) {
        if (e.target === this) closeToggleModal();
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeToggleModal();
            closeModal();
        }
    });
    function openUserDetail(id){
        fetch(
            "${pageContext.request.contextPath}/admin/users?action=detail&id=" +id
        )
            .then(res => res.json())
            .then(user => {
                document.getElementById("detailUserId").value = user.userId;
                document.getElementById("detailId").innerText = "#U" + user.userId;
                document.getElementById("detailName").value = user.username|| "";
                document.getElementById("detailEmail").value = user.email|| "";
                document.getElementById("detailPhone").value = user.phone || "";
                document.getElementById("detailRole").value = user.role || "";
                document.getElementById("previewName").innerText = user.username || "";
                document.getElementById("previewEmail").innerText = user.email || "";
                document.getElementById("previewPhone").innerText = user.phone || "";
                const status = document.getElementById("previewStatus");
                const toggleBtn = document.getElementById("toggleStatusBtn");
                status.classList.remove("active","lock");
                toggleBtn.classList.remove("btn-danger", "btn-success");
                if(user.isActive){

                    status.innerText = "● Hoạt động";
                    status.classList.add("active");

                    toggleBtn.innerText = "Khoá tài khoản";
                    toggleBtn.classList.remove("btn-success");
                    toggleBtn.classList.add("btn-danger");

                } else {

                    status.innerText = "● Đã khoá";
                    status.classList.add("lock");

                    toggleBtn.innerText = "Mở khoá tài khoản";
                    toggleBtn.classList.remove("btn-danger");
                    toggleBtn.classList.add("btn-success");
                }
                toggleBtn.onclick = function (){
                    const message = user.isActive
                    ? "Bạn có chắc muốn khoá tài khoản này?" : "Bạn có chắc muốn mở khoá tài khoản này?"
                    if (confirm(message)) {
                        let form = document.createElement("form");
                        form.method = "post";
                        form.action = "${pageContext.request.contextPath}/admin/users";

                        let actionInput = document.createElement("input");
                        actionInput.type ="hidden";
                        actionInput.name = "action";
                        actionInput.value = "toggle-status";
                        let idInput = document.createElement("input");
                        idInput.type = "hidden";
                        idInput.name = "id";
                        idInput.value = user.userId;
                        form.appendChild(actionInput);
                        form.appendChild(idInput);
                        document.body.appendChild(form);
                        form.submit();
                    }
                };
                document.getElementById("userModal").style.display = "flex";

            });

    }
    function closeModal(){
        document.getElementById("userModal").style.display = "none";
    }
    window.onclick =function (event){
        let modal = document.getElementById("userModal");
        if (event.target === modal){
            closeModal();
        }
    }
    function filterUsers(){
        let keyword = document.getElementById("search-input")
            .value
            .toLowerCase();
        let rows=document.querySelectorAll("#userTableBody tr");
        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            if (text.includes(keyword)) {
                row.style.display=""
            } else {
                row.style.display="none"
            }
        });
    }
    function sortUsers(){
        let tbody = document.getElementById("userTableBody");
        let rows = Array.from(tbody.querySelectorAll("tr"));
        let sortType = document.getElementById("sortselect").value;
        rows.sort((a, b) => {
            let nameA = a.cells[1].innerText.toLowerCase();
            let nameB = b.cells[1].innerText.toLowerCase();
            if (sortType === "asc"){
                return nameA.localeCompare(nameB)
            }
            if (sortType === "desc"){
                return nameB.localeCompare(nameA)
            }
            return 0;
        });
        rows.forEach(row=> tbody.appendChild(row));
    }
</script>
</body>
</html>