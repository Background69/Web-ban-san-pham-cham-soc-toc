const slides = document.querySelectorAll('.banner-slides .item');
const slideContainer = document.querySelector('.banner-slides');
const prevButton = document.querySelector('.nav.prev');
const nextButton = document.querySelector('.nav.next');
const dotsContainer = document.querySelector('.slider-dots');

let currentSlide = 0;
let autoSlide;

// Tạo dots theo số slide
slides.forEach((_, index) => {
    const dot = document.createElement('button');
    dot.addEventListener('click', () => goToSlide(index));
    dotsContainer.appendChild(dot);
});
const dots = dotsContainer.querySelectorAll('button');

function updateSlide() {
    const offset = -currentSlide * 100;
    slideContainer.style.transform = `translateX(${offset}%)`;
    dots.forEach(dot => dot.classList.remove('active'));
    dots[currentSlide].classList.add('active');
}

function prevSlide() {
    currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    updateSlide();
}

function nextSlide() {
    currentSlide = (currentSlide + 1) % slides.length;
    updateSlide();
}

function goToSlide(index) {
    currentSlide = index;
    updateSlide();
}

function startAutoSlide() {
    autoSlide = setInterval(nextSlide, 4000);
}

function stopAutoSlide() {
    clearInterval(autoSlide);
}

// Event listeners
prevButton.addEventListener('click', () => {
    prevSlide();
    stopAutoSlide();
    startAutoSlide();
});

nextButton.addEventListener('click', () => {
    nextSlide();
    stopAutoSlide();
    startAutoSlide();
});

slideContainer.addEventListener('mouseenter', stopAutoSlide);
slideContainer.addEventListener('mouseleave', startAutoSlide);

// Khởi động
updateSlide();
startAutoSlide();
