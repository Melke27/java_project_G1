package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EditMemberServlet extends HttpServlet {

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

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Missing member id.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            int memberId = Integer.parseInt(idParam);
            Member member = memberDAO.getMemberById(memberId);
            if (member == null) {
                req.getSession().setAttribute("error", "Member not found.");
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                return;
            }

            req.setAttribute("memberToEdit", member);
            req.getRequestDispatcher("/views/admin/edit-member.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid member id.");
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
