package controller;

import dao.DeliveryStaffDAO;
import dao.OnlineOrderDAO;
import model.OnlineOrder6;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/warehouse/approve")
public class ApproveOrderServlet extends WebServletSupport {
    private final OnlineOrderDAO orders = new OnlineOrderDAO();
    private final DeliveryStaffDAO deliveryStaff = new DeliveryStaffDAO();

    /** Hiển thị đơn và người giao đang rảnh, hoặc phân công đã lưu nếu đơn đã xuất. */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = readId(request, response, "orderId");
        if (orderId == 0) {
            return;
        }
        try {
            showOrder(request, response, orderId);
        } catch (SQLException e) {
            throw new ServletException("Không thể đọc đơn hàng.", e);
        }
    }

    /** Xác nhận xuất và chuyển hướng sang GET để làm mới trang an toàn. */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = readId(request, response, "orderId");
        if (orderId == 0) {
            return;
        }
        int deliveryStaffId = readId(request, response, "deliveryStaffId");
        if (deliveryStaffId == 0) {
            return;
        }
        int warehouseStaffId = (Integer) request.getSession(false).getAttribute("memberId");
        try {
            if (orders.updateOrderStatus(orderId, deliveryStaffId, OnlineOrder6.EXPORTED, warehouseStaffId)) {
                redirect(request, response, "/warehouse/approve?orderId=" + orderId);
                return;
            }
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            request.setAttribute("error", "Đơn đã thay đổi hoặc người giao không còn rảnh. Kiểm tra lại thông tin bên dưới.");
            showOrder(request, response, orderId);
        } catch (SQLException e) {
            throw new ServletException("Không thể xác nhận xuất hàng.", e);
        }
    }

    private void showOrder(HttpServletRequest request, HttpServletResponse response, int orderId)
            throws SQLException, IOException, ServletException {
        OnlineOrder6 order = orders.getOrderById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
            return;
        }
        boolean pending = OnlineOrder6.UNEXPORTED.equals(order.getStatus());
        request.setAttribute("order", order);
        request.setAttribute("pending", pending);
        request.setAttribute("inDelivery", OnlineOrder6.EXPORTED.equals(order.getStatus()));
        if (pending) {
            request.setAttribute("deliveryStaff", deliveryStaff.getAvailableStaff());
        }
        view(request, response, "warehouseStaff/ApproveAndExportOrder");
    }
}
