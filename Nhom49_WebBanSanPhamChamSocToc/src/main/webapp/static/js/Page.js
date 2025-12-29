// Flash Sale Countdown Timer
(function () {
    const hoursEl = document.getElementById('flash-sale-hours');
    const minutesEl = document.getElementById('flash-sale-minutes');
    const secondsEl = document.getElementById('flash-sale-seconds');

    if (!hoursEl || !minutesEl || !secondsEl) return;

    function updateCountdown() {
        const now = new Date();
        const endOfDay = new Date();
        endOfDay.setHours(23, 59, 59, 999);

        const diff = endOfDay - now;

        if (diff <= 0) {
            hoursEl.textContent = '00';
            minutesEl.textContent = '00';
            secondsEl.textContent = '00';
            return;
        }

        const hours = Math.floor(diff / (1000 * 60 * 60));
        const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((diff % (1000 * 60)) / 1000);

        hoursEl.textContent = String(hours).padStart(2, '0');
        minutesEl.textContent = String(minutes).padStart(2, '0');
        secondsEl.textContent = String(seconds).padStart(2, '0');
    }

    updateCountdown();
    setInterval(updateCountdown, 1000);
})();

// Flash Sale Slider
(function () {
    const track = document.getElementById('flash-sale-track');
    const prevBtn = document.getElementById('flash-sale-prev');
    const nextBtn = document.getElementById('flash-sale-next');

    if (!track || !prevBtn || !nextBtn) return;

    const cards = track.querySelectorAll('.product-item');
    if (cards.length === 0) return;

    let currentIndex = 0;
    const cardWidth = 260;
    const gap = 20;
    const slideWidth = cardWidth + gap;

    // Calculate how many products are visible
    function getVisibleCards() {
        const containerWidth = track.parentElement.offsetWidth;
        return Math.floor(containerWidth / slideWidth);
    }

    function updateSlider() {
        const visibleCards = getVisibleCards();
        const maxIndex = Math.max(0, cards.length - visibleCards);

        // Limit currentIndex
        currentIndex = Math.max(0, Math.min(currentIndex, maxIndex));

        // Move slider
        const translateX = -(currentIndex * slideWidth);
        track.style.transform = `translateX(${translateX}px)`;

        // Update button states
        prevBtn.disabled = currentIndex === 0;
        nextBtn.disabled = currentIndex >= maxIndex;
    }

    prevBtn.addEventListener('click', function () {
        if (currentIndex > 0) {
            currentIndex--;
            updateSlider();
        }
    });

    nextBtn.addEventListener('click', function () {
        const visibleCards = getVisibleCards();
        const maxIndex = Math.max(0, cards.length - visibleCards);
        if (currentIndex < maxIndex) {
            currentIndex++;
            updateSlider();
        }
    });

    updateSlider();
})();