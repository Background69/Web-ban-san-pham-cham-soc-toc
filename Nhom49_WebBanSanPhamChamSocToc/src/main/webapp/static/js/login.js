
    const emailInput = document.getElementById("email");

    function showAlert(msg) {
    alert(msg);
}

    function redirect(url) {
    window.location.href = url;
}

    if (document.title.includes("Đăng nhập")) {
    const form = document.querySelector(".login-box form");
    const emailInput = form.querySelector('input[type="email"]');
    const passwordInput = form.querySelector('input[type="password"]');

    if (form) {
    form.addEventListener("submit", (e) => {
    e.preventDefault();
    let email = emailInput.value.trim();
    let password = passwordInput.value.trim();

    if (!email || !password) {
    showAlert("Vui lòng nhập đầy đủ thông tin");
    return;
}

    if (email === "admin") {

    emailInput.setAttribute("type", "text");

    if (password === "admin") {
    showAlert("Đăng nhập Admin thành công!");
    redirect("Dashboard.html"); //
    return;
} else {
    showAlert("Sai mật khẩu admin");
    return;
}
}

    emailInput.setAttribute("type", "email");

    const user = JSON.parse(localStorage.getItem("user"));
    if (user && (email === user.email || email === user.phone) && (password === user.password)) {
    showAlert("Đăng nhập thành công!");
    redirect("MainPage2.html");
} else {
    showAlert("Sai email hoặc mật khẩu");
}
});
}
    emailInput.addEventListener("input", function () {
    const value = emailInput.value.trim();


    if (value === "admin") {
    emailInput.setAttribute("type", "text");
} else if (value.includes("@")) {
    emailInput.setAttribute("type", "email");
}
});

    document.querySelector(".toggle-password").addEventListener("click", function () {
    const input = document.getElementById(this.dataset.target);
    input.type = (input.type === "password") ? "text" : "password";
    this.classList.toggle("fa-eye");
    this.classList.toggle("fa-eye-slash");
});
}
    document.getElementById("confirm-order").addEventListener("click", function () {
        // Hiển thị thông báo
        alert("🎉 Đặt hàng thành công! Cảm ơn bạn đã mua hàng.");

        // Chuyển về trang chủ sau 2 giây
        setTimeout(function () {
            window.location.href = "MainPage.html";
        }, 2000);
    });

    document.addEventListener('DOMContentLoaded', function () {
        const tabButtons = document.querySelectorAll('.main-detail-header .detail-page-btn');
        const tabContents = document.querySelectorAll('.product-main-detail-page .detail-page-content');
        const header = document.querySelector('header');

        function getHeaderOffset() {
            return header ? header.offsetHeight + 20 : 0;
        }

        function activateTab(index) {
            if (!tabButtons[index] || !tabContents[index]) return;

            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));

            const btn = tabButtons[index];
            const content = tabContents[index];

            btn.classList.add('active');
            content.classList.add('active');

            const headerOffset = getHeaderOffset();
            const top = content.getBoundingClientRect().top + window.pageYOffset - headerOffset;

            window.scrollTo({
                top: top,
                behavior: 'smooth'
            });
        }

        // Click nút tab
        tabButtons.forEach((btn, index) => {
            btn.addEventListener('click', function () {
                activateTab(index);
            });
        });

        // Click h2 của từng khối detail-page-content để chuyển
        const headings = document.querySelectorAll('.detail-page-content > h2');
        headings.forEach((heading, index) => {
            heading.style.cursor = 'pointer';
            heading.addEventListener('click', function () {
                activateTab(index);
            });
        });
    });
    document.addEventListener('DOMContentLoaded', function () {
        // format tiền VND đúng chuẩn
        function formatCurrency(value) {
            if (typeof value !== 'number' || isNaN(value)) return '';
            return value.toLocaleString('vi-VN') + '₫';
        }

        // Tự chọn dung tích & cập nhật giá
        const optionButtons = document.querySelectorAll('.product-section-options .option-btn');
        const priceCurrentEl = document.querySelector('.product-section-price .price-current');
        const priceOldEl = document.querySelector('.product-section-price .price-old');
        const discountEl = document.querySelector('.product-section-price .discount-percent');

        if (optionButtons.length && priceCurrentEl && priceOldEl && discountEl) {
            optionButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    optionButtons.forEach(function (b) {
                        b.classList.remove('active');
                    });
                    btn.classList.add('active');

                    const price = parseInt(btn.dataset.price, 10);
                    const oldPrice = parseInt(btn.dataset.oldPrice, 10);

                    if (!isNaN(price)) {
                        priceCurrentEl.textContent = formatCurrency(price);
                    }
                    if (!isNaN(oldPrice)) {
                        priceOldEl.textContent = formatCurrency(oldPrice);
                    }

                    if (!isNaN(price) && !isNaN(oldPrice) && oldPrice > 0) {
                        const discount = Math.round((1 - price / oldPrice) * 100);
                        if (discount > 0) {
                            discountEl.textContent = '-' + discount + '%';
                            discountEl.style.display = '';
                        } else {
                            discountEl.textContent = '';
                            discountEl.style.display = 'none';
                        }
                    }
                });
            });
        }
        // Tăng / giảm số lượng mua
        const qtyInput = document.getElementById('quantity');
        const qtyButtons = document.querySelectorAll('.quantity-selector .qty-btn');

        if (qtyInput) {
            const min = parseInt(qtyInput.min || '1', 10);
            const max = parseInt(qtyInput.max || '99', 10);

            function clampQty(value) {
                if (isNaN(value)) return min;
                return Math.max(min, Math.min(max, value));
            }

            qtyButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    let current = clampQty(parseInt(qtyInput.value, 10));
                    if (btn.textContent.trim() === '-') {
                        current = clampQty(current - 1);
                    } else {
                        current = clampQty(current + 1);
                    }
                    qtyInput.value = current;
                });
            });

            qtyInput.addEventListener('input', function () {
                qtyInput.value = clampQty(parseInt(qtyInput.value, 10));
            });
        }
        // Hiệu ứng & cộng số khi bấm Thêm vào giỏ
        const addCartBtn = document.querySelector('.btn btn-add-cart, .btn-add-cart');
        const cartCountEl = document.querySelector('.cart-count');

        if (addCartBtn) {
            addCartBtn.addEventListener('click', function () {
                // số lượng muốn thêm
                let quantityToAdd = 1;
                if (qtyInput) {
                    quantityToAdd = parseInt(qtyInput.value, 10);
                    if (isNaN(quantityToAdd) || quantityToAdd < 1) quantityToAdd = 1;
                }

                // cộng vào số trên icon giỏ hàng
                if (cartCountEl) {
                    const currentCount = parseInt(cartCountEl.textContent, 10) || 0;
                    cartCountEl.textContent = currentCount + quantityToAdd;
                }

                // hiệu ứng nút
                const originalHTML = addCartBtn.innerHTML;
                addCartBtn.classList.add('added');
                addCartBtn.disabled = true;
                addCartBtn.innerHTML = '<i class="fas fa-check"></i> Đã thêm vào giỏ';

                setTimeout(function () {
                    addCartBtn.classList.remove('added');
                    addCartBtn.disabled = false;
                    addCartBtn.innerHTML = originalHTML;
                }, 2000);
            });
        }
    });