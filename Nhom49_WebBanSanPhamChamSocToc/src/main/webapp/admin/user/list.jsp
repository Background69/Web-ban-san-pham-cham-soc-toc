<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - HairGlow Admin</title>
    <meta name="description" content="Quản lý tài khoản khách hàng và quản trị viên hệ thống HairGlow">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/user-list.css">
</head>
<body class="admin-users-page">
<div class="container admin-shell">
    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="users"/>
    </jsp:include>

    <main class="content users-content">
        <section class="stats-grid" id="statsGrid" aria-label="Thống kê người dùng">
            <article class="stat-card stat-card--total">
                <div class="stat-icon"><i class="fa-solid fa-users" aria-hidden="true"></i></div>
                <div class="stat-body">
                    <span class="stat-label">Tổng người dùng</span>
                    <strong class="stat-number" id="statTotalUsers">${totalUsers}</strong>
                    <span class="stat-note">${newUsersThisMonth} mới trong tháng</span>
                </div>
            </article>

            <article class="stat-card stat-card--customer">
                <div class="stat-icon"><i class="fa-solid fa-user" aria-hidden="true"></i></div>
                <div class="stat-body">
                    <span class="stat-label">Khách hàng</span>
                    <strong class="stat-number" id="statCustomerUsers">${customerUsers}</strong>
                    <span class="stat-note">Tài khoản mua sắm</span>
                </div>
            </article>

            <article class="stat-card stat-card--admin">
                <div class="stat-icon"><i class="fa-solid fa-user-shield" aria-hidden="true"></i></div>
                <div class="stat-body">
                    <span class="stat-label">Admin</span>
                    <strong class="stat-number" id="statAdminUsers">${adminUsers}</strong>
                    <span class="stat-note">Tài khoản quản trị</span>
                </div>
            </article>

            <article class="stat-card stat-card--locked">
                <div class="stat-icon"><i class="fa-solid fa-user-lock" aria-hidden="true"></i></div>
                <div class="stat-body">
                    <span class="stat-label">Bị khóa</span>
                    <strong class="stat-number" id="statLockedUsers">${lockedUsers}</strong>
                    <span class="stat-note">Cần kiểm tra</span>
                </div>
            </article>
        </section>

        <section class="filter-panel" aria-label="Bộ lọc người dùng">
            <div class="filter-panel__header">
                <div>
                    <h2>Danh sách tài khoản</h2>
                    <p>Tìm nhanh theo tên, email, số điện thoại và lọc theo vai trò hoặc trạng thái.</p>
                </div>
                <button type="button" class="filter-reset-btn" onclick="resetFilters()">
                    <i class="fa-solid fa-rotate-right" aria-hidden="true"></i>
                    Làm mới
                </button>
            </div>

            <div class="filter-grid">
                <label class="field field--search" for="search-input">
                    <span>Tìm kiếm</span>
                    <input type="text"
                           class="search-input"
                           id="search-input"
                           placeholder="Tên, email, số điện thoại..."
                           oninput="filterUsers()">
                </label>

                <label class="field" for="role-filter">
                    <span>Vai trò</span>
                    <select class="filter-select" id="role-filter" onchange="filterUsers()">
                        <option value="">Tất cả vai trò</option>
                        <option value="customer">Khách hàng</option>
                        <option value="admin">Admin</option>
                    </select>
                </label>
                <label class="field" for="status-filter">
                    <span>Trạng thái</span>
                    <select class="filter-select" id="status-filter" onchange="filterUsers()">
                        <option value="">Tất cả trạng thái</option>
                        <option value="active">Hoạt động</option>
                        <option value="locked">Đã khóa</option>
                    </select>
                </label>

                <label class="field" for="sortselect">
                    <span>Sắp xếp</span>
                    <select class="sort-select" id="sortselect" onchange="sortUsers()">
                        <option value="">Mặc định</option>
                        <option value="asc">Tên A - Z</option>
                        <option value="desc">Tên Z - A</option>
                    </select>
                </label>
            </div>
        </section>
        <section class="users-table-card" aria-label="Bảng người dùng">
            <div class="table-scroll">
                <table class="data-grid" id="userTable">
                    <thead>
                    <tr>
                        <th>Tài khoản</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Cập nhật</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>

                    <tbody id="userTableBody">
                    <c:forEach var="user" items="${users}" varStatus="loop">
                        <c:set var="displayName" value="${empty user.fullName ? user.username : user.fullName}" />
                        <c:set var="rawRoleValue" value="${empty user.role ? '' : user.role}" />
                        <c:set var="rawRoleLower" value="${fn:toLowerCase(fn:trim(rawRoleValue))}" />
                        <c:set var="roleValue" value="${rawRoleLower == 'admin' ? 'Admin' : 'Khách hàng'}" />
                        <c:set var="roleFilter" value="${roleValue == 'Admin' ? 'admin' : 'customer'}" />
                        <c:set var="statusFilter" value="${user.active ? 'active' : 'locked'}" />
                        <c:set var="avatarValue" value="${fn:trim(user.avatar)}" />
                        <c:set var="avatarIsProjectDefault" value="${avatarValue == 'avatar/avatar.jpg'}" />
                        <c:set var="hasAvatar" value="${not empty avatarValue && not avatarIsProjectDefault}" />
                        <c:set var="avatarIsAbsolute" value="${fn:startsWith(avatarValue, 'http://') || fn:startsWith(avatarValue, 'https://')}" />
                        <c:set var="avatarStartsSlash" value="${fn:startsWith(avatarValue, '/')}" />
                        <c:set var="avatarStartsAppAsset" value="${fn:startsWith(avatarValue, 'static/') || fn:startsWith(avatarValue, 'uploads/') || fn:startsWith(avatarValue, 'media/')}" />

                        <tr class="user-row"
                            data-user-id="${user.userId}"
                            data-user-active="${user.active}"
                            data-user-role="${roleFilter}"
                            data-user-status="${statusFilter}"
                            data-user-sort="${fn:escapeXml(displayName)}"
                            data-original-index="${loop.index}">
                            <td class="cell-account">
                                <div class="account-cell">
                                    <span class="user-avatar ${hasAvatar ? 'user-avatar--image' : 'user-avatar--fallback'}">
                                        <c:choose>
                                            <c:when test="${hasAvatar}">
                                                <c:choose>
                                                    <c:when test="${avatarIsAbsolute}">
                                                        <img src="${fn:escapeXml(avatarValue)}"
                                                             alt="Ảnh đại diện của ${fn:escapeXml(displayName)}"
                                                             class="user-avatar__img"
                                                             loading="lazy"
                                                             onerror="this.style.display='none'; this.parentElement.classList.remove('user-avatar--image'); this.parentElement.classList.add('user-avatar--fallback');">
                                                    </c:when>
                                                    <c:when test="${avatarStartsSlash}">
                                                        <img src="${pageContext.request.contextPath}${fn:escapeXml(avatarValue)}"
                                                             alt="Ảnh đại diện của ${fn:escapeXml(displayName)}"
                                                             class="user-avatar__img"
                                                             loading="lazy"
                                                             onerror="this.style.display='none'; this.parentElement.classList.remove('user-avatar--image'); this.parentElement.classList.add('user-avatar--fallback');">
                                                    </c:when>
                                                    <c:when test="${avatarStartsAppAsset}">
                                                        <img src="${pageContext.request.contextPath}/${fn:escapeXml(avatarValue)}"
                                                             alt="Ảnh đại diện của ${fn:escapeXml(displayName)}"
                                                             class="user-avatar__img"
                                                             loading="lazy"
                                                             onerror="this.style.display='none'; this.parentElement.classList.remove('user-avatar--image'); this.parentElement.classList.add('user-avatar--fallback');">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/static/${fn:escapeXml(avatarValue)}"
                                                             alt="Ảnh đại diện của ${fn:escapeXml(displayName)}"
                                                             class="user-avatar__img"
                                                             loading="lazy"
                                                             onerror="this.style.display='none'; this.parentElement.classList.remove('user-avatar--image'); this.parentElement.classList.add('user-avatar--fallback');">
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="user-avatar__initial">
                                                    <c:choose>
                                                        <c:when test="${not empty displayName}">
                                                            ${fn:toUpperCase(fn:substring(displayName, 0, 1))}
                                                        </c:when>
                                                        <c:otherwise>U</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="user-avatar__initial">
                                                    <c:choose>
                                                        <c:when test="${not empty displayName}">
                                                            ${fn:toUpperCase(fn:substring(displayName, 0, 1))}
                                                        </c:when>
                                                        <c:otherwise>U</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="account-meta">
                                        <strong><c:out value="${displayName}" /></strong>
                                        <small>
                                            #U${user.userId}
                                            <c:if test="${not empty user.fullName && not empty user.username}">
                                                · <c:out value="${user.username}" />
                                            </c:if>
                                        </small>
                                    </span>
                                </div>
                            </td>
                            <td class="cell-email"><c:out value="${user.email}" /></td>
                            <td class="cell-phone">
                                <c:choose>
                                    <c:when test="${not empty user.phone}">
                                        <c:out value="${user.phone}" />
                                    </c:when>
                                    <c:otherwise>Chưa có</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${roleValue == 'Admin'}">
                                        <span class="role-badge role-admin">
                                            <i class="fa-solid fa-crown" aria-hidden="true"></i>
                                            <c:out value="${roleValue}" />
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="role-badge role-customer">
                                            <i class="fa-solid fa-user" aria-hidden="true"></i>
                                            <c:out value="${roleValue}" />
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="status-badge ${user.active ? 'status-active' : 'status-locked'}">
                                    <span class="status-dot"></span>
                                    ${user.active ? 'Hoạt động' : 'Đã khóa'}
                                </span>
                            </td>
                            <td class="cell-date">
                                <c:choose>
                                    <c:when test="${not empty user.createdAt}">
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                    </c:when>
                                    <c:otherwise>Chưa có</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="cell-date">
                                <c:choose>
                                    <c:when test="${not empty user.updatedAt}">
                                        <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy" />
                                    </c:when>
                                    <c:otherwise>Chưa có</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="quick-actions">
                                    <button type="button"
                                            class="icon-btn icon-btn--view"
                                            data-tooltip="Xem chi tiết"
                                            title="Xem chi tiết"
                                            aria-label="Xem chi tiết người dùng"
                                            onclick="openUserDetail(${user.userId})">
                                        <i class="fa-solid fa-eye" aria-hidden="true"></i>
                                    </button>
                                    <button type="button"
                                            class="icon-btn icon-btn--edit"
                                            data-tooltip="Sửa"
                                            title="Sửa"
                                            aria-label="Sửa người dùng"
                                            onclick="openUserDetailEdit(${user.userId})">
                                        <i class="fa-solid fa-pen-to-square" aria-hidden="true"></i>
                                    </button>
                                    <c:choose>
                                        <c:when test="${user.active}">
                                            <button type="button"
                                                    class="icon-btn icon-btn--lock"
                                                    data-tooltip="Khóa"
                                                    data-action="lock"
                                                    data-user-id="${user.userId}"
                                                    data-username="${fn:escapeXml(displayName)}"
                                                    title="Khóa"
                                                    aria-label="Khóa tài khoản người dùng"
                                                    onclick="showToggleModal(this)">
                                                <i class="fa-solid fa-lock" aria-hidden="true"></i>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button"
                                                    class="icon-btn icon-btn--unlock"
                                                    data-tooltip="Mở khóa"
                                                    data-action="unlock"
                                                    data-user-id="${user.userId}"
                                                    data-username="${fn:escapeXml(displayName)}"
                                                    title="Mở khóa"
                                                    aria-label="Mở khóa tài khoản người dùng"
                                                    onclick="showToggleModal(this)">
                                                <i class="fa-solid fa-lock-open" aria-hidden="true"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="8" class="empty-state">
                                <i class="fa-solid fa-users-slash" aria-hidden="true"></i>
                                <strong>Chưa có người dùng nào trong hệ thống.</strong>
                                <span>Dữ liệu sẽ hiển thị tại đây sau khi có tài khoản mới.</span>
                            </td>
                        </tr>
                    </c:if>

                    <tr id="filterEmptyRow" class="filter-empty-row" style="display: none;">
                        <td colspan="8" class="empty-state">
                            <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                            <strong>Chưa có người dùng nào phù hợp với bộ lọc.</strong>
                            <span>Thử thay đổi từ khóa, vai trò hoặc trạng thái tài khoản.</span>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
