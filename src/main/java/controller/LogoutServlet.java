package controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/logout")
public class LogoutServlet extends WebServletSupport {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().invalidate();
        redirect(request, response, "/login");
    }
}
