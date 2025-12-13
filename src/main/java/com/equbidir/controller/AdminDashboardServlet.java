package com.equbidir.controller;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}
