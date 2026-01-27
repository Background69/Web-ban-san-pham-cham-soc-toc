<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        .success-container {
            max-width: 600px;
            margin: 60px auto;
            padding: 40px;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .success-icon {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #4caf50, #81c784);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: scaleIn 0.5s ease-out;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .success-icon i {
            font-size: 60px;
            color: white;
        }

        .success-title {
            font-size: 28px;
            font-weight: 700;
            color: #2e7d32;
            margin-bottom: 15px;
        }

        .success-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .order-info {
            background: #e8f5e9;
            padding: 25px;
            border-radius: 16px;
            margin-bottom: 30px;
        }

        .order-info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px dashed #c8e6c9;
        }

        .order-info-row:last-child {
            border-bottom: none;
        }

        .order-info-row .label {
            color: #558b2f;
            font-size: 14px;
        }

        .order-info-row .value {
            font-weight: 600;
            color: #2e7d32;
        }

        .order-info-row .value.highlight {
            font-size: 20px;
            color: #1b5e20;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #e91e63, #ad1457);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(233, 30, 99, 0.35);
        }

        .btn-secondary {
            background: #e9ecef;
            color: #495057;
        }

        .btn-secondary:hover {
            background: #dee2e6;
        }

        .confetti {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
            z-index: -1;
        }

        .confetti-piece {
            position: absolute;
            width: 10px;
            height: 10px;
            top: -20px;
            animation: confetti-fall 3s linear forwards;
        }

        @keyframes confetti-fall {
            to {
                transform: translateY(100vh) rotate(720deg);
                opacity: 0;
            }
        }

        .payment-badge {
            display: inline-block;
            padding: 8px 16px;
            background: linear-gradient(135deg, #4caf50, #66bb6a);
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .payment-badge i {
            margin-right: 5px;
        }
    </style>
</head>

<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<!-- Confetti Effect -->
<div class="confetti" id="confetti"></div>

<main>
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check"></i>
        </div>

        <span class="payment-badge">
                            <i class="fas fa-credit-card"></i> Thanh toán thành công
                        </span>

        <h1 class="success-title">Đặt hàng thành công!</h1>

        <p class="success-message">
            Cảm ơn bạn đã mua hàng tại HairGlow.
            <c:if test="${order != null}">
                Đơn hàng <strong>#${order.orderId}</strong> của bạn đã được ghi nhận.
            </c:if>
            Chúng tôi sẽ xử lý và giao hàng trong thời gian sớm nhất.
        </p>

        <div class="order-info">
            <c:if test="${order != null}">
                <div class="order-info-row">
                    <span class="label">Mã đơn hàng</span>
                    <span class="value">#${order.orderId}</span>
                </div>
            </c:if>
            <c:if test="${transaction != null}">
                <div class="order-info-row">
                    <span class="label">Mã giao dịch</span>
                    <span class="value">${transaction.orderTempId}</span>
                </div>
                <div class="order-info-row">
                    <span class="label">Phương thức thanh toán</span>
                    <span class="value">
                            ${transaction.paymentMethod == 'BANK' ? 'Chuyển khoản ngân hàng' : 'Ví MoMo'}
                    </span>
                </div>
                <div class="order-info-row">
                    <span class="label">Số tiền</span>
                    <span class="value highlight">
                                        <fmt:formatNumber value="${transaction.amount}" type="number"/>₫
                                    </span>
                </div>
            </c:if>
            <div class="order-info-row">
                <span class="label">Trạng thái</span>
                <span class="value" style="color: #4caf50;">
                                    <i class="fas fa-check-circle"></i> Đã thanh toán
                                </span>
            </div>
        </div>

        <div class="action-buttons">
            <c:if test="${order != null}">
                <a href="${pageContext.request.contextPath}/orders/${order.orderId}"
                   class="btn btn-primary">
                    <i class="fas fa-receipt"></i> Xem đơn hàng
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary">
                <i class="fas fa-list"></i> Lịch sử đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">
                <i class="fas fa-shopping-bag"></i> Tiếp tục mua sắm
            </a>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    // Create confetti effect
    function createConfetti() {
        const confettiContainer = document.getElementById('confetti');
        const colors = ['#e91e63', '#4caf50', '#2196f3', '#ffeb3b', '#9c27b0', '#ff5722'];

        for (let i = 0; i < 50; i++) {
            const confetti = document.createElement('div');
            confetti.className = 'confetti-piece';
            confetti.style.left = Math.random() * 100 + '%';
            confetti.style.background = colors[Math.floor(Math.random() * colors.length)];
            confetti.style.animationDelay = Math.random() * 2 + 's';
            confetti.style.animationDuration = (Math.random() * 2 + 2) + 's';
            confettiContainer.appendChild(confetti);
        }

        // Remove confetti after animation
        setTimeout(() => {
            confettiContainer.innerHTML = '';
        }, 5000);
    }

    // Run confetti on page load
    document.addEventListener('DOMContentLoaded', createConfetti);
</script>
</body>

</html>