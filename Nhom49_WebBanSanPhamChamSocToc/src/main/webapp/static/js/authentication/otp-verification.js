let timeLeft = 60 * 5;

function startCountdown() {
    const timer = document.getElementById("timer");

    const interval = setInterval(() => {
        timeLeft--;
        if (timer) {
            timer.innerText = "OTP hết hạn sau: " + timeLeft + "s";
        }

        if (timeLeft <= 0) {
            clearInterval(interval);
            if (timer) {
                timer.innerText = "OTP đã hết hạn!";
            }
        }
    }, 1000);

}

function combineOtp() {
    let otp = "";
    for (let i = 1; i <= 6; i++) {
        const input = document.getElementById("otp" + i);
        if (input) otp += input.value;
    }
    document.getElementById("fullOtp").value = otp;
}

window.addEventListener("DOMContentLoaded", function () {
    startCountdown();

    for (let i = 1; i <= 6; i++) {
        const input = document.getElementById("otp" + i);

        if (!input) continue;

        // Auto next
        input.addEventListener("input", function () {
            this.value = this.value.replace(/[^0-9]/g, ""); // chỉ số

            if (this.value.length === 1) {
                const next = document.getElementById("otp" + (i + 1));
                if (next) next.focus();
            }
        });

        // Backspace quay lại
        input.addEventListener("keydown", function (e) {
            if (e.key === "Backspace" && this.value === "" && i > 1) {
                const prev = document.getElementById("otp" + (i - 1));
                if (prev) prev.focus();
            }
        });
    }

// Focus ô đầu tiên
    const first = document.getElementById("otp1");
    if (first) first.focus();

});
