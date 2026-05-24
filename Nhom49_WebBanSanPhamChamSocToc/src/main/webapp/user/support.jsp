<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ trợ khách hàng - HairGlow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/support.css">
</head>
<body>

<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="support-main">

    <!-- Banner -->
    <section class="support-banner">
        <div class="support-banner-content">
            <h1><i class="fas fa-headset"></i> Hỗ trợ khách hàng</h1>
            <p>Chúng tôi luôn sẵn sàng giúp đỡ bạn</p>
        </div>
    </section>

    <div class="support-container">

        <!-- Tìm kiếm -->
        <div class="support-search">
            <form id="supportSearchForm" action="${pageContext.request.contextPath}/support" method="get"
                  autocomplete="off">
                <input
                        id="supportSearchInput"
                        type="text"
                        name="q"
                        placeholder="Bạn cần hỗ trợ gì? Nhập từ khóa như đổi trả, thanh toán, vận chuyển..."
                        value="<c:out value='${searchQuery}' default=""/>"
                >
                <button type="submit" aria-label="Tìm kiếm">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <div id="supportSuggestions" class="support-suggestions"></div>
        </div>

        <!-- Thông tin liên hệ nhanh -->
        <div class="contact-quick">
            <div class="contact-item">
                <div class="contact-icon">
                    <i class="fas fa-phone"></i>
                </div>
                <div class="contact-body">
                    <h3>Hotline</h3>
                    <p>(+84) 1234 5678</p>
                    <span>8:00 - 21:00 hàng ngày</span>
                </div>
            </div>

            <div class="contact-item">
                <div class="contact-icon">
                    <i class="fas fa-envelope"></i>
                </div>
                <div class="contact-body">
                    <h3>Email</h3>
                    <p>support@hairglow.vn</p>
                    <span>Phản hồi trong 24 giờ</span>
                </div>
            </div>

        </div>

        <!-- Hướng dẫn mua hàng -->
        <section id="huong-dan" class="support-section">
            <h2><i class="fas fa-shopping-cart"></i> Hướng dẫn mua hàng</h2>

            <div class="guide-steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <h4>Tìm sản phẩm</h4>
                    <p>Duyệt danh mục hoặc sử dụng thanh tìm kiếm để tìm sản phẩm bạn cần.</p>
                </div>
                <div class="step">
                    <div class="step-number">2</div>
                    <h4>Thêm vào giỏ</h4>
                    <p>Chọn số lượng và nhấn "Thêm vào giỏ hàng".</p>
                </div>
                <div class="step">
                    <div class="step-number">3</div>
                    <h4>Thanh toán</h4>
                    <p>Kiểm tra giỏ hàng, điền thông tin giao hàng và chọn phương thức thanh toán.</p>
                </div>
                <div class="step">
                    <div class="step-number">4</div>
                    <h4>Nhận hàng</h4>
                    <p>Theo dõi đơn hàng và nhận sản phẩm tại địa chỉ đã đăng ký.</p>
                </div>
            </div>
        </section>

        <!-- Chính sách đổi trả -->
        <section id="doi-tra" class="support-section">
            <h2><i class="fas fa-exchange-alt"></i> Chính sách đổi trả</h2>

            <div class="policy-content">
                <h4>Điều kiện đổi trả:</h4>
                <ul>
                    <li>Sản phẩm còn nguyên tem, nhãn mác, chưa qua sử dụng</li>
                    <li>Sản phẩm bị lỗi do nhà sản xuất</li>
                    <li>Sản phẩm giao không đúng với đơn hàng</li>
                    <li>Thời gian đổi trả: trong vòng 7 ngày kể từ ngày nhận hàng</li>
                </ul>

                <h4>Quy trình đổi trả:</h4>
                <ol>
                    <li>Liên hệ hotline hoặc email để thông báo đổi trả</li>
                    <li>Gửi sản phẩm về địa chỉ kho hàng (chi phí vận chuyển do HairGlow chịu nếu lỗi từ shop)</li>
                    <li>Nhận sản phẩm thay thế hoặc hoàn tiền trong 3-5 ngày làm việc</li>
                </ol>
            </div>
        </section>

        <!-- Chính sách bảo hành -->
        <section id="bao-hanh" class="support-section">
            <h2><i class="fas fa-shield-alt"></i> Chính sách bảo hành</h2>

            <div class="policy-content">
                <p>HairGlow cam kết tất cả sản phẩm đều là hàng chính hãng 100%.</p>
                <ul>
                    <li>Sản phẩm lỗi do nhà sản xuất được đổi mới trong 30 ngày</li>
                    <li>Bảo hành chất lượng theo chính sách của từng thương hiệu</li>
                    <li>Hỗ trợ tư vấn sử dụng sản phẩm miễn phí</li>
                </ul>
            </div>
        </section>

        <!-- Phương thức thanh toán -->
        <section id="thanh-toan" class="support-section">
            <h2><i class="fas fa-credit-card"></i> Phương thức thanh toán</h2>

            <div class="payment-methods">
                <div class="method">
                    <i class="fas fa-money-bill-wave"></i>
                    <h4>Thanh toán khi nhận hàng (COD)</h4>
                    <p>Thanh toán trực tiếp cho nhân viên giao hàng khi nhận sản phẩm.</p>
                </div>
                <div class="method">
                    <i class="fas fa-university"></i>
                    <h4>Chuyển khoản ngân hàng</h4>
                    <p>Chuyển khoản trước khi giao hàng. Hỗ trợ tất cả ngân hàng nội địa.</p>
                </div>
                <div class="method">
                    <i class="fas fa-wallet"></i>
                    <h4>Ví điện tử</h4>
                    <p>Thanh toán qua MoMo, VNPay, ZaloPay.</p>
                </div>
                <div class="method">
                    <i class="far fa-credit-card"></i>
                    <h4>Thẻ tín dụng/ghi nợ</h4>
                    <p>Visa, Mastercard, JCB với bảo mật 3D Secure.</p>
                </div>
            </div>
        </section>

        <!-- Vận chuyển & Giao hàng -->
        <section id="van-chuyen" class="support-section">
            <h2><i class="fas fa-truck"></i> Vận chuyển & Giao hàng</h2>

            <div class="shipping-info">
                <table class="shipping-table">
                    <thead>
                    <tr>
                        <th>Phương thức</th>
                        <th>Thời gian</th>
                        <th>Phí vận chuyển</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Giao hàng tiêu chuẩn</td>
                        <td>3-5 ngày</td>
                        <td>30.000₫</td>
                    </tr>
                    <tr>
                        <td>Giao hàng nhanh</td>
                        <td>1-2 ngày</td>
                        <td>40.000₫</td>
                    </tr>
                    <tr>
                        <td>Nội thành TP.HCM</td>
                        <td>Trong ngày</td>
                        <td>25.000₫</td>
                    </tr>
                    </tbody>
                </table>

                <p class="note"><i class="fas fa-info-circle"></i> Miễn phí vận chuyển cho đơn hàng từ 500.000₫</p>
            </div>
        </section>

        <!-- Câu hỏi thường gặp -->
        <section id="faq" class="support-section">
            <h2><i class="fas fa-question-circle"></i> Câu hỏi thường gặp</h2>

            <div class="faq-list">
                <div class="faq-item">
                    <button class="faq-question" type="button">
                        <span>Làm sao để theo dõi đơn hàng?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể theo dõi đơn hàng bằng cách đăng nhập vào tài khoản, vào mục "Đơn hàng của tôi" để
                            xem trạng thái đơn hàng.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" type="button">
                        <span>Sản phẩm có phải hàng chính hãng không?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Tất cả sản phẩm tại HairGlow đều là hàng chính hãng 100%, nhập khẩu trực tiếp từ các thương
                            hiệu hoặc nhà phân phối ủy quyền.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" type="button">
                        <span>Tôi có thể hủy đơn hàng không?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể hủy đơn hàng khi đơn hàng chưa được xác nhận giao cho đơn vị vận chuyển. Vui lòng
                            liên hệ hotline để được hỗ trợ.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question" type="button">
                        <span>Làm sao để nhận mã giảm giá?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể nhận mã giảm giá bằng cách đăng ký thành viên, theo dõi fanpage Facebook hoặc tham
                            gia các chương trình khuyến mãi định kỳ.</p>
                    </div>
                </div>
            </div>
        </section>

    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    document.querySelectorAll('.faq-question').forEach(btn => {
        btn.addEventListener('click', function () {
            const faqItem = this.closest('.faq-item');
            const isActive = faqItem.classList.contains('active');

            document.querySelectorAll('.faq-item').forEach(item => {
                item.classList.remove('active');
                item.querySelector('.faq-question').setAttribute('aria-expanded', 'false');
            });

            if (!isActive) {
                faqItem.classList.add('active');
                this.setAttribute('aria-expanded', 'true');
            }
        });
    });

    (function () {
        const form = document.getElementById('supportSearchForm');
        const input = document.getElementById('supportSearchInput');
        const suggestionsBox = document.getElementById('supportSuggestions');
        const faqItems = Array.from(document.querySelectorAll('#faq .faq-item'));
        const emptyMessage = document.getElementById('faqEmpty');

        if (!form || !input || !suggestionsBox) return;

        function getFaqTitle(item) {
            return item.querySelector('.faq-question span')?.textContent.trim() || '';
        }

        function getFaqText(item) {
            return item.textContent.toLowerCase();
        }

        function filterFaq(keyword) {
            let visibleCount = 0;

            faqItems.forEach(item => {
                const isMatched = keyword === '' || getFaqText(item).includes(keyword);

                item.classList.toggle('is-hidden', !isMatched);

                if (isMatched) {
                    visibleCount++;
                } else {
                    item.classList.remove('active');
                }
            });

            if (emptyMessage) {
                emptyMessage.classList.toggle('show', visibleCount === 0);
            }
        }

        function renderSuggestions(keyword) {
            suggestionsBox.innerHTML = '';

            if (keyword === '') {
                suggestionsBox.classList.remove('show');
                return;
            }

            const matchedItems = faqItems
                .filter(item => getFaqText(item).includes(keyword))
                .slice(0, 5);

            if (matchedItems.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'support-suggestion-empty';
                empty.textContent = 'Không có gợi ý phù hợp';
                suggestionsBox.appendChild(empty);
                suggestionsBox.classList.add('show');
                return;
            }

            matchedItems.forEach(item => {
                const title = getFaqTitle(item);

                const suggestion = document.createElement('div');
                suggestion.className = 'support-suggestion-item';
                suggestion.textContent = title;

                suggestion.addEventListener('click', function () {
                    input.value = title;
                    suggestionsBox.classList.remove('show');

                    faqItems.forEach(faq => {
                        faq.classList.toggle('is-hidden', faq !== item);
                        faq.classList.remove('active');
                    });

                    item.classList.add('active');
                    item.scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                    });
                });

                suggestionsBox.appendChild(suggestion);
            });

            suggestionsBox.classList.add('show');
        }

        input.addEventListener('input', function () {
            const keyword = input.value.trim().toLowerCase();

            filterFaq(keyword);
            renderSuggestions(keyword);
        });

        form.addEventListener('submit', function (e) {
            e.preventDefault();

            const keyword = input.value.trim().toLowerCase();
            filterFaq(keyword);
            renderSuggestions(keyword);
        });

        document.addEventListener('click', function (e) {
            if (!form.contains(e.target) && !suggestionsBox.contains(e.target)) {
                suggestionsBox.classList.remove('show');
            }
        });
    })();
</script>

</body>
</html>

