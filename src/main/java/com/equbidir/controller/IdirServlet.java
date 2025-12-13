package com.equbidir.controller;

import com.equbidir.dao.IdirDAO;
<<<<<<< HEAD
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.IdirGroup;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class IdirServlet extends HttpServlet {

    private final IdirDAO idirDAO = new IdirDAO();
    private final MemberDAO memberDAO = new MemberDAO();

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
            req.setAttribute("allMembers", memberDAO.getAllMembers());

            String idirIdStr = req.getParameter("idir_id");
            if (idirIdStr != null && !idirIdStr.trim().isEmpty()) {
                int idirId = Integer.parseInt(idirIdStr);
                req.setAttribute("selectedIdirId", idirId);
                req.setAttribute("idirMembers", idirDAO.getIdirMembers(idirId));
            }

            req.getRequestDispatcher("/views/admin/idir_management.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
=======
import com.equbidir.model.IdirGroup;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/idir")
public class IdirServlet extends HttpServlet {

    private final IdirDAO idirDAO = new IdirDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadGroups(req);
        String selectedId = req.getParameter("groupId");
        if (selectedId != null) {
            try {
                int id = Integer.parseInt(selectedId);
                idirDAO.findById(id).ifPresent(group -> req.setAttribute("selectedGroup", group));
            } catch (NumberFormatException ignored) {
                req.setAttribute("error", "Invalid group id");
            }
        }
        req.getRequestDispatcher("/views/admin/idir_management.jsp").forward(req, resp);
>>>>>>> 02b51aac394f9d81545be5c42cde5eaebbec63e2
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
<<<<<<< HEAD
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String idirIdStr = req.getParameter("idir_id");

        try {
            if ("create_group".equalsIgnoreCase(action)) {
                IdirGroup g = new IdirGroup();
                g.setIdirName(req.getParameter("idir_name"));
                g.setMonthlyPayment(Double.parseDouble(req.getParameter("monthly_payment")));
                idirDAO.createGroup(g);
                resp.sendRedirect(req.getContextPath() + "/admin/idir");
                return;
            }

            if ("delete_group".equalsIgnoreCase(action)) {
                idirDAO.deleteGroup(Integer.parseInt(idirIdStr));
                resp.sendRedirect(req.getContextPath() + "/admin/idir");
                return;
            }

            int idirId = Integer.parseInt(idirIdStr);

            if ("add_member".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                idirDAO.addMemberToIdir(memberId, idirId);
            } else if ("approve_payment".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                idirDAO.approvePayment(idirId, memberId);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/idir?idir_id=" + idirId);
        } catch (Exception e) {
            throw new ServletException(e);
=======
        String action = req.getParameter("action");
        boolean success = false;
        String message = null;
        String error = null;

        try {
            if ("createGroup".equals(action)) {
                success = handleCreate(req);
                message = success ? "Group created" : "Unable to create group";
            } else if ("updateGroup".equals(action)) {
                success = handleUpdate(req);
                message = success ? "Group updated" : "Group not found";
            } else if ("deleteGroup".equals(action)) {
                success = handleDelete(req);
                message = success ? "Group deleted" : "Group not found";
            } else if ("recordPayment".equals(action)) {
                success = handlePayment(req);
                message = success ? "Payment recorded" : "Unable to record payment";
            } else if ("recordExpense".equals(action)) {
                success = handleExpense(req);
                message = success ? "Expense recorded" : "Unable to record expense";
            } else {
                error = "Unknown action";
            }
        } catch (IllegalArgumentException e) {
            error = e.getMessage();
        }

        if (message != null && success) {
            req.getSession().setAttribute("flash", message);
        } else if (error != null) {
            req.getSession().setAttribute("error", error);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/idir");
    }

    private boolean handleCreate(HttpServletRequest req) {
        String name = req.getParameter("name");
        String monthly = req.getParameter("monthlyContribution");
        double monthlyContribution = parseAmount(monthly, "Invalid monthly contribution");
        idirDAO.create(name, monthlyContribution);
        return true;
    }

    private boolean handleUpdate(HttpServletRequest req) {
        int id = parseId(req.getParameter("id"));
        String name = req.getParameter("name");
        double monthlyContribution = parseAmount(req.getParameter("monthlyContribution"), "Invalid monthly contribution");
        return idirDAO.update(id, name, monthlyContribution);
    }

    private boolean handleDelete(HttpServletRequest req) {
        int id = parseId(req.getParameter("id"));
        return idirDAO.delete(id);
    }

    private boolean handlePayment(HttpServletRequest req) {
        int groupId = parseId(req.getParameter("groupId"));
        String member = req.getParameter("member");
        double amount = parseAmount(req.getParameter("amount"), "Invalid payment amount");
        LocalDate date = parseDate(req.getParameter("date"));
        return idirDAO.recordPayment(groupId, member, amount, date);
    }

    private boolean handleExpense(HttpServletRequest req) {
        int groupId = parseId(req.getParameter("groupId"));
        String description = req.getParameter("description");
        double amount = parseAmount(req.getParameter("amount"), "Invalid expense amount");
        LocalDate date = parseDate(req.getParameter("date"));
        return idirDAO.recordExpense(groupId, description, amount, date);
    }

    private int parseId(String id) {
        try {
            return Integer.parseInt(id);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid ID");
        }
    }

    private double parseAmount(String value, String message) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(message);
        }
    }

    private LocalDate parseDate(String value) {
        try {
            return value == null || value.isEmpty() ? LocalDate.now() : LocalDate.parse(value);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Invalid date");
        }
    }

    private void loadGroups(HttpServletRequest req) {
        List<IdirGroup> groups = idirDAO.findAll();
        req.setAttribute("groups", groups);
        Object flash = req.getSession().getAttribute("flash");
        Object error = req.getSession().getAttribute("error");
        if (flash != null) {
            req.setAttribute("message", flash);
            req.getSession().removeAttribute("flash");
        }
        if (error != null) {
            req.setAttribute("error", error);
            req.getSession().removeAttribute("error");
>>>>>>> 02b51aac394f9d81545be5c42cde5eaebbec63e2
        }
    }
}
