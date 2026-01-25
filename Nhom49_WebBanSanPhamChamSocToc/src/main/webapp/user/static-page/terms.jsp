<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Điều khoản sử dụng - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
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
            position: relative;
        }

        .section ul li::marker {
            color: #89af63;
        }

        .highlight-box {
            background: linear-gradient(135deg, #f0f7eb, #e8f5e0);
            border-left: 4px solid #89af63;
            padding: 20px;
            border-radius: 0 12px 12px 0;
            margin: 20px 0;
        }

        .highlight-box p {
            margin: 0;
            color: #2c5940;
        }

        .last-updated {
            text-align: center;
            color: #888;
            font-size: 14px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        /* Table of Contents */
        .toc {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 40px;
        }

        .toc h3 {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }

        .toc ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 10px;
        }

        .toc a {
            color: #2c5940;
            text-decoration: none;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .toc a:hover {
            background: #e8f5e0;
            padding-left: 18px;
        }

        .toc a i {
            color: #89af63;
            font-size: 12px;
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
<jsp:include page="/layout/header.jsp"/>

<main class="static-page">
    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-file-contract me-3"></i>Điều khoản sử dụng</h1>
            <p>Vui lòng đọc kỹ các điều khoản trước khi sử dụng dịch vụ của chúng tôi</p>
        </div>

        <div class="content-card">
            <!-- Table of Contents -->
            <div class="toc">
                <h3><i class="fas fa-list me-2"></i>Mục lục</h3>
                <ul>
                    <li><a href="#gioi-thieu"><i class="fas fa-chevron-right"></i>Giới thiệu</a></li>
                    <li><a href="#dieu-kien"><i class="fas fa-chevron-right"></i>Điều kiện sử dụng</a></li>
                    <li><a href="#tai-khoan"><i class="fas fa-chevron-right"></i>Tài khoản người dùng</a></li>
                    <li><a href="#dat-hang"><i class="fas fa-chevron-right"></i>Đặt hàng & Thanh toán</a></li>
                    <li><a href="#giao-hang"><i class="fas fa-chevron-right"></i>Giao hàng</a></li>
                    <li><a href="#doi-tra"><i class="fas fa-chevron-right"></i>Đổi trả & Hoàn tiền</a></li>
                    <li><a href="#so-huu-tri-tue"><i class="fas fa-chevron-right"></i>Sở hữu trí tuệ</a></li>
                    <li><a href="#lien-he"><i class="fas fa-chevron-right"></i>Liên hệ</a></li>
                </ul>
            </div>

            <div class="section" id="gioi-thieu">
                <h2><i class="fas fa-info-circle"></i>1. Giới thiệu</h2>
                <p>Chào mừng bạn đến với HairGlow - website thương mại điện tử chuyên cung cấp các sản phẩm chăm sóc tóc
                    chính hãng. Bằng việc truy cập và sử dụng website này, bạn đồng ý tuân thủ các điều khoản và điều
                    kiện được nêu dưới đây.</p>
                <div class="highlight-box">
                    <p><i class="fas fa-exclamation-triangle me-2"></i>Nếu bạn không đồng ý với bất kỳ điều khoản nào,
                        vui lòng không sử dụng dịch vụ của chúng tôi.</p>
                </div>
            </div>

            <div class="section" id="dieu-kien">
                <h2><i class="fas fa-check-circle"></i>2. Điều kiện sử dụng</h2>
                <p>Khi sử dụng website HairGlow, bạn cam kết:</p>
                <ul>
                    <li>Đủ 18 tuổi hoặc có sự đồng ý của phụ huynh/người giám hộ</li>
                    <li>Cung cấp thông tin chính xác, đầy đủ khi đăng ký tài khoản</li>
                    <li>Không sử dụng website cho mục đích bất hợp pháp</li>
                    <li>Không can thiệp vào hoạt động bình thường của website</li>
                    <li>Không sao chép, phân phối nội dung mà không có sự cho phép</li>
                </ul>
            </div>

            <div class="section" id="tai-khoan">
                <h2><i class="fas fa-user-shield"></i>3. Tài khoản người dùng</h2>
                <p>Khi tạo tài khoản tại HairGlow:</p>
                <ul>
                    <li>Bạn chịu trách nhiệm bảo mật thông tin đăng nhập</li>
                    <li>Thông báo ngay cho chúng tôi nếu phát hiện truy cập trái phép</li>
                    <li>Mỗi người chỉ được sở hữu một tài khoản</li>
                    <li>Chúng tôi có quyền khóa tài khoản vi phạm điều khoản</li>
                </ul>
            </div>

            <div class="section" id="dat-hang">
                <h2><i class="fas fa-shopping-cart"></i>4. Đặt hàng & Thanh toán</h2>
                <ul>
                    <li>Giá sản phẩm có thể thay đổi mà không cần thông báo trước</li>
                    <li>Đơn hàng chỉ được xác nhận sau khi thanh toán thành công</li>
                    <li>Chúng tôi có quyền từ chối đơn hàng trong trường hợp đặc biệt</li>
                    <li>Hỗ trợ nhiều phương thức thanh toán: COD, chuyển khoản, ví điện tử</li>
                </ul>
            </div>

            <div class="section" id="giao-hang">
                <h2><i class="fas fa-truck"></i>5. Giao hàng</h2>
                <ul>
                    <li>Thời gian giao hàng: 2-5 ngày làm việc tùy khu vực</li>
                    <li>Phí vận chuyển được tính dựa trên địa chỉ và phương thức giao hàng</li>
                    <li>Miễn phí vận chuyển cho đơn hàng từ 500.000đ</li>
                    <li>Kiểm tra hàng trước khi nhận</li>
                </ul>
            </div>

            <div class="section" id="doi-tra">
                <h2><i class="fas fa-exchange-alt"></i>6. Đổi trả & Hoàn tiền</h2>
                <ul>
                    <li>Đổi trả trong vòng 7 ngày kể từ ngày nhận hàng</li>
                    <li>Sản phẩm phải còn nguyên tem, nhãn, chưa qua sử dụng</li>
                    <li>Hoàn tiền trong 3-5 ngày làm việc sau khi xác nhận</li>
                    <li>Không áp dụng đổi trả với sản phẩm khuyến mãi đặc biệt</li>
                </ul>
            </div>

            <div class="section" id="so-huu-tri-tue">
                <h2><i class="fas fa-copyright"></i>7. Sở hữu trí tuệ</h2>
                <p>Tất cả nội dung trên website bao gồm logo, hình ảnh, văn bản, thiết kế đều thuộc quyền sở hữu của
                    HairGlow hoặc các đối tác được cấp phép. Nghiêm cấm sao chép, sử dụng mà không có sự cho phép bằng
                    văn bản.</p>
            </div>

            <div class="section" id="lien-he">
                <h2><i class="fas fa-envelope"></i>8. Liên hệ</h2>
                <p>Nếu có bất kỳ thắc mắc nào về điều khoản sử dụng, vui lòng liên hệ:</p>
                <ul>
                    <li><strong>Email:</strong> support@hairglow.vn</li>
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

<jsp:include page="/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

