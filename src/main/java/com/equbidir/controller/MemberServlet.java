//package com.equbidir.controller;
//
//import com.equbidir.dao.MemberDAO;
//import com.equbidir.model.Member;
//import com.equbidir.util.SecurityUtil;
//
//import javax.servlet.ServletException;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//public class MemberServlet extends HttpServlet {
//
//    private final MemberDAO memberDAO = new MemberDAO();
//
//    private boolean isAdmin(HttpServletRequest req) {
//        HttpSession session = req.getSession(false);
//        return session != null && "admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")));
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        if (!isAdmin(req)) {
//            resp.sendRedirect(req.getContextPath() + "/login");
//            return;
//        }
//
//        try {
//            req.setAttribute("members", memberDAO.getAllMembers());
//            req.getRequestDispatcher("/views/admin/member_management.jsp").forward(req, resp);
//        } catch (Exception e) {
//            throw new ServletException(e);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        if (!isAdmin(req)) {
//            resp.sendRedirect(req.getContextPath() + "/login");
//            return;
//        }
//
//        String action = req.getParameter("action");
//
//        try {
//            if ("create".equalsIgnoreCase(action)) {
//                Member m = new Member();
//                m.setFullName(req.getParameter("full_name"));
//                m.setPhone(req.getParameter("phone"));
//                m.setAddress(req.getParameter("address"));
//                m.setRole(req.getParameter("role") == null ? "member" : req.getParameter("role"));
//
//                String rawPassword = req.getParameter("password");
//                if (rawPassword == null || rawPassword.trim().isEmpty()) rawPassword = "123456";
//                m.setPasswordHash(SecurityUtil.sha256(rawPassword));
//
//                memberDAO.createMember(m);
//            } else if ("update".equalsIgnoreCase(action)) {
//                Member m = new Member();
//                m.setMemberId(Integer.parseInt(req.getParameter("member_id")));
//                m.setFullName(req.getParameter("full_name"));
//                m.setPhone(req.getParameter("phone"));
//                m.setAddress(req.getParameter("address"));
//                m.setRole(req.getParameter("role"));
//                memberDAO.updateMember(m);
//            } else if ("reset_password".equalsIgnoreCase(action)) {
//                int memberId = Integer.parseInt(req.getParameter("member_id"));
//                String newPassword = req.getParameter("password");
//                memberDAO.resetPassword(memberId, SecurityUtil.sha256(newPassword));
//            } else if ("delete".equalsIgnoreCase(action)) {
//                int memberId = Integer.parseInt(req.getParameter("member_id"));
//                memberDAO.deleteMember(memberId);
//            }
//
//            resp.sendRedirect(req.getContextPath() + "/admin/members");
//        } catch (Exception e) {
//            throw new ServletException(e);
//        }
//    }
//}
