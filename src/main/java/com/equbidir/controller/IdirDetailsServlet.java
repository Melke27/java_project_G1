package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import com.equbidir.model.IdirMembership;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/member/idir-details")
public class IdirDetailsServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Member user = (session != null) ? (Member) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get all Idir groups for this member
            List<IdirMembership> idirMemberships = memberDAO.getIdirMemberships(user.getMemberId());

            // Load real members for each group
            if (idirMemberships != null) {
                for (IdirMembership idir : idirMemberships) {
                    List<Member> groupMembers = memberDAO.getMembersInIdir(idir.getIdirId());
                    idir.setGroupMembers(groupMembers != null ? groupMembers : Collections.emptyList());
                }
            }

            request.setAttribute("idirMemberships",
                    idirMemberships != null ? idirMemberships : Collections.emptyList());

            request.getRequestDispatcher("/views/member/idir-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("error", "Unable to load your Idir groups. Please try again later.");
            }
            response.sendRedirect(request.getContextPath() + "/member/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}