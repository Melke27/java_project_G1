package com.equbidir.controller;

import com.equbidir.dao.IdirDAO;
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.IdirGroup;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class IdirServlet extends HttpServlet {

    private final IdirDAO idirDAO = new IdirDAO();
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
            // Load all Idir groups
            List<IdirGroup> groups = idirDAO.getAllGroups();
            req.setAttribute("groups", groups);

            // Load all members
            List<Member> allMembers = memberDAO.getAllMembers();

            // Filter: only members NOT in any Idir group (max 1 allowed)
            List<Member> availableMembers = new ArrayList<>();
            for (Member m : allMembers) {
                int groupCount = memberDAO.countIdirGroupsForMember(m.getMemberId());
                if (groupCount == 0) {
                    availableMembers.add(m);
                }
            }
            req.setAttribute("availableMembers", availableMembers);

            // Handle selected group
            String idirIdStr = req.getParameter("idir_id");
            if (idirIdStr != null && !idirIdStr.trim().isEmpty()) {
                int idirId = Integer.parseInt(idirIdStr);
                req.setAttribute("selectedIdirId", idirId);
                req.setAttribute("idirMembers", idirDAO.getIdirMembers(idirId));
            }

            req.getRequestDispatcher("/views/admin/idir_management.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading Idir management page", e);
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
                IdirGroup g = new IdirGroup();
                g.setIdirName(req.getParameter("idir_name"));
                g.setMonthlyPayment(Double.parseDouble(req.getParameter("monthly_payment")));

                idirDAO.createGroup(g);

                HttpSession session = req.getSession();
                session.setAttribute("message", "Idir group created successfully!");
                resp.sendRedirect(req.getContextPath() + "/admin/idir");
                return;
            }

            if ("delete_group".equalsIgnoreCase(action)) {
                int idirId = Integer.parseInt(req.getParameter("idir_id"));
                idirDAO.deleteGroup(idirId);

                HttpSession session = req.getSession();
                session.setAttribute("message", "Idir group deleted successfully!");
                resp.sendRedirect(req.getContextPath() + "/admin/idir");
                return;
            }

            String idirIdStr = req.getParameter("idir_id");
            if (idirIdStr == null || idirIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Idir ID is required");
            }
            int idirId = Integer.parseInt(idirIdStr);

            HttpSession session = req.getSession();

            if ("add_member".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));

                // Server-side protection: only allow if not in any Idir group
                int currentCount = memberDAO.countIdirGroupsForMember(memberId);
                if (currentCount > 0) {
                    session.setAttribute("error", "This member is already in an Idir group and cannot join another.");
                }
                // Prevent duplicate in same group
                else if (idirDAO.isMemberInIdir(memberId, idirId)) {
                    session.setAttribute("error", "This member is already in this group.");
                } else {
                    idirDAO.addMemberToIdir(memberId, idirId);
                    session.setAttribute("message", "Member added successfully!");
                }
            }
            else if ("approve_payment".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));

                Member admin = (Member) session.getAttribute("user");
                Integer approvedBy = (admin != null) ? admin.getMemberId() : null;

                idirDAO.approvePayment(idirId, memberId, approvedBy);
                session.setAttribute("message", "Payment approved successfully!");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/idir?idir_id=" + idirId);

        } catch (Exception e) {
            HttpSession session = req.getSession();
            session.setAttribute("error", "Operation failed: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/idir");
        }
    }
}