
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
