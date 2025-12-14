package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class MemberServlet extends HttpServlet {

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
            req.setAttribute("members", memberDAO.getAllMembers());
            req.getRequestDispatcher("/views/admin/member_management.jsp").forward(req, resp);
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

        String action = req.getParameter("action");

        try {
            if ("create".equalsIgnoreCase(action)) {
                String fullName = req.getParameter("full_name");
                String phone = req.getParameter("phone");
                String address = req.getParameter("address");
                String role = req.getParameter("role");

                String plainPassword = req.getParameter("password");
                if (plainPassword == null || plainPassword.trim().isEmpty()) {
                    plainPassword = "123456";
                }

                Member m = new Member(0, fullName, phone, address, (role == null || role.isEmpty()) ? "member" : role);
                memberDAO.createMember(m, plainPassword);
            } else if ("update".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                String fullName = req.getParameter("full_name");
                String phone = req.getParameter("phone");
                String address = req.getParameter("address");
                String role = req.getParameter("role");

                Member m = new Member(memberId, fullName, phone, address, role);
                memberDAO.updateMember(m);
            } else if ("reset_password".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                String newPassword = req.getParameter("password");
                memberDAO.resetPassword(memberId, newPassword);
            } else if ("delete".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                memberDAO.deleteMember(memberId);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/members");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
