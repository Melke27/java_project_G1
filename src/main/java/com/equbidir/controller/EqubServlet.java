package com.equbidir.controller;

import com.equbidir.dao.EqubDAO;
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.EqubGroup;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class EqubServlet extends HttpServlet {

    private final EqubDAO equbDAO = new EqubDAO();
    private final MemberDAO memberDAO = new MemberDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        Member user = (session != null) ? (Member) session.getAttribute("user") : null;
        return user != null && "admin".equalsIgnoreCase(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Load all Equb groups
            List<EqubGroup> groups = equbDAO.getAllGroups();
            req.setAttribute("groups", groups);

            // Load all members
            List<Member> allMembers = memberDAO.getAllMembers();

            // Filter available members: only those in less than 2 groups
            List<Member> availableMembers = new ArrayList<>();
            for (Member m : allMembers) {
                int groupCount = memberDAO.countEqubGroupsForMember(m.getMemberId());
                if (groupCount < 2) {
                    availableMembers.add(m);
                }
            }
            req.setAttribute("availableMembers", availableMembers);

            // Handle selected group
            String equbIdStr = req.getParameter("equb_id");
            if (equbIdStr != null && !equbIdStr.trim().isEmpty()) {
                int equbId = Integer.parseInt(equbIdStr);
                req.setAttribute("selectedEqubId", equbId);
                req.setAttribute("equbMembers", equbDAO.getEqubMembers(equbId));
            }

            req.getRequestDispatcher("/views/admin/equb_management.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading Equb management page", e);
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
            if ("create_group".equalsIgnoreCase(action)) {
                EqubGroup g = new EqubGroup();
                g.setEqubName(req.getParameter("equb_name"));
                g.setAmount(Double.parseDouble(req.getParameter("amount")));
                g.setFrequency(req.getParameter("frequency"));

                equbDAO.createGroup(g);

                HttpSession session = req.getSession();
                session.setAttribute("message", "Equb group created successfully!");
                resp.sendRedirect(req.getContextPath() + "/admin/equb");
                return;
            }

            if ("delete_group".equalsIgnoreCase(action)) {
                int equbId = Integer.parseInt(req.getParameter("equb_id"));
                equbDAO.deleteGroup(equbId);

                HttpSession session = req.getSession();
                session.setAttribute("message", "Equb group deleted successfully!");
                resp.sendRedirect(req.getContextPath() + "/admin/equb");
                return;
            }

            // All other actions require equb_id
            String equbIdStr = req.getParameter("equb_id");
            if (equbIdStr == null || equbIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Equb ID is required");
            }
            int equbId = Integer.parseInt(equbIdStr);

            HttpSession session = req.getSession();

            if ("add_member".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));

                // Prevent adding if already in 2 groups
                int currentCount = memberDAO.countEqubGroupsForMember(memberId);
                if (currentCount >= 2) {
                    session.setAttribute("error", "This member is already in 2 Equb groups and cannot join more.");
                }
                // Prevent duplicate in same group
                else if (equbDAO.isMemberInEqub(memberId, equbId)) {
                    session.setAttribute("error", "This member is already in this group.");
                } else {
                    equbDAO.addMemberToEqub(memberId, equbId);
                    session.setAttribute("message", "Member added successfully!");
                }
            }
            else if ("approve_payment".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));

                Member admin = (Member) session.getAttribute("user");
                Integer approvedBy = (admin != null) ? admin.getMemberId() : null;

                equbDAO.approvePayment(equbId, memberId, approvedBy);
                session.setAttribute("message", "Payment approved successfully!");
            }
            else if ("generate_rotation".equalsIgnoreCase(action)) {
                boolean random = "random".equalsIgnoreCase(req.getParameter("mode"));
                equbDAO.generateRotation(equbId, random);
                session.setAttribute("message", "Rotation generated successfully!");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/equb?equb_id=" + equbId);

        } catch (Exception e) {
            HttpSession session = req.getSession();
            session.setAttribute("error", "Operation failed: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/equb");
        }
    }
}