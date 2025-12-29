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