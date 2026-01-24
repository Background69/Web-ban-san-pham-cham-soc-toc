<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer>
    <!-- Footer Top -->
    <div class="main-footer footer-top">
        <div class="footer-container">

            <div class="footer-col">
                <h4><i class="fas fa-address-card me-2"></i>Liên hệ với chúng tôi</h4>
                <div class="contact-info">
                    <div>
                        <i class="fas fa-map-marker-alt"></i>
                        <p>Trụ sở: Khu Phố 6, P. Linh Trung, Q. Thủ Đức, TP.HCM</p>
                    </div>
                    <div>
                        <i class="fas fa-phone-alt"></i>
                        <p>Hotline tư vấn: (+84) 1234 5678</p>
                    </div>
                    <div>
                        <i class="fas fa-headset"></i>
                        <p>Hotline bán hàng: (+84) 1234 5678</p>
                    </div>
                    <div>
                        <i class="fas fa-envelope"></i>
                        <p>Email: support@hairglow.vn</p>
                    </div>
                    <div>
                        <i class="fas fa-clock"></i>
                        <p>Thứ 2 - Thứ 7: 8:00 - 21:00<br>Chủ nhật: 9:00 - 18:00</p>
                    </div>
                    <div>
                        <i class="fas fa-file-contract"></i>
                        <p>GPKD: 123456789, cấp ngày 20/02/2020, TP. HCM</p>
                    </div>
                </div>
            </div>

            <!-- Categories -->
            <div class="footer-col">
                <h4><i class="fas fa-list me-2"></i>Danh mục</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/store?category=dau-goi"><i
                            class="fas fa-chevron-right me-1"></i>Dầu gội</a></li>
                    <li><a href="${pageContext.request.contextPath}/store?category=dau-xa"><i
                            class="fas fa-chevron-right me-1"></i>Dầu xả</a></li>
                    <li><a href="${pageContext.request.contextPath}/store?category=kem-u"><i
                            class="fas fa-chevron-right me-1"></i>Kem ủ tóc</a></li>
                    <li><a href="${pageContext.request.contextPath}/store?category=serum"><i
                            class="fas fa-chevron-right me-1"></i>Serum dưỡng tóc</a></li>
                    <li><a href="${pageContext.request.contextPath}/store?category=tao-kieu"><i
                            class="fas fa-chevron-right me-1"></i>Sáp vuốt tóc</a></li>
                    <li><a href="${pageContext.request.contextPath}/deals"><i class="fas fa-fire text-warning me-1"></i>Khuyến
                        mãi</a></li>
                </ul>
            </div>

            <!-- Customer Service -->
            <div class="footer-col">
                <h4><i class="fas fa-life-ring me-2"></i>Hỗ trợ khách hàng</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/support#huong-dan"><i
                            class="fas fa-chevron-right me-1"></i>Hướng dẫn mua hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/support#doi-tra"><i
                            class="fas fa-chevron-right me-1"></i>Chính sách đổi trả</a></li>
                    <li><a href="${pageContext.request.contextPath}/support#bao-hanh"><i
                            class="fas fa-chevron-right me-1"></i>Chính sách bảo hành</a></li>
                    <li><a href="${pageContext.request.contextPath}/support#thanh-toan"><i
                            class="fas fa-chevron-right me-1"></i>Phương thức thanh toán</a></li>
                    <li><a href="${pageContext.request.contextPath}/support#van-chuyen"><i
                            class="fas fa-chevron-right me-1"></i>Vận chuyển & Giao hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/support#faq"><i
                            class="fas fa-chevron-right me-1"></i>Câu hỏi thường gặp</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <!-- About Us -->
                <div class="about-us">
                    <h4><i class="fas fa-users me-2"></i>Về chúng tôi</h4>
                    <div class="social-links">
                        <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i
                                class="fab fa-facebook-f"></i></a>
                        <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i
                                class="fab fa-youtube"></i></a>
                        <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i
                                class="fab fa-tiktok"></i></a>
                        <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i
                                class="fas fa-comment-dots"></i></a>
                    </div>
                </div>

                <!-- Payment methods -->
                <div class="payment">
                    <h4><i class="fas fa-credit-card me-2"></i>Thanh toán</h4>
                    <div class="payment-methods">
                        <a class="logo-tile"><img alt="Visa"
                                                  src="${pageContext.request.contextPath}/static/assets/icons/VisaIcon.svg"></a>
                        <a class="logo-tile"><img alt="MasterCard"
                                                  src="${pageContext.request.contextPath}/static/assets/icons/MasterCardIcon.svg"></a>
                        <a class="logo-tile"><img alt="Napas"
                                                  src="${pageContext.request.contextPath}/static/assets/icons/NapasIcon.svg"></a>
                        <a class="logo-tile"><img alt="VNPay"
                                                  src="${pageContext.request.contextPath}/static/assets/icons/VNPayIcon.png"></a>
                        <a class="logo-tile"><img alt="MoMo"
                                                  src="${pageContext.request.contextPath}/static/assets/icons/MoMoIcon.svg"></a>
                    </div>
                </div>

                <!-- Badges -->
                <div class="mt-3">
                    <span class="badge bg-success"><i class="fas fa-check-circle me-1"></i>Chính hãng 100%</span>
                    <span class="badge bg-warning text-dark"><i class="fas fa-award me-1"></i>Uy tín</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer Bottom -->
    <div class="footer-bottom">
        <div class="footer-bottom-content">
            <p><i class="far fa-copyright me-1"></i>2025 Khoa Công Nghệ Thông Tin. Tất cả quyền được bảo lưu.</p>
            <div class="footer-bottom-links">
                <a href="#"><i class="fas fa-file-contract me-1"></i>Điều khoản sử dụng</a>
                <a href="#"><i class="fas fa-user-shield me-1"></i>Chính sách bảo mật</a>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous">
</script>
