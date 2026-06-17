<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý nhập kho</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/inventory.css">
</head>

<body>

<div class="container">

    <jsp:include page="/admin/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="import"/>
    </jsp:include>

    <main class="content">

        <div class="header">
            <h1>Quản lý nhập kho</h1>

            <button class="btn-add" onclick="openModal()">
                + Nhập kho
            </button>
        </div>

        <!-- SUCCESS / ERROR -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert success">${sessionScope.success}</div>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert error">${sessionScope.error}</div>
        </c:if>

        <!-- LIST RECEIPTS -->
        <table class="table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Người tạo</th>
                <th>Ngày nhập</th>
                <th>Tổng tiền</th>
                <th>Ghi chú</th>
                <th>Chi tiết</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="r" items="${receipts}">
                <tr>
                    <td>#${r.receiptId}</td>
                    <td>${r.createdBy}</td>
                    <td>${r.receiptDate}</td>
                    <td>${r.totalAmount}</td>
                    <td>${r.note}</td>
                    <td>
                        <button class="btn-view"
                                onclick="openDetail(${r.receiptId})">
                            Xem
                        </button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty receipts}">
                <tr>
                    <td colspan="6" style="text-align:center;">
                        Chưa có phiếu nhập kho
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>

    </main>
</div>


<!-- MODAL -->
<div id="inventoryModal" class="modal">
    <div class="modal-content" style="width: 800px;">

        <h2>Nhập kho nhanh</h2>

        <h2>Nhập kho nhanh</h2>

        <input type="text"
               id="searchVariant"
               placeholder="Tìm variant..."
               class="search-box"
               oninput="filterVariants()">
        <form method="post" action="${pageContext.request.contextPath}/admin/inventory">
            <input type="hidden"
                   name="_csrf"
                   value="${fn:escapeXml(_csrf)}"/>

            <div class="variant-list">

                <table class="table">
                    <thead>
                    <tr>
                        <th>Chọn</th>
                        <th>Variant</th>
                        <th>Tồn kho</th>
                        <th>Số lượng nhập</th>
                        <th>Giá nhập</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="v" items="${variants}">
                        <tr>
                            <td>
                                <input type="checkbox"
                                       name="selected"
                                       value="${v.variantId}"
                                       onchange="toggleRow(this)">
                            </td>
                            <td>${v.variantName}</td>

                            <td>${v.stockQuantity}</td>

                            <!-- số lượng nhập -->
                            <td>
                                <input type="number"
                                       name="quantity_${v.variantId}"
                                       min="0"
                                       value="0"
                                       class="qty-input">
                            </td>

                            <!-- giá nhập (readonly auto) -->
                            <td>
                                <input type="number"
                                       class="price-input"
                                       value="${v.currentPrice}"
                                       readonly>
                            </td>

                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <div style="margin-top: 15px; padding: 12px; background: #f5f5f5; border-radius: 8px;">
                    <strong>Tổng phiếu nhập:</strong>
                    <span id="totalReceipt">0 đ</span>
                </div>
            </div>

            <div class="modal-actions">
                <button type="submit" class="btn-save">Lưu phiếu nhập</button>
                <button type="button" class="btn-cancel" onclick="closeModal()">Huỷ</button>
            </div>
        </form>

    </div>
</div>

<!-- DETAIL MODAL -->
<div id="detailModal" class="modal">
    <div class="modal-content" style="width: 700px;">

        <h2>Chi tiết phiếu nhập</h2>

        <div id="detailContent">
            Đang tải...
        </div>

        <div class="modal-actions">
            <button type="button" class="btn-cancel" onclick="closeDetail()">Đóng</button>
        </div>

    </div>
</div>

<script>
    function calcTotal() {
        let total = 0;

        document.querySelectorAll(".qty-input").forEach(input => {
            const row = input.closest("tr");

            const qty = Number(input.value || 0);
            const priceInput = row.querySelector(".price-input");
            const price = Number(priceInput.value || 0);

            total += qty * price;
        });

        document.getElementById("totalReceipt").innerText =
            total.toLocaleString("vi-VN") + " đ";
    }

    // bind event
    function bindInventoryEvents() {

        document.querySelectorAll(".qty-input").forEach(input => {
            input.addEventListener("input", calcTotal);
        });
    }

    function closeModal() {
        document.getElementById("inventoryModal").style.display = "none";
    }

    function openModal() {
        document.getElementById("inventoryModal").style.display = "block";

        document.getElementById("searchVariant").value = "";

        document.querySelectorAll("#inventoryModal tbody tr")
            .forEach(r => r.style.display = "");

        document.querySelectorAll(".qty-input").forEach(i => i.value = 0);

        bindInventoryEvents();
        calcTotal();
    }


    function openDetail(id) {
        const modal = document.getElementById("detailModal");
        const content = document.getElementById("detailContent");

        modal.style.display = "block";
        content.innerHTML = "Đang tải...";

        fetch(`${pageContext.request.contextPath}/admin/inventory/details?id=` + id)
            .then(res => res.json())
            .then(data => {

                let html = `
                <table class="table">
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
            `;

                let total = 0;

                data.forEach(d => {
                    const lineTotal = d.quantity * d.unitCost;
                    total += lineTotal;

                    html += `
                    <tr>
                        <td>\${d.variantName}</td>
                        <td>\${d.quantity}</td>
                        <td>\${Number(d.unitCost).toLocaleString("vi-VN")} đ</td>
                        <td>\${lineTotal.toLocaleString("vi-VN")} đ</td>
                    </tr>
                `;
                });

                html += `</table>`;

                html += `
                <div style="margin-top: 15px; padding: 12px; background: #f5f5f5; border-radius: 8px;">
                    <strong>Tổng cộng:</strong>
                    <span>\${total.toLocaleString("vi-VN")} đ</span>
                </div>
            `;

                content.innerHTML = html;
            })
            .catch(() => {
                content.innerHTML = "Lỗi tải dữ liệu";
            });
    }

    function closeDetail() {
        document.getElementById("detailModal").style.display = "none";
    }

    window.onclick = function (e) {
        const modal = document.getElementById("inventoryModal");
        if (e.target === modal) closeModal();
    };

    function filterVariants() {
        const keyword = document.getElementById("searchVariant").value.toLowerCase();

        document.querySelectorAll("#inventoryModal tbody tr").forEach(row => {
            const nameCell = row.querySelector("td");

            if (!nameCell) return;

            const text = nameCell.innerText.toLowerCase();

            row.style.display = text.includes(keyword) ? "" : "none";
        });
    }

    function toggleRow(cb) {
        const row = cb.closest("tr");
        const qty = row.querySelector(".qty-input");

        qty.disabled = !cb.checked;

        if (!cb.checked) {
            qty.value = 0;
        }

        calcTotal();
    }
</script>

</body>
</html>