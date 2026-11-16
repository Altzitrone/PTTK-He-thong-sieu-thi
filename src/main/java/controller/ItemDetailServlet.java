package controller;

import dao.ItemDAO;
import model.Item6;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/customer/item")
public class ItemDetailServlet extends WebServletSupport {
    private final ItemDAO items = new ItemDAO();

    /** Đọc chi tiết theo mã và trả 404 nếu mặt hàng không tồn tại. */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = readId(request, response, "id");
        if (id == 0) {
            return;
        }
        try {
            Item6 item = items.getItemById(id);
            if (item == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy mặt hàng.");
                return;
            }
            request.setAttribute("item", item);
            view(request, response, "customer/ItemDetail");
        } catch (SQLException e) {
            throw new ServletException("Không thể đọc mặt hàng.", e);
        }
    }
}
