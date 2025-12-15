package com.equbidir.controller;

import com.equbidir.dao.IdirDAO;
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.IdirGroup;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class IdirServlet extends HttpServlet {

    private final IdirDAO idirDAO = new IdirDAO();
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
            req.setAttribute("groups", idirDAO.getAllGroups());
            req.setAttribute("allMembers", memberDAO.getAllMembers());

            String idirIdStr = req.getParameter("idir_id");
            if (idirIdStr != null && !idirIdStr.trim().isEmpty()) {
                int idirId = Integer.parseInt(idirIdStr);
                req.setAttribute("selectedIdirId", idirId);
                req.setAttribute("idirMembers", idirDAO.getIdirMembers(idirId));
            }

            req.getRequestDispatcher("/views/admin/idir_management.jsp").forward(req, resp);
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
        String idirIdStr = req.getParameter("idir_id");

        try {
            if ("create_group".equalsIgnoreCase(action)) {
                IdirGroup g = new IdirGroup();
                g.setIdirName(req.getParameter("idir_name"));
                g.setMonthlyPayment(Double.parseDouble(req.getParameter("monthly_payment")));
                idirDAO.createGroup(g);
                resp.sendRedirect(req.getContextPath() + "/admin/idir");
                return;
            }

            if ("delete_group".equalsIgnoreCase(action)) {
                idirDAO.deleteGroup(Integer.parseInt(idirIdStr));
                resp.sendRedirect(req.getContextPath() + "/admin/idir");
                return;
            }

            int idirId = Integer.parseInt(idirIdStr);

            if ("add_member".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));
                idirDAO.addMemberToIdir(memberId, idirId);
            } else if ("approve_payment".equalsIgnoreCase(action)) {
                int memberId = Integer.parseInt(req.getParameter("member_id"));

                HttpSession session = req.getSession(false);
                Member admin = session == null ? null : (Member) session.getAttribute("user");
                Integer approvedBy = admin == null ? null : admin.getMemberId();

                idirDAO.approvePayment(idirId, memberId, approvedBy);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/idir?idir_id=" + idirId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
