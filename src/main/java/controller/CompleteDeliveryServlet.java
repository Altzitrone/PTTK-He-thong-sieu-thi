package controller;

import dao.OnlineOrderDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/warehouse/complete-delivery")
public class CompleteDeliveryServlet extends WebServletSupport {
    private final OnlineOrderDAO orders = new OnlineOrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = readId(request, response, "orderId");
        if (orderId == 0) {
            return;
        }
        try {
            if (!orders.completeDelivery(orderId)) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Chỉ xác nhận giao cho đơn đang ở trạng thái Đã xuất.");
                return;
            }
            redirect(request, response, "/warehouse/approve?orderId=" + orderId);
        } catch (SQLException e) {
            throw new ServletException("Không thể xác nhận đã giao.", e);
        }
    }
}
