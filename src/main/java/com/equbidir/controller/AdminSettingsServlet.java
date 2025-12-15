package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminSettingsServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    private Member requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }

        Object u = session.getAttribute("user");
        if (!(u instanceof Member)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }

        Member user = (Member) u;
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }

        return user;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (requireAdmin(req, resp) == null) return;
        req.getRequestDispatcher("/views/admin/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Member admin = requireAdmin(req, resp);
        if (admin == null) return;

        HttpSession session = req.getSession();
        String action = req.getParameter("action");

        if (!"change_password".equalsIgnoreCase(action)) {
            session.setAttribute("error", "Unknown action.");
            resp.sendRedirect(req.getContextPath() + "/admin/settings");
            return;
        }

        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmNewPassword = req.getParameter("confirmNewPassword");

        if (currentPassword == null || newPassword == null || confirmNewPassword == null ||
                currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmNewPassword.trim().isEmpty()) {
            session.setAttribute("error", "All fields are required.");
            resp.sendRedirect(req.getContextPath() + "/admin/settings");
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            session.setAttribute("error", "New passwords do not match.");
            resp.sendRedirect(req.getContextPath() + "/admin/settings");
            return;
        }

        try {
            boolean ok = memberDAO.verifyCurrentPassword(admin.getMemberId(), currentPassword);
            if (!ok) {
                session.setAttribute("error", "Current password is incorrect.");
                resp.sendRedirect(req.getContextPath() + "/admin/settings");
                return;
            }

            boolean updated = memberDAO.resetPassword(admin.getMemberId(), newPassword);
            session.setAttribute(updated ? "message" : "error", updated ? "Password updated successfully." : "Failed to update password.");
            resp.sendRedirect(req.getContextPath() + "/admin/settings");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
