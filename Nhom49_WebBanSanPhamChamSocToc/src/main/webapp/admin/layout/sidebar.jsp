<%@ page contentType="text/html; charset=UTF-8" %>

<aside class="sidebar">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/static/assets/images/LOGO.png" alt="logo">
    </div>

    <p>HairGlow Admin</p>

    <ul class="menu">
        <!-- Dashboard -->
        <li class="${activeMenu == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                Dashboard
            </a>
        </li>

        <!-- Người dùng -->
        <li class="${activeMenu == 'users' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/users">
                Quản lý người dùng
            </a>
        </li>

        <!-- Danh mục -->
        <li class="${activeMenu == 'categories' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/categories">
                Quản lý danh mục
            </a>
        </li>

        <!-- Thương hiệu -->
        <li class="${activeMenu == 'brands' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/brands">
                Quản lý thương hiệu
            </a>
        </li>

        <!-- Sản phẩm -->
        <li class="${activeMenu == 'products' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/products">
                Quản lý sản phẩm
            </a>
        </li>

        <!-- Đơn hàng -->
        <li class="${activeMenu == 'orders' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/orders">
                Quản lý đơn hàng
            </a>
        </li>

        <!-- Flash Sale -->
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
