package com.equbidir.controller;

import com.equbidir.dao.EqubDAO;
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.EqubGroup;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class EqubServlet extends HttpServlet {

    private final EqubDAO equbDAO = new EqubDAO();
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
            req.setAttribute("groups", equbDAO.getAllGroups());
            req.setAttribute("allMembers", memberDAO.getAllMembers());

            String equbIdStr = req.getParameter("equb_id");
            if (equbIdStr != null && !equbIdStr.trim().isEmpty()) {
                int equbId = Integer.parseInt(equbIdStr);
                req.setAttribute("selectedEqubId", equbId);
                req.setAttribute("equbMembers", equbDAO.getEqubMembers(equbId));
            }

            req.getRequestDispatcher("/views/admin/equb_management.jsp").forward(req, resp);
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
        String equbIdStr = req.getParameter("equb_id");

        try {
            if ("create_group".equalsIgnoreCase(action)) {
                EqubGroup g = new EqubGroup();
                g.setEqubName(req.getParameter("equb_name"));
                g.setAmount(Double.parseDouble(req.getParameter("amount")));
                g.setFrequency(req.getParameter("frequency"));
                equbDAO.createGroup(g);
                resp.sendRedirect(req.getContextPath() + "/admin/equb");
                return;
            }

            if ("delete_group".equalsIgnoreCase(action)) {
                equbDAO.deleteGroup(Integer.parseInt(equbIdStr));
                resp.sendRedirect(req.getContextPath() + "/admin/equb");
                return;
            }

            int equbId = Integer.parseInt(equbIdStr);

            if ("add_member".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                equbDAO.addMemberToEqub(memberId, equbId);
            } else if ("approve_payment".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                equbDAO.approvePayment(equbId, memberId);
            } else if ("generate_rotation".equalsIgnoreCase(action)) {
                boolean random = "random".equalsIgnoreCase(req.getParameter("mode"));
                equbDAO.generateRotation(equbId, random);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/equb?equb_id=" + equbId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
