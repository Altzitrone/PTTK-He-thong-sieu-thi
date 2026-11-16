package controller;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

abstract class WebServletSupport extends HttpServlet {
    protected void view(HttpServletRequest request, HttpServletResponse response, String jsp)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/" + jsp + ".jsp").forward(request, response);
    }

    protected void redirect(HttpServletRequest request, HttpServletResponse response, String path) {
        response.setStatus(HttpServletResponse.SC_SEE_OTHER);
        response.setHeader("Location", request.getContextPath() + path);
    }

    protected int readId(HttpServletRequest request, HttpServletResponse response, String name) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter(name));
            if (id > 0) {
                return id;
            }
        } catch (NumberFormatException ignored) {
            // Tham số thiếu hoặc không phải số nguyên.
        }
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã không hợp lệ.");
        return 0;
    }
}
