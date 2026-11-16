<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Đăng nhập | Quản lý siêu thị</title>
    <%@ include file="../shared/head.jspf" %>
</head>
<body>
<main class="container page-shell">

    <section class="login-panel card p-4 p-md-5 mx-auto">
        <p class="eyebrow">QUẢN LÝ SIÊU THỊ</p>
        <h1 class="h2 mb-3">Đăng nhập</h1>
        <p class="text-secondary">Sử dụng tài khoản khách hàng hoặc nhân viên kho.</p>
    <%@ include file="../shared/error.jspf" %>
        <form action="<c:url value='/login'/>" method="post">
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
            <label class="form-label" for="username">Tên đăng nhập</label>
            <input class="form-control mb-3" id="username" name="username" autocomplete="username" maxlength="80" required>
            <label class="form-label" for="password">Mật khẩu</label>
            <input class="form-control mb-4" id="password" name="password" type="password"
                   autocomplete="current-password" maxlength="128" required>
            <button class="btn btn-primary w-100" type="submit">Đăng nhập</button>
        </form>
    </section>
</main>
</body>
</html>
