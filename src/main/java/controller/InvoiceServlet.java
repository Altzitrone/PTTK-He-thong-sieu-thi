package controller;

import dao.InvoiceDAO;
import dao.OnlineOrderDAO;
import model.Invoice6;
import model.OnlineOrder6;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/warehouse/invoice")
public class InvoiceServlet extends WebServletSupport {
    private final OnlineOrderDAO orders = new OnlineOrderDAO();
    private final InvoiceDAO invoices = new InvoiceDAO();

    /** Chuẩn bị bản in từ chứng từ của đơn đã xác nhận xuất. */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = readId(request, response, "orderId");
        if (orderId == 0) {
            return;
        }
        try {
            OnlineOrder6 order = orders.getOrderById(orderId);
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
                return;
            }
            Invoice6 invoice = invoices.getByOrderId(order);
            if (OnlineOrder6.UNEXPORTED.equals(order.getStatus()) || invoice == null || invoice.getDeliveryStaff() == null
                    || !invoices.createInvoice(invoice)) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Cần xác nhận xuất trước khi in hóa đơn.");
                return;
            }
            request.setAttribute("invoice", invoices.getByOrderId(order));
            view(request, response, "warehouseStaff/InvoiceDetail");
        } catch (SQLException e) {
            throw new ServletException("Không thể chuẩn bị hóa đơn.", e);
        }
    }
}
