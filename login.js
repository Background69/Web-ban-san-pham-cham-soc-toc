function showAlert(msg){
    alert(msg);
}
function redirect(url){
    window.location.href = url;
}
// xử lí trang đăng nhập
if (document.title.includes("Đăng nhập")){
    const form = document.querySelector("form");
    const passwordInput = form.querySelector('input[type="password"]');
    const eyeIcon = document.querySelector(".eye-icon");
    const closeBtn = document.querySelector(".close-btn");
    const overplay = document.querySelector(".overplay");
    if( eyeIcon && passwordInput){
        eyeIcon.addEventListener("click", () => {
            const type = passwordInput.type === "password" ? "text" : "password";
            passwordInput.type = type;
        });
    }
    if (closeBtn && overplay){
        closeBtn.addEventListener("click", () => {
            overplay.style.display = "none";
        })
    }
    if (form){
        form.addEventListener("submit", (e) => {
            e.preventDefault();
            const email = form.querySelector('input[type="email"]').value.trim();
            const password = form.querySelector('input[type="password"]').value.trim();
            if (!email ||!password){
                showAlert("Vui lòng nhập đầy đủ thông tin")
                return;
            }
            const user = JSON.parse(localStorage.getItem("user"));
            if (user && (email === user.email || email === user.phone) && (password === user.password)) {
                showAlert("đăng nhập thành công!")
                redirect("Login.html");
            }else {
                showAlert("sai email hoặc mật khẩu")
            }
        })
    }

}
//trang đăng kí
if (document.title.includes("đăng kí")){
    const form = document.querySelector("form");
    if (form) {
        form.addEventListener("submit", (e) => {
            e.preventDefault();
            const name = form.querySelector('input[name="name"]').value.trim();
            const email = form.querySelector('input[type="email"]').value.trim();
            const password = form.querySelector('#password').value.trim();
            const confirm = form.querySelector('#confirm').value.trim();

            if (!name || !email || !password || !confirm){
                showAlert("Vui lòng điền đầy đủ thông tin ");
                return;
            }
            if (password !== confirm){
                showAlert("Mật khẩu không khớp");
                return;
            }
            localStorage.setItem("user", JSON.stringify({name,email,password}));
            showAlert("Đăng kí thành công!")
            redirect("Login.html");
        })
    }
}
//trang quên mật khẩu
if (document.title.includes("Quên Mật Khẩu")){
    const form = document.querySelector("form");
    if (form) {
        form.addEventListener("submit", (e) => {
            e.preventDefault();
            const email = form.querySelector('input[type="email"]').value.trim();
            if (!email){
                showAlert("Vui lòng nhập email để khôi phục mật khẩu");
                return;
            }
            showAlert(`Liên kết khôi phục mật khẩu đã được gửi đến ${email}`);
            redirect("Login.html");
        })
    }
}