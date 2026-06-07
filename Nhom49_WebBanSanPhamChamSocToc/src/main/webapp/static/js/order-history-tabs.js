/**
 * Order History Tabs — SPA Experience
 * ====================================
 * 1. Sliding Tab Indicator (thanh trượt xanh lục bảo)
 * 2. Client-side Filtering (không reload trang)
 * 3. Fade Animation (mượt mà, stagger effect)
 */

(function () {
    'use strict';

    // ── DOM References ──────────────────────────────────
    const tabContainer = document.getElementById('orderFilterTabs');
    const ordersList   = document.getElementById('ordersListContainer');
    const emptyState   = document.getElementById('emptyStateFiltered');

    if (!tabContainer || !ordersList) return;

    const tabs      = tabContainer.querySelectorAll('.order-filter-btn');
    const indicator = tabContainer.querySelector('.tab-indicator');
    const allCards  = ordersList.querySelectorAll('.order-card[data-order-status]');

    if (!indicator || tabs.length === 0) return;

    let isAnimating = false; // Lock để tránh click liên tục khi đang animate

    // ── 1. SLIDING INDICATOR ────────────────────────────

    /**
     * Di chuyển indicator đến đúng vị trí và độ rộng của tab
     * @param {HTMLElement} tab - Tab đích
     * @param {boolean} instant - Nếu true, không có transition (dùng cho lần load đầu)
     */
    function moveIndicator(tab, instant) {
        if (!tab || !indicator) return;

        var tabRect      = tab.getBoundingClientRect();
        var containerRect = tabContainer.getBoundingClientRect();
        var scrollLeft    = tabContainer.scrollLeft;

        var left  = tabRect.left - containerRect.left + scrollLeft;
        var width = tabRect.width;

        if (instant) {
            indicator.style.transition = 'none';
        }

        indicator.style.left  = left + 'px';
        indicator.style.width = width + 'px';

        if (instant) {
            // Force reflow để áp dụng style không transition
            indicator.offsetHeight; // eslint-disable-line no-unused-expressions
            indicator.style.transition = '';
        }
    }

    /**
     * Set active class cho tab + cập nhật indicator
     */
    function setActiveTab(targetTab) {
        tabs.forEach(function (t) {
            t.classList.remove('active');
        });
        targetTab.classList.add('active');
        moveIndicator(targetTab, false);
    }

    // ── 2. CLIENT-SIDE FILTERING ────────────────────────

    /**
     * Lọc order cards theo trạng thái — không reload trang
     * @param {string} status - Tên status hoặc 'all'
     */
    function filterOrders(status) {
        var matchedCards   = [];
        var unmatchedCards = [];

        allCards.forEach(function (card) {
            var cardStatus = card.getAttribute('data-order-status');
            if (status === 'all' || cardStatus === status) {
                matchedCards.push(card);
            } else {
                unmatchedCards.push(card);
            }
        });

        // Hiện/ẩn empty state
        if (emptyState) {
            if (matchedCards.length === 0 && allCards.length > 0) {
                emptyState.style.display = '';
            } else {
                emptyState.style.display = 'none';
            }
        }

        // Ẩn cards không khớp, hiện cards khớp
        unmatchedCards.forEach(function (card) {
            card.style.display = 'none';
            card.classList.remove('card-appear');
        });

        matchedCards.forEach(function (card) {
            card.style.display = '';
        });

        // Stagger effect: từng card xuất hiện lần lượt
        matchedCards.forEach(function (card, index) {
            card.classList.remove('card-appear');
            // Force reflow
            card.offsetHeight; // eslint-disable-line no-unused-expressions
            card.style.animationDelay = (index * 60) + 'ms';
            card.classList.add('card-appear');
        });
    }

    // ── 3. FADE ANIMATION ORCHESTRATOR ──────────────────

    /**
     * Hiệu ứng chuyển đổi mượt mà:
     * B1: Fade out danh sách cũ (trượt xuống + mờ dần)
     * B2: setTimeout → đổi display none/block cho cards
     * B3: Fade in danh sách mới (trượt lên + rõ dần)
     */
    function animateTransition(status) {
        if (isAnimating) return;
        isAnimating = true;

        // B1: Fade out
        ordersList.classList.remove('fade-in');
        ordersList.classList.add('fade-out');

        // B2: Sau khi fade out xong (250ms) → lọc + fade in
        setTimeout(function () {
            filterOrders(status);

            // B3: Fade in
            ordersList.classList.remove('fade-out');
            ordersList.classList.add('fade-in');

            // Dọn dẹp class sau animation
            setTimeout(function () {
                ordersList.classList.remove('fade-in');
                // Xóa stagger delay
                allCards.forEach(function (card) {
                    card.style.animationDelay = '';
                    card.classList.remove('card-appear');
                });
                isAnimating = false;
            }, 400);
        }, 250);
    }

    // ── EVENT LISTENERS ─────────────────────────────────

    tabs.forEach(function (tab) {
        tab.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();

            if (isAnimating) return;

            var target = tab.getAttribute('data-target');
            if (!target) return;

            // Nếu click vào tab đang active → không làm gì
            if (tab.classList.contains('active')) return;

            // Set active tab + trượt indicator
            setActiveTab(tab);

            // Animate transition + filter
            animateTransition(target);

            // Cập nhật URL (không reload)
            var newUrl = window.location.pathname;
            if (target !== 'all') {
                newUrl += '?status=' + target;
            }
            window.history.replaceState(null, '', newUrl);
        });
    });

    // ── INITIALIZATION ──────────────────────────────────

    // Tìm tab active ban đầu (từ server) và đặt indicator
    var initialActive = tabContainer.querySelector('.order-filter-btn.active');
    if (!initialActive) {
        initialActive = tabs[0];
        if (initialActive) initialActive.classList.add('active');
    }

    if (initialActive) {
        // Đặt indicator ngay lập tức (không animation) khi page load
        moveIndicator(initialActive, true);

        // Nếu có filter status từ URL → lọc ngay
        var initialTarget = initialActive.getAttribute('data-target');
        if (initialTarget && initialTarget !== 'all') {
            filterOrders(initialTarget);
        }
    }

    // Cập nhật indicator khi resize window
    var resizeTimer;
    window.addEventListener('resize', function () {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function () {
            var active = tabContainer.querySelector('.order-filter-btn.active');
            if (active) {
                moveIndicator(active, true);
            }
        }, 100);
    });

})();
