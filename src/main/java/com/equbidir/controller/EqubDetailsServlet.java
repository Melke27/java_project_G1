package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import com.equbidir.model.EqubMembership;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/member/equb-details")
public class EqubDetailsServlet extends HttpServlet {

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
            // Fetch ALL Equb memberships for this member
            List<EqubMembership> equbMemberships = memberDAO.getEqubMemberships(user.getMemberId());

            // Load actual group members for each Equb group
            if (equbMemberships != null) {
                for (EqubMembership equb : equbMemberships) {
                    List<Member> groupMembers = memberDAO.getMembersInEqub(equb.getEqubId());
                    equb.setGroupMembers(groupMembers != null ? groupMembers : Collections.emptyList());
                }
            }

            // Pass the enriched list to JSP
            request.setAttribute("equbMemberships",
                    equbMemberships != null ? equbMemberships : Collections.emptyList());

            request.getRequestDispatcher("/views/member/equb-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("error", "Unable to load your Equb groups. Please try again later.");
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