package com.equbidir.controller;

import com.equbidir.dao.ExpenseDAO;
import com.equbidir.dao.IdirDAO;
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/admin/reports")
public class ReportsServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();
    private final IdirDAO idirDAO = new IdirDAO();
    private final MemberDAO memberDAO = new MemberDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        Member user = (session != null) ? (Member) session.getAttribute("user") : null;
        return user != null && "admin".equalsIgnoreCase(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            BigDecimal totalExpenses = expenseDAO.getTotalExpenses();
            BigDecimal fundBalance = idirDAO.getTotalFundBalance();
            int totalMembers = memberDAO.countRegularMembers(null);
            int activeEqubGroups = expenseDAO.countActiveEqubGroups();

            req.setAttribute("totalExpenses", totalExpenses);
            req.setAttribute("fundBalance", fundBalance);
            req.setAttribute("totalMembers", totalMembers);
            req.setAttribute("activeEqubGroups", activeEqubGroups);

            req.setAttribute("monthlyTotals", expenseDAO.getMonthlyExpenseTotals());
            req.setAttribute("expenses", expenseDAO.getAllExpenses());

            // Category totals skipped since no category column — you can add later

            req.getRequestDispatcher("/views/admin/reports.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Unable to load reports.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }
}