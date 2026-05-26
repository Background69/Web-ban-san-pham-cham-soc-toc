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

        <!-- Trung tâm hỗ trợ -->
        <section id="faq" class="support-section">
            <h2><i class="fas fa-life-ring"></i> Trung tâm hỗ trợ</h2>

            <div class="faq-categories">
                <button class="faq-category active" type="button" data-category="all">
                    <i class="fas fa-layer-group"></i>
                    Tất cả
                </button>

                <button class="faq-category" type="button" data-category="shopping">
                    <i class="fas fa-shopping-cart"></i>
                    Mua hàng
                </button>

                <button class="faq-category" type="button" data-category="shipping">
                    <i class="fas fa-truck"></i>
                    Giao nhận
                </button>

                <button class="faq-category" type="button" data-category="return">
                    <i class="fas fa-exchange-alt"></i>
                    Đổi trả & Bảo hành
                </button>

                <button class="faq-category" type="button" data-category="payment">
                    <i class="fas fa-credit-card"></i>
                    Thanh toán
                </button>

                <button class="faq-category" type="button" data-category="product">
                    <i class="fas fa-spray-can"></i>
                    Sản phẩm
                </button>
            </div>

            <div class="faq-list">

                <div class="faq-item" data-category="shopping">
                    <button class="faq-question" type="button">
                        <span>Làm sao để mua hàng?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ol class="support-steps">
                            <li>Tìm sản phẩm bằng danh mục hoặc thanh tìm kiếm.</li>
                            <li>Chọn sản phẩm, số lượng và nhấn “Thêm vào giỏ hàng”.</li>
                            <li>Kiểm tra giỏ hàng và điền thông tin giao hàng.</li>
                            <li>Chọn phương thức thanh toán và hoàn tất đơn hàng.</li>
                        </ol>
                    </div>
                </div>

                <div class="faq-item" data-category="shipping">
                    <button class="faq-question" type="button">
                        <span>Làm sao để theo dõi đơn hàng?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể theo dõi đơn hàng bằng cách đăng nhập vào tài khoản, vào mục “Đơn hàng của tôi” để
                            xem trạng thái đơn hàng.</p>
                    </div>
                </div>

                <div class="faq-item" data-category="shipping">
                    <button class="faq-question" type="button">
                        <span>Thời gian giao hàng là bao lâu?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ul>
                            <li>Giao hàng tiêu chuẩn: 3-5 ngày.</li>
                            <li>Giao hàng nhanh: 1-2 ngày.</li>
                            <li>Nội thành TP.HCM: có thể giao trong ngày.</li>
                            <li>Miễn phí vận chuyển cho đơn hàng từ 500.000₫.</li>
                        </ul>
                    </div>
                </div>

                <div class="faq-item" data-category="return">
                    <button class="faq-question" type="button">
                        <span>Điều kiện đổi trả sản phẩm là gì?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ul>
                            <li>Sản phẩm còn nguyên tem, nhãn mác và chưa qua sử dụng.</li>
                            <li>Sản phẩm bị lỗi do nhà sản xuất.</li>
                            <li>Sản phẩm giao không đúng với đơn hàng.</li>
                            <li>Thời gian đổi trả trong vòng 7 ngày kể từ ngày nhận hàng.</li>
                        </ul>
                    </div>
                </div>

                <div class="faq-item" data-category="return">
                    <button class="faq-question" type="button">
                        <span>Quy trình đổi trả sản phẩm lỗi như thế nào?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ol class="support-steps">
                            <li>Liên hệ hotline hoặc email để thông báo yêu cầu đổi trả.</li>
                            <li>Gửi sản phẩm về địa chỉ kho hàng theo hướng dẫn.</li>
                            <li>HairGlow kiểm tra tình trạng sản phẩm.</li>
                            <li>Nhận sản phẩm thay thế hoặc hoàn tiền trong 3-5 ngày làm việc.</li>
                        </ol>
                    </div>
                </div>

                <div class="faq-item" data-category="return">
                    <button class="faq-question" type="button">
                        <span>Chính sách bảo hành sản phẩm ra sao?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ul>
                            <li>Sản phẩm lỗi do nhà sản xuất được đổi mới trong 30 ngày.</li>
                            <li>Bảo hành chất lượng theo chính sách của từng thương hiệu.</li>
                            <li>Hỗ trợ tư vấn sử dụng sản phẩm miễn phí.</li>
                        </ul>
                    </div>
                </div>

                <div class="faq-item" data-category="payment">
                    <button class="faq-question" type="button">
                        <span>HairGlow hỗ trợ những phương thức thanh toán nào?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ul>
                            <li>Thanh toán khi nhận hàng (COD).</li>
                            <li>Chuyển khoản ngân hàng.</li>
                            <li>Thanh toán qua ví điện tử như MoMo, VNPay, ZaloPay.</li>
                            <li>Thanh toán bằng thẻ tín dụng hoặc thẻ ghi nợ.</li>
                        </ul>
                    </div>
                </div>

                <div class="faq-item" data-category="product">
                    <button class="faq-question" type="button">
                        <span>Sản phẩm có phải hàng chính hãng không?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Tất cả sản phẩm tại HairGlow đều là hàng chính hãng 100%, nhập khẩu trực tiếp từ các thương
                            hiệu hoặc nhà phân phối ủy quyền.</p>
                    </div>
                </div>

                <div class="faq-item" data-category="shopping">
                    <button class="faq-question" type="button">
                        <span>Tôi có thể hủy đơn hàng không?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể hủy đơn hàng khi đơn hàng chưa được xác nhận giao cho đơn vị vận chuyển. Vui lòng
                            liên hệ hotline để được hỗ trợ.</p>
                    </div>
                </div>

                <div class="faq-item" data-category="shopping">
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

            <p id="faqEmpty" class="faq-empty">Không tìm thấy nội dung hỗ trợ phù hợp.</p>
        </section>


    </div>
</main>

<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>

<script>
    (function () {
        const form = document.getElementById('supportSearchForm');
        const input = document.getElementById('supportSearchInput');
        const suggestionsBox = document.getElementById('supportSuggestions');
        const faqItems = Array.from(document.querySelectorAll('#faq .faq-item'));
        const faqButtons = document.querySelectorAll('.faq-question');
        const categoryButtons = document.querySelectorAll('.faq-category');
        const emptyMessage = document.getElementById('faqEmpty');

        let currentCategory = 'all';

        if (!form || !input || !suggestionsBox) return;

        function getFaqTitle(item) {
            return item.querySelector('.faq-question span')?.textContent.trim() || '';
        }

        function getFaqText(item) {
            return item.textContent.toLowerCase();
        }

        function closeAllFaq() {
            faqItems.forEach(item => {
                item.classList.remove('active');
                item.querySelector('.faq-question')?.setAttribute('aria-expanded', 'false');
            });
        }

        faqButtons.forEach(button => {
            button.setAttribute('aria-expanded', 'false');

            button.addEventListener('click', function () {
                const faqItem = this.closest('.faq-item');
                const isActive = faqItem.classList.contains('active');

                closeAllFaq();

                if (!isActive) {
                    faqItem.classList.add('active');
                    this.setAttribute('aria-expanded', 'true');
                }
            });
        });

        categoryButtons.forEach(button => {
            button.addEventListener('click', function () {
                currentCategory = this.dataset.category;

                categoryButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');

                closeAllFaq();
                applyFilter();
                suggestionsBox.classList.remove('show');
            });
        });

        function matchCategory(item) {
            return currentCategory === 'all' || item.dataset.category === currentCategory;
        }

        function matchKeyword(item, keyword) {
            return keyword === '' || getFaqText(item).includes(keyword);
        }

        function applyFilter() {
            const keyword = input.value.trim().toLowerCase();
            let visibleCount = 0;

            faqItems.forEach(item => {
                const isMatched = matchCategory(item) && matchKeyword(item, keyword);

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

        function renderSuggestions() {
            suggestionsBox.innerHTML = '';

            const keyword = input.value.trim().toLowerCase();

            if (keyword === '') {
                suggestionsBox.classList.remove('show');
                return;
            }

            const matchedItems = faqItems
                .filter(item => matchCategory(item) && matchKeyword(item, keyword))
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
                        faq.classList.remove('is-hidden');
                        faq.classList.remove('active');
                    });

                    item.classList.add('active');
                    item.querySelector('.faq-question')?.setAttribute('aria-expanded', 'true');

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
            applyFilter();
            renderSuggestions();
        });

        form.addEventListener('submit', function (e) {
            e.preventDefault();
            applyFilter();
            renderSuggestions();
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

