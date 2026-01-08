document.addEventListener('DOMContentLoaded', function () {
    const mainImg = document.querySelector('.product-detail-image .product-image');
    const thumbWrap = document.querySelector('.thumbnail-images');
    const thumbs = Array.from(document.querySelectorAll('.thumbnail-images .thumbnail'));
    if (!mainImg || !thumbWrap || thumbs.length === 0) return;

    function setActiveThumb(thumb, animate = true) {
        if (!thumb) return;
        // đổi viền xanh
        thumbs.forEach(t => t.classList.remove('active'));
        thumb.classList.add('active');

        const newSrc = thumb.getAttribute('data-full') || thumb.getAttribute('src');
        const newAlt = thumb.getAttribute('alt') || 'Product image';
        if (!newSrc) return;

        if (animate) {
            mainImg.classList.add('is-fading');
            setTimeout(() => {
                mainImg.src = newSrc;
                mainImg.alt = newAlt;
                mainImg.classList.remove('is-fading');
            }, 120);
        } else {
            mainImg.src = newSrc;
            mainImg.alt = newAlt;
        }
    }

    // khi tải trang ưu tiên ảnh đang active
    setActiveThumb(thumbWrap.querySelector('.thumbnail.active') || thumbs[0], false);

    // nhấn ảnh (dùng event delegation)
    thumbWrap.addEventListener('click', function (e) {
        const thumb = e.target.closest('.thumbnail');
        if (!thumb) return;
        setActiveThumb(thumb, true);
    });
});


    document.addEventListener('DOMContentLoaded', function () {
        // format tiền VND đúng chuẩn
        function formatCurrency(value) {
            if (typeof value !== 'number' || isNaN(value)) return '';
            return value.toLocaleString('vi-VN') + '₫';


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
                })
            }
        }
    })
