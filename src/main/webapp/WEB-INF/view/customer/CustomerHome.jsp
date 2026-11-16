<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Trang chủ khách hàng | Quản lý siêu thị</title>
    <%@ include file="../shared/head.jspf" %>
</head>
<body class="home-page">
<%@ include file="../shared/nav.jspf" %>
<main class="container home-menu">
    <h1>Trang chủ khách hàng</h1>
    <a class="home-action" href="<c:url value='/customer/search'/>">Tìm kiếm mặt hàng</a>
</main>
</body>
</html>
