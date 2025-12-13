package com.equbidir.controller;

import com.equbidir.dao.ExpenseDAO;
import com.equbidir.dao.IdirDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
        }
    }

    @Override
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
