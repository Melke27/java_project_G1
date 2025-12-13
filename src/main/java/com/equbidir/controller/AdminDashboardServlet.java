package com.equbidir.controller;

import com.equbidir.dao.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminDashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            req.setAttribute("membersCount", dashboardDAO.countMembers());
            req.setAttribute("equbGroupsCount", dashboardDAO.countEqubGroups());
            req.setAttribute("idirGroupsCount", dashboardDAO.countIdirGroups());
            req.setAttribute("equbUnpaidCount", dashboardDAO.countEqubUnpaidMembers());
            req.setAttribute("idirUnpaidCount", dashboardDAO.countIdirUnpaidMembers());
            req.setAttribute("idirExpensesCount", dashboardDAO.countIdirExpenses());
            req.setAttribute("idirExpensesTotal", dashboardDAO.totalIdirExpensesAmount());
        } catch (Exception e) {
            // Keep the dashboard working even if DB is not configured yet.
            req.setAttribute("dashboardError", "Dashboard stats unavailable: " + e.getMessage());
        }

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}
