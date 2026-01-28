<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    .sidebar {
        width: 240px;
        background: #ffffff;
        min-height: 100vh;
        padding: 20px 16px;
        box-sizing: border-box;
        border-right: 1px solid #e0e0e0;
    }

    .sidebar .logo {
        text-align: center;
        margin-bottom: 12px;
    }

    .sidebar .logo img {
        max-width: 120px;
        height: auto;
        object-fit: contain;
    }

    .sidebar p {
        text-align: center;
        font-weight: 700;
        margin-bottom: 20px;
    }

    .menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .menu li {
        margin-bottom: 6px;
    }

    .menu li a {
        display: block;
        padding: 10px 14px;
        border-radius: 8px;
        text-decoration: none;
        color: #333;
        font-weight: 500;
    }

    .menu li.active a,
    .menu li a:hover {
        background: #a3c46c;
        color: #fff;
    }

    .view-site {
        display: block;
        margin-top: 30px;
        text-align: center;
        padding: 10px;
        border-radius: 8px;
        background: #a3c46c;
        color: #fff;
        text-decoration: none;
        font-weight: 600;
    }

    .view-site:hover {
        background: #8fb458;
    }
</style>

<aside class="sidebar">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" alt="HairGlow Logo">
    </div>

    <p>HairGlow Admin</p>

    <ul class="menu">
        <li class="${activeMenu == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a>
        </li>

        <li class="${activeMenu == 'users' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/user/list.jsp">Quản lý người dùng</a>
        </li>

        <li class="${activeMenu == 'categories' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/category/list.jsp">Quản lý danh mục</a>
        </li>

        <li class="${activeMenu == 'brands' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/brand/list.jsp">Quản lý thương hiệu</a>
        </li>

        <li class="${activeMenu == 'products' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/product/list.jsp">Quản lý sản phẩm</a>
        </li>

        <li class="${activeMenu == 'orders' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/order/list.jsp">Quản lý đơn hàng</a>
        </li>

        <!-- ✅ FLASH SALE: ĐI QUA CONTROLLER -->
        <li class="${activeMenu == 'flash-sale' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/flash-sale">
                Flash Sale
            </a>
        </li>
    </ul>

    <a class="view-site" href="${pageContext.request.contextPath}/index">
        Quay lại Website
    </a>
</aside>
