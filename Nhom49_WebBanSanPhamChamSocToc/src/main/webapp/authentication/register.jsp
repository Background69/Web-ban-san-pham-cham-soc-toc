<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - HairGlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/register.css">
</head>
<body class="register-page">

<%@ include file="/layout/header.jsp" %>

<main>
    <div class="login-container">
        <div class="login-box">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/static/assets/icons/LOGO.png" class="logo"
                     alt="HairGlow Logo">
            </div>

            <h2>Đăng ký</h2>
            <p>Tạo tài khoản mới để tiếp tục</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form id="registerForm" action="${pageContext.request.contextPath}/auth/register" method="post" novalidate>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input class="form-control" type="email" id="email" name="email"
                           placeholder="Nhập email" required value="${email}"
                           aria-describedby="emailError">
                    <small id="emailError" class="form-error"></small>
                </div>

                <div class="form-group">
                    <label for="fullname">Họ tên</label>
                    <input class="form-control" type="text" id="fullname" name="fullname"
                           placeholder="Nhập họ tên" required value="${fullname}"
                           aria-describedby="fullnameError">
                    <small id="fullnameError" class="form-error"></small>
                </div>

                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input class="form-control" type="text" id="username" name="username"
                           placeholder="Nhập tên đăng nhập" required value="${username}"
                           aria-describedby="usernameError">
                    <small id="usernameError" class="form-error"></small>
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input class="form-control" type="tel" id="phone" name="phone"
                           placeholder="Nhập số điện thoại" inputmode="numeric"
                           maxlength="11" value="${phone}"
                           aria-describedby="phoneError">
                    <small id="phoneError" class="form-error"></small>
                </div>

                <div class="password-wrapper">
                    <label for="password">Mật khẩu</label>
                    <input class="form-control" type="password" id="password" name="password"
                           placeholder="Nhập mật khẩu" required
                           aria-describedby="passwordHelp passwordError">

                    <small id="passwordError" class="form-error"></small>
                </div>

                <div class="password-wrapper">
                    <label for="confirm">Xác nhận mật khẩu</label>
                    <input class="form-control" type="password" id="confirm" name="confirmPassword"
                           placeholder="Nhập lại mật khẩu" required
                           aria-describedby="confirmError">
                    <small id="confirmError" class="form-error"></small>
                </div>

                <button type="submit" class="btn-primary">Đăng ký</button>

                <div class="or-divider"><span>Hoặc</span></div>

                <div class="social-login">
                    <a class="google-btn" href="${pageContext.request.contextPath}/auth/google">
                        <img src="${pageContext.request.contextPath}/static/assets/icons/Google.png" alt="Google">
                        <span>Google</span>
                    </a>
                </div>

                <p class="signup-text">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
                </p>
            </form>
        </div>
    </div>
</main>

<%@ include file="/layout/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Form validation
    (function () {
        const form = document.getElementById('registerForm');
        if (!form) return;
        const fields = {
            email: form.querySelector('#email'),
            fullname: form.querySelector('#fullname'),
            username: form.querySelector('#username'),
            phone: form.querySelector('#phone'),
            password: form.querySelector('#password'),
            confirm: form.querySelector('#confirm')
        };

        function setInvalid(input, message) {
            const error = document.getElementById(input.id + 'Error');
            input.classList.remove('is-valid');
            input.classList.add('is-invalid');
            input.setAttribute('aria-invalid', 'true');
            if (error) error.textContent = message;
        }

        function setValid(input) {
            const error = document.getElementById(input.id + 'Error');
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
            input.setAttribute('aria-invalid', 'false');
            if (error) error.textContent = '';
        }

        function resetField(input) {
            const error = document.getElementById(input.id + 'Error');
            input.classList.remove('is-invalid', 'is-valid');
            input.removeAttribute('aria-invalid');
            if (error) error.textContent = '';
        }

        function validateEmail() {
            const input = fields.email;
            const value = input.value.trim();
            if (value === '') {
                setInvalid(input, 'Email không được để trống');
                return false;
            }
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                setInvalid(input, 'Email không đúng định dạng');
                return false;
            }
            setValid(input);
            return true;
        }

        function validateFullname() {
            const input = fields.fullname;
            const value = input.value.trim().replace(/\s+/g, ' ');
            if (value === '') {
                setInvalid(input, 'Họ tên không được để trống');
                return false;
            }
            if (value.length < 10 || value.length > 30) {
                setInvalid(input, 'Họ tên phải từ 10 đến 30 ký tự');
                return false;
            }
            if (!/^[\p{L}\s]+$/u.test(value)) {
                setInvalid(input, 'Họ tên chỉ được chứa chữ cái và khoảng trắng');
                return false;
            }
            setValid(input);
            return true;
        }

        function validateUsername() {
            const input = fields.username;
            const value = input.value.trim();
            if (value === '') {
                setInvalid(input, 'Tên đăng nhập không được để trống');
                return false;
            }
            if (value.length < 3 || value.length > 50) {
                setInvalid(input, 'Tên đăng nhập phải từ 3 đến 50 ký tự');
                return false;
            }
            if (!/^\w+$/.test(value)) {
                setInvalid(input, 'Tên đăng nhập chỉ được chứa chữ cái, số và dấu _');
                return false;
            }
            setValid(input);
            return true;
        }

        function validatePhone() {
            const input = fields.phone;
            input.value = input.value.replace(/\D/g, '').slice(0, 11);
            const value = input.value;
            if (value === '') {
                resetField(input);
                return true;
            }
            if (!/^\d{10,11}$/.test(value)) {
                setInvalid(input, 'Số điện thoại phải gồm 10 đến 11 chữ số');
                return false;
            }
            setValid(input);
            return true;
        }

        function validatePassword() {
            const input = fields.password;
            const value = input.value;

            if (value === '') {
                resetField(input);
                return false;
            }

            if (value.length < 8) {
                setInvalid(input, 'Mật khẩu phải có ít nhất 8 ký tự');
                return false;
            }

            if (!/[A-Z]/.test(value)) {
                setInvalid(input, 'Mật khẩu phải có ít nhất 1 chữ cái viết hoa');
                return false;
            }

            if (!/\d/.test(value)) {
                setInvalid(input, 'Mật khẩu phải có ít nhất 1 chữ số');
                return false;
            }

            if (value.length > 100) {
                setInvalid(input, 'Mật khẩu không được quá 100 ký tự');
                return false;
            }

            setValid(input);
            return true;
        }

        function validateConfirm() {
            const input = fields.confirm;
            const value = input.value;
            if (value === '') {
                setInvalid(input, 'Vui lòng xác nhận mật khẩu');
                return false;
            }
            if (value !== fields.password.value) {
                setInvalid(input, 'Mật khẩu xác nhận không khớp');
                return false;
            }
            setValid(input);
            return true;
        }

        const validators = {
            email: validateEmail, fullname: validateFullname, username: validateUsername,
            phone: validatePhone, password: validatePassword, confirm: validateConfirm
        };

        // focus → bắt đầu validate realtime ngay từ lần nhập đầu tiên
        Object.keys(fields).forEach(key => {
            const input = fields[key];

            input.addEventListener('input', () => {
                validators[key]();
                if (key === 'password' && (fields.confirm.classList.contains('is-invalid') || fields.confirm.classList.contains('is-valid'))) {
                    validateConfirm();
                }
            });
        });

        form.addEventListener('submit', function (e) {
            const results = [
                validateEmail(), validateFullname(), validateUsername(),
                validatePhone(), validatePassword(), validateConfirm()
            ];
            if (results.includes(false)) e.preventDefault();
        });
    })();
</script>

</body>
</html>