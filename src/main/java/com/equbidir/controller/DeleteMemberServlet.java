package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/delete-member")
public class DeleteMemberServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Member currentUser = (Member) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("error", "Invalid member ID.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            int memberId = Integer.parseInt(idParam);

            if (memberId == currentUser.getMemberId()) {
                session.setAttribute("error", "You cannot delete your own admin account.");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            boolean deleted = memberDAO.deleteMember(memberId);

            if (deleted) {
                session.setAttribute("message", "Member deleted successfully.");
            } else {
                session.setAttribute("error", "Failed to delete member.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid member ID format.");
        } catch (Exception e) {
            session.setAttribute("error", "Error deleting member.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}