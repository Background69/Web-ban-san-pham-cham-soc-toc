<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ - Câu hỏi thường gặp</title>
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
            background: linear-gradient(135deg, #f3f7f5, #e7f1eb);
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

        .faq-wrap {
            max-width: 900px;
            margin: 40px auto 80px;
            padding: 0 20px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .faq-item {
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 18px 20px;
            background: #fff;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .faq-item h3 {
            margin: 0 0 10px;
            font-size: 18px;
            color: var(--text);
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .faq-item p {
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
        <h1>Câu hỏi thường gặp</h1>
        <p>Giải đáp nhanh các thắc mắc phổ biến về đơn hàng, giao nhận, đổi trả và tài khoản.</p>
    </div>
</section>

<section class="faq-wrap">
    <div class="faq-item">
        <h3><i class="fas fa-truck-fast"></i> Thời gian giao hàng bao lâu?</h3>
        <p>Đơn nội thành thường 1-2 ngày, ngoại tỉnh 3-5 ngày làm việc. Bạn có thể chọn giao nhanh ở bước thanh
            toán.</p>
    </div>
    <div class="faq-item">
        <h3><i class="fas fa-rotate"></i> Đổi trả như thế nào?</h3>
        <p>Chấp nhận đổi trả trong 7 ngày khi sản phẩm còn nguyên tem, chưa qua sử dụng. Liên hệ hỗ trợ để được hướng
            dẫn.</p>
    </div>
    <div class="faq-item">
        <h3><i class="fas fa-credit-card"></i> Có hỗ trợ COD không?</h3>
        <p>Có. Bạn có thể chọn COD hoặc thanh toán online. Với đơn giá trị cao, chúng tôi sẽ xác minh qua điện
            thoại.</p>
    </div>
    <div class="faq-item">
        <h3><i class="fas fa-user-shield"></i> Bảo mật tài khoản ra sao?</h3>
        <p>Chúng tôi mã hóa mật khẩu, tuân thủ chính sách bảo mật và khuyến nghị bạn bật xác thực đa lớp nếu có.</p>
    </div>
</section>

<jsp:include page="/layout/footer.jsp"/>
</body>
</html>

