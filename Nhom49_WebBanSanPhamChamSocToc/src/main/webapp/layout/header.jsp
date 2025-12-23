<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chăm sóc tóc chính hãng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
          integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="/static/css/style.css" rel="stylesheet">
</head>
<body>
<header>
    <div class="header-container">
        <div class="header-row header-top">

            <!-- Logo -->
            <div class="left-header">
                <div class="header-logo">
                    <a class="logo" href="">
                        <img alt="logo" class="logo-image" src="/static/assests/icons/LOGO.png">
                    </a>
                </div>
            </div>

            <!-- Search bar -->
            <div class="center-header">
                <div class="search-bar">
                    <form action="/search" class="search-form" method="get">
                        <input class="input" id="search" placeholder="Bạn muốn tìm sản phẩm nào" type="text">
                        <button aria-label="search button suggest" class="search-button" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
            </div>

            <!-- Account and cart -->
            <div class="right-header">
                <div class="account">
                    <a href="">
                        <i class="fas fa-user-circle"></i>
                        <span class="login-in-text">Đăng nhập</span>
                    </a>
                </div>

                <div class="cart position-relative">
                    <a href="">
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
                            <a class="nav-link home-page" href="l">
                                <i class="fas fa-home me-1"></i> Trang Chủ
                            </a>
                        </li>
                        <li class="nav-item has-dropdown">
                            <a class="nav-link product" href="s">
                                <i class="fas fa-box-open me-1"></i> Sản Phẩm
                                <i class="fa fa-caret-down ms-1"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-tint text-primary me-2"></i>Dầu gội</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-pump-soap text-info me-2"></i>Dầu xả</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-jar text-warning me-2"></i>Kem ủ – Mặt nạ tóc</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-flask text-danger me-2"></i>Serum – Dầu dưỡng tóc</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-spray-can text-success me-2"></i>Xịt dưỡng – Tinh chất dưỡng</a>
                                </li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-magic text-purple me-2"></i>Thuốc uốn – Duỗi – Nhuộm</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-cut text-secondary me-2"></i>Gôm – Sáp – Gel tạo kiểu</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-wind text-info me-2"></i>Dầu gội khô</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-seedling text-success me-2"></i>Tinh chất mọc tóc</a></li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-medkit text-danger me-2"></i>Sản phẩm trị gàu / nấm / rụng tóc</a>
                                </li>
                                <li><a class="dropdown-item" href=""><i
                                        class="fas fa-tools text-dark me-2"></i>Dụng cụ tóc</a></li>
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="">
                                <i class="fas fa-award me-1"></i> Thương Hiệu
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="">
                                <i class="fas fa-headset me-1"></i> Hỗ Trợ Khách Hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link special-button" href="">
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
</body>
</html>
