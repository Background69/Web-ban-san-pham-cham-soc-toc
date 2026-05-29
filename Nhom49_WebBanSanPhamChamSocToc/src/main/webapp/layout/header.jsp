<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    /* User Menu Wrapper */
    .user-menu {
        position: relative;
    }

    .user-menu-trigger {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 8px 15px;
        border-radius: 25px;
        background: rgba(214, 198, 198, 0.2);
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .user-menu-trigger:hover {
        background: rgba(172, 155, 155, 0.4);
        transform: translateY(-2px);
    }

    /* User Avatar */
    .user-avatar-wrapper {
        width: 35px;
        height: 35px;
        border-radius: 50%;
        overflow: hidden;
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .user-avatar {
        width: 100%;
        height: 100%;
        display: block;
        object-fit: cover;
        border: 2px solid white;
        border-radius: 50%;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    /* Default Avatar (when no image) */
    .default-avatar {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #667eea, #764ba2);
        border-radius: 50%;
        border: 2px solid white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .default-avatar i {
        color: white;
        font-size: 16px;
        line-height: 1;
    }

    /* User Name */
    .user-name {
        font-size: 14px;
        font-weight: 500;
        color: #1e1c1c;
        max-width: 120px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    /* Dropdown Icon */
    .dropdown-icon {
        font-size: 12px;
        color: #666;
        transition: transform 0.3s ease;
    }

    .user-menu:hover .dropdown-icon {
        transform: rotate(180deg);
    }

    .user-dropdown-menu {
        position: absolute;
        top: calc(100% + 10px);
        right: 0;
        background: white;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        min-width: 260px;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-15px);
        transition: all 0.3s ease;
        z-index: 2000;
        overflow: hidden;
    }

    .user-menu:hover .user-dropdown-menu {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    /* Dropdown Header */
    .dropdown-header {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 15px 20px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
    }

    .dropdown-avatar {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        overflow: hidden;
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .dropdown-avatar img {
        width: 100%;
        height: 100%;
        display: block;
        object-fit: cover;
        border: 2px solid rgba(255, 255, 255, 0.5);
        border-radius: 50%;
    }

    .default-avatar-large {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        border: 2px solid rgba(255, 255, 255, 0.5);
    }

    .default-avatar-large i {
        color: white;
        font-size: 20px;
        line-height: 1;
    }

    .dropdown-user-info {
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }

    .dropdown-username {
        font-size: 15px;
        font-weight: 600;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .dropdown-email {
        font-size: 12px;
        opacity: 0.85;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    /* Dropdown Body */
    .dropdown-body {
        padding: 8px 0;
    }

    .dropdown-item-link {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 20px;
        color: #333;
        font-size: 14px;
        transition: all 0.2s ease;
    }

    .dropdown-item-link:hover {
        background: #f5f5f5;
        padding-left: 25px;
    }

    .dropdown-item-link i {
        font-size: 18px;
        width: 20px;
        text-align: center;
        color: #666;
    }

    .dropdown-item-link span {
        flex: 1;
    }


    .dropdown-divider {
        height: 1px;
        background: #eee;
        margin: 5px 15px;
    }

    .admin-item {
        color: #326e51 !important;
        font-weight: 600;
    }

    .admin-item i {
        color: #326e51 !important;
    }

    .admin-item:hover {
        background: rgba(50, 110, 81, 0.1) !important;
    }

    .admin-star {
        color: #ffc107 !important;
        font-size: 12px !important;
    }

    .logout-item {
        color: #d32f2f !important;
    }

    .logout-item i {
        color: #d32f2f !important;
    }

    .logout-item:hover {
        background: rgba(211, 47, 47, 0.05) !important;
    }


    .cart .cart-count {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #ff5252;
        color: white;
        font-size: 12px;
        font-weight: bold;
        padding: 3px 7px;
        border-radius: 12px;
        min-width: 20px;
        text-align: center;
        animation: pulse 1.5s infinite;
    }

    .search-form {
        position: relative;
        display: flex;
        align-items: center;
        width: 100%;
    }

    /* Style the reset button */
    .reset-button {
        position: absolute;
        right: 45px;
        top: 50%;
        transform: translateY(-50%);
        background: transparent;
        border: none;
        color: #999;
        font-size: 16px;
        cursor: pointer;
        padding: 5px;
        display: none;
        z-index: 2;
    }

    .reset-button:hover {
        color: #f44336;
    }

    .search-form .input:not(:placeholder-shown) ~ .reset-button {
        display: block;
    }
    @keyframes pulse {
        0% {
            box-shadow: 0 0 0 0 rgba(255, 82, 82, 0.4);
        }

        70% {
            box-shadow: 0 0 0 8px rgba(255, 82, 82, 0);
        }

        100% {
            box-shadow: 0 0 0 0 rgba(255, 82, 82, 0);
        }
    }


    @media (max-width: 768px) {

        .user-name {
            display: none;
        }

        .user-menu-trigger {
            padding: 8px 12px;
        }

        .user-dropdown-menu {
            min-width: 240px;
            right: -10px;
        }

        .dropdown-item-link {
            font-size: 14px;
        }

        .dropdown-header {
            padding: 12px 15px;
        }

        .dropdown-avatar {
            width: 40px;
            height: 40px;
        }

        .dropdown-username {
            font-size: 14px;
        }

        .dropdown-email {
            font-size: 11px;
        }

        /* Cart text hidden on mobile */
        .cart-text {
            display: none;
        }

        .cart {
            padding: 10px 14px;
        }

        .login-text {
            display: none;
        }

        .account {
            padding: 10px 14px;
        }
    }

    @media (max-width: 576px) {
        .right-header {
            gap: 10px;
        }

        .user-avatar-wrapper {
            width: 32px;
            height: 32px;
        }

        .default-avatar i {
            font-size: 14px;
        }
    }
</style>
<header>
    <div class="header-container">
        <div class="header-row header-top">

            <div class="left-header">
                <div class="header-logo">
                    <a class="logo" href="${pageContext.request.contextPath}/">
                        <img alt="logo" class="logo-image"
                             src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
                    </a>
                </div>
            </div>

            <div class="center-header">
                <div class="search-bar">
                    <form action="${pageContext.request.contextPath}/search" class="search-form"
                          method="get">
                        <input class="input" id="search" name="q" placeholder="Bạn muốn tìm sản phẩm nào"
                               type="text">
                        <button aria-label="Xóa từ khóa tìm kiếm" class="reset-button" type="reset">
                            <i class="fas fa-times"></i>
                        </button>
                        <button aria-label="Tìm kiếm sản phẩm" class="search-button" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
            </div>

            <div class="right-header">
                <c:choose>
                    <%-- TRẠNG THÁI: CHƯA ĐĂNG NHẬP --%>
                    <c:when test="${empty sessionScope.currentUser}">
                        <%-- Build redirect URL from current page (URI - contextPath + queryString) --%>
                        <c:set var="_headerRedirectPath" value="${requestScope['jakarta.servlet.forward.request_uri'] != null
                            ? requestScope['jakarta.servlet.forward.request_uri']
                            : pageContext.request.requestURI}"/>
                        <c:set var="_headerRedirectPath"
                               value="${fn:substringAfter(_headerRedirectPath, pageContext.request.contextPath)}"/>
                        <c:set var="_headerQueryString" value="${requestScope['jakarta.servlet.forward.query_string'] != null
                            ? requestScope['jakarta.servlet.forward.query_string']
                            : pageContext.request.queryString}"/>
                        <c:if test="${not empty _headerQueryString}">
                            <c:set var="_headerRedirectPath"
                                   value="${_headerRedirectPath}?${_headerQueryString}"/>
                        </c:if>
                        <c:url var="_headerLoginUrl" value="/auth/login">
                            <c:if
                                    test="${not empty _headerRedirectPath && _headerRedirectPath != '/' && !fn:startsWith(_headerRedirectPath, '/auth/')}">
                                <c:param name="redirect" value="${_headerRedirectPath}"/>
                            </c:if>
                        </c:url>
                        <div class="account">
                            <a href="${_headerLoginUrl}">
                                <i class="fas fa-user"></i>
                                <span class="login-text">Đăng nhập</span>
                            </a>
                        </div>
                    </c:when>

                    <%-- TRẠNG THÁI: ĐÃ ĐĂNG NHẬP --%>
                    <c:otherwise>
                        <%-- Giỏ hàng --%>
                        <c:set var="avatarValue" value="${sessionScope.currentUser.avatar}"/>
                        <c:set var="hasCustomAvatar"
                               value="${not empty avatarValue && avatarValue != 'avatar/avatar.jpg'}"/>
                        <c:set var="resolvedAvatarSrc" value=""/>
                        <c:if test="${hasCustomAvatar}">
                            <c:choose>
                                <c:when test="${avatarValue.startsWith('http')}">
                                    <c:set var="resolvedAvatarSrc" value="${avatarValue}"/>
                                </c:when>
                                <c:when test="${avatarValue.startsWith('/static/')}">
                                    <c:set var="resolvedAvatarSrc"
                                           value="${pageContext.request.contextPath}${avatarValue}"/>
                                </c:when>
                                <c:when test="${avatarValue.startsWith('static/')}">
                                    <c:set var="resolvedAvatarSrc"
                                           value="${pageContext.request.contextPath}/${avatarValue}"/>
                                </c:when>
                                <c:when test="${avatarValue.startsWith('/')}">
                                    <c:set var="resolvedAvatarSrc"
                                           value="${pageContext.request.contextPath}${avatarValue}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="resolvedAvatarSrc"
                                           value="${pageContext.request.contextPath}/static/${avatarValue}"/>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <div class="cart position-relative">
                            <a href="${pageContext.request.contextPath}/cart">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-text">Giỏ hàng</span>
                                <span class="cart-count badge" id="header-cart-count"
                                      style="${sessionScope.cartCount == null || sessionScope.cartCount == 0 ? 'display:none;' : ''}">
                                                            <c:choose>
                                                                <c:when test="${sessionScope.cartCount > 99}">99+
                                                                </c:when>
                                                                <c:otherwise>${sessionScope.cartCount}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                            </a>
                        </div>

                        <%-- User Menu Dropdown --%>
                        <div class="user-menu">
                            <div class="user-menu-trigger">
                                    <%-- Avatar --%>
                                <div class="user-avatar-wrapper">
                                    <c:choose>
                                        <c:when test="${hasCustomAvatar}">
                                            <img src="${resolvedAvatarSrc}" alt="Avatar"
                                                 class="user-avatar"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                            <div class="default-avatar"
                                                 style="display: none;">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="default-avatar">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span
                                        class="user-name">${sessionScope.currentUser.username}</span>
                                <i class="fas fa-chevron-down dropdown-icon"></i>
                            </div>

                                <%-- Dropdown Menu --%>
                            <div class="user-dropdown-menu">
                                    <%-- Header với thông tin user --%>
                                <div class="dropdown-header">
                                    <div class="dropdown-avatar">
                                        <c:choose>
                                            <c:when test="${hasCustomAvatar}">
                                                <img src="${resolvedAvatarSrc}"
                                                     alt="Avatar"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                <div class="default-avatar-large" style="display: none;">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="default-avatar-large">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="dropdown-user-info">
                                                                            <span
                                                                                    class="dropdown-username">${sessionScope.currentUser.username}</span>
                                        <span
                                                class="dropdown-email">${sessionScope.currentUser.email}</span>
                                    </div>
                                </div>

                                    <%-- Menu Items --%>
                                <div class="dropdown-body">
                                    <a href="${pageContext.request.contextPath}/profile"
                                       class="dropdown-item-link">
                                        <i class="fas fa-user-circle"></i>
                                        <span>Hồ sơ cá nhân</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/profile/orders"
                                       class="dropdown-item-link">
                                        <i class="fas fa-box"></i>
                                        <span>Đơn hàng của tôi</span>
                                    </a>

                                        <%-- Admin Link - chỉ hiển thị nếu là Admin --%>
                                    <c:if
                                            test="${sessionScope.currentUser.role == 'Admin'}">
                                        <div class="dropdown-divider"></div>
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                                           class="dropdown-item-link admin-item">
                                            <i class="fas fa-shield-alt"></i>
                                            <span>Trang quản trị</span>
                                            <i
                                                    class="fas fa-star admin-star"></i>
                                        </a>
                                    </c:if>

                                    <div class="dropdown-divider"></div>
                                    <a href="${pageContext.request.contextPath}/auth/logout"
                                       class="dropdown-item-link logout-item">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Đăng xuất</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>

    <div class="header-row header-below nav-container">
        <nav>
            <div>
                <ul class="side-bar-menu-list side-bar-items">
                    <li class="nav-item">
                        <a class="nav-link home-page" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-home me-1"></i> Trang Chủ
                        </a>
                    </li>
                    <li class="nav-item has-dropdown">
                        <a class="nav-link product" href="${pageContext.request.contextPath}/store">
                            <i class="fas fa-box-open me-1"></i> Sản Phẩm
                            <i class="fa fa-caret-down ms-1"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=shampoo"><i
                                    class="fas fa-tint text-primary me-2"></i>Dầu gội</a></li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=conditioner"><i
                                    class="fas fa-pump-soap text-info me-2"></i>Dầu xả</a></li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=mask-hair"><i
                                    class="fas fa-jar text-warning me-2"></i>Kem ủ – Mặt nạ tóc</a></li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=serum"><i
                                    class="fas fa-flask text-danger me-2"></i>Serum – Dầu dưỡng tóc</a>
                            </li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=hair-care-products"><i
                                    class="fas fa-spray-can text-success me-2"></i>Xịt dưỡng – Tinh chất
                                dưỡng</a></li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=hair-chemical-product"><i
                                    class="fas fa-magic text-purple me-2"></i>Thuốc uốn – Duỗi –
                                Nhuộm</a>
                            </li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=hair-styling-products"><i
                                    class="fas fa-cut text-secondary me-2"></i>Gôm – Sáp – Gel tạo
                                kiểu</a>
                            </li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=dry-shampoo"><i
                                    class="fas fa-wind text-info me-2"></i>Dầu gội khô</a></li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=hair-serum"><i
                                    class="fas fa-seedling text-success me-2"></i>Tinh chất mọc tóc</a>
                            </li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=hair-loss"><i
                                    class="fas fa-medkit text-danger me-2"></i>Sản phẩm trị gàu / nấm /
                                rụng
                                tóc</a>
                            </li>
                            <li><a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/products?category=hair-tools"><i
                                    class="fas fa-tools text-dark me-2"></i>Dụng cụ tóc</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/brands">
                            <i class="fas fa-award me-1"></i> Thương Hiệu
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/support">
                            <i class="fas fa-headset me-1"></i> Hỗ Trợ Khách Hàng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link special-button" href="${pageContext.request.contextPath}/deals">
                            <i class="fas fa-fire-alt me-1"></i> Siêu Khuyến Mãi
                            <i class="fas fa-percent ms-1"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</header>

<div id="toast-container" style="position:fixed;top:20px;right:20px;z-index:9999;"></div>

<style>
    /* Notification Styles */
    .toast-notification {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 20px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
        margin-bottom: 10px;
        transform: translateX(120%);
        transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        max-width: 320px;
        border-left: 4px solid #4caf50;
    }

    .toast-notification.show {
        transform: translateX(0);
    }

    .toast-notification.error {
        border-left-color: #f44336;
    }

    .toast-notification .toast-icon {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #e8f5e9;
        color: #4caf50;
        flex-shrink: 0;
    }

    .toast-notification.error .toast-icon {
        background: #ffebee;
        color: #f44336;
    }

    .toast-notification .toast-content {
        flex: 1;
    }

    .toast-notification .toast-title {
        font-weight: 600;
        font-size: 14px;
        color: #333;
        margin-bottom: 2px;
    }

    .toast-notification .toast-message {
        font-size: 13px;
        color: #666;
    }

    .toast-notification .toast-close {
        background: none;
        border: none;
        color: #999;
        cursor: pointer;
        padding: 4px;
        font-size: 16px;
    }

    .toast-notification .toast-close:hover {
        color: #333;
    }

    /* Cart badge bounce animation */
    @keyframes cartBounce {

        0%,
        100% {
            transform: scale(1);
        }

        50% {
            transform: scale(1.3);
        }
    }

    .cart-count.bounce {
        animation: cartBounce 0.4s ease;
    }
</style>

<script>
    // ===== CART HELPER FUNCTIONS =====
    var HairGlow = HairGlow || {};

    /**
     * toast notification
     */
    HairGlow.showToast = function (title, message, isError) {
        var container = document.getElementById('toast-container');
        if (!container) return;

        var toast = document.createElement('div');
        toast.className = 'toast-notification' + (isError ? ' error' : '');
        toast.innerHTML =
            '<div class="toast-icon">' +
            '<i class="fas ' + (isError ? 'fa-exclamation-circle' : 'fa-check-circle') + '"></i>' +
            '</div>' +
            '<div class="toast-content">' +
            '<div class="toast-title">' + title + '</div>' +
            '<div class="toast-message">' + message + '</div>' +
            '</div>' +
            '<button class="toast-close" onclick="this.parentElement.remove();">' +
            '<i class="fas fa-times"></i>' +
            '</button>';

        container.appendChild(toast);

        setTimeout(function () {
            toast.classList.add('show');
        }, 10);

        setTimeout(function () {
            toast.classList.remove('show');
            setTimeout(function () {
                toast.remove();
            }, 400);
        }, 3000);
    };

    /**
     * Update cart
     */
    HairGlow.updateCartCount = function (count) {
        var badge = document.getElementById('header-cart-count');
        if (!badge) return;

        if (count > 0) {
            badge.textContent = count > 99 ? '99+' : count;
            badge.style.display = '';
            badge.classList.add('bounce');
            setTimeout(function () {
                badge.classList.remove('bounce');
            }, 400);
        } else {
            badge.style.display = 'none';
        }
    };

    /**
     * Add product to cart via AJAX
     */
    HairGlow.addToCart = function (productId, variantId, quantity, button) {
        quantity = quantity || 1;

        // Show loading state on button
        var originalContent = '';
        if (button) {
            originalContent = button.innerHTML;
            button.disabled = true;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        }

        var bodyData = 'productId=' + productId + '&quantity=' + quantity;
        if (variantId) {
            bodyData += '&variantId=' + variantId;
        }

        fetch('${pageContext.request.contextPath}/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json'
            },
            body: bodyData
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) {
                if (data.success) {
                    HairGlow.updateCartCount(data.cartCount);
                    HairGlow.showToast('Thành công!', 'Đã thêm sản phẩm vào giỏ hàng', false);
                } else {
                    HairGlow.showToast('Lỗi', data.message || 'Không thể thêm vào giỏ hàng', true);
                }
            })
            .catch(function (err) {
                console.error('Add to cart error:', err);
                HairGlow.showToast('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại', true);
            })
            .finally(function () {
                // Restore button state
                if (button) {
                    button.disabled = false;
                    button.innerHTML = originalContent;
                }
            });
    };


    document.addEventListener('DOMContentLoaded', function () {
        // Bind to all .add-to-cart buttons
        document.querySelectorAll('.add-to-cart').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                var productId = this.dataset.productId;
                var variantId = this.dataset.variantId || null;
                var quantity = this.dataset.quantity || 1;

                if (productId) {
                    HairGlow.addToCart(productId, variantId, quantity, this);
                }
            });
        });

        document.querySelectorAll('form.action-buttons').forEach(function (form) {
            form.addEventListener('submit', function (e) {
                var submitBtn = e.submitter;
                if (submitBtn && submitBtn.value === 'add_to_cart') {
                    e.preventDefault();
                    var productId = form.querySelector('input[name="productId"]').value;
                    var quantity = form.querySelector('input[name="quantity"]').value || 1;
                    HairGlow.addToCart(productId, null, quantity, submitBtn);
                }
            });
        });
    });
