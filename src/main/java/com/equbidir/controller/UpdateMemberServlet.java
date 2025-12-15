package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UpdateMemberServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && "admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        HttpSession session = req.getSession();
        String action = req.getParameter("action");
        String idParam = req.getParameter("member_id");

        if (idParam == null || idParam.trim().isEmpty()) {
            session.setAttribute("error", "Missing member id.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        int memberId;
        try {
            memberId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid member id.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            if ("update".equalsIgnoreCase(action)) {
                String fullName = req.getParameter("full_name");
                String phone = req.getParameter("phone");
                String address = req.getParameter("address");
                String role = req.getParameter("role");

                Member m = new Member(memberId, fullName, phone, address, role);
                boolean ok = memberDAO.updateMember(m);
                session.setAttribute(ok ? "message" : "error", ok ? "Member updated successfully." : "Failed to update member.");

            } else if ("reset_password".equalsIgnoreCase(action)) {
                String newPassword = req.getParameter("password");
                if (newPassword == null || newPassword.trim().isEmpty()) {
                    session.setAttribute("error", "Password is required.");
                } else {
                    boolean ok = memberDAO.resetPassword(memberId, newPassword);
                    session.setAttribute(ok ? "message" : "error", ok ? "Password reset successfully." : "Failed to reset password.");
                }
            } else {
                session.setAttribute("error", "Unknown action.");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/edit-member?id=" + memberId);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
