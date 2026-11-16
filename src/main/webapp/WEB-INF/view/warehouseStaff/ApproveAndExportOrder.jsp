<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Duyệt đơn và xuất hàng | Quản lý siêu thị</title>
    <%@ include file="../shared/head.jspf" %>
</head>
<body>
<%@ include file="../shared/nav.jspf" %>
<main class="container page-shell">

    <c:url value="/warehouse/orders" var="ordersUrl"><c:param name="status" value="${order.status}"/></c:url>
    <a class="back-link" href="<c:out value='${ordersUrl}'/>">← Danh sách đơn hàng</a>
    <h1 class="my-3">Đơn #<c:out value="${order.id}"/></h1>
    <%@ include file="../shared/error.jspf" %>
    <c:if test="${inDelivery}">
        <p class="alert alert-success" role="status">Đơn đã xuất và hóa đơn đã sẵn sàng để in.</p>
    </c:if>
    <c:if test="${not pending and not inDelivery}">
        <p class="alert alert-success" role="status">Đơn đã được xác nhận giao thành công.</p>
    </c:if>
    <dl class="row">
        <dt class="col-sm-3">Khách hàng</dt><dd class="col-sm-9"><c:out value="${order.customer.fullName}"/></dd>
        <dt class="col-sm-3">Ngày đặt</dt><dd class="col-sm-9"><c:out value="${order.orderDateLabel}"/></dd>
        <dt class="col-sm-3">Địa chỉ giao</dt><dd class="col-sm-9"><c:out value="${order.deliveryAddress}"/></dd>
        <dt class="col-sm-3">Trạng thái</dt><dd class="col-sm-9"><c:out value="${order.status}"/></dd>
    </dl>
    <h2 class="h5">Chi tiết mặt hàng</h2>
    <%@ include file="../shared/orderLines.jspf" %>
    <c:choose>
        <c:when test="${not pending}">
            <p><strong>Người giao đã phân công:</strong> <c:out value="${order.deliveryStaff.fullName}"/></p>
            <form action="<c:url value='/warehouse/invoice'/>" method="post">
                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                <input type="hidden" name="orderId" value="<c:out value='${order.id}'/>">
                <button class="btn btn-secondary" type="submit">In hóa đơn</button>
            </form>
            <c:if test="${inDelivery}">
                <form action="<c:url value='/warehouse/complete-delivery'/>" method="post" class="mt-2">
                    <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                    <input type="hidden" name="orderId" value="<c:out value='${order.id}'/>">
                    <button class="btn btn-primary" type="submit">Xác nhận đã giao</button>
                </form>
            </c:if>
        </c:when>
        <c:otherwise>
            <h2 class="h5 mt-4" id="delivery-title">Chọn nhân viên giao hàng</h2>
            <form id="approve-form" action="<c:url value='/warehouse/approve'/>" method="post">
                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                <input type="hidden" name="orderId" value="<c:out value='${order.id}'/>">
                <c:choose>
                    <c:when test="${empty deliveryStaff}"><p class="alert alert-info">Chưa có nhân viên giao hàng đang rảnh.</p></c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table align-middle" aria-labelledby="delivery-title">
                                <thead><tr><th scope="col">Chọn</th><th scope="col">Họ tên</th>
                                    <th scope="col">Điện thoại</th><th scope="col">Trạng thái</th></tr></thead>
                                <tbody>
                                <c:forEach items="${deliveryStaff}" var="staff">
                                    <tr>
                                        <td><input class="form-check-input" type="radio" name="deliveryStaffId"
                                                   id="staff-${staff.id}" value="${staff.id}" required></td>
                                        <td><label for="staff-${staff.id}"><c:out value="${staff.fullName}"/></label></td>
                                        <td><c:out value="${staff.phoneNumber}"/></td>
                                        <td><c:out value="${staff.workStatus}"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
                <button id="approve-button" class="btn btn-primary" type="submit" disabled>Cập nhật trạng thái</button>
                <button class="btn btn-secondary" type="button" disabled>In hóa đơn</button>
                <p class="form-text">Có thể in hóa đơn sau khi hệ thống xác nhận xuất hàng.</p>
            </form>
            <script src="<c:url value='/assets/approve.js'/>" defer></script>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