</script>

<%--Welcome Modal nếu đăng ký thành công --%>

<div id="hg-welcome-overlay" class="hg-welcome-overlay" style="display:none;"
     onclick="HairGlow.closeWelcomeModal()">
    <div class="hg-welcome-modal" onclick="event.stopPropagation()">
        <div class="hg-welcome-check">
            <svg class="hg-welcome-check-svg" viewBox="0 0 80 80">
                <circle class="hg-check-circle" cx="40" cy="40" r="36" fill="none" stroke="#3B5838"
                        stroke-width="3"/>
                <path class="hg-check-mark" d="M24 42 L35 53 L56 28" fill="none" stroke="#3B5838"
                      stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <div class="hg-check-glow"></div>
        </div>

        <h2 class="hg-welcome-title">Chào mừng bạn!</h2>
        <p class="hg-welcome-message">
            Chào mừng bạn đến với mái nhà <strong>HairGlow</strong>!<br>
            Tài khoản của bạn đã được khởi tạo thành công.<br>
            Hãy bắt đầu hành trình nâng niu mái tóc của mình ngay nhé!
        </p>
        <button class="hg-welcome-btn" onclick="HairGlow.closeWelcomeModal()">
            <i class="fas fa-sparkles" style="margin-right:8px;"></i>Khám phá ngay
        </button>
    </div>
</div>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap');

    .hg-welcome-overlay {
        position: fixed;
        inset: 0;
        z-index: 99999;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        opacity: 0;
        transition: opacity 0.4s ease;
    }

    .hg-welcome-overlay.hg-show {
        opacity: 1;
    }

    .hg-welcome-modal {
        position: relative;
        background: linear-gradient(165deg, #fefcf7 0%, #f5f0e8 50%, #eee8da 100%);
        border-radius: 20px;
        padding: 44px 40px 36px;
        max-width: 460px;
        width: 92%;
        text-align: center;
        box-shadow: 0 24px 80px rgba(59, 88, 56, 0.25),
        0 8px 32px rgba(0, 0, 0, 0.12),
        inset 0 1px 0 rgba(255, 255, 255, 0.6);
        border: 1px solid rgba(59, 88, 56, 0.12);
        transform: scale(0.85) translateY(30px);
        transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
    }

    .hg-welcome-overlay.hg-show .hg-welcome-modal {
        transform: scale(1) translateY(0);
    }

    .hg-welcome-check {
        position: relative;
        width: 80px;
        height: 80px;
        margin: 0 auto 20px;
    }

    .hg-welcome-check-svg {
        width: 80px;
        height: 80px;
        position: relative;
        z-index: 2;
    }

    .hg-check-circle {
        stroke-dasharray: 226;
        stroke-dashoffset: 226;
        animation: hg-draw-circle 0.6s 0.3s ease-out forwards;
    }

    .hg-check-mark {
        stroke-dasharray: 60;
        stroke-dashoffset: 60;
        animation: hg-draw-check 0.4s 0.8s ease-out forwards;
    }

    @keyframes hg-draw-circle {
        to {
            stroke-dashoffset: 0;
        }
    }

    @keyframes hg-draw-check {
        to {
            stroke-dashoffset: 0;
        }
    }

    .hg-check-glow {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 100px;
        height: 100px;
        transform: translate(-50%, -50%);
        border-radius: 50%;
        background: radial-gradient(circle, rgba(59, 88, 56, 0.2) 0%, transparent 70%);
        animation: hg-glow-pulse 2s ease-in-out infinite;
        z-index: 1;
    }

    @keyframes hg-glow-pulse {

        0%,
        100% {
            transform: translate(-50%, -50%) scale(1);
            opacity: 0.6;
        }

        50% {
            transform: translate(-50%, -50%) scale(1.35);
            opacity: 1;
        }
    }

    .hg-welcome-title {
        font-family: 'Playfair Display', 'Georgia', serif;
        font-size: 28px;
        font-weight: 700;
        color: #3B5838;
        margin: 0 0 14px;
        letter-spacing: 0.5px;
    }

    .hg-welcome-message {
        font-family: 'Roboto', sans-serif;
        font-size: 15px;
        line-height: 1.7;
        color: #555;
        margin: 0 0 28px;
    }

    .hg-welcome-message strong {
        color: #3B5838;
        font-weight: 700;
    }

    .hg-welcome-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 13px 36px;
        border: none;
        border-radius: 50px;
        background: linear-gradient(135deg, #3B5838 0%, #4e7a4a 50%, #5a8f55 100%);
        color: #fff;
        font-family: 'Roboto', sans-serif;
        font-size: 15px;
        font-weight: 600;
        letter-spacing: 0.3px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 16px rgba(59, 88, 56, 0.35);
        position: relative;
        overflow: hidden;
    }

    .hg-welcome-btn::before {
        content: '';
        position: absolute;
        inset: 0;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.15) 0%, transparent 60%);
        border-radius: inherit;
    }

    .hg-welcome-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 24px rgba(59, 88, 56, 0.45);
        background: linear-gradient(135deg, #4e7a4a 0%, #5a8f55 50%, #6ba366 100%);
    }

    .hg-welcome-btn:active {
        transform: translateY(0);
    }

    @media (max-width: 480px) {
        .hg-welcome-modal {
            padding: 32px 24px 28px;
            max-width: 340px;
        }

        .hg-welcome-title {
            font-size: 24px;
        }

        .hg-welcome-message {
            font-size: 14px;
        }
    }
</style>

<script>
    HairGlow.closeWelcomeModal = function () {
        var overlay = document.getElementById('hg-welcome-overlay');
        if (!overlay) return;
        overlay.classList.remove('hg-show');
        setTimeout(function () {
            overlay.style.display = 'none';
        }, 400);
    };

    (function () {
        var params = new URLSearchParams(window.location.search);
        if (params.get('registerSuccess') !== 'true') return;

        params.delete('registerSuccess');
        var newUrl = window.location.pathname;
        var remaining = params.toString();
        if (remaining) newUrl += '?' + remaining;
        window.history.replaceState({}, '', newUrl);

        var overlay = document.getElementById('hg-welcome-overlay');
        if (!overlay) return;
        overlay.style.display = 'flex';
        void overlay.offsetWidth;
        overlay.classList.add('hg-show');

        setTimeout(function () {
            HairGlow.closeWelcomeModal();
        }, 5000);
    })();
</script>