package controller;

import dao.MemberDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.UUID;

@WebServlet("/login")
public class LoginServlet extends WebServletSupport {
    private final MemberDAO members = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role != null) {
            goToHome(request, response, role);
            return;
        }
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }
        view(request, response, "member/Login");
    }

    /** Kiểm tra mật khẩu và tạo phiên mới theo vai trò lấy từ CSDL. */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String rawPassword = request.getParameter("password");
        MemberDAO.Account account = null;
        if (username != null && !username.isBlank() && username.length() <= 80
                && rawPassword != null && !rawPassword.isEmpty() && rawPassword.length() <= 128) {
            char[] password = rawPassword.toCharArray();
            try {
                account = members.authenticate(username.strip(), password);
            } catch (SQLException e) {
                throw new ServletException("Không thể xác thực tài khoản.", e);
            } finally {
                Arrays.fill(password, '\0');
            }
        }

        if (account == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
            view(request, response, "member/Login");
            return;
        }

        request.getSession().invalidate();
        HttpSession session = request.getSession(true);
        session.setAttribute("memberId", account.id());
        session.setAttribute("fullName", account.fullName());
        session.setAttribute("role", account.role());
        session.setAttribute("csrfToken", UUID.randomUUID().toString());
        goToHome(request, response, account.role());
    }

    private void goToHome(HttpServletRequest request, HttpServletResponse response, String role) {
        redirect(request, response, "WAREHOUSE".equals(role) ? "/warehouse/home" : "/customer/home");
    }
}
