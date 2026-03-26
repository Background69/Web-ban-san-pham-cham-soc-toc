<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không tìm thấy trang - HairGlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>
<jsp:include page="/layout/header.jsp"/>

<main class="store-container" style="padding: 60px 0;">
    <div class="no-products">
        <i class="fas fa-search"></i>
        <h3>Không tìm thấy trang</h3>
        <p>Trang bạn yêu cầu không tồn tại hoặc đã bị di chuyển.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>
</body>
</html>

