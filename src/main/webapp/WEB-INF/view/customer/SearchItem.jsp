<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Tìm kiếm mặt hàng | Quản lý siêu thị</title>
    <%@ include file="../shared/head.jspf" %>
</head>
<body>
<%@ include file="../shared/nav.jspf" %>
<main class="container page-shell">

    <p class="eyebrow">KHÁCH HÀNG</p>
    <h1 class="mb-4">Tìm kiếm mặt hàng</h1>
    <%@ include file="../shared/error.jspf" %>
    <form action="<c:url value='/customer/search'/>" method="get" class="card p-3 mb-4">
        <label for="keyword" class="form-label fw-semibold">Tên mặt hàng</label>
        <div class="d-flex flex-wrap gap-2">
            <input type="search" name="keyword" id="keyword" class="form-control search-field"
                   value="<c:out value='${keyword}'/>" maxlength="160" required placeholder="Ví dụ: Sữa">
            <button class="btn btn-primary" type="submit">Tìm kiếm</button>
        </div>
    </form>
    <c:if test="${not empty keyword}">
        <h2 class="h5">Kết quả cho “<c:out value="${keyword}"/>”</h2>
        <c:choose>
            <c:when test="${empty items}"><p class="alert alert-info">Không tìm thấy mặt hàng phù hợp.</p></c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead><tr><th scope="col">Mã</th><th scope="col">Tên mặt hàng</th>
                            <th scope="col">Giá bán</th><th scope="col">Tồn kho</th><th scope="col">Chi tiết</th></tr></thead>
                        <tbody>
                        <c:forEach items="${items}" var="item">
                            <c:url value="/customer/item" var="detailUrl">
                                <c:param name="id" value="${item.id}"/>
                                <c:param name="keyword" value="${keyword}"/>
                            </c:url>
                            <tr>
                                <td><c:out value="${item.id}"/></td>
                                <td><c:out value="${item.itemName}"/></td>
                                <td><fmt:formatNumber value="${item.price}" maxFractionDigits="2"/> ₫</td>
                                <td><c:out value="${item.stockQuantity}"/></td>
                                <td><a class="btn btn-sm btn-outline-primary" href="<c:out value='${detailUrl}'/>">Xem</a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>
</main>
</body>
</html>
