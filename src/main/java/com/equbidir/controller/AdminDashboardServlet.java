package com.equbidir.controller;

import com.equbidir.dao.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            request.setAttribute("membersCount", dashboardDAO.countMembers());
            request.setAttribute("equbGroupsCount", dashboardDAO.countEqubGroups());
            request.setAttribute("idirGroupsCount", dashboardDAO.countIdirGroups());
            request.setAttribute("equbUnpaidCount", dashboardDAO.countEqubUnpaidMembers());
            request.setAttribute("idirUnpaidCount", dashboardDAO.countIdirUnpaidMembers());
            request.setAttribute("idirExpensesCount", dashboardDAO.countIdirExpenses());
            request.setAttribute("idirExpensesTotal", dashboardDAO.totalIdirExpensesAmount());
        } catch (Exception e) {
            // Keep the dashboard working even if DB is not configured yet.
            request.setAttribute("dashboardError", "Dashboard stats unavailable: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