<div id="userModal" class="modal">
    <div class="modal-content user-modal user-modal--redesigned" role="dialog" aria-modal="true" aria-labelledby="userModalTitle">
        <button type="button" class="btn-close" onclick="closeModal()" aria-label="Đóng">&times;</button>

        <div class="modal-heading">
            <span class="eyebrow">Hồ sơ tài khoản</span>
            <h2 id="userModalTitle">Chi tiết người dùng</h2>
        </div>
        <div class="metrics-grid" id="metricsGrid">
            <div class="metric-card metric-card--spending">
                <div class="metric-icon"><i class="fa-solid fa-coins" aria-hidden="true"></i></div>
                <div class="metric-body">
                    <span class="metric-label">Tổng chi tiêu</span>
                    <span class="metric-value" id="metricSpending">0 ₫</span>
                    <span class="metric-sub">Giá trị vòng đời khách hàng</span>
                </div>
            </div>
            <div class="metric-card metric-card--orders">
                <div class="metric-icon"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></div>
                <div class="metric-body">
                    <span class="metric-label">Đơn hàng</span>
                    <span class="metric-value" id="metricOrders">0 / 0</span>
                    <span class="metric-sub">Tổng đơn / đơn hủy</span>
                </div>
            </div>
            <div class="metric-card metric-card--activity">
                <div class="metric-icon"><i class="fa-solid fa-clock-rotate-left" aria-hidden="true"></i></div>
                <div class="metric-body">
                    <span class="metric-label">Hoạt động</span>
                    <span class="metric-value metric-value--sm" id="metricJoinDate">Chưa có</span>
                    <span class="metric-sub" id="metricLastUpdate">Cập nhật gần nhất: Chưa có</span>
                </div>
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/admin/users" method="post" id="userEditForm" novalidate>
            <input type="hidden" name="action" value="update-profile">
            <input type="hidden" name="id" id="detailUserId">
            <div class="modal-body">
                <aside class="user-preview">
                    <div class="avatar-circle" id="previewAvatarInitial">U</div>
                    <h3 id="previewName">Tên người dùng</h3>
                    <span id="previewStatus" class="status-pill active">
                        <span class="status-dot"></span>
                        <span id="previewStatusText">Hoạt động</span>
                    </span>
                    <div class="preview-info">
                        <p><strong>ID:</strong> <span id="detailId"></span></p>
                        <p><strong>Email:</strong> <span id="previewEmail"></span></p>
                        <p><strong>Số điện thoại:</strong> <span id="previewPhone"></span></p>
                    </div>
                </aside>
                <section class="user-form" id="userInfoPanel">
                    <div class="info-panel-header">
                        <h4 class="info-panel-title">
                            <i class="fa-solid fa-id-card" aria-hidden="true"></i>
                            Thông tin cá nhân
                        </h4>
                        <button type="button" class="btn-edit-toggle" id="btnEditToggle" onclick="toggleEditMode()">
                            <i class="fa-solid fa-pen" aria-hidden="true"></i>
                            Chỉnh sửa
                        </button>
                    </div>
                    <div class="info-view-mode" id="viewMode">
                        <div class="info-row">
                            <span class="info-label"><i class="fa-solid fa-user" aria-hidden="true"></i> Tên người dùng</span>
                            <span class="info-value" id="viewName">Chưa có</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fa-solid fa-envelope" aria-hidden="true"></i> Email</span>
                            <span class="info-value" id="viewEmail">Chưa có</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fa-solid fa-phone" aria-hidden="true"></i> Số điện thoại</span>
                            <span class="info-value" id="viewPhone">Chưa có</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fa-solid fa-shield-halved" aria-hidden="true"></i> Vai trò</span>
                            <span class="info-value" id="viewRole">Chưa có</span>
                        </div>
                    </div>
                    <div class="info-edit-mode" id="editMode" style="display: none;">
                        <div class="form-section form-section--personal">
                            <h4 class="form-section-title">
                                <i class="fa-solid fa-id-card" aria-hidden="true"></i>
                                Thông tin cá nhân
                            </h4>

                            <div class="form-row">
                                <label class="form-label-hg" for="detailName">Tên người dùng</label>
                                <input type="text" name="username" id="detailName" class="form-input-hg" required>
                                <small class="field-error" id="detailNameError"></small>
                            </div>

                            <div class="form-row">
                                <label class="form-label-hg" for="detailEmail">Email</label>
                                <input type="email" name="email" id="detailEmail" class="form-input-hg" required>
                                <small class="field-error" id="detailEmailError"></small>
                            </div>

                            <div class="form-row">
                                <label class="form-label-hg" for="detailPhone">Số điện thoại</label>
                                <input type="tel"
                                       name="phone"
                                       id="detailPhone"
                                       class="form-input-hg"
                                       inputmode="numeric"
                                       pattern="[0-9]{9,11}"
                                       maxlength="11"
                                       required>
                                <small class="field-error" id="detailPhoneError"></small>
                            </div>
                        </div>

                        <div class="form-section form-section--role">
                            <div class="role-section-header">
                                <h4 class="form-section-title">
                                    <i class="fa-solid fa-shield-halved" aria-hidden="true"></i>
                                    Phân quyền tài khoản
                                </h4>
                                <p>Vai trò quyết định quyền truy cập của tài khoản trong hệ thống.</p>
                            </div>

                            <div class="form-row">
                                <label class="form-label-hg" for="detailRole">Vai trò</label>
                                <select name="role" id="detailRole" class="form-input-hg role-select">
                                    <option value="Khách hàng">Khách hàng</option>
                                    <option value="Admin">Admin</option>
                                </select>
                                <small class="role-help-text" id="roleHelpText">
                                    Khách hàng chỉ có quyền mua hàng, quản lý giỏ hàng, đơn hàng và hồ sơ cá nhân.
                                </small>
                            </div>
                        </div>

                        <div class="edit-actions edit-actions--inline">
                            <button class="btn btn-primary" type="submit" id="saveUserChangesBtn">
                                <i class="fa-solid fa-floppy-disk" aria-hidden="true"></i>
                                Lưu thay đổi
                            </button>
                            <button type="button" class="btn btn-cancel-edit" onclick="cancelEditMode()">
                                <i class="fa-solid fa-xmark" aria-hidden="true"></i>
                                Hủy bỏ
                            </button>
                        </div>
                    </div>
                </section>
            </div>
            <div class="modal-actions">
                <button type="button" id="toggleStatusBtn" class="btn btn-danger">
                    <i class="fa-solid fa-lock" aria-hidden="true"></i>
                    Khóa tài khoản
                </button>
            </div>
        </form>
    </div>
</div>
<div id="toggleConfirmModal" class="confirm-overlay">
    <div class="confirm-box" role="dialog" aria-modal="true" aria-labelledby="confirmTitle">
        <div class="confirm-icon-wrapper" id="confirmIconWrapper">
            <i class="fa-solid fa-shield-halved" aria-hidden="true"></i>
        </div>
        <h3 class="confirm-title" id="confirmTitle">Xác nhận hành động</h3>
        <p class="confirm-message" id="confirmMessage">Bạn có chắc chắn muốn thay đổi trạng thái tài khoản này?</p>
        <div class="confirm-actions">
            <button type="button" class="confirm-btn confirm-btn--cancel" id="confirmCancelBtn" onclick="closeToggleModal()">
                <i class="fa-solid fa-xmark" aria-hidden="true"></i>
                Hủy bỏ
            </button>
            <button type="button" class="confirm-btn confirm-btn--ok" id="confirmOkBtn" onclick="executeToggle()">
                <i class="fa-solid fa-check" aria-hidden="true"></i>
                Đồng ý
            </button>
        </div>
    </div>
</div>
<div id="adminRoleConfirmModal" class="confirm-overlay">
    <div class="confirm-box confirm-box--admin-role" role="dialog" aria-modal="true" aria-labelledby="adminRoleConfirmTitle">
        <div class="confirm-icon-wrapper confirm-icon--admin">
            <i class="fa-solid fa-crown" aria-hidden="true"></i>
        </div>
        <h3 class="confirm-title" id="adminRoleConfirmTitle">Xác nhận cấp quyền Admin</h3>
        <p class="confirm-message">
            Tài khoản này sẽ có quyền truy cập khu vực quản trị. Chỉ cấp quyền Admin cho tài khoản đáng tin cậy.
        </p>
        <ul class="confirm-list">
            <li>Có thể xem và chỉnh sửa dữ liệu quản lý như người dùng, sản phẩm, đơn hàng.</li>
            <li>Có quyền thao tác với dữ liệu hệ thống trong khu vực admin.</li>
        </ul>
        <div class="confirm-actions">
            <button type="button" class="confirm-btn confirm-btn--cancel" id="cancelAdminRoleBtn">
                <i class="fa-solid fa-xmark" aria-hidden="true"></i>
                Hủy
            </button>
            <button type="button" class="confirm-btn confirm-btn--ok" id="confirmAdminRoleBtn">
                <i class="fa-solid fa-check" aria-hidden="true"></i>
                Xác nhận cấp quyền
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
    let currentUserData = null;
    let originalUserRole = 'Khách hàng';
    let adminRoleConfirmed = false;
    document.addEventListener('DOMContentLoaded', function() {
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            return;
        }
        const statCards = document.querySelectorAll('.stats-grid .stat-card');
        statCards.forEach(function(card, i) {
            card.style.opacity = '0';
            card.style.transform = 'translateY(14px)';
            setTimeout(function() {
                card.style.transition = 'opacity 0.35s ease, transform 0.35s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 70 + i * 80);
        });
    });
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
            iconWrapper.innerHTML = '<i class="fa-solid fa-lock" aria-hidden="true"></i>';
            title.textContent = 'Khóa tài khoản';
            message.textContent = 'Bạn có chắc chắn muốn khóa tài khoản "' + username + '" không?';
            okBtn.className = 'confirm-btn confirm-btn--danger';
            okBtn.innerHTML = '<i class="fa-solid fa-lock" aria-hidden="true"></i> Khóa ngay';
        } else {
            iconWrapper.className = 'confirm-icon-wrapper confirm-icon--unlock';
            iconWrapper.innerHTML = '<i class="fa-solid fa-lock-open" aria-hidden="true"></i>';
            title.textContent = 'Mở khóa tài khoản';
            message.textContent = 'Bạn có chắc chắn muốn mở khóa tài khoản "' + username + '" không?';
            okBtn.className = 'confirm-btn confirm-btn--success';
            okBtn.innerHTML = '<i class="fa-solid fa-lock-open" aria-hidden="true"></i> Mở khóa';
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
        }, 180);
        pendingToggleUserId = null;
    }
    function executeToggle() {
        if (!pendingToggleUserId) {
            return;
        }
        document.getElementById('toggleUserId').value = pendingToggleUserId;
        document.getElementById('toggleStatusForm').submit();
    }
    function formatCurrency(amount) {
        if (amount == null || isNaN(amount)) {
            return '0 ₫';
        }
        return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
    }
    function formatDate(timestamp) {
        if (!timestamp) {
            return 'Chưa có';
        }
        const d = new Date(timestamp);
        const day = String(d.getDate()).padStart(2, '0');
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const year = d.getFullYear();
        return day + '/' + month + '/' + year;
    }
    function formatDateTime(timestamp) {
        if (!timestamp) {
            return 'Chưa có';
        }
        const d = new Date(timestamp);
        const day = String(d.getDate()).padStart(2, '0');
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const year = d.getFullYear();
        const hours = String(d.getHours()).padStart(2, '0');
        const mins = String(d.getMinutes()).padStart(2, '0');
        return hours + ':' + mins + ' - ' + day + '/' + month + '/' + year;
    }

    function getInitial(value) {
        const normalized = (value || 'U').trim();
        return normalized ? normalized.charAt(0).toUpperCase() : 'U';
    }

    function clearElement(element) {
        while (element.firstChild) {
            element.removeChild(element.firstChild);
        }
    }
    function resolveAvatarSrc(avatar) {
        const value = (avatar || '').trim();
        const contextPath = '${pageContext.request.contextPath}';
        if (!value || value === 'avatar/avatar.jpg') {
            return '';
        }
        if (value.startsWith('http://') || value.startsWith('https://')) {
            return value;
        }
        if (value.startsWith('/')) {
            return contextPath + value;
        }
        if (value.startsWith('static/') || value.startsWith('uploads/') || value.startsWith('media/')) {
            return contextPath + '/' + value;
        }
        return contextPath + '/static/' + value;
    }
    function renderPreviewAvatar(user, displayName) {
        const avatarBox = document.getElementById('previewAvatarInitial');
        if (!avatarBox) {
            return;
        }

        clearElement(avatarBox);
        avatarBox.classList.remove('avatar-circle--image');

        const src = resolveAvatarSrc(user.avatar || '');
        if (!src) {
            avatarBox.textContent = getInitial(displayName);
            return;
        }
        const img = document.createElement('img');
        img.src = src;
        img.alt = 'Ảnh đại diện';
        img.className = 'preview-avatar-img';
        img.loading = 'lazy';
        img.onerror = function() {
            clearElement(avatarBox);
            avatarBox.classList.remove('avatar-circle--image');
            avatarBox.textContent = getInitial(displayName);
        };

        avatarBox.appendChild(img);
        avatarBox.classList.add('avatar-circle--image');
    }

    function normalizeRole(role) {
        const value = (role || '').trim();
        return value.toLowerCase() === 'admin' ? 'Admin' : 'Khách hàng';
    }

    function updateRoleHelpText() {
        const roleSelect = document.getElementById('detailRole');
        const role = normalizeRole(roleSelect ? roleSelect.value : '');
        const help = document.getElementById('roleHelpText');
        if (!help) {
            return;
        }

        if (role === 'Admin') {
            help.textContent = 'Admin có quyền truy cập khu vực quản trị, quản lý người dùng, sản phẩm, đơn hàng và dữ liệu hệ thống.';
        } else {
            help.textContent = 'Khách hàng chỉ có quyền mua hàng, quản lý giỏ hàng, đơn hàng và hồ sơ cá nhân.';
        }
    }

    function isValidEmail(value) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
    }

    function isValidPhone(value) {
        return /^[0-9]{9,11}$/.test(value);
    }

    function setFieldError(inputId, errorId, message) {
        const input = document.getElementById(inputId);
        const error = document.getElementById(errorId);
        if (!input || !error) {
            return;
        }

        const row = input.closest('.form-row');
        input.classList.add('is-invalid');
        if (row) {
            row.classList.add('has-error');
        }
        error.textContent = message;
    }

    function clearFieldError(inputId, errorId) {
        const input = document.getElementById(inputId);
        const error = document.getElementById(errorId);
        if (!input || !error) {
            return;
        }

        const row = input.closest('.form-row');
        input.classList.remove('is-invalid');
        if (row) {
            row.classList.remove('has-error');
        }
        error.textContent = '';
    }

    function validateNameField() {
        const name = document.getElementById('detailName');
        if (!name) {
            return true;
        }

        const value = name.value.trim();
        if (!value) {
            setFieldError('detailName', 'detailNameError', 'Tên người dùng không được để trống');
            return false;
        }

        clearFieldError('detailName', 'detailNameError');
        return true;
    }

    function validateEmailField() {
        const email = document.getElementById('detailEmail');
        if (!email) {
            return true;
        }

        const value = email.value.trim();
        if (!value || !isValidEmail(value)) {
            setFieldError('detailEmail', 'detailEmailError', 'Định dạng email chưa chính xác');
            return false;
        }

        clearFieldError('detailEmail', 'detailEmailError');
        return true;
    }

    function validatePhoneField() {
        const phone = document.getElementById('detailPhone');
        if (!phone) {
            return true;
        }

        const value = phone.value.trim();
        if (!value || !isValidPhone(value)) {
            setFieldError('detailPhone', 'detailPhoneError', 'Số điện thoại phải chứa từ 9-11 chữ số');
            return false;
        }

        clearFieldError('detailPhone', 'detailPhoneError');
        return true;
    }

    function validateUserEditForm() {
        const validName = validateNameField();
        const validEmail = validateEmailField();
        const validPhone = validatePhoneField();

        if (!validName) {
            const name = document.getElementById('detailName');
            if (name) {
                name.focus();
            }
            return false;
        }

        if (!validEmail) {
            const email = document.getElementById('detailEmail');
            if (email) {
                email.focus();
            }
            return false;
        }

        if (!validPhone) {
            const phone = document.getElementById('detailPhone');
            if (phone) {
                phone.focus();
            }
            return false;
        }

        return true;
    }

    function clearUserEditValidation() {
        clearFieldError('detailName', 'detailNameError');
        clearFieldError('detailEmail', 'detailEmailError');
        clearFieldError('detailPhone', 'detailPhoneError');
    }

    function openAdminRoleConfirmModal() {
        const modal = document.getElementById('adminRoleConfirmModal');
        if (!modal) {
            return;
        }

        modal.classList.add('active');
        setTimeout(function() {
            const box = modal.querySelector('.confirm-box');
            if (box) {
                box.classList.add('show');
            }
        }, 10);
    }

    function closeAdminRoleConfirmModal() {
        const modal = document.getElementById('adminRoleConfirmModal');
        if (!modal) {
            return;
        }

        const box = modal.querySelector('.confirm-box');
        if (box) {
            box.classList.remove('show');
        }
        setTimeout(function() {
            modal.classList.remove('active');
        }, 180);
    }

    function submitUserEditFormAfterAdminConfirm() {
        const form = document.getElementById('userEditForm');
        if (!form) {
            return;
        }

        adminRoleConfirmed = true;
        closeAdminRoleConfirmModal();
        if (typeof form.requestSubmit === 'function') {
            form.requestSubmit();
        } else {
            form.submit();
        }
    }

    function bindUserEditInteractions() {
        const form = document.getElementById('userEditForm');
        const name = document.getElementById('detailName');
        const email = document.getElementById('detailEmail');
        const phone = document.getElementById('detailPhone');
        const role = document.getElementById('detailRole');
        const confirmAdminBtn = document.getElementById('confirmAdminRoleBtn');
        const cancelAdminBtn = document.getElementById('cancelAdminRoleBtn');

        if (name) {
            name.addEventListener('input', validateNameField);
            name.addEventListener('blur', validateNameField);
        }
        if (email) {
            email.addEventListener('input', validateEmailField);
            email.addEventListener('blur', validateEmailField);
        }
        if (phone) {
            phone.addEventListener('input', validatePhoneField);
            phone.addEventListener('blur', validatePhoneField);
        }
        if (role) {
            role.addEventListener('change', function() {
                adminRoleConfirmed = false;
                updateRoleHelpText();
            });
        }

        if (form) {
            form.addEventListener('submit', function(e) {
                if (!validateUserEditForm()) {
                    e.preventDefault();
                    return;
                }

                const newRole = normalizeRole(role ? role.value : '');
                const upgradingToAdmin = originalUserRole !== 'Admin' && newRole === 'Admin';
                if (upgradingToAdmin && !adminRoleConfirmed) {
                    e.preventDefault();
                    openAdminRoleConfirmModal();
                }
            });
        }

        if (confirmAdminBtn) {
            confirmAdminBtn.addEventListener('click', submitUserEditFormAfterAdminConfirm);
        }
        if (cancelAdminBtn) {
            cancelAdminBtn.addEventListener('click', function() {
                adminRoleConfirmed = false;
                closeAdminRoleConfirmModal();
            });
        }

        updateRoleHelpText();
    }

    document.addEventListener('DOMContentLoaded', bindUserEditInteractions);

    function openUserDetail(id) {
        resetToViewMode();
        fetchAndShowUser(id, false);
    }

    function openUserDetailEdit(id) {
        fetchAndShowUser(id, true);
    }
    function fetchAndShowUser(id, autoEdit) {
        fetch("${pageContext.request.contextPath}/admin/users?action=detail&id=" + id)
            .then(function(res) {
                return res.json();
            })
            .then(function(user) {
                currentUserData = user;
                adminRoleConfirmed = false;
                const displayName = user.fullName || user.username || 'Người dùng';

                document.getElementById('detailUserId').value = user.userId;
                document.getElementById('detailId').innerText = '#U' + user.userId;
                renderPreviewAvatar(user, displayName);
                document.getElementById('previewName').innerText = displayName;
                document.getElementById('previewEmail').innerText = user.email || 'Chưa có';
                document.getElementById('previewPhone').innerText = user.phone || 'Chưa có';

                const status = document.getElementById('previewStatus');
                const statusText = document.getElementById('previewStatusText');
                const toggleBtn = document.getElementById('toggleStatusBtn');
                status.classList.remove('active', 'lock');
                toggleBtn.classList.remove('btn-danger', 'btn-success');

                if (user.isActive) {
                    statusText.innerText = 'Hoạt động';
                    status.classList.add('active');
                    toggleBtn.innerHTML = '<i class="fa-solid fa-lock" aria-hidden="true"></i> Khóa tài khoản';
                    toggleBtn.classList.add('btn-danger');
                } else {
                    statusText.innerText = 'Đã khóa';
                    status.classList.add('lock');
                    toggleBtn.innerHTML = '<i class="fa-solid fa-lock-open" aria-hidden="true"></i> Mở khóa tài khoản';
                    toggleBtn.classList.add('btn-success');
                }

                toggleBtn.onclick = function() {
                    const tempBtn = document.createElement('button');
                    tempBtn.setAttribute('data-action', user.isActive ? 'lock' : 'unlock');
                    tempBtn.setAttribute('data-user-id', user.userId);
                    tempBtn.setAttribute('data-username', displayName);
                    showToggleModal(tempBtn);
                };

                document.getElementById('viewName').innerText = displayName;
                document.getElementById('viewEmail').innerText = user.email || 'Chưa có';
                document.getElementById('viewPhone').innerText = user.phone || 'Chưa có';
                document.getElementById('viewRole').innerText = normalizeRole(user.role);

                document.getElementById('detailName').value = user.username || '';
                document.getElementById('detailEmail').value = user.email || '';
                document.getElementById('detailPhone').value = user.phone || '';
                originalUserRole = normalizeRole(user.role);
                document.getElementById('detailRole').value = originalUserRole;
                clearUserEditValidation();
                updateRoleHelpText();

                document.getElementById('metricSpending').innerText = formatCurrency(user.totalSpending);
                document.getElementById('metricOrders').innerText = (user.totalOrders || 0) + ' / ' + (user.cancelledOrders || 0);
                document.getElementById('metricJoinDate').innerText = 'Gia nhập: ' + formatDate(user.createdAt);
                document.getElementById('metricLastUpdate').innerText = 'Cập nhật gần nhất: ' + formatDateTime(user.updatedAt);

                document.getElementById('userModal').style.display = 'flex';
                if (autoEdit) {
                    setTimeout(function() {
                        toggleEditMode();
                    }, 180);
                }
            });
    }

    function toggleEditMode() {
        const viewMode = document.getElementById('viewMode');
        const editMode = document.getElementById('editMode');
        const toggleBtn = document.getElementById('btnEditToggle');

        viewMode.style.display = 'none';
        editMode.style.display = 'block';
        toggleBtn.style.display = 'none';
    }

    function cancelEditMode() {
        if (currentUserData) {
            document.getElementById('detailName').value = currentUserData.username || '';
            document.getElementById('detailEmail').value = currentUserData.email || '';
            document.getElementById('detailPhone').value = currentUserData.phone || '';
            document.getElementById('detailRole').value = normalizeRole(currentUserData.role);
            adminRoleConfirmed = false;
            clearUserEditValidation();
            updateRoleHelpText();
        }
        resetToViewMode();
    }

    function resetToViewMode() {
        document.getElementById('editMode').style.display = 'none';
        document.getElementById('viewMode').style.display = 'block';
        document.getElementById('btnEditToggle').style.display = 'inline-flex';
    }

    function closeModal() {
        document.getElementById('userModal').style.display = 'none';
        adminRoleConfirmed = false;
        closeAdminRoleConfirmModal();
        resetToViewMode();
    }

    function filterUsers() {
        const keyword = document.getElementById('search-input').value.trim().toLowerCase();
        const role = document.getElementById('role-filter').value;
        const status = document.getElementById('status-filter').value;
        const rows = document.querySelectorAll('#userTableBody tr.user-row');
        let visibleCount = 0;

        rows.forEach(function(row) {
            const textMatch = row.innerText.toLowerCase().includes(keyword);
            const roleMatch = !role || row.dataset.userRole === role;
            const statusMatch = !status || row.dataset.userStatus === status;
            const visible = textMatch && roleMatch && statusMatch;

            row.style.display = visible ? '' : 'none';
            if (visible) {
                visibleCount++;
            }
        });

        const emptyRow = document.getElementById('filterEmptyRow');
        if (emptyRow) {
            emptyRow.style.display = rows.length > 0 && visibleCount === 0 ? '' : 'none';
        }
    }

    function sortUsers() {
        const tbody = document.getElementById('userTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr.user-row'));
        const sortType = document.getElementById('sortselect').value;

        if (!sortType) {
            restoreDefaultOrder();
            filterUsers();
            return;
        }

        rows.sort(function(a, b) {
            const nameA = (a.dataset.userSort || '').toLowerCase();
            const nameB = (b.dataset.userSort || '').toLowerCase();
            return sortType === 'asc' ? nameA.localeCompare(nameB) : nameB.localeCompare(nameA);
        });

        rows.forEach(function(row) {
            tbody.insertBefore(row, document.getElementById('filterEmptyRow'));
        });
        filterUsers();
    }

    function restoreDefaultOrder() {
        const tbody = document.getElementById('userTableBody');
        const rows = Array.from(tbody.querySelectorAll('tr.user-row'));

        rows.sort(function(a, b) {
            return Number(a.dataset.originalIndex) - Number(b.dataset.originalIndex);
        });

        rows.forEach(function(row) {
            tbody.insertBefore(row, document.getElementById('filterEmptyRow'));
        });
    }

    function resetFilters() {
        document.getElementById('search-input').value = '';
        document.getElementById('role-filter').value = '';
        document.getElementById('status-filter').value = '';
        document.getElementById('sortselect').value = '';
        restoreDefaultOrder();
        filterUsers();
    }

    document.getElementById('toggleConfirmModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeToggleModal();
        }
    });

    document.getElementById('userModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    document.getElementById('adminRoleConfirmModal').addEventListener('click', function(e) {
        if (e.target === this) {
            adminRoleConfirmed = false;
            closeAdminRoleConfirmModal();
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const adminRoleModal = document.getElementById('adminRoleConfirmModal');
            const toggleModal = document.getElementById('toggleConfirmModal');

            if (adminRoleModal && adminRoleModal.classList.contains('active')) {
                adminRoleConfirmed = false;
                closeAdminRoleConfirmModal();
                return;
            }

            if (toggleModal && toggleModal.classList.contains('active')) {
                closeToggleModal();
                return;
            }

            closeModal();
        }
    });
</script>
</body>
</html>
