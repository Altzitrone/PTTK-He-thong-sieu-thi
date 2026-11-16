<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Hóa đơn xuất | Quản lý siêu thị</title>
    <%@ include file="../shared/head.jspf" %>
</head>
<body>
<%@ include file="../shared/nav.jspf" %>
<main class="container page-shell">

    <c:set var="order" value="${invoice.onlineOrder}"/>
    <c:url value="/warehouse/approve" var="approveUrl"><c:param name="orderId" value="${order.id}"/></c:url>
    <div class="d-print-none d-flex justify-content-between align-items-center mb-3">
        <a class="back-link" href="<c:out value='${approveUrl}'/>">← Chi tiết đơn hàng</a>
        <button type="button" class="btn btn-primary" id="print-invoice">In</button>
    </div>
    <article class="invoice-panel card p-4">
        <p class="eyebrow">QUẢN LÝ SIÊU THỊ</p>
        <h1>Hóa đơn xuất kho</h1>
        <dl class="row mt-3">
            <dt class="col-5 col-sm-3">Mã hóa đơn</dt><dd class="col-7 col-sm-9">#<c:out value="${invoice.id}"/></dd>
            <dt class="col-5 col-sm-3">Mã đơn</dt><dd class="col-7 col-sm-9">#<c:out value="${order.id}"/></dd>
            <dt class="col-5 col-sm-3">Ngày lập bản in</dt><dd class="col-7 col-sm-9"><c:out value="${invoice.printDateLabel}"/></dd>
            <dt class="col-5 col-sm-3">Khách hàng</dt><dd class="col-7 col-sm-9"><c:out value="${order.customer.fullName}"/></dd>
            <dt class="col-5 col-sm-3">Địa chỉ giao</dt><dd class="col-7 col-sm-9"><c:out value="${order.deliveryAddress}"/></dd>
            <dt class="col-5 col-sm-3">Nhân viên kho</dt><dd class="col-7 col-sm-9"><c:out value="${order.warehouseStaff.fullName}" default="—"/></dd>
            <dt class="col-5 col-sm-3">Nhân viên giao hàng</dt><dd class="col-7 col-sm-9"><c:out value="${invoice.deliveryStaff.fullName}"/></dd>
        </dl>
        <%@ include file="../shared/orderLines.jspf" %>
        <p><c:out value="${invoice.paymentDetail}"/></p>
        <div class="row text-center signature-area">
            <div class="col">Người bàn giao</div><div class="col">Nhân viên giao hàng</div>
        </div>
    </article>
    <script src="<c:url value='/assets/invoice.js'/>" defer></script>
</main>
</body>
</html>
