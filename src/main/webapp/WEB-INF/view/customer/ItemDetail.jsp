<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Chi tiết mặt hàng | Quản lý siêu thị</title>
    <%@ include file="../shared/head.jspf" %>
</head>
<body>
<%@ include file="../shared/nav.jspf" %>
<main class="container page-shell">

    <c:url value="/customer/search" var="searchUrl">
        <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
    </c:url>
    <a class="back-link" href="<c:out value='${searchUrl}'/>">← Quay lại tìm kiếm</a>
    <section class="card p-4 mt-3">
        <p class="eyebrow">MẶT HÀNG #<c:out value="${item.id}"/></p>
        <h1><c:out value="${item.itemName}"/></h1>
        <dl class="row mt-4">
            <dt class="col-sm-3">Giá bán</dt><dd class="col-sm-9"><fmt:formatNumber value="${item.price}" maxFractionDigits="2"/> ₫</dd>
            <dt class="col-sm-3">Số lượng tồn</dt><dd class="col-sm-9"><c:out value="${item.stockQuantity}"/></dd>
            <dt class="col-12 mt-3 mb-2">Mô tả chi tiết</dt>
            <dd class="col-12 preserve-lines"><c:out value="${item.description}"/></dd>
        </dl>
    </section>
</main>
</body>
</html>
