<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán chuyển khoản - HairGlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <style>
        .bank-transfer-page {
            max-width: 1100px;
            margin: 24px auto;
            padding: 0 12px 24px;
        }

        .bank-transfer-card {
            border: 1px solid #e9ecef;
            border-radius: 14px;
            background: #fff;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
        }

        .bank-transfer-head {
            padding: 18px 20px;
            border-bottom: 1px solid #eef1f4;
        }

        .bank-transfer-body {
            padding: 20px;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 13px;
        }

        .status-pending {
            color: #8a6d00;
            background: #fff6d1;
        }

        .status-success {
            color: #0b6d3b;
            background: #d9f7e8;
        }

        .status-expired {
            color: #7c2d12;
            background: #ffedd5;
        }

        .transfer-info p {
            margin-bottom: 8px;
        }

        .transfer-label {
            color: #5f6a75;
            min-width: 150px;
            display: inline-block;
        }

        .qr-box {
            border: 1px solid #eef1f4;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
            background: #fafcfe;
        }

        .qr-box img {
            max-width: 100%;
            width: 300px;
            height: auto;
            border-radius: 8px;
            border: 1px solid #e8edf2;
            background: #fff;
        }

        .qr-box canvas {
            max-width: 100%;
            border-radius: 8px;
            border: 1px solid #e8edf2;
            background: #fff;
        }

        .demo-note {
            border: 1px dashed #f0ad4e;
            background: #fff9ed;
            color: #6f4d0a;
            border-radius: 10px;
            padding: 12px 14px;
            margin-bottom: 16px;
        }

        .transfer-content {
            font-weight: 700;
            color: #1f2937;
        }
    </style>
</head>
<body>
<jsp:include page="/layout/header.jsp"/>

<main class="bank-transfer-page">
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="bank-transfer-card">
        <div class="bank-transfer-head d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h4 class="mb-1">Thanh toán chuyển khoản ngân hàng</h4>
                <small class="text-muted">
                    Giao dịch #${paymentTransaction.transactionId}
                    <c:if test="${not empty order}">
                        | Đơn hàng ${order.orderCode}
                    </c:if>
                </small>
            </div>
            <c:choose>
                <c:when test="${paymentTransaction.status == 'SUCCESS'}">
                    <span class="status-badge status-success">Đã thanh toán</span>
                </c:when>
                <c:when test="${paymentTransaction.status == 'EXPIRED'}">
                    <span class="status-badge status-expired">Đã hết hạn</span>
                </c:when>
                <c:otherwise>
                    <span class="status-badge status-pending">Đang chờ thanh toán</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="bank-transfer-body">
            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="transfer-info">
                        <p><span class="transfer-label">Ngân hàng:</span>
                            <strong><c:out value="${paymentTransaction.bankName}"/></strong></p>
                        <p><span class="transfer-label">Số tài khoản:</span>
                            <strong><c:out value="${paymentTransaction.bankAccount}"/></strong></p>
                        <p><span class="transfer-label">Chủ tài khoản:</span>
                            <strong><c:out value="${paymentTransaction.accountHolder}"/></strong></p>
                        <p><span class="transfer-label">Số tiền:</span>
                            <strong><fmt:formatNumber value="${paymentTransaction.amount}" type="number"/>đ</strong></p>
                        <p><span class="transfer-label">Nội dung CK:</span>
                            <span class="transfer-content"><c:out value="${paymentTransaction.transferContent}"/></span></p>
                        <p><span class="transfer-label">Hạn thanh toán:</span>
                            <c:choose>
                                <c:when test="${not empty paymentTransaction.expiresAt}">
                                    <fmt:formatDate value="${paymentTransaction.expiresAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </c:when>
                                <c:otherwise>Không giới hạn</c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${not empty paymentTransaction.confirmedAt}">
                            <p><span class="transfer-label">Thời gian xác nhận:</span>
                                <fmt:formatDate value="${paymentTransaction.confirmedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                        </c:if>
                    </div>

                    <c:if test="${paymentTransaction.status == 'PENDING'}">
                        <form action="${pageContext.request.contextPath}/payment/bank-transfer/mock-confirm" method="post"
                              class="mt-3">
                            <input type="hidden" name="transactionId" value="${paymentTransaction.transactionId}">
                            <button type="submit" class="btn btn-success"
                                    onclick="return confirm('Xác nhận demo: bạn đã chuyển khoản?')">
                                Tôi đã chuyển khoản (Demo)
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${paymentTransaction.status == 'PENDING'}">
                        <div class="demo-note" style="margin-top: 16px; border-color: #3b82f6; background: #eff6ff; color: #1e40af;">
                            <strong><i class="fas fa-info-circle" style="margin-right: 4px;"></i> Hướng dẫn thanh toán:</strong>
                            <ul style="margin: 8px 0 0 16px; padding: 0; line-height: 1.7;">
                                <li>Quét mã QR hoặc chuyển khoản thủ công theo thông tin bên trên.</li>
                                <li><strong>Nội dung chuyển khoản phải chính xác</strong> để hệ thống đối soát.</li>
                                <li>Sau khi chuyển khoản, đơn hàng sẽ được nhân viên xác nhận
                                    trong vòng <strong>24 giờ</strong> (ngày làm việc).</li>
                                <li>Nếu cần hỗ trợ, vui lòng liên hệ hotline: <strong>1900-xxxx</strong>.</li>
                            </ul>
                        </div>
                    </c:if>

                    <div class="mt-3 d-flex gap-2 flex-wrap">
                        <c:if test="${not empty order}">
                            <a href="${pageContext.request.contextPath}/orders/${order.orderId}"
                               class="btn btn-primary">Xem chi tiết đơn hàng</a>
                        </c:if>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="qr-box">
                        <c:choose>
                            <c:when test="${not empty paymentTransaction.qrCodeUrl
                                && (fn:startsWith(paymentTransaction.qrCodeUrl, 'data:image')
                                || fn:startsWith(paymentTransaction.qrCodeUrl, 'http'))}">
                                <img src="${paymentTransaction.qrCodeUrl}" alt="QR thanh toán">
                                <div class="mt-2 text-muted">Quét mã QR để chuyển khoản</div>
                            </c:when>
                            <c:when test="${not empty paymentTransaction.qrCodeUrl}">
                                <div class="text-start">
                                    <div class="text-center">
                                        <canvas id="rawQrCanvas" width="300" height="300"></canvas>
                                        <div class="mt-2 text-muted">Quét mã QR để chuyển khoản</div>
                                    </div>
                                    <div id="rawQrFallback" class="mt-3">
                                        <p class="mb-1"><strong>Dữ liệu QR:</strong></p>
                                        <textarea id="rawQrData" class="form-control" rows="6"
                                                  readonly><c:out value="${paymentTransaction.qrCodeUrl}"/></textarea>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted">Chưa tạo được ảnh QR. Bạn vẫn có thể chuyển khoản thủ công bằng thông tin bên trái.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.4/build/qrcode.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var qrData = document.getElementById('rawQrData');
        var qrCanvas = document.getElementById('rawQrCanvas');
        var qrFallback = document.getElementById('rawQrFallback');

        if (!qrData || !qrCanvas || !window.QRCode) {
            return;
        }

        QRCode.toCanvas(qrCanvas, qrData.value, {width: 300, margin: 1}, function (error) {
            if (error) {
                qrCanvas.style.display = 'none';
                return;
            }
            if (qrFallback) {
                qrFallback.style.display = 'none';
            }
        });
    });
</script>
</body>
</html>
