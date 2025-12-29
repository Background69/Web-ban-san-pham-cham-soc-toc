document.getElementById("confirm-order").addEventListener("click", function () {
    // Hiển thị thông báo
    alert("🎉 Đặt hàng thành công! Cảm ơn bạn đã mua hàng.");

    // Chuyển về trang chủ sau 2 giây
    setTimeout(function () {
        window.location.href = "MainPage.html";
    }, 2000);
});