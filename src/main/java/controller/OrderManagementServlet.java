package controller;

import dao.OnlineOrderDAO;
import model.OnlineOrder6;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/warehouse/orders")
public class OrderManagementServlet extends WebServletSupport {
    private final OnlineOrderDAO orders = new OnlineOrderDAO();

    /** Hiển thị tất cả đơn hoặc lọc theo trạng thái. */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        if (!OnlineOrder6.UNEXPORTED.equals(status) && !OnlineOrder6.EXPORTED.equals(status)
                && !OnlineOrder6.DELIVERED.equals(status)) {
            status = null;
        }
        try {
            request.setAttribute("status", status);
            request.setAttribute("orders", orders.getOrdersByStatus(status));
            view(request, response, "warehouseStaff/OrderList");
        } catch (SQLException e) {
            throw new ServletException("Không thể đọc danh sách đơn hàng.", e);
        }
    }
}
