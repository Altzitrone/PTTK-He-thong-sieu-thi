package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/customer/home", "/warehouse/home"})
public class HomeServlet extends WebServletSupport {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String home = "/warehouse/home".equals(request.getServletPath())
                ? "warehouseStaff/WarehouseHome"
                : "customer/CustomerHome";
        view(request, response, home);
    }
}
