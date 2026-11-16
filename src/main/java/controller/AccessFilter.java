package controller;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AccessFilter implements Filter {
    /** Thiết lập UTF-8, kiểm tra vai trò và xác thực yêu cầu POST thay đổi trạng thái. */
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        if (path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        response.setHeader("Cache-Control", "no-store");
        HttpSession session = request.getSession(false);
        String role = session == null ? null : (String) session.getAttribute("role");
        if (role == null && !"/login".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ((path.startsWith("/customer/") && !"CUSTOMER".equals(role))
                || (path.startsWith("/warehouse/") && !"WAREHOUSE".equals(role))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Tài khoản không có quyền truy cập.");
            return;
        }

        if ("POST".equals(request.getMethod()) && !"/customer/search".equals(path)) {
            Object token = session == null ? null : session.getAttribute("csrfToken");
            if (token == null || !token.equals(request.getParameter("csrfToken"))) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Biểu mẫu đã hết hiệu lực.");
                return;
            }
        }
        chain.doFilter(request, response);
    }
}
