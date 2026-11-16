<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Đơn hàng trực tuyến | Quản lý siêu thị</title>
    <%@ include file="../shared/head.jspf" %>
</head>
<body>
<%@ include file="../shared/nav.jspf" %>
<main class="container page-shell">

    <p class="eyebrow">NHÂN VIÊN KHO</p>
    <h1 class="mb-4">Đơn hàng trực tuyến</h1>
    <form action="<c:url value='/warehouse/orders'/>" method="get" class="card p-3 mb-4">
        <label for="status" class="form-label fw-semibold">Trạng thái</label>
        <div class="d-flex flex-wrap gap-2">
            <select name="status" id="status" class="form-select search-field">
                <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                <option value="Chưa xuất" ${status eq 'Chưa xuất' ? 'selected' : ''}>Chưa xuất</option>
                <option value="Đã xuất" ${status eq 'Đã xuất' ? 'selected' : ''}>Đã xuất</option>
                <option value="Đã giao" ${status eq 'Đã giao' ? 'selected' : ''}>Đã giao</option>
            </select>
            <button class="btn btn-primary" type="submit">Lọc</button>
        </div>
    </form>
    <c:choose>
        <c:when test="${empty orders}"><p class="alert alert-info">Không có đơn hàng ở trạng thái đã chọn.</p></c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead><tr><th scope="col">Mã đơn</th><th scope="col">Ngày đặt</th>
                        <th scope="col">Khách hàng</th><th scope="col">Tổng tiền</th>
                        <th scope="col">Trạng thái</th><th scope="col">Người giao</th><th scope="col">Thao tác</th></tr></thead>
                    <tbody>
                    <c:forEach items="${orders}" var="order">
                        <c:url value="/warehouse/approve" var="approveUrl"><c:param name="orderId" value="${order.id}"/></c:url>
                        <tr>
                            <td>#<c:out value="${order.id}"/></td>
                            <td><c:out value="${order.orderDateLabel}"/></td>
                            <td><c:out value="${order.customer.fullName}"/></td>
                            <td><fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="2"/> ₫</td>
                            <td><c:out value="${order.status}"/></td>
                            <td><c:out value="${order.deliveryStaff.fullName}" default="—"/></td>
                            <td><a class="btn btn-sm btn-outline-primary" href="<c:out value='${approveUrl}'/>">Chọn</a></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
