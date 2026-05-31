<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="activeMenu" value="brands"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${brand != null}">Cập nhật thương hiệu</c:when>
            <c:otherwise>Thêm thương hiệu</c:otherwise>
        </c:choose>
        | HairGlow Admin
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin/dashboard.css">
    <style>
        .form-container {
            background: #fff;
            border-radius: 16px;
            padding: 32px;
            max-width: 700px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
        }

        .form-container h2 {
            margin: 0 0 24px 0;
            font-size: 22px;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4b6b3c;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4b6b3c, #5d8a47);
            color: #fff;
        }

        .btn-primary:hover {
            opacity: 0.9;
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        .error-message {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .preview-img {
            margin-top: 10px;
            max-width: 120px;
            max-height: 80px;
            border-radius: 8px;
            border: 1px solid #eee;
        }
    </style>
</head>

<body>
<div class="container">
    <jsp:include page="/admin/layout/sidebar.jsp"/>

    <main class="content">
        <div class="header">
            <h1>
                <c:choose>
                    <c:when test="${brand != null}">Cập nhật thương hiệu</c:when>
                    <c:otherwise>Thêm thương hiệu mới</c:otherwise>
                </c:choose>
            </h1>
            <a href="${pageContext.request.contextPath}/admin/brands" class="btn btn-secondary">
                ← Quay lại
            </a>
        </div>

        <div class="form-container">
            <c:if test="${not empty branderror}">
                <div class="error-message">${branderror}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/brands/save" method="post" enctype="multipart/form-data">
                <!-- Hidden ID for edit -->
                <c:if test="${brand != null}">
                    <input type="hidden" name="id" value="${brand.brandId}">
                </c:if>

                <div class="form-row">
                    <div class="form-group">
                        <label>Tên thương hiệu <span style="color:red">*</span></label>
                        <input type="text" name="brandName" value="${brand.brandName}"
                               placeholder="Nhập tên thương hiệu" required>
                    </div>

                    <div class="form-group">
                        <label>Slug</label>
                        <input type="text" name="brandSlug" value="${brand.brandSlug}"
                               placeholder="vd: loreal-paris">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Logo</label>
                        <input type="file" name="logo" accept="image/*">
                        <c:if test="${not empty brand.logoUrl}">
                            <c:choose>
                                <c:when test="${fn:startsWith(brand.logoUrl, 'http')}">
                                    <img class="preview-img" src="${brand.logoUrl}" alt="Logo preview">
                                </c:when>
                                <c:otherwise>
                                    <img class="preview-img" src="${pageContext.request.contextPath}/static/${brand.logoUrl}" alt="Logo preview">
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>Xuất xứ</label>
                        <input type="text" name="origin" value="${brand.origin}"
                               placeholder="vd: Pháp, Hàn Quốc...">
                    </div>
                </div>

                <div class="form-group">
                    <label>Mô tả ngắn</label>
                    <textarea name="shortDescription" rows="3"
                              placeholder="Mô tả ngắn gọn về thương hiệu...">${brand.shortDescription}</textarea>
                </div>

                <div class="form-group">
                    <label>Mô tả chi tiết</label>
                    <textarea name="fullDescription" rows="5"
                              placeholder="Mô tả chi tiết về thương hiệu, lịch sử, sản phẩm nổi bật...">${brand.fullDescription}</textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${brand != null}">Cập nhật</c:when>
                            <c:otherwise>Thêm mới</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/brands"
                       class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </main>
</div>
</body>

</html>
