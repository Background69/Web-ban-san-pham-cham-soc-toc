document.querySelectorAll('.filter-tag').forEach(tag => {
    tag.addEventListener('click', function () {
        // Xóa class active ở tất cả các nút
        document.querySelectorAll('.filter-tag').forEach(t => t.classList.remove('active'));
        // Thêm class active vào nút được nhấn
        this.classList.add('active');

        const origin = this.dataset.origin;
        document.querySelectorAll('.brand-item').forEach(card => {
            if (origin === 'all' || card.dataset.origin === origin) {
                card.style.removeProperty('display');
            } else {
                card.style.display = 'none';
            }
        });
    });
});