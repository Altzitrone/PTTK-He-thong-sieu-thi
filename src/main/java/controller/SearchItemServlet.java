package controller;

import dao.ItemDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/customer/search")
public class SearchItemServlet extends WebServletSupport {
    private final ItemDAO items = new ItemDAO();

    /** Hiển thị biểu mẫu và tìm các mặt hàng có tên chứa từ khóa. */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String input = request.getParameter("keyword");
        if (input != null) {
            String keyword = input.strip();
            if (keyword.isEmpty() || keyword.length() > 160) {
                request.setAttribute("error", "Nhập từ khóa từ 1 đến 160 ký tự.");
            } else {
                try {
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("items", items.searchItemByName(keyword));
                } catch (SQLException e) {
                    throw new ServletException("Không thể tìm kiếm mặt hàng.", e);
                }
            }
        }
        view(request, response, "customer/SearchItem");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
