<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý khuyến mãi</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/form.css">

    <style>
        .modal{display:none;position:fixed;z-index:9999;inset:0;background:rgba(0,0,0,.45)}
        .modal-content{background:#fff;width:min(760px,92vw);margin:60px auto;border-radius:12px;overflow:hidden;box-shadow:0 20px 60px rgba(0,0,0,.25)}
        .modal-header{display:flex;align-items:center;justify-content:space-between;padding:18px 20px;border-bottom:1px solid #eee;background:#fff}
        .modal-title{font-size:22px;font-weight:800;margin:0}
        .close{background:transparent;border:none;font-size:22px;cursor:pointer;line-height:1;padding:6px 10px}
        .modal-body{max-height:calc(90vh - 120px);overflow-y:auto;padding:18px 20px 20px}
        .modal-footer{display:flex;gap:10px;justify-content:flex-end;padding:14px 20px;border-top:1px solid #eee;background:#fff}
        .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px 16px}
        .form-group{display:flex;flex-direction:column;gap:6px}
        .form-group label{font-weight:700}
        .form-group input,.form-group select{width:100%;padding:10px 12px;border:1px solid #cfcfcf;border-radius:8px;outline:none}
        .span-2{grid-column:span 2}
        .btn{border:none;padding:10px 14px;border-radius:10px;cursor:pointer;font-weight:700}
        .btn-primary{background:#2e7d32;color:#fff}
        .btn-secondary{background:#e0e0e0;color:#111}
        .badge{display:inline-block;padding:6px 12px;border-radius:999px;font-weight:800;font-size:12px}
        .badge-on{background:#e7f7ea;color:#1b5e20}
        .badge-off{background:#ffebee;color:#b71c1c}
        @media (max-width:720px){
            .modal-content{margin:30px auto}
            .form-grid{grid-template-columns:1fr}
            .span-2{grid-column:span 1}
        }
    </style>
</head>

<body>
<div class="container">
    <jsp:include page="/admin/layout/sidebar.jsp" />

    <main class="content">
        <div class="header">
            <h1>Quản lý khuyến mãi</h1>
            <button class="btn-add" type="button" onclick="openCreate()">+ Thêm khuyến mãi</button>
        </div>

        <table class="product-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Loại</th>
                <th>Giảm (%)</th>
                <th>Badge</th>
                <th>Bắt đầu</th>
                <th>Kết thúc</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="p" items="${promotions}">
                <tr>
                    <td>#PM${p.promotionId}</td>
                    <td><c:out value="${p.promotionName}"/></td>
                    <td><c:out value="${p.promotionType}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${p.discountPercent != null}">${p.discountPercent}%</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td><c:out value="${p.badgeText}"/></td>
                    <td><c:out value="${p.startDate}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${p.endDate != null}"><c:out value="${p.endDate}"/></c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${p.active}">
                                <span class="badge badge-on">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-off">Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <!-- Nút sửa: dùng data-* để lấy dữ liệu, không cần jsEscape -->
                        <button type="button"
                                class="btn"
                                style="background:#eeeeee"
                                data-id="${p.promotionId}"
                                data-name="<c:out value='${p.promotionName}'/>"
                                data-type="<c:out value='${p.promotionType}'/>"
                                data-percent="${p.discountPercent}"
                                data-badge="<c:out value='${p.badgeText}'/>"
                                data-start="${p.startDate}"
                                data-end="${p.endDate}"
                                data-active="${p.active}"
                                onclick="openEdit(this)">
                            Sửa
                        </button>

                        <form action="${pageContext.request.contextPath}/admin/flash-sale"
                              method="post"
                              style="display:inline"
                              onsubmit="return confirm('Xóa khuyến mãi này?')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="promotionId" value="${p.promotionId}">
                            <button type="submit" class="btn" style="background:#ffebee;color:#b71c1c">Xóa</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty promotions}">
                <tr>
                    <td colspan="9" style="text-align:center">Không có khuyến mãi</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </main>
</div>

<!-- CREATE MODAL -->
<div id="createModal" class="modal" onclick="backdropClose(event,'createModal')">
    <div class="modal-content">
        <div class="modal-header">
            <h2 class="modal-title">Thêm khuyến mãi</h2>
            <button class="close" type="button" onclick="closeModal('createModal')">×</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/flash-sale" method="post" style="margin:0;">
            <input type="hidden" name="action" value="add">

            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group span-2">
                        <label>Tên khuyến mãi</label>
                        <input type="text" name="promotionName" required>
                    </div>

                    <div class="form-group">
                        <label>Loại</label>
                        <select name="promotionType" required>
                            <option value="flash-sale">flash-sale</option>
                            <option value="percent">percent</option>
                            <option value="fixed">fixed</option>
                            <option value="combo">combo</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Giảm (%)</label>
                        <input type="number" name="discountPercent" min="0" max="100">
                    </div>

                    <div class="form-group span-2">
                        <label>Badge</label>
                        <input type="text" name="badgeText">
                    </div>

                    <div class="form-group">
                        <label>Bắt đầu</label>
                        <input type="datetime-local" name="startDate">
                    </div>

                    <div class="form-group">
                        <label>Kết thúc</label>
                        <input type="datetime-local" name="endDate">
                    </div>

                    <div class="form-group span-2" style="display:flex;flex-direction:row;align-items:center;gap:10px">
                        <input id="c_active" type="checkbox" name="isActive" checked>
                        <label for="c_active" style="margin:0;font-weight:800">Active</label>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" onclick="closeModal('createModal')">Hủy</button>
                <button class="btn btn-primary" type="submit">Lưu</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT MODAL -->
<div id="editModal" class="modal" onclick="backdropClose(event,'editModal')">
    <div class="modal-content">
        <div class="modal-header">
            <h2 class="modal-title">Sửa khuyến mãi</h2>
            <button class="close" type="button" onclick="closeModal('editModal')">×</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/flash-sale" method="post" style="margin:0;">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="promotionId" id="e_id">

            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group span-2">
                        <label>Tên khuyến mãi</label>
                        <input type="text" name="promotionName" id="e_name" required>
                    </div>

                    <div class="form-group">
                        <label>Loại</label>
                        <select name="promotionType" id="e_type" required>
                            <option value="flash-sale">flash-sale</option>
                            <option value="percent">percent</option>
                            <option value="fixed">fixed</option>
                            <option value="combo">combo</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Giảm (%)</label>
                        <input type="number" name="discountPercent" id="e_percent" min="0" max="100">
                    </div>

                    <div class="form-group span-2">
                        <label>Badge</label>
                        <input type="text" name="badgeText" id="e_badge">
                    </div>

                    <div class="form-group">
                        <label>Bắt đầu</label>
                        <input type="datetime-local" name="startDate" id="e_start">
                    </div>

                    <div class="form-group">
                        <label>Kết thúc</label>
                        <input type="datetime-local" name="endDate" id="e_end">
                    </div>

                    <div class="form-group span-2" style="display:flex;flex-direction:row;align-items:center;gap:10px">
                        <input id="e_active" type="checkbox" name="isActive">
                        <label for="e_active" style="margin:0;font-weight:800">Active</label>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" onclick="closeModal('editModal')">Hủy</button>
                <button class="btn btn-primary" type="submit">Lưu</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreate(){document.getElementById("createModal").style.display="block";}
    function closeModal(id){document.getElementById(id).style.display="none";}
    function backdropClose(e,id){if(e.target && e.target.classList.contains("modal")) closeModal(id);}
    document.addEventListener("keydown",function(e){if(e.key==="Escape"){closeModal("createModal");closeModal("editModal");}});

    function toLocal(s){
        if(!s || s==="null") return "";
        if(s.includes("T")) return s.substring(0,16);
        if(s.includes(" ")) return s.replace(" ","T").substring(0,16);
        return "";
    }

    function openEdit(btn){
        const d = btn.dataset;
        document.getElementById("e_id").value = d.id || "";
        document.getElementById("e_name").value = d.name || "";
        document.getElementById("e_type").value = d.type || "flash-sale";
        document.getElementById("e_percent").value = (d.percent && d.percent !== "null") ? d.percent : "";
        document.getElementById("e_badge").value = d.badge || "";
        document.getElementById("e_start").value = toLocal(d.start);
        document.getElementById("e_end").value = toLocal(d.end);
        document.getElementById("e_active").checked = (d.active === "true");
        document.getElementById("editModal").style.display="block";
    }
</script>

</body>
</html>
