package com.equbidir.controller;

import com.equbidir.dao.ExpenseDAO;
<<<<<<< HEAD
import com.equbidir.dao.IdirDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

public class ExpenseServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();
    private final IdirDAO idirDAO = new IdirDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && "admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            req.setAttribute("groups", idirDAO.getAllGroups());
            String idirIdStr = req.getParameter("idir_id");
            if (idirIdStr != null && !idirIdStr.trim().isEmpty()) {
                int idirId = Integer.parseInt(idirIdStr);
                req.setAttribute("selectedIdirId", idirId);
                req.setAttribute("expenses", expenseDAO.listExpensesByIdir(idirId));
            }
            req.getRequestDispatcher("/views/admin/expense_management.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
=======
import com.equbidir.model.Expense;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ExpenseServlet", urlPatterns = {"/admin/expenses", "/admin/reports"})
public class ExpenseServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Expense> expenses = expenseDAO.findAll();
            Map<String, BigDecimal> categoryTotals = expenseDAO.getCategoryTotals();
            Map<String, BigDecimal> monthlyTotals = expenseDAO.getMonthlyTotals();
            BigDecimal totalExpenses = expenseDAO.getTotalExpenses();
            BigDecimal fundBalance = expenseDAO.getFundBalance();

            request.setAttribute("expenses", expenses);
            request.setAttribute("categoryTotals", categoryTotals);
            request.setAttribute("monthlyTotals", monthlyTotals);
            request.setAttribute("totalExpenses", totalExpenses);
            request.setAttribute("fundBalance", fundBalance);
            String uri = request.getRequestURI();
            String view = uri != null && uri.endsWith("/reports")
                    ? "/views/admin/reports.jsp"
                    : "/views/admin/expense_management.jsp";
            request.getRequestDispatcher(view).forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load expenses", e);
>>>>>>> 02b51aac394f9d81545be5c42cde5eaebbec63e2
        }
    }

    @Override
<<<<<<< HEAD
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int idirId = Integer.parseInt(req.getParameter("idir_id"));
            double amount = Double.parseDouble(req.getParameter("amount"));
            String description = req.getParameter("description");
            Date expenseDate = Date.valueOf(req.getParameter("expense_date"));

            expenseDAO.addExpense(idirId, amount, description, expenseDate);
            resp.sendRedirect(req.getContextPath() + "/admin/expenses?idir_id=" + idirId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
=======
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Expense expense = mapRequestToExpense(request);
            expenseDAO.addExpense(expense);
            response.sendRedirect(request.getContextPath() + "/admin/expenses");
        } catch (SQLException e) {
            throw new ServletException("Unable to save expense", e);
        }
    }

    private Expense mapRequestToExpense(HttpServletRequest request) {
        BigDecimal amount = new BigDecimal(request.getParameter("amount"));
        LocalDate date = LocalDate.parse(request.getParameter("date"));
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        return new Expense(amount, date, description, category);
    }
}

>>>>>>> 02b51aac394f9d81545be5c42cde5eaebbec63e2
