"use strict";

(function () {

    function $(id) {
        return document.getElementById(id);
    }

    function setText(id, text) {
        var el = $(id);
        if (el) el.textContent = text;
    }

    function toNumber(value, fallback) {
        var n = Number(value);
        return Number.isFinite(n) ? n : fallback;
    }

    function clearOtpError() {
        var container = document.querySelector(".otp-inputs");
        if (container) container.classList.remove("shake-error");
    }

    function wireOtpInputs() {
        for (var i = 1; i <= 6; i++) {
            (function (idx) {
                var input = $("otp" + idx);
                if (!input) return;

                input.addEventListener("input", function () {
                    this.value = this.value.replace(/\D/g, "").slice(0, 1);
                    if (this.value.length === 1) {
                        var next = $("otp" + (idx + 1));
                        if (next) next.focus();
                    }
                    clearOtpError();
                });

                input.addEventListener("keydown", function (e) {
                    if (e.key === "Backspace" && this.value === "" && idx > 1) {
                        var prev = $("otp" + (idx - 1));
                        if (prev) prev.focus();
                    }
                });

                input.addEventListener("paste", function (e) {
                    e.preventDefault();
                    var text = (e.clipboardData || window.clipboardData).getData("text");
                    var digits = text.replace(/\D/g, "").slice(0, 6);
                    if (!digits) return;

                    for (var j = 0; j < digits.length; j++) {
                        var target = $("otp" + (j + 1));
                        if (target) target.value = digits[j];
                    }

                    var focusEl = $("otp" + Math.min(digits.length + 1, 6));
                    if (focusEl) focusEl.focus();
                    clearOtpError();
                });

            })(i);
        }

        var first = $("otp1");
        if (first) first.focus();
    }

    // Gọi từ form onsubmit="return combineOtp(event)"
    window.combineOtp = function (e) {
        var otp = "";
        for (var i = 1; i <= 6; i++) {
            var input = $("otp" + i);
            otp += input ? input.value : "";
        }

        // Nếu chưa đủ 6 số → chặn submit
        if (otp.length < 6) {
            if (e) e.preventDefault();

            var container = document.querySelector(".otp-inputs");
            if (container) {
                container.classList.remove("shake-error");
                void container.offsetWidth;
                container.classList.add("shake-error");

                container.addEventListener("animationend", function handler() {
                    container.removeEventListener("animationend", handler);
                }, { once: true });
            }

            for (var j = 1; j <= 6; j++) {
                var el = $("otp" + j);
                if (el && el.value === "") {
                    el.focus();
                    break;
                }
            }
            return false;
        }

        // Đủ 6 số → gom vào hidden field và cho phép submit
        var fullOtp = $("fullOtp");
        if (fullOtp) fullOtp.value = otp;
        return true;
    };

    function startTimers(otpExpiryAt, otpLastSentAt, cooldownSeconds) {
        var resendBtn = document.querySelector(
            'form[action$="/auth/resend-otp"] button[type="submit"]'
        );

        function tick() {
            var now = Date.now();

            // Timer hết hạn OTP
            if (otpExpiryAt > 0) {
                var remainOtp = Math.ceil((otpExpiryAt - now) / 1000);
                setText("otpExpiryTimer",
                    remainOtp > 0
                        ? "OTP hết hạn sau: " + remainOtp + " giây"
                        : "OTP đã hết hạn!"
                );
            }

            // Cooldown nút gửi lại
            if (otpLastSentAt > 0) {
                var cooldownEnd = otpLastSentAt + cooldownSeconds * 1000;
                var remainCooldown = Math.ceil((cooldownEnd - now) / 1000);

                if (remainCooldown > 0) {
                    setText("resendCooldownTimer", "Vui lòng đợi " + remainCooldown + " giây để gửi lại OTP.");
                    if (resendBtn) resendBtn.disabled = true;
                } else {
                    setText("resendCooldownTimer", "Bạn có thể gửi lại OTP.");
                    if (resendBtn) resendBtn.disabled = false;
                }
            }
        }

        tick();
        setInterval(tick, 1000);
    }


    window.addEventListener("DOMContentLoaded", function () {
        wireOtpInputs();

        var box = document.querySelector(".otp-box[data-otp-expiry-at]");
        if (!box) return;

        startTimers(
            toNumber(box.dataset.otpExpiryAt, 0),
            toNumber(box.dataset.otpLastSentAt, 0),
            toNumber(box.dataset.resendCooldownSeconds, 45)
        );
    });

})();