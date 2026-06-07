(function () {
    'use strict';

    const tabContainer = document.getElementById('orderFilterTabs');
    const ordersList = document.getElementById('ordersListContainer');
    const emptyState = document.getElementById('emptyStateFiltered');

    if (!tabContainer || !ordersList) return;

    const tabs = tabContainer.querySelectorAll('.order-filter-btn');
    const indicator = tabContainer.querySelector('.tab-indicator');
    const allCards = ordersList.querySelectorAll('.order-card[data-order-status]');

    if (!indicator || tabs.length === 0) return;

    let isAnimating = false;
    function moveIndicator(tab, instant) {
        if (!tab || !indicator) return;

        var tabRect = tab.getBoundingClientRect();
        var containerRect = tabContainer.getBoundingClientRect();
        var scrollLeft = tabContainer.scrollLeft;

        var left = tabRect.left - containerRect.left + scrollLeft;
        var width = tabRect.width;

        if (instant) {
            indicator.style.transition = 'none';
        }

        indicator.style.left = left + 'px';
        indicator.style.width = width + 'px';

        if (instant) {
            indicator.offsetHeight;
            indicator.style.transition = '';
        }
    }
    function setActiveTab(targetTab) {
        tabs.forEach(function (t) {
            t.classList.remove('active');
        });
        targetTab.classList.add('active');
        moveIndicator(targetTab, false);
    }


    function filterOrders(status) {
        var matchedCards = [];
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
            card.offsetHeight;
            card.style.animationDelay = (index * 60) + 'ms';
            card.classList.add('card-appear');
        });
    }

    function animateTransition(status) {
        if (isAnimating) return;
        isAnimating = true;

        ordersList.classList.remove('fade-in');
        ordersList.classList.add('fade-out');

        setTimeout(function () {
            filterOrders(status);

            ordersList.classList.remove('fade-out');
            ordersList.classList.add('fade-in');

            setTimeout(function () {
                ordersList.classList.remove('fade-in');
                allCards.forEach(function (card) {
                    card.style.animationDelay = '';
                    card.classList.remove('card-appear');
                });
                isAnimating = false;
            }, 400);
        }, 250);
    }


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
