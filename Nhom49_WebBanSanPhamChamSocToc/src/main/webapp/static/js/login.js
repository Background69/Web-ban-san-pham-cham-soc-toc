document.addEventListener("DOMContentLoaded", function () {

    /* ===============================
       TOGGLE HIỂN THỊ MẬT KHẨU
       (chỉ khi có password field)
    =============================== */
    const togglePassword = document.querySelector(".toggle-password");

    if (togglePassword) {
        togglePassword.addEventListener("click", function () {
            const targetId = this.dataset.target;
            const input = document.getElementById(targetId);
            if (!input) return;

            input.type = input.type === "password" ? "text" : "password";
            this.classList.toggle("fa-eye");
            this.classList.toggle("fa-eye-slash");
        });
    }

    /* ===============================
       VALIDATE FORM LOGIN / FORGOT
       (KHÔNG chặn submit – Servlet xử lý)
    =============================== */
    const form = document.querySelector(".login-box form");

    if (form) {
        form.addEventListener("submit", function () {

            const emailInput = form.querySelector('input[name="email"]');
            const passwordInput = form.querySelector('input[name="password"]');

            // Validate Email (login + forgot)
            if (!emailInput || !emailInput.value.trim()) {
                alert("Vui lòng nhập Email");
                return;
            }

            // Validate Password (chỉ login)
            if (passwordInput && !passwordInput.value.trim()) {
                alert("Vui lòng nhập Mật khẩu");
            }

            // ❗ KHÔNG preventDefault → gửi về Servlet
        });
    }

});
// trang đăng kí
document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector(".login-box form");
    if (!form) return;

    form.addEventListener("submit", function (e) {
        const passwordInput = form.querySelector('input[name="password"]');
        const confirmInput = form.querySelector('input[name="confirm"]');

        if (!passwordInput || !confirmInput) return;

        const password = passwordInput.value.trim();
        const confirm = confirmInput.value.trim();

        if (password !== confirm) {
            e.preventDefault(); // ⛔ chặn submit
            alert("Mật khẩu xác nhận không khớp");
        }
    });
});



