<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trung tâm hỗ trợ — HairGlow</title>
    <meta name="description" content="Trung tâm hỗ trợ khách hàng HairGlow — Giải đáp thắc mắc, chính sách mua hàng, vận chuyển, đổi trả và gửi phản hồi.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/support.css">
</head>
<body>

<!-- Header -->
<jsp:include page="/layout/header.jsp"/>

<main class="support-page">
    <section class="sp-hero" id="supportHero">
        <div class="sp-hero-inner">
            <div class="sp-hero-content">
                <h1>Chúng tôi ở đây<br>để <em>hỗ trợ</em> bạn</h1>
                <p class="sp-hero-desc">Tìm câu trả lời nhanh, gửi yêu cầu hỗ trợ và theo dõi phản hồi từ HairGlow trong một không gian rõ ràng, nhẹ nhàng.</p>
                <div class="sp-hero-cta">
                    <a href="#feedbackForm" class="sp-btn sp-btn-primary">
                        <i class="fas fa-paper-plane"></i> Gửi yêu cầu hỗ trợ
                    </a>
                    <a href="#faq" class="sp-btn sp-btn-outline">
                        <i class="fas fa-book-open"></i> Xem câu hỏi thường gặp
                    </a>
                </div>
            </div>

            <div class="sp-hero-visual">
                <div class="sp-promise-card">
                    <h3>Cam kết hỗ trợ</h3>
                    <div class="sp-promise-item">
                        <div class="sp-promise-icon"><i class="fas fa-clock"></i></div>
                        <div class="sp-promise-text">
                            <strong>Phản hồi trong 24 giờ</strong>
                            Mọi yêu cầu đều được xử lý nhanh chóng
                        </div>
                    </div>
                    <div class="sp-promise-item">
                        <div class="sp-promise-icon"><i class="fas fa-truck"></i></div>
                        <div class="sp-promise-text">
                            <strong>Hỗ trợ thanh toán, giao hàng, đổi trả</strong>
                            Đội ngũ chuyên nghiệp luôn sẵn sàng
                        </div>
                    </div>
                    <div class="sp-promise-item">
                        <div class="sp-promise-icon"><i class="fas fa-spa"></i></div>
                        <div class="sp-promise-text">
                            <strong>Tư vấn chăm sóc tóc</strong>
                            Chọn sản phẩm phù hợp với loại tóc
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="sp-container">
        <div class="sp-search-wrap">
            <div class="sp-search">
                <form id="supportSearchForm" autocomplete="off">
                    <span class="sp-search-icon"><i class="fas fa-search"></i></span>
                    <input
                        id="supportSearchInput"
                        type="text"
                        placeholder="Tìm kiếm câu hỏi... VD: đổi trả, thanh toán, vận chuyển"
                        value="<c:out value='${searchQuery}' default=""/>"
                    >
                    <button type="button" class="search-clear" id="searchClear" aria-label="Xóa">
                        <i class="fas fa-times"></i>
                    </button>
                    <button type="submit" class="search-submit" aria-label="Tìm kiếm">
                        <i class="fas fa-arrow-right"></i>
                    </button>
                </form>
                <div id="supportSuggestions" class="support-suggestions"></div>
            </div>
        </div>
        <section class="sp-section">
            <div class="sp-contact-grid">
                <div class="sp-contact-card">
                    <div class="sp-contact-icon"><i class="fas fa-phone"></i></div>
                    <h4>Hotline</h4>
                    <p>(+84) 1234 5678</p>
                    <span>8:00 — 21:00 hàng ngày</span>
                </div>
                <div class="sp-contact-card">
                    <div class="sp-contact-icon"><i class="fas fa-envelope"></i></div>
                    <h4>Email hỗ trợ</h4>
                    <p>support@hairglow.vn</p>
                    <span>Phản hồi trong 24 giờ</span>
                </div>
                <div class="sp-contact-card">
                    <div class="sp-contact-icon"><i class="fas fa-clock"></i></div>
                    <h4>Thời gian hỗ trợ</h4>
                    <p>T2 — CN</p>
                    <span>8:00 sáng — 9:00 tối</span>
                </div>
                <div class="sp-contact-card">
                    <div class="sp-contact-icon"><i class="fas fa-headset"></i></div>
                    <h4>Trung tâm trợ giúp</h4>
                    <p>Hỗ trợ trực tuyến</p>
                    <span>Chat hoặc gọi điện</span>
                </div>
            </div>
        </section>
        <section class="sp-section">
            <div class="sp-section-header">
                <h2>Chọn vấn đề bạn cần hỗ trợ</h2>
                <p>Nhấn vào chủ đề để chuyển tới form gửi yêu cầu hoặc xem câu hỏi liên quan</p>
            </div>

            <div class="sp-topics-grid" id="topicCards">
                <div class="sp-topic-card" data-category="shopping" data-scroll="feedbackForm">
                    <div class="sp-topic-icon"><i class="fas fa-shopping-bag"></i></div>
                    <div class="sp-topic-body">
                        <h4>Đơn hàng & mua hàng</h4>
                        <p>Đặt hàng, hủy đơn, mã giảm giá, hướng dẫn mua sắm</p>
                    </div>
                </div>
                <div class="sp-topic-card" data-category="payment" data-scroll="feedbackForm">
                    <div class="sp-topic-icon"><i class="fas fa-credit-card"></i></div>
                    <div class="sp-topic-body">
                        <h4>Thanh toán</h4>
                        <p>COD, chuyển khoản, MoMo, VNPay, thẻ tín dụng</p>
                    </div>
                </div>
                <div class="sp-topic-card" data-category="shipping" data-scroll="feedbackForm">
                    <div class="sp-topic-icon"><i class="fas fa-truck"></i></div>
                    <div class="sp-topic-body">
                        <h4>Giao hàng & vận chuyển</h4>
                        <p>Theo dõi đơn, thời gian giao, phí vận chuyển</p>
                    </div>
                </div>
                <div class="sp-topic-card" data-category="return" data-scroll="feedbackForm">
                    <div class="sp-topic-icon"><i class="fas fa-exchange-alt"></i></div>
                    <div class="sp-topic-body">
                        <h4>Đổi trả & hoàn tiền</h4>
                        <p>Điều kiện đổi trả, bảo hành, quy trình hoàn tiền</p>
                    </div>
                </div>
                <div class="sp-topic-card" data-category="product" data-scroll="feedbackForm">
                    <div class="sp-topic-icon"><i class="fas fa-spray-can"></i></div>
                    <div class="sp-topic-body">
                        <h4>Tư vấn sản phẩm</h4>
                        <p>Chọn sản phẩm phù hợp, hàng chính hãng, cách sử dụng</p>
                    </div>
                </div>
                <div class="sp-topic-card" data-category="SYSTEM_ERROR" data-scroll="feedbackForm">
                    <div class="sp-topic-icon"><i class="fas fa-bug"></i></div>
                    <div class="sp-topic-body">
                        <h4>Báo lỗi hệ thống</h4>
                        <p>Website lỗi, không thanh toán được, tài khoản bị khóa</p>
                    </div>
                </div>
            </div>
        </section>
        <section id="faq" class="sp-section">
            <div class="sp-section-header">
                <h2>Câu hỏi thường gặp</h2>
                <p>Tìm câu trả lời nhanh cho các thắc mắc phổ biến</p>
            </div>

            <div class="faq-categories">
                <button class="faq-category active" type="button" data-category="all">
                    <i class="fas fa-layer-group"></i> Tất cả
                </button>
                <button class="faq-category" type="button" data-category="shopping">
                    <i class="fas fa-shopping-cart"></i> Mua hàng
                </button>
                <button class="faq-category" type="button" data-category="shipping">
                    <i class="fas fa-truck"></i> Giao nhận
                </button>
                <button class="faq-category" type="button" data-category="return">
                    <i class="fas fa-exchange-alt"></i> Đổi trả
                </button>
                <button class="faq-category" type="button" data-category="payment">
                    <i class="fas fa-credit-card"></i> Thanh toán
                </button>
                <button class="faq-category" type="button" data-category="product">
                    <i class="fas fa-spray-can"></i> Sản phẩm
                </button>
            </div>

            <div class="faq-list" id="faqList">

                <div class="faq-item" data-category="shopping" data-keywords="mua hàng đặt hàng giỏ hàng">
                    <button class="faq-question" type="button" aria-expanded="false">
                        <span>Làm sao để mua hàng?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ol>
                            <li>Tìm sản phẩm bằng danh mục hoặc thanh tìm kiếm.</li>
                            <li>Chọn sản phẩm, số lượng và nhấn "Thêm vào giỏ hàng".</li>
                            <li>Kiểm tra giỏ hàng và điền thông tin giao hàng.</li>
                            <li>Chọn phương thức thanh toán và hoàn tất đơn hàng.</li>
                        </ol>
                    </div>
                </div>

                <div class="faq-item" data-category="shopping" data-keywords="hủy đơn hàng cancel">
                    <button class="faq-question" type="button" aria-expanded="false">
                        <span>Tôi có thể hủy đơn hàng không?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể hủy đơn hàng khi đơn hàng chưa được xác nhận giao cho đơn vị vận chuyển. Vui lòng liên hệ hotline để được hỗ trợ.</p>
                    </div>
                </div>

                <div class="faq-item" data-category="shopping" data-keywords="mã giảm giá voucher khuyến mãi">
                    <button class="faq-question" type="button" aria-expanded="false">
                        <span>Làm sao để nhận mã giảm giá?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể nhận mã giảm giá bằng cách đăng ký thành viên, theo dõi fanpage Facebook hoặc tham gia các chương trình khuyến mãi định kỳ.</p>
                    </div>
                </div>

                <div class="faq-item" data-category="shipping" data-keywords="theo dõi đơn hàng tracking">
                    <button class="faq-question" type="button" aria-expanded="false">
                        <span>Làm sao để theo dõi đơn hàng?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Bạn có thể theo dõi đơn hàng bằng cách đăng nhập vào tài khoản, vào mục "Đơn hàng của tôi" để xem trạng thái đơn hàng.</p>
                    </div>
                </div>

                <div class="faq-item" data-category="shipping" data-keywords="thời gian giao hàng vận chuyển miễn phí">
                    <button class="faq-question" type="button" aria-expanded="false">
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

                <div class="faq-item" data-category="return" data-keywords="đổi trả điều kiện trả hàng">
                    <button class="faq-question" type="button" aria-expanded="false">
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

                <div class="faq-item" data-category="return" data-keywords="quy trình đổi trả sản phẩm lỗi hoàn tiền">
                    <button class="faq-question" type="button" aria-expanded="false">
                        <span>Quy trình đổi trả sản phẩm lỗi như thế nào?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <ol>
                            <li>Liên hệ hotline hoặc email để thông báo yêu cầu đổi trả.</li>
                            <li>Gửi sản phẩm về địa chỉ kho hàng theo hướng dẫn.</li>
                            <li>HairGlow kiểm tra tình trạng sản phẩm.</li>
                            <li>Nhận sản phẩm thay thế hoặc hoàn tiền trong 3-5 ngày làm việc.</li>
                        </ol>
                    </div>
                </div>

                <div class="faq-item" data-category="return" data-keywords="bảo hành chính sách warranty">
                    <button class="faq-question" type="button" aria-expanded="false">
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

                <div class="faq-item" data-category="payment" data-keywords="thanh toán phương thức COD chuyển khoản momo vnpay">
                    <button class="faq-question" type="button" aria-expanded="false">
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

                <div class="faq-item" data-category="product" data-keywords="chính hãng authentic hàng thật">
                    <button class="faq-question" type="button" aria-expanded="false">
                        <span>Sản phẩm có phải hàng chính hãng không?</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="faq-answer">
                        <p>Tất cả sản phẩm tại HairGlow đều là hàng chính hãng 100%, nhập khẩu trực tiếp từ các thương hiệu hoặc nhà phân phối ủy quyền.</p>
                    </div>
                </div>

            </div>

            <p id="faqEmpty" class="faq-empty">Không tìm thấy câu hỏi phù hợp. Hãy thử từ khóa khác hoặc gửi yêu cầu hỗ trợ bên dưới.</p>
        </section>
        <section class="sp-section">
            <div class="sp-section-header">
                <h2>Chính sách hỗ trợ khách hàng</h2>
                <p>Cam kết bảo vệ quyền lợi khách hàng tại HairGlow</p>
            </div>

            <div class="sp-policy-grid">
                <div class="sp-policy-card">
                    <div class="sp-policy-icon"><i class="fas fa-shopping-bag"></i></div>
                    <h4>Mua hàng</h4>
                    <p>Đặt hàng dễ dàng, giao diện thân thiện. Hỗ trợ tư vấn chọn sản phẩm phù hợp với loại tóc.</p>
                </div>
                <div class="sp-policy-card">
                    <div class="sp-policy-icon"><i class="fas fa-credit-card"></i></div>
                    <h4>Thanh toán</h4>
                    <p>Đa dạng phương thức: COD, chuyển khoản, MoMo, VNPay. Bảo mật thông tin tuyệt đối.</p>
                </div>
                <div class="sp-policy-card">
                    <div class="sp-policy-icon"><i class="fas fa-truck-fast"></i></div>
                    <h4>Vận chuyển</h4>
                    <p>Giao hàng toàn quốc. Miễn phí ship đơn từ 500K. Nội thành HCM giao trong ngày.</p>
                </div>
                <div class="sp-policy-card">
                    <div class="sp-policy-icon"><i class="fas fa-rotate-left"></i></div>
                    <h4>Đổi trả</h4>
                    <p>Đổi trả trong 7 ngày. Hoàn tiền 100% nếu sản phẩm lỗi. Quy trình nhanh gọn.</p>
                </div>
            </div>
        </section>
        <section id="feedbackForm" class="sp-section">
            <div class="sp-section-header">
                <h2>Gửi yêu cầu hỗ trợ</h2>
                <p>Mô tả vấn đề của bạn, HairGlow sẽ phản hồi sớm nhất có thể</p>
            </div>

            <div class="sp-feedback-layout">

                <!-- Form card -->
                <div class="sp-form-card">
                    <h3>Thông tin yêu cầu</h3>
                    <p>Vui lòng điền đầy đủ thông tin để chúng tôi hỗ trợ bạn tốt nhất.</p>

                    <form id="feedbackFormEl" novalidate>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fbName">Họ và tên</label>
                                <input type="text" id="fbName" class="form-control"
                                       placeholder="Nhập họ tên"
                                       value="<c:if test='${not empty currentUser}'>${fn:escapeXml(currentUser.username)}</c:if>">
                            </div>
                            <div class="form-group">
                                <label for="fbEmail">Email <span class="required">*</span></label>
                                <input type="email" id="fbEmail" class="form-control"
                                       placeholder="email@example.com"
                                       value="<c:if test='${not empty currentUser}'>${fn:escapeXml(currentUser.email)}</c:if>"
                                       required>
                                <div class="form-error" id="fbEmailError">Vui lòng nhập email hợp lệ</div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="fbCategory">Chủ đề hỗ trợ <span class="required">*</span></label>
                                <select id="fbCategory" class="form-control" required>
                                    <option value="">— Chọn chủ đề —</option>
                                    <option value="SYSTEM_ERROR">Lỗi hệ thống</option>
                                    <option value="SHIPPING">Vận chuyển / Giao hàng</option>
                                    <option value="PRODUCT_QUALITY">Chất lượng sản phẩm</option>
                                    <option value="SHOPPING_GUIDE">Hướng dẫn mua hàng</option>
                                    <option value="OTHER">Khác</option>
                                </select>
                                <div class="form-error" id="fbCategoryError">Vui lòng chọn chủ đề</div>
                            </div>
                            <div class="form-group">
                                <label for="fbTitle">Tiêu đề <span class="required">*</span></label>
                                <input type="text" id="fbTitle" class="form-control"
                                       placeholder="Tóm tắt vấn đề (ít nhất 5 ký tự)"
                                       required minlength="5" maxlength="255">
                                <div class="form-error" id="fbTitleError">Tiêu đề phải có ít nhất 5 ký tự</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="fbContent">Nội dung chi tiết <span class="required">*</span></label>
                            <textarea id="fbContent" class="form-control" rows="5"
                                      placeholder="Mô tả chi tiết vấn đề bạn gặp phải (ít nhất 20 ký tự)"
                                      required minlength="20"></textarea>
                            <div class="form-error" id="fbContentError">Nội dung phải có ít nhất 20 ký tự</div>
                        </div>

                        <div class="form-group">
                            <label>Ảnh đính kèm <span style="color: var(--sp-muted); font-weight: 400;">(tối đa 3 ảnh, mỗi ảnh ≤ 5MB)</span></label>
                            <div class="upload-zone" id="uploadZone">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <p>Kéo thả ảnh vào đây hoặc nhấn để chọn</p>
                                <span>JPG, PNG, WebP — Tối đa 5MB/ảnh</span>
                            </div>
                            <input type="file" id="fbImages" accept="image/jpeg,image/png,image/webp"
                                   multiple style="display: none">
                            <div class="upload-previews" id="uploadPreviews"></div>
                        </div>

                        <input type="hidden" name="_csrf" value="${fn:escapeXml(_csrf)}">

                        <button type="submit" class="btn-submit" id="btnSubmitFeedback">
                            <span class="btn-text"><i class="fas fa-paper-plane"></i> Gửi yêu cầu</span>
                            <span class="spinner"></span>
                        </button>
                    </form>
                </div>

            </div>
        </section>
        <section class="sp-section">
            <div class="sp-section-header">
                <h2>Theo dõi phản hồi</h2>
                <p>Xem trạng thái các yêu cầu hỗ trợ bạn đã gửi</p>
            </div>

            <div class="sp-ticket-card">
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <c:choose>
                            <c:when test="${not empty recentTickets}">
                                <div class="ticket-list">
                                    <c:forEach var="ticket" items="${recentTickets}" end="4">
                                        <div class="ticket-item">
                                            <span class="ticket-code">${fn:escapeXml(ticket.ticketCode)}</span>
                                            <span class="ticket-title">${fn:escapeXml(ticket.title)}</span>
                                            <span class="ticket-status ${fn:toLowerCase(ticket.status)}">
                                                <c:choose>
                                                    <c:when test="${ticket.status == 'RECEIVED'}">Đã tiếp nhận</c:when>
                                                    <c:when test="${ticket.status == 'PROCESSING'}">Đang xử lý</c:when>
                                                    <c:when test="${ticket.status == 'RESOLVED'}">Đã giải quyết</c:when>
                                                    <c:when test="${ticket.status == 'CLOSED'}">Đã đóng</c:when>
                                                    <c:otherwise>${fn:escapeXml(ticket.status)}</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="ticket-date">
                                                <fmt:formatDate value="${ticket.createdAt}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="ticket-login-prompt">
                                    <i class="fas fa-inbox"></i>
                                    Bạn chưa có yêu cầu hỗ trợ nào. Gửi yêu cầu đầu tiên ở phần trên!
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div class="ticket-login-prompt">
                            <i class="fas fa-lock"></i>
                            <a href="${pageContext.request.contextPath}/auth/login?redirect=/support">Đăng nhập</a> để xem lịch sử yêu cầu và theo dõi trạng thái ticket.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>
