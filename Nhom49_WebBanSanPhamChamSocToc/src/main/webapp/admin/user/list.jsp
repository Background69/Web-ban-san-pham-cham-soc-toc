<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
</head>

<body>
<div class="container">

    <!-- Sidebar -->
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
                <option value="">Sắp xếp</option>
                <option value="asc">Từ A-Z</option>
                <option value="desc">Từ Z-A</option>
            </select>
        </div>
        </div>
        <table class="product-table">
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
                <tr>
                    <td>#U${user.userId}</td>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>${user.phone}</td>
                    <td>${user.role}</td>
                    <td>
                       <button type="button" class="action-btn edit"
                               onclick="openUserDetail(${user.userId})">Chi tiết</button>
                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/users"
                              style="display: inline">
                            <input type="hidden" name="action" value="toggle-status">
                            <input type="hidden" name="id" value="${user.userId}">
                            <button type="submit"
                                    class="action-btn ${user.active ? 'lock-btn': 'unlock-btn'}">
                                ${user.active ? 'Khoá' : 'Mở'}
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty users}">
                <tr>
                    <td colspan="6" style="text-align:center">Không có dữ liệu</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </main>
</div>
<div id="userModal" class="modal">
    <div class="modal-content">
        <span class="btn-close" onclick="closeModal()">&times;</span>
        <h2>Chi tiết người dùng</h2>
        <form action="${pageContext.request.contextPath}/admin/users" method="post">
            <input type="hidden" name="action" value="update-profile">
            <input type ="hidden" name="id" id="detailUserId">
            <p><b>ID:</b> <span id="detailId"></span></p>
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
                <label>SĐT</label>
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
            <div class="actions">
                <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>
<script>
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
                document.getElementById("userModal").style.display = "flex";

            });

    }
    function closeModal(){
        document.getElementById("userModal").style.display = "none";
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
