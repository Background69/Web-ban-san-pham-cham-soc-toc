<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách bảo mật - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .static-page {
            min-height: 60vh;
            padding: 60px 0;
            background: linear-gradient(135deg, #f8f9fa 0%, #fff 100%);
        }

        .page-header {
            text-align: center;
            margin-bottom: 50px;
            animation: fadeInDown 0.6s ease;
        }

        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c5940;
            margin-bottom: 15px;
        }

        .page-header p {
            color: #666;
            font-size: 1.1rem;
        }

        .content-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            animation: fadeInUp 0.6s ease;
        }

        .section {
            margin-bottom: 35px;
            padding-bottom: 35px;
            border-bottom: 1px solid #eee;
        }

        .section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .section h2 {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c5940;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section h2 i {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #89af63, #2c5940);
            color: white;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .section p, .section li {
            color: #555;
            line-height: 1.8;
            font-size: 15px;
        }

        .section ul {
            padding-left: 20px;
        }

        .section ul li {
            margin-bottom: 10px;
        }

        .section ul li::marker {
            color: #89af63;
        }

        .highlight-box {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-left: 4px solid #2196f3;
            padding: 20px;
            border-radius: 0 12px 12px 0;
            margin: 20px 0;
        }

        .highlight-box.warning {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            border-left-color: #ff9800;
        }

        .highlight-box.success {
            background: linear-gradient(135deg, #f0f7eb, #e8f5e0);
            border-left-color: #89af63;
        }

        .highlight-box p {
            margin: 0;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            border-radius: 12px;
            overflow: hidden;
        }

        .data-table th, .data-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .data-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c5940;
        }

        .data-table tr:hover {
            background: #f8f9fa;
        }

        .last-updated {
            text-align: center;
            color: #888;
            font-size: 14px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .shield-icon {
            text-align: center;
            margin-bottom: 30px;
        }

        .shield-icon i {
            font-size: 60px;
            color: #2c5940;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="static-page">
    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-user-shield me-3"></i>Chính sách bảo mật</h1>
            <p>Cam kết bảo vệ thông tin cá nhân của khách hàng</p>
        </div>

        <div class="content-card">
            <div class="shield-icon">
                <i class="fas fa-shield-alt"></i>
            </div>

            <div class="section">
                <h2><i class="fas fa-bullseye"></i>1. Mục đích thu thập thông tin</h2>
                <p>HairGlow thu thập thông tin cá nhân của bạn nhằm mục đích:</p>
                <ul>
                    <li>Xử lý đơn hàng và giao hàng đến địa chỉ của bạn</li>
                    <li>Liên hệ xác nhận đơn hàng và hỗ trợ khách hàng</li>
                    <li>Gửi thông tin khuyến mãi, sản phẩm mới (nếu bạn đồng ý)</li>
                    <li>Cải thiện chất lượng dịch vụ và trải nghiệm người dùng</li>
                    <li>Thực hiện các nghĩa vụ pháp lý khi được yêu cầu</li>
                </ul>
            </div>

            <div class="section">
                <h2><i class="fas fa-database"></i>2. Thông tin thu thập</h2>
                <p>Chúng tôi có thể thu thập các loại thông tin sau:</p>
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Loại thông tin</th>
                        <th>Mục đích sử dụng</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Họ tên, email, số điện thoại</td>
                        <td>Liên hệ, xác nhận đơn hàng</td>
                    </tr>
                    <tr>
                        <td>Địa chỉ giao hàng</td>
                        <td>Vận chuyển đơn hàng</td>
                    </tr>
                    <tr>
                        <td>Thông tin thanh toán</td>
                        <td>Xử lý giao dịch (không lưu trữ)</td>
                    </tr>
                    <tr>
                        <td>Lịch sử mua hàng</td>
                        <td>Hỗ trợ khách hàng, đề xuất sản phẩm</td>
                    </tr>
                    <tr>
                        <td>Cookies, IP address</td>
                        <td>Phân tích, cải thiện website</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="section">
                <h2><i class="fas fa-lock"></i>3. Bảo mật thông tin</h2>
                <p>Chúng tôi áp dụng các biện pháp bảo mật nghiêm ngặt:</p>
                <ul>
                    <li>Mã hóa SSL/TLS cho tất cả giao dịch</li>
                    <li>Mật khẩu được mã hóa bằng thuật toán BCrypt</li>
                    <li>Hệ thống firewall và giám sát 24/7</li>
                    <li>Giới hạn quyền truy cập dữ liệu cho nhân viên</li>
                    <li>Sao lưu dữ liệu định kỳ</li>
                </ul>
                <div class="highlight-box success">
                    <p><i class="fas fa-check-circle me-2"></i>Chúng tôi cam kết không bán, trao đổi hoặc chia sẻ thông
                        tin cá nhân của bạn cho bên thứ ba vì mục đích thương mại.</p>
                </div>
            </div>

            <div class="section">
                <h2><i class="fas fa-share-alt"></i>4. Chia sẻ thông tin</h2>
                <p>Thông tin của bạn chỉ được chia sẻ trong các trường hợp:</p>
                <ul>
                    <li><strong>Đối tác vận chuyển:</strong> Để giao hàng đến bạn</li>
                    <li><strong>Cổng thanh toán:</strong> Để xử lý giao dịch</li>
                    <li><strong>Cơ quan pháp luật:</strong> Khi có yêu cầu hợp pháp</li>
                    <li><strong>Với sự đồng ý của bạn:</strong> Trong các trường hợp khác</li>
                </ul>
            </div>

            <div class="section">
                <h2><i class="fas fa-cookie-bite"></i>5. Cookies</h2>
                <p>Website sử dụng cookies để:</p>
                <ul>
                    <li>Ghi nhớ thông tin đăng nhập</li>
                    <li>Lưu giỏ hàng của bạn</li>
                    <li>Phân tích hành vi người dùng</li>
                    <li>Cá nhân hóa trải nghiệm</li>
                </ul>
                <div class="highlight-box warning">
                    <p><i class="fas fa-info-circle me-2"></i>Bạn có thể tắt cookies trong cài đặt trình duyệt, tuy
                        nhiên một số tính năng có thể không hoạt động đúng.</p>
                </div>
            </div>

            <div class="section">
                <h2><i class="fas fa-user-cog"></i>6. Quyền của bạn</h2>
                <p>Bạn có quyền:</p>
                <ul>
                    <li>Truy cập và xem thông tin cá nhân của mình</li>
                    <li>Yêu cầu chỉnh sửa thông tin không chính xác</li>
                    <li>Yêu cầu xóa tài khoản và dữ liệu</li>
                    <li>Từ chối nhận email marketing</li>
                    <li>Khiếu nại về việc xử lý dữ liệu</li>
                </ul>
            </div>

            <div class="section">
                <h2><i class="fas fa-child"></i>7. Bảo vệ trẻ em</h2>
                <p>Website không dành cho người dưới 13 tuổi. Chúng tôi không cố ý thu thập thông tin từ trẻ em. Nếu
                    phát hiện vi phạm, vui lòng liên hệ để chúng tôi xử lý.</p>
            </div>

            <div class="section">
                <h2><i class="fas fa-sync-alt"></i>8. Cập nhật chính sách</h2>
                <p>Chính sách bảo mật có thể được cập nhật theo thời gian. Chúng tôi sẽ thông báo qua email hoặc trên
                    website khi có thay đổi quan trọng.</p>
            </div>

            <div class="section">
                <h2><i class="fas fa-headset"></i>9. Liên hệ</h2>
                <p>Nếu có thắc mắc về chính sách bảo mật, vui lòng liên hệ:</p>
                <ul>
                    <li><strong>Email:</strong> privacy@hairglow.vn</li>
                    <li><strong>Hotline:</strong> (+84) 1234 5678</li>
                    <li><strong>Địa chỉ:</strong> Khu Phố 6, P. Linh Trung, Q. Thủ Đức, TP.HCM</li>
                </ul>
            </div>

            <div class="last-updated">
                <i class="fas fa-clock me-2"></i>Cập nhật lần cuối: 31/12/2025
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

