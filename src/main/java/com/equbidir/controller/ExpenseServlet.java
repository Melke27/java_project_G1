package com.equbidir.controller;

import com.equbidir.dao.ExpenseDAO;
import com.equbidir.dao.IdirDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/expenses")
public class ExpenseServlet extends HttpServlet {

    private final ExpenseDAO expenseDAO = new ExpenseDAO();
    private final IdirDAO idirDAO = new IdirDAO();

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
            req.setAttribute("groups", idirDAO.getAllGroups());

            String idirIdStr = req.getParameter("idir_id");
            if (idirIdStr != null && !idirIdStr.trim().isEmpty()) {
                int idirId = Integer.parseInt(idirIdStr);
                req.setAttribute("selectedIdirId", idirId);
                req.setAttribute("expenses", expenseDAO.listExpensesByIdir(idirId));
            }

            req.getRequestDispatcher("/views/admin/expense_management.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Unable to load expenses.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        HttpSession session = req.getSession();

        try {
            int idirId = Integer.parseInt(req.getParameter("idir_id"));
            double amount = Double.parseDouble(req.getParameter("amount"));
            String description = req.getParameter("description");
            String dateStr = req.getParameter("expense_date");

            if (dateStr == null || dateStr.trim().isEmpty()) {
                session.setAttribute("error", "Expense date is required.");
                resp.sendRedirect(req.getContextPath() + "/admin/expenses?idir_id=" + idirId);
                return;
            }

            Date expenseDate = Date.valueOf(dateStr);

            expenseDAO.addExpense(idirId, amount, description, expenseDate);

            session.setAttribute("message", "Expense recorded successfully!");
            resp.sendRedirect(req.getContextPath() + "/admin/expenses?idir_id=" + idirId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to record expense: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/expenses");
        }
    }
}