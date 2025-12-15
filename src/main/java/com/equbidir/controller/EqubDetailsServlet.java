package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import com.equbidir.model.EqubMemberInfo;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/member/equb-details")
public class EqubDetailsServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Member user = session == null ? null : (Member) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String equbIdStr = request.getParameter("equb_id");

        try {
            // If equb_id not provided, fall back to the first Equb membership.
            int equbId;
            if (equbIdStr == null || equbIdStr.trim().isEmpty()) {
                var memberships = memberDAO.getEqubMemberships(user.getMemberId());
                if (memberships.isEmpty()) {
                    request.setAttribute("equbInfo", null);
                    request.getRequestDispatcher("/views/member/equb-details.jsp").forward(request, response);
                    return;
                }
                equbId = memberships.get(0).getEqubId();
            } else {
                equbId = Integer.parseInt(equbIdStr);
            }

            EqubMemberInfo equbInfo = memberDAO.getMemberEqubInfo(user.getMemberId(), equbId);
            request.setAttribute("equbInfo", equbInfo);
            request.getRequestDispatcher("/views/member/equb-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("error", "Error loading Equb details: " + e.getMessage());
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