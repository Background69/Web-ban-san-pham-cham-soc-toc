<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>

<aside class="sidebar">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" alt="HairGlow Admin">
    </div>
    <p>HairGlow Admin</p>

    <ul class="menu">
        <li class="${param.activeMenu == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        </li>
        <li class="${param.activeMenu == 'users' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a>
        </li>
        <li class="${param.activeMenu == 'products' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a>
        </li>
        <li class="${param.activeMenu == 'orders' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a>
        </li>
        <li class="${param.activeMenu == 'brands' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/brands">Quản lý thương hiệu</a>
        </li>
        <li class="${param.activeMenu == 'categories' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a>
        </li>
        <li class="${param.activeMenu == 'flash-sale' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/flash-sale">Quản lý giảm giá</a>
        </li>
        <li class="${param.activeMenu == 'flash-sale' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/inventory">Nhập kho</a>
        </li>
        <li class="view-site-item">
            <a href="${pageContext.request.contextPath}/home"> Quay lại Website</a>
        </li>
    </ul>
</aside>
