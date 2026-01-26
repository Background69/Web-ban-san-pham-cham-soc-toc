
<aside class="sidebar">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" alt="logo">
    </div>

    <p>HairGlow Admin</p>

    <ul class="menu">
        <!-- Dashboard -->
        <li class="${activeMenu == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                Dashboard
            </a>
        </li>

        <!-- Người dùng -->
        <li class="${activeMenu == 'users' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/user/list.jsp">
                Quản lý người dùng
            </a>
        </li>

        <!-- Danh mục -->
        <li class="${activeMenu == 'categories' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/category/list.jsp">
                Quản lý danh mục
            </a>
        </li>

        <!-- Thương hiệu -->
        <li class="${activeMenu == 'brands' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/brand/list.jsp">
                Quản lý thương hiệu
            </a>
        </li>

        <!-- Sản phẩm -->
        <li class="${activeMenu == 'products' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/product/list.jsp">
                Quản lý sản phẩm
            </a>
        </li>

        <!-- Đơn hàng -->
        <li class="${activeMenu == 'orders' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/order/list.jsp">
                Quản lý đơn hàng
            </a>
        </li>

        <!-- Flash Sale -->
        <li class="${activeMenu == 'flash-sale' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/promotion/flash-sale.jsp">
                Flash Sale
            </a>
        </li>
    </ul>

    <a class="view-site" href="${pageContext.request.contextPath}/index">
        Quay lại Website
    </a>
</aside>
