package com.equbidir.controller;

import com.equbidir.dao.ExpenseDAO;
import com.equbidir.dao.IdirDAO;
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Expense;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports")
public class ReportsServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();
    private final IdirDAO idirDAO = new IdirDAO();
    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Security Check
        HttpSession session = req.getSession(false);
        Member user = (session != null) ? (Member) session.getAttribute("user") : null;
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Set Active Page for Sidebar Highlighting
        req.setAttribute("activePage", "expenses.reports");

        try {
            // 3. Fetch Data
            BigDecimal totalExpenses = expenseDAO.getTotalExpenses();
            BigDecimal fundBalance = idirDAO.getTotalFundBalance();
            int totalMembers = memberDAO.countRegularMembers(null);
            int activeEqubGroups = expenseDAO.countActiveEqubGroups();
            Map<String, BigDecimal> monthlyTotals = expenseDAO.getMonthlyExpenseTotals();
            List<Expense> expenses = expenseDAO.getAllExpenses();

            // 4. Handle Categories (Since DB has no category column, we aggregate everything as 'General')
            Map<String, BigDecimal> categoryTotals = new HashMap<>();
            if (totalExpenses != null && totalExpenses.compareTo(BigDecimal.ZERO) > 0) {
                categoryTotals.put("General Idir Expenses", totalExpenses);
            }

            // 5. Set Attributes
            req.setAttribute("totalExpenses", totalExpenses);
            req.setAttribute("fundBalance", fundBalance);
            req.setAttribute("totalMembers", totalMembers);
            req.setAttribute("activeEqubGroups", activeEqubGroups);
            req.setAttribute("monthlyTotals", monthlyTotals);
            req.setAttribute("expenses", expenses);
            req.setAttribute("categoryTotals", categoryTotals);

            // 6. Forward to JSP
            req.getRequestDispatcher("/views/admin/reports.jsp").forward(req, resp);

        } catch (Exception ex) {
            ex.printStackTrace();
            req.getSession().setAttribute("error", "Error loading reports: " + ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }
}