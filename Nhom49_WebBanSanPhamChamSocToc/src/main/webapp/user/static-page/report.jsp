<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo lỗi / Góp ý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --brand: #2c5940;
            --border: #e2e8f0;
            --text: #0f172a;
            --muted: #475569;
            --ghost: #f7f8fb;
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

        .report-wrap {
            max-width: 760px;
            margin: 40px auto 80px;
            padding: 0 20px;
        }

        form {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.06);
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        label {
            font-weight: 600;
            color: var(--text);
        }

        input, textarea, select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: var(--ghost);
            transition: all .2s ease;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: var(--brand);
            background: #fff;
            box-shadow: 0 0 0 3px rgba(44, 89, 64, 0.1);
        }

        textarea {
            min-height: 140px;
            resize: vertical;
        }

        .btn-submit {
            background: var(--brand);
            color: #fff;
            border: none;
            border-radius: 14px;
            padding: 14px 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all .2s ease;
        }

        .btn-submit:hover {
            background: #1f3f30;
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(44, 89, 64, 0.18);
        }

        .note {
            color: var(--muted);
            font-size: 14px;
        }
    </style>
</head>
<body>
<jsp:include page="/layout/header.jsp"/>

<section class="static-hero">
    <div class="container">
        <h1>Báo lỗi / Góp ý</h1>
        <p>Cho chúng tôi biết vấn đề bạn gặp phải hoặc ý tưởng cải thiện trải nghiệm HairGlow.</p>
    </div>
</section>

<section class="report-wrap">
    <form>
        <div>
            <label for="topic">Loại vấn đề</label>
            <select id="topic" name="topic">
                <option value="bug">Lỗi chức năng / hiển thị</option>
                <option value="payment">Thanh toán / đơn hàng</option>
                <option value="shipping">Giao nhận</option>
                <option value="ux">Góp ý trải nghiệm</option>
                <option value="other">Khác</option>
            </select>
        </div>
        <div>
            <label for="email">Email (để chúng tôi liên hệ)</label>
            <input type="email" id="email" name="email" placeholder="you@example.com">
        </div>
        <div>
            <label for="message">Mô tả chi tiết</label>
            <textarea id="message" name="message" placeholder="Mô tả lỗi, bước tái hiện, ảnh hưởng..."></textarea>
        </div>
        <p class="note">Hiện tại form này chỉ hiển thị tĩnh. Vui lòng liên hệ qua mục Hỗ trợ để được phản hồi nhanh
            nhất.</p>
        <button type="button" class="btn-submit">Gửi phản hồi</button>
    </form>
</section>

<jsp:include page="/layout/footer.jsp"/>
</body>
</html>
