<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán QR - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/qr-payment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        .qr-payment-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }

        .qr-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .qr-header h1 {
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .qr-header .amount {
            font-size: 32px;
            font-weight: 700;
            color: #e91e63;
        }

        .payment-method-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .payment-method-badge.bank {
            background: linear-gradient(135deg, #1976d2, #42a5f5);
            color: white;
        }

        .payment-method-badge.momo {
            background: linear-gradient(135deg, #a50064, #d63384);
            color: white;
        }

        .qr-code-wrapper {
            text-align: center;
            padding: 30px;
            background: white;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        }

        .qr-code-wrapper img {
            max-width: 250px;
            height: auto;
            border-radius: 10px;
        }

        .payment-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .payment-info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px dashed #dee2e6;
        }

        .payment-info-row:last-child {
            border-bottom: none;
        }

        .payment-info-row .label {
            color: #6c757d;
            font-size: 14px;
        }

        .payment-info-row .value {
            font-weight: 600;
            color: #333;
        }

        .payment-info-row .value.highlight {
            color: #e91e63;
            font-size: 16px;
        }

        .timer-section {
            text-align: center;
            margin-bottom: 25px;
        }

        .timer {
            font-size: 48px;
            font-weight: 700;
            color: #ff5722;
        }

        .timer.warning {
            color: #f44336;
            animation: pulse 1s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.5;
            }
        }

        .timer-label {
            color: #6c757d;
            font-size: 14px;
            margin-top: 5px;
        }

        .status-section {
            text-align: center;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .status-section.pending {
            background: #fff3e0;
            border: 2px dashed #ff9800;
        }

        .status-section.success {
            background: #e8f5e9;
            border: 2px solid #4caf50;
        }

        .status-section.expired {
            background: #ffebee;
            border: 2px solid #f44336;
        }

        .status-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }

        .status-section.pending .status-icon {
            color: #ff9800;
        }

        .status-section.success .status-icon {
            color: #4caf50;
        }

        .status-section.expired .status-icon {
            color: #f44336;
        }

        .status-text {
            font-size: 18px;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 10px;
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
            box-shadow: 0 5px 20px rgba(233, 30, 99, 0.4);
        }

        .btn-secondary {
            background: #e9ecef;
            color: #495057;
        }

        .btn-secondary:hover {
            background: #dee2e6;
        }

        .btn-success {
            background: linear-gradient(135deg, #4caf50, #388e3c);
            color: white;
        }

        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #fff3;
            border-top-color: white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        .instructions {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .instructions h3 {
            color: #1976d2;
            margin-bottom: 15px;
            font-size: 16px;
        }

        .instructions ol {
            margin: 0;
            padding-left: 20px;
            color: #333;
        }

        .instructions li {
            margin-bottom: 8px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="qr-payment-main">
    <div class="qr-payment-container">
        <!-- Header -->
        <div class="qr-header">
            <span class="payment-method-badge ${transaction.paymentMethod == 'BANK' ? 'bank' : 'momo'}">
                <i class="fas ${transaction.paymentMethod == 'BANK' ? 'fa-university' : 'fa-wallet'}"></i>
                ${transaction.paymentMethod == 'BANK' ? 'Chuyển khoản ngân hàng' : 'Ví MoMo'}
            </span>
            <h1>Quét mã QR để thanh toán</h1>
            <div class="amount">
                <fmt:formatNumber value="${transaction.amount}" type="number"/>₫
            </div>
        </div>

        <!-- QR Code -->
        <div class="qr-code-wrapper">
            <img src="${transaction.qrCodeUrl}" alt="QR Code thanh toán" id="qrCodeImage">
        </div>

        <!-- Payment Info -->
        <div class="payment-info">
            <div class="payment-info-row">
                <span class="label">${transaction.paymentMethod == 'BANK' ? 'Ngân hàng' : 'Ví điện tử'}</span>
                <span class="value">${transaction.bankName}</span>
            </div>
            <div class="payment-info-row">
                <span class="label">${transaction.paymentMethod == 'BANK' ? 'Số tài khoản' : 'Số điện thoại'}</span>
                <span class="value">${transaction.bankAccount}</span>
            </div>
            <div class="payment-info-row">
                <span class="label">Chủ tài khoản</span>
                <span class="value">${transaction.accountHolder}</span>
            </div>
            <div class="payment-info-row">
                <span class="label">Nội dung chuyển khoản</span>
                <span class="value highlight">${transaction.transferContent}</span>
            </div>
            <div class="payment-info-row">
                <span class="label">Số tiền</span>
                <span class="value highlight"><fmt:formatNumber value="${transaction.amount}" type="number"/>₫</span>
            </div>
        </div>

        <!-- Instructions -->
        <div class="instructions">
            <h3><i class="fas fa-info-circle"></i> Hướng dẫn thanh toán</h3>
            <ol>
                <li>Mở ứng dụng ${transaction.paymentMethod == 'BANK' ? 'Ngân hàng' : 'MoMo'} trên điện thoại</li>
                <li>Quét mã QR phía trên hoặc chuyển khoản thủ công</li>
                <li>Nhập chính xác nội dung chuyển khoản: <strong>${transaction.transferContent}</strong></li>
                <li>Xác nhận thanh toán và chờ hệ thống xử lý</li>
            </ol>
        </div>

        <!-- Timer -->
        <div class="timer-section">
            <div class="timer" id="countdown">15:00</div>
            <div class="timer-label">Thời gian còn lại để thanh toán</div>
        </div>

        <!-- Status -->
        <div class="status-section pending" id="statusSection">
            <div class="status-icon"><i class="fas fa-spinner fa-spin"></i></div>
            <div class="status-text" id="statusText">Đang chờ thanh toán...</div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <button class="btn btn-primary" id="btnConfirm" onclick="confirmPayment()">
                <i class="fas fa-check"></i> Tôi đã thanh toán
            </button>
            <a href="${pageContext.request.contextPath}/payment/cancel?orderTempId=${transaction.orderTempId}"
               class="btn btn-secondary" onclick="return confirm('Bạn có chắc muốn hủy giao dịch?')">
                <i class="fas fa-times"></i> Hủy
            </a>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    const orderTempId = '${transaction.orderTempId}';
    const contextPath = '${pageContext.request.contextPath}';
    const expiresAt = new Date('${transaction.expiresAt}').getTime();
    let checkInterval;

    // Countdown timer
    function updateCountdown() {
        const now = Date.now();
        const remaining = expiresAt - now;

        if (remaining <= 0) {
            document.getElementById('countdown').textContent = '00:00';
            document.getElementById('countdown').classList.add('warning');
            updateStatus('EXPIRED');
            return;
        }

        const minutes = Math.floor(remaining / 60000);
        const seconds = Math.floor((remaining % 60000) / 1000);
        document.getElementById('countdown').textContent =
            String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');

        if (remaining < 60000) {
            document.getElementById('countdown').classList.add('warning');
        }
    }

    // Check payment status
    function checkPaymentStatus() {
        fetch(contextPath + '/payment/status?orderTempId=' + orderTempId)
            .then(response => response.json())
            .then(data => {
                if (data.status === 'SUCCESS') {
                    updateStatus('SUCCESS');
                    clearInterval(checkInterval);
                    setTimeout(() => {
                        window.location.href = contextPath + '/checkout/success?orderTempId=' + orderTempId;
                    }, 2000);
                } else if (data.status === 'EXPIRED') {
                    updateStatus('EXPIRED');
                    clearInterval(checkInterval);
                }
            })
            .catch(err => console.error('Error checking status:', err));
    }

    // Update status UI
    function updateStatus(status) {
        const section = document.getElementById('statusSection');
        const text = document.getElementById('statusText');
        const icon = section.querySelector('.status-icon i');

        section.className = 'status-section ' + status.toLowerCase();

        if (status === 'SUCCESS') {
            icon.className = 'fas fa-check-circle';
            text.textContent = 'Thanh toán thành công!';
            document.getElementById('btnConfirm').style.display = 'none';
        } else if (status === 'EXPIRED') {
            icon.className = 'fas fa-times-circle';
            text.textContent = 'Giao dịch đã hết hạn';
            document.getElementById('btnConfirm').style.display = 'none';
        } else {
            icon.className = 'fas fa-spinner fa-spin';
            text.textContent = 'Đang chờ thanh toán...';
        }
    }

    // Manual confirm payment
    function confirmPayment() {
        const btn = document.getElementById('btnConfirm');
        btn.disabled = true;
        btn.innerHTML = '<span class="loading-spinner"></span> Đang xử lý...';

        fetch(contextPath + '/payment/confirm', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'orderTempId=' + orderTempId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateStatus('SUCCESS');
                    setTimeout(() => {
                        window.location.href = contextPath + '/checkout/success?orderTempId=' + orderTempId;
                    }, 1500);
                } else {
                    alert(data.message || 'Xác nhận thất bại. Vui lòng thử lại.');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-check"></i> Tôi đã thanh toán';
                }
            })
            .catch(err => {
                console.error('Error:', err);
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-check"></i> Tôi đã thanh toán';
            });
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function () {
        updateCountdown();
        setInterval(updateCountdown, 1000);

        // Check status every 3 seconds
        checkInterval = setInterval(checkPaymentStatus, 3000);
    });
</script>
</body>
</html>
