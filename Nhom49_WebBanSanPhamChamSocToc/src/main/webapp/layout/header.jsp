<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header>
    <div class="header-container">
        <div class="header-row header-top">

            <!-- Logo -->
            <div class="left-header">
                <div class="header-logo">
                    <a class="logo" href="${pageContext.request.contextPath}/">
                        <img alt="logo" class="logo-image" src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png">
                    </a>
                </div>
            </div>

            <!-- Search bar -->
            <div class="center-header">
                <div class="search-bar">
                    <form action="${pageContext.request.contextPath}/search" class="search-form" method="get">
                        <input class="input" id="search" name="q" placeholder="Bạn muốn tìm sản phẩm nào" type="text">
                        <button aria-label="search button suggest" class="search-button" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
            </div>

            <!-- Account and cart -->
            <div class="right-header">
                <div class="account">
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-user-circle"></i>
                        <span class="login-in-text">Đăng nhập</span>
                    </a>
                </div>

                <div class="cart position-relative">
                    <a href="${pageContext.request.contextPath}/cart">
                        <i class="fas fa-shopping-cart"></i>
                        <span class="cart-text">Giỏ hàng</span>
                        <span class="cart-count badge bg-danger rounded-pill">0</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Navigation -->
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
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=dau-goi"><i class="fas fa-tint text-primary me-2"></i>Dầu gội</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=dau-xa"><i class="fas fa-pump-soap text-info me-2"></i>Dầu xả</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=kem-u"><i class="fas fa-jar text-warning me-2"></i>Kem ủ – Mặt nạ tóc</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=serum"><i class="fas fa-flask text-danger me-2"></i>Serum – Dầu dưỡng tóc</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=xit-duong"><i class="fas fa-spray-can text-success me-2"></i>Xịt dưỡng – Tinh chất dưỡng</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=hoa-chat"><i class="fas fa-magic text-purple me-2"></i>Thuốc uốn – Duỗi – Nhuộm</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=tao-kieu"><i class="fas fa-cut text-secondary me-2"></i>Gôm – Sáp – Gel tạo kiểu</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=dau-goi-kho"><i class="fas fa-wind text-info me-2"></i>Dầu gội khô</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=moc-toc"><i class="fas fa-seedling text-success me-2"></i>Tinh chất mọc tóc</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=tri-gau"><i class="fas fa-medkit text-danger me-2"></i>Sản phẩm trị gàu / nấm / rụng tóc</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/store?category=dung-cu"><i class="fas fa-tools text-dark me-2"></i>Dụng cụ tóc</a></li>
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
    </div>
</header>
