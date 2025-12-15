package com.equbidir.controller;

import com.equbidir.dao.DashboardDAO;
import com.equbidir.dao.MemberDAO;

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
    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("q");

        int page = 1;
        int size = 10;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("size") != null) {
                size = Integer.parseInt(request.getParameter("size"));
            }
        } catch (NumberFormatException ignored) {
        }
        if (page < 1) page = 1;
        if (size < 5) size = 5;
        if (size > 50) size = 50;

        try {
            // Stats
            request.setAttribute("membersCount", dashboardDAO.countMembers());
            request.setAttribute("equbGroupsCount", dashboardDAO.countEqubGroups());
            request.setAttribute("idirGroupsCount", dashboardDAO.countIdirGroups());
            request.setAttribute("equbUnpaidCount", dashboardDAO.countEqubUnpaidMembers());
            request.setAttribute("idirUnpaidCount", dashboardDAO.countIdirUnpaidMembers());
            request.setAttribute("idirExpensesCount", dashboardDAO.countIdirExpenses());
            request.setAttribute("idirExpensesTotal", dashboardDAO.totalIdirExpensesAmount());

            // Members list (non-admin only)
            int totalRegular = memberDAO.countRegularMembers(search);
            int totalPages = (int) Math.ceil(totalRegular / (double) size);
            if (totalPages == 0) totalPages = 1;
            if (page > totalPages) page = totalPages;

            request.setAttribute("regularMembers", memberDAO.getRegularMembers(search, (page - 1) * size, size));
            request.setAttribute("regularMembersTotal", totalRegular);
            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("q", search);

        } catch (Exception e) {
            // Keep the dashboard page rendering even if DB is not configured yet.
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
