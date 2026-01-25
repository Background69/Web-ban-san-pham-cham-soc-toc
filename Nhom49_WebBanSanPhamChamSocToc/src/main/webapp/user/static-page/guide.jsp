<%@ page contentType="text/html;charset=UTF-8" language="java"  pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hướng dẫn mua hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --brand: #2c5940;
            --border: #e2e8f0;
            --text: #0f172a;
            --muted: #475569;
        }

        .static-hero {
            padding: 60px 0;
            background: linear-gradient(135deg, #eef5f1, #e2eee7);
            text-align: center;
        }

        .static-hero h1 {
            font-size: 32px;
            margin-bottom: 10px;
            color: var(--brand);
        }

        .static-hero p {
            color: var(--muted);
            max-width: 640px;
            margin: 0 auto;
        }

        .steps {
            max-width: 900px;
            margin: 40px auto 80px;
            padding: 0 20px;
            display: grid;
            gap: 16px;
        }

        .step {
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 20px;
            background: #fff;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.06);
            display: flex;
            gap: 14px;
        }

        .step-badge {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            background: var(--brand);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .step h3 {
            margin: 0 0 8px;
            font-size: 18px;
            color: var(--text);
        }

        .step p {
            margin: 0;
            color: var(--muted);
            line-height: 1.6;
        }
    </style>
</head>
<body>
<jsp:include page="/layout/header.jsp"/>

<section class="static-hero">
    <div class="container">
        <h1>Hướng dẫn mua hàng</h1>
        <p>4 bước đơn giản để đặt sản phẩm chăm sóc tóc trên HairGlow.</p>
    </div>
</section>

<section class="steps">
    <div class="step">
        <div class="step-badge">1</div>
        <div>
            <h3>Chọn sản phẩm</h3>
            <p>Duyệt danh mục hoặc tìm kiếm, xem chi tiết biến thể và đánh giá để chọn sản phẩm phù hợp.</p>
        </div>
    </div>
    <div class="step">
        <div class="step-badge">2</div>
        <div>
            <h3>Thêm vào giỏ</h3>
            <p>Chọn số lượng/phiên bản, thêm vào giỏ. Bạn có thể chỉnh sửa số lượng ngay tại trang giỏ hàng.</p>
        </div>
    </div>
    <div class="step">
        <div class="step-badge">3</div>
        <div>
            <h3>Điền thông tin giao hàng</h3>
            <p>Đăng nhập hoặc điền thông tin nhận hàng, chọn phương thức giao và thanh toán (COD/online).</p>
        </div>
    </div>
    <div class="step">
        <div class="step-badge">4</div>
        <div>
            <h3>Xác nhận & theo dõi</h3>
            <p>Hoàn tất đặt hàng, theo dõi tình trạng trong mục Đơn hàng. Liên hệ hỗ trợ nếu cần thay đổi.</p>
        </div>
    </div>
</section>

<jsp:include page="/layout/footer.jsp"/>
</body>
</html>