</main>
<div class="toast-container" id="toastContainer"></div>
<!-- Footer -->
<jsp:include page="/layout/footer.jsp"/>
<script>
(function () {
    'use strict';
    const searchForm = document.getElementById('supportSearchForm');
    const searchInput = document.getElementById('supportSearchInput');
    const searchClear = document.getElementById('searchClear');
    const suggestionsBox = document.getElementById('supportSuggestions');
    const faqItems = Array.from(document.querySelectorAll('.faq-item'));
    const categoryButtons = document.querySelectorAll('.faq-category');
    const emptyMessage = document.getElementById('faqEmpty');
    const feedbackForm = document.getElementById('feedbackFormEl');
    const suggestionListEl = document.getElementById('suggestionList');
    const uploadZone = document.getElementById('uploadZone');
    const fileInput = document.getElementById('fbImages');
    const previewsContainer = document.getElementById('uploadPreviews');
    const submitBtn = document.getElementById('btnSubmitFeedback');
    const toastContainer = document.getElementById('toastContainer');

    let currentCategory = 'all';
    let selectedFiles = [];
    let debounceTimer = null;

    const csrfToken = document.querySelector('input[name="_csrf"]')?.value || '';
    document.querySelectorAll('.sp-topic-card').forEach(card => {
        card.addEventListener('click', () => {
            const cat = card.dataset.category;
            const scrollTarget = card.dataset.scroll;
            const categoryMap = {
                'shopping': 'SHOPPING_GUIDE',
                'payment': 'SHOPPING_GUIDE',
                'shipping': 'SHIPPING',
                'return': 'PRODUCT_QUALITY',
                'product': 'PRODUCT_QUALITY',
                'SYSTEM_ERROR': 'SYSTEM_ERROR'
            };

            const selectEl = document.getElementById('fbCategory');
            if (selectEl && categoryMap[cat]) {
                selectEl.value = categoryMap[cat];
            }

            const faqBtn = document.querySelector('.faq-category[data-category="' + (cat === 'SYSTEM_ERROR' ? 'all' : cat) + '"]');
            if (faqBtn) {
                faqBtn.click();
            }
            if (scrollTarget) {
                const target = document.getElementById(scrollTarget);
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }
        });
    });

    function closeAllFaq() {
        faqItems.forEach(item => {
            item.classList.remove('active');
            const btn = item.querySelector('.faq-question');
            if (btn) btn.setAttribute('aria-expanded', 'false');
        });
    }

    faqItems.forEach(item => {
        const btn = item.querySelector('.faq-question');
        if (!btn) return;
        btn.addEventListener('click', function () {
            const isActive = item.classList.contains('active');
            closeAllFaq();
            if (!isActive) {
                item.classList.add('active');
                btn.setAttribute('aria-expanded', 'true');
            }
        });
    });

    categoryButtons.forEach(button => {
        button.addEventListener('click', function () {
            currentCategory = this.dataset.category;
            categoryButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            closeAllFaq();
            applyFilter();
            suggestionsBox.classList.remove('show');
        });
    });
    function getFaqTitle(item) {
        return item.querySelector('.faq-question span')?.textContent.trim() || '';
    }

    function getFaqSearchText(item) {
        const keywords = item.dataset.keywords || '';
        return (item.textContent + ' ' + keywords).toLowerCase();
    }

    function matchCategory(item) {
        return currentCategory === 'all' || item.dataset.category === currentCategory;
    }

    function matchKeyword(item, keyword) {
        return keyword === '' || getFaqSearchText(item).includes(keyword);
    }

    function applyFilter() {
        const keyword = searchInput.value.trim().toLowerCase();
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

        emptyMessage.classList.toggle('show', visibleCount === 0);
        searchClear.classList.toggle('visible', keyword.length > 0);
    }

    function renderSuggestions() {
        suggestionsBox.innerHTML = '';
        const keyword = searchInput.value.trim().toLowerCase();

        if (keyword === '') {
            suggestionsBox.classList.remove('show');
            return;
        }

        const matched = faqItems
            .filter(item => matchCategory(item) && matchKeyword(item, keyword))
            .slice(0, 5);

        if (matched.length === 0) {
            const empty = document.createElement('div');
            empty.className = 'support-suggestion-empty';
            empty.textContent = 'Không có gợi ý phù hợp';
            suggestionsBox.appendChild(empty);
            suggestionsBox.classList.add('show');
            return;
        }

        matched.forEach(item => {
            const title = getFaqTitle(item);
            const el = document.createElement('div');
            el.className = 'support-suggestion-item';
            el.textContent = title;
            el.addEventListener('click', () => {
                searchInput.value = title;
                suggestionsBox.classList.remove('show');
                faqItems.forEach(f => { f.classList.remove('is-hidden', 'active'); });
                item.classList.add('active');
                item.querySelector('.faq-question')?.setAttribute('aria-expanded', 'true');
                item.scrollIntoView({ behavior: 'smooth', block: 'center' });
            });
            suggestionsBox.appendChild(el);
        });

        suggestionsBox.classList.add('show');
    }

    searchInput.addEventListener('input', () => {
        applyFilter();
        renderSuggestions();
    });

    searchForm.addEventListener('submit', (e) => {
        e.preventDefault();
        applyFilter();
        suggestionsBox.classList.remove('show');
    });

    searchClear.addEventListener('click', () => {
        searchInput.value = '';
        applyFilter();
        suggestionsBox.classList.remove('show');
        searchInput.focus();
    });

    document.addEventListener('click', (e) => {
        if (!searchForm.contains(e.target) && !suggestionsBox.contains(e.target)) {
            suggestionsBox.classList.remove('show');
        }
    });

    uploadZone.addEventListener('click', () => fileInput.click());

    uploadZone.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadZone.classList.add('dragover');
    });

    uploadZone.addEventListener('dragleave', () => {
        uploadZone.classList.remove('dragover');
    });

    uploadZone.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadZone.classList.remove('dragover');
        handleFiles(e.dataTransfer.files);
    });

    fileInput.addEventListener('change', () => {
        handleFiles(fileInput.files);
        fileInput.value = '';
    });

    function handleFiles(files) {
        const allowedTypes = ['image/jpeg', 'image/png', 'image/webp'];
        const maxSize = 5 * 1024 * 1024;

        for (const file of files) {
            if (selectedFiles.length >= 3) {
                showToast('Tối đa 3 ảnh', 'Bạn chỉ có thể đính kèm tối đa 3 ảnh.', true);
                break;
            }
            if (!allowedTypes.includes(file.type)) {
                showToast('File không hợp lệ', file.name + ' không phải định dạng JPG/PNG/WebP.', true);
                continue;
            }
            if (file.size > maxSize) {
                showToast('File quá lớn', file.name + ' vượt quá 5MB.', true);
                continue;
            }
            selectedFiles.push(file);
        }
        renderPreviews();
    }

    function renderPreviews() {
        previewsContainer.innerHTML = '';
        selectedFiles.forEach((file, index) => {
            const wrapper = document.createElement('div');
            wrapper.className = 'upload-preview';

            const img = document.createElement('img');
            img.src = URL.createObjectURL(file);
            img.alt = file.name;

            const removeBtn = document.createElement('button');
            removeBtn.className = 'remove-btn';
            removeBtn.type = 'button';
            removeBtn.innerHTML = '<i class="fas fa-times"></i>';
            removeBtn.addEventListener('click', () => {
                selectedFiles.splice(index, 1);
                renderPreviews();
            });

            wrapper.appendChild(img);
            wrapper.appendChild(removeBtn);
            previewsContainer.appendChild(wrapper);
        });
    }

    feedbackForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        let isValid = true;

        const email = document.getElementById('fbEmail');
        const category = document.getElementById('fbCategory');
        const title = document.getElementById('fbTitle');
        const content = document.getElementById('fbContent');

        const emailRegex = /^[\w.+-]+@[\w.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(email.value.trim())) {
            email.classList.add('error');
            document.getElementById('fbEmailError').classList.add('visible');
            isValid = false;
        } else {
            email.classList.remove('error');
            document.getElementById('fbEmailError').classList.remove('visible');
        }

        if (!category.value) {
            category.classList.add('error');
            document.getElementById('fbCategoryError').classList.add('visible');
            isValid = false;
        } else {
            category.classList.remove('error');
            document.getElementById('fbCategoryError').classList.remove('visible');
        }

        if (title.value.trim().length < 5) {
            title.classList.add('error');
            document.getElementById('fbTitleError').classList.add('visible');
            isValid = false;
        } else {
            title.classList.remove('error');
            document.getElementById('fbTitleError').classList.remove('visible');
        }

        if (content.value.trim().length < 20) {
            content.classList.add('error');
            document.getElementById('fbContentError').classList.add('visible');
            isValid = false;
        } else {
            content.classList.remove('error');
            document.getElementById('fbContentError').classList.remove('visible');
        }

        if (!isValid) return;

        const formData = new FormData();
        formData.append('category', category.value);
        formData.append('title', title.value.trim());
        formData.append('content', content.value.trim());
        formData.append('customerName', document.getElementById('fbName').value.trim());
        formData.append('customerEmail', email.value.trim());

        selectedFiles.forEach(file => {
            formData.append('images', file);
        });

        submitBtn.classList.add('loading');
        submitBtn.disabled = true;

        try {
            const response = await fetch('${pageContext.request.contextPath}/support/feedback', {
                method: 'POST',
                headers: { 'X-CSRF-TOKEN': csrfToken },
                body: formData
            });

            const result = await response.json();

            if (result.success) {
                showToast('Gửi thành công!', result.message);
                feedbackForm.reset();
                selectedFiles = [];
                renderPreviews();
                <c:if test="${not empty currentUser}">
                document.getElementById('fbName').value = '${fn:escapeXml(currentUser.username)}';
                document.getElementById('fbEmail').value = '${fn:escapeXml(currentUser.email)}';
                </c:if>
            } else {
                showToast('Gửi thất bại', result.message || 'Có lỗi xảy ra.', true);
            }
        } catch (err) {
            showToast('Lỗi kết nối', 'Không thể gửi phản hồi. Vui lòng thử lại sau.', true);
        } finally {
            submitBtn.classList.remove('loading');
            submitBtn.disabled = false;
        }
    });

    ['fbEmail', 'fbCategory', 'fbTitle', 'fbContent'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('input', () => {
                el.classList.remove('error');
                const errorEl = document.getElementById(id + 'Error');
                if (errorEl) errorEl.classList.remove('visible');
            });
        }
    });

    const contentField = document.getElementById('fbContent');
    const titleField = document.getElementById('fbTitle');

    function updateSmartSuggestions() {
        const text = (titleField.value + ' ' + contentField.value).toLowerCase();

        if (text.trim().length < 5) {
            suggestionListEl.innerHTML = '<div class="suggestions-empty"><i class="fas fa-search"></i>Nhập nội dung để nhận gợi ý</div>';
            return;
        }

        const words = text.split(/\s+/).filter(w => w.length > 2);
        const scored = faqItems.map(item => {
            const searchText = getFaqSearchText(item);
            let score = 0;
            words.forEach(word => {
                if (searchText.includes(word)) score++;
            });
            return { item, score };
        }).filter(s => s.score > 0)
          .sort((a, b) => b.score - a.score)
          .slice(0, 4);

        if (scored.length === 0) {
            suggestionListEl.innerHTML = '<div class="suggestions-empty"><i class="fas fa-search"></i>Không tìm thấy gợi ý phù hợp</div>';
            return;
        }

        suggestionListEl.innerHTML = '';
        scored.forEach(({ item }) => {
            const t = getFaqTitle(item);
            const el = document.createElement('div');
            el.className = 'suggestion-item';
            el.innerHTML = '<i class="fas fa-lightbulb"></i><span>' + escapeHtml(t) + '</span>';
            el.addEventListener('click', () => {
                closeAllFaq();
                faqItems.forEach(f => f.classList.remove('is-hidden'));
                item.classList.add('active');
                item.querySelector('.faq-question')?.setAttribute('aria-expanded', 'true');
                item.scrollIntoView({ behavior: 'smooth', block: 'center' });
            });
            suggestionListEl.appendChild(el);
        });
    }

    function debounceSuggestions() {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(updateSmartSuggestions, 300);
    }

    titleField.addEventListener('input', debounceSuggestions);
    contentField.addEventListener('input', debounceSuggestions);

    function showToast(title, message, isError) {
        const toast = document.createElement('div');
        toast.className = 'toast' + (isError ? ' error' : '');

        toast.innerHTML =
            '<div class="toast-icon"><i class="fas fa-' + (isError ? 'exclamation-triangle' : 'check') + '"></i></div>' +
            '<div class="toast-body"><div class="toast-title">' + escapeHtml(title) + '</div>' +
            '<div class="toast-message">' + escapeHtml(message) + '</div></div>' +
            '<button class="toast-close" type="button"><i class="fas fa-times"></i></button>';

        toast.querySelector('.toast-close').addEventListener('click', () => removeToast(toast));
        toastContainer.appendChild(toast);
        setTimeout(() => removeToast(toast), 6000);
    }

    function removeToast(toast) {
        if (!toast || toast.classList.contains('removing')) return;
        toast.classList.add('removing');
        setTimeout(() => toast.remove(), 250);
    }

    function escapeHtml(str) {
        const div = document.createElement('div');
        div.textContent = str || '';
        return div.innerHTML;
    }

    document.querySelectorAll('.sp-btn[href^="#"], .sp-hero-cta a[href^="#"]').forEach(link => {
        link.addEventListener('click', (e) => {
            const targetId = link.getAttribute('href').slice(1);
            const target = document.getElementById(targetId);
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });
    if (searchInput.value.trim()) {
        applyFilter();
    }
})();
</script>
</body>
</html>