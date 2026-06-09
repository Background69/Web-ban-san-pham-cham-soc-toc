(function () {
    'use strict';
    function flyToCart(imgEl, onDone) {
        var cartIcon = document.querySelector('.cart a') ||
                       document.querySelector('.cart');
        if (!cartIcon || !imgEl) {
            if (onDone) onDone();
            return;
        }

        var imgRect  = imgEl.getBoundingClientRect();
        var cartRect = cartIcon.getBoundingClientRect();
        var clone = imgEl.cloneNode(true);
        clone.className = 'fly-clone';
        clone.style.cssText =
            'position:fixed;z-index:99999;pointer-events:none;' +
            'width:' + imgRect.width + 'px;height:' + imgRect.height + 'px;' +
            'left:' + imgRect.left + 'px;top:' + imgRect.top + 'px;' +
            'border-radius:14px;object-fit:cover;' +
            'transition:none;opacity:1;';
        document.body.appendChild(clone);
        var dx = cartRect.left + cartRect.width / 2 - (imgRect.left + imgRect.width / 2);
        var dy = cartRect.top  + cartRect.height / 2 - (imgRect.top  + imgRect.height / 2);
        clone.offsetHeight;

        clone.style.transition = 'transform 0.7s cubic-bezier(.4,0,.2,1), opacity 0.7s ease';
        clone.style.transform  = 'translate(' + dx + 'px, ' + dy + 'px) scale(0.15)';
        clone.style.opacity    = '0.25';

        clone.addEventListener('transitionend', function handler() {
            clone.removeEventListener('transitionend', handler);
            clone.remove();

            var badge = document.getElementById('header-cart-count');
            if (badge) {
                badge.classList.add('bounce');
                setTimeout(function () { badge.classList.remove('bounce'); }, 400);
            }

            if (onDone) onDone();
        });
    }

    function handleReorder(e) {
        e.preventDefault();
        var btn = e.currentTarget;
        if (btn.classList.contains('is-loading')) return;

        var orderId = btn.getAttribute('data-order-id');
        if (!orderId) return;

        btn.classList.add('is-loading');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý…';

        var productImg = document.querySelector('.od-product-item__img');

        flyToCart(productImg, function () {
            var reorderUrl = btn.getAttribute('data-reorder-url') ||
                             (window.location.pathname.replace(/\/[^/]*$/, '') + '/' + orderId + '/reorder');

            fetch(reorderUrl, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (data.success || data.redirect) {
                    if (typeof HairGlow !== 'undefined' && HairGlow.updateCartCount && data.cartCount) {
                        HairGlow.updateCartCount(data.cartCount);
                    }
                    window.location.href = data.redirect || (document.querySelector('meta[name="ctx"]') ?
                        document.querySelector('meta[name="ctx"]').content + '/cart' : '/cart');
                } else {
                    if (typeof HairGlow !== 'undefined' && HairGlow.showToast) {
                        HairGlow.showToast('Lỗi', data.message || 'Không thể mua lại đơn hàng', true);
                    }
                    btn.classList.remove('is-loading');
                    btn.innerHTML = '<span class="od-ctx-btn__icon"><i class="fas fa-cart-plus"></i></span>' +
                                    '<span class="od-ctx-btn__label">Mua lại đơn hàng</span>';
                }
            })
            .catch(function () {
                window.location.href = reorderUrl.replace(/\?.*$/, '');
            });
        });
    }
    var currentReviewData = { rating: 0, productId: null, orderId: null, itemId: null };

    function openReviewModal(e) {
        e.preventDefault();
        var btn = e.currentTarget;
        currentReviewData.productId = btn.getAttribute('data-product-id');
        currentReviewData.orderId   = btn.getAttribute('data-order-id');
        currentReviewData.itemId    = btn.getAttribute('data-item-id');
        currentReviewData.rating    = 0;

        var modal = document.getElementById('reviewModal');
        if (!modal) return;

        var nameEl = modal.querySelector('.rv-modal__product-name');
        if (nameEl) nameEl.textContent = btn.getAttribute('data-product-name') || 'Sản phẩm';

        var imgEl = modal.querySelector('.rv-modal__product-img');
        if (imgEl) imgEl.src = btn.getAttribute('data-product-img') || '';

        resetReviewForm(modal);

        modal.classList.add('is-open');
        document.body.style.overflow = 'hidden';
    }

    function closeReviewModal() {
        var modal = document.getElementById('reviewModal');
        if (!modal) return;
        modal.classList.remove('is-open');
        document.body.style.overflow = '';
    }

    function resetReviewForm(modal) {
        var stars = modal.querySelectorAll('.rv-star');
        stars.forEach(function (s) { s.classList.remove('is-active', 'is-hover'); });

        var textarea = modal.querySelector('.rv-modal__textarea');
        if (textarea) textarea.value = '';

        var preview = modal.querySelector('.rv-modal__img-preview');
        if (preview) preview.innerHTML = '';

        var fileInput = modal.querySelector('.rv-modal__file-input');
        if (fileInput) fileInput.value = '';

        currentReviewData.rating = 0;

        var ratingText = modal.querySelector('.rv-modal__rating-text');
        if (ratingText) ratingText.textContent = 'Chưa chấm điểm';
    }

    function handleStarHover(stars, index) {
        stars.forEach(function (s, i) {
            if (i <= index) {
                s.classList.add('is-hover');
            } else {
                s.classList.remove('is-hover');
            }
        });
    }

    function handleStarLeave(stars) {
        stars.forEach(function (s, i) {
            s.classList.remove('is-hover');
        });
    }

    function handleStarClick(stars, index) {
        currentReviewData.rating = index + 1;
        stars.forEach(function (s, i) {
            if (i <= index) {
                s.classList.add('is-active');
            } else {
                s.classList.remove('is-active');
            }
        });

        var labels = ['Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Tuyệt vời!'];
        var ratingText = document.querySelector('.rv-modal__rating-text');
        if (ratingText) ratingText.textContent = labels[index] + ' (' + (index + 1) + '/5)';
    }

    function handleFilePreview(input) {
        var previewArea = document.querySelector('.rv-modal__img-preview');
        if (!previewArea) return;
        previewArea.innerHTML = '';

        if (!input.files || input.files.length === 0) return;

        Array.prototype.forEach.call(input.files, function (file) {
            if (!file.type.startsWith('image/') && !file.type.startsWith('video/')) return;

            var reader = new FileReader();
            reader.onload = function (e) {
                var wrapper = document.createElement('div');
                wrapper.className = 'rv-preview-thumb';

                if (file.type.startsWith('video/')) {
                    var video = document.createElement('video');
                    video.src = e.target.result;
                    video.muted = true;
                    video.setAttribute('playsinline', '');
                    wrapper.appendChild(video);
                } else {
                    var img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = file.name;
                    wrapper.appendChild(img);
                }

                var removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'rv-preview-thumb__remove';
                removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                removeBtn.addEventListener('click', function () {
                    wrapper.remove();
                });
                wrapper.appendChild(removeBtn);

                previewArea.appendChild(wrapper);
            };
            reader.readAsDataURL(file);
        });
    }

    function handleReviewSubmit(e) {
        e.preventDefault();

        if (currentReviewData.rating === 0) {
            var starsWrap = document.querySelector('.rv-modal__stars');
            if (starsWrap) {
                starsWrap.classList.add('shake');
                setTimeout(function () { starsWrap.classList.remove('shake'); }, 600);
            }
            if (typeof HairGlow !== 'undefined' && HairGlow.showToast) {
                HairGlow.showToast('Chưa chấm điểm', 'Vui lòng chọn số sao đánh giá', true);
            }
            return;
        }

        var modal = document.getElementById('reviewModal');
        var textarea = modal.querySelector('.rv-modal__textarea');
        var submitBtn = modal.querySelector('.rv-modal__submit');

        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi…';

        var formData = new FormData();
        formData.append('rating', currentReviewData.rating);
        formData.append('comment', textarea ? textarea.value : '');
        formData.append('productId', currentReviewData.productId || '');
        formData.append('orderId', currentReviewData.orderId || '');

        var fileInput = modal.querySelector('.rv-modal__file-input');
        if (fileInput && fileInput.files) {
            Array.prototype.forEach.call(fileInput.files, function (f) {
                formData.append('images', f);
            });
        }

        var ctx = '';
        var ctxMeta = document.querySelector('meta[name="ctx"]');
        if (ctxMeta) ctx = ctxMeta.content;

        fetch(ctx + '/reviews/submit', {
            method: 'POST',
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
            body: formData
        })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (data.success) {
                if (typeof HairGlow !== 'undefined' && HairGlow.showToast) {
                    HairGlow.showToast('Cảm ơn bạn!', 'Đánh giá đã được gửi thành công', false);
                }
                closeReviewModal();

                var reviewedBtn = document.querySelector(
                    '.btn-review-product[data-product-id="' + currentReviewData.productId + '"]'
                );
                if (reviewedBtn) {
                    reviewedBtn.classList.add('is-reviewed');
                    reviewedBtn.innerHTML = '<i class="fas fa-check-circle"></i> Đã đánh giá';
                    reviewedBtn.disabled = true;
                }
            } else {
                if (typeof HairGlow !== 'undefined' && HairGlow.showToast) {
                    HairGlow.showToast('Lỗi', data.message || 'Gửi đánh giá thất bại', true);
                }
            }
        })
        .catch(function () {
            if (typeof HairGlow !== 'undefined' && HairGlow.showToast) {
                HairGlow.showToast('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại', true);
            }
        })
        .finally(function () {
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi đánh giá';
        });
    }
    document.addEventListener('DOMContentLoaded', function () {

        document.querySelectorAll('.btn-reorder-fly').forEach(function (btn) {
            btn.addEventListener('click', handleReorder);
        });

        document.querySelectorAll('.btn-review-product').forEach(function (btn) {
            btn.addEventListener('click', openReviewModal);
        });

        var overlay = document.querySelector('.rv-modal-overlay');
        if (overlay) {
            overlay.addEventListener('click', function (e) {
                if (e.target === overlay) closeReviewModal();
            });
        }

        var closeBtn = document.querySelector('.rv-modal__close');
        if (closeBtn) {
            closeBtn.addEventListener('click', closeReviewModal);
        }

        var stars = document.querySelectorAll('.rv-star');
        stars.forEach(function (star, idx) {
            star.addEventListener('mouseenter', function () { handleStarHover(stars, idx); });
            star.addEventListener('mouseleave', function () { handleStarLeave(stars); });
            star.addEventListener('click',      function () { handleStarClick(stars, idx); });
        });

        var fileInput = document.querySelector('.rv-modal__file-input');
        if (fileInput) {
            fileInput.addEventListener('change', function () { handleFilePreview(this); });
        }

        var submitBtn = document.querySelector('.rv-modal__submit');
        if (submitBtn) {
            submitBtn.addEventListener('click', handleReviewSubmit);
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeReviewModal();
        });
    });
})();