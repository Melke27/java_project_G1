package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AddMemberServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Member currentUser = (Member) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        if (fullName == null || phone == null || password == null ||
                fullName.trim().isEmpty() || phone.trim().isEmpty() || password.trim().isEmpty()) {

            session.setAttribute("error", "All required fields must be filled.");
            response.sendRedirect(request.getContextPath() + "/views/admin/member_management.jsp");
            return;
        }

        fullName = fullName.trim();
        phone = phone.trim();
        address = (address != null) ? address.trim() : null;

        Member newMember = new Member();
        newMember.setFullName(fullName);
        newMember.setPhone(phone);
        newMember.setAddress(address);
        newMember.setRole("member");

        String next = request.getParameter("next");

        try {
            boolean created = memberDAO.createMember(newMember, password);

            if (created) {
                session.setAttribute("message", "Member '" + fullName + "' added successfully!");
            } else {
                session.setAttribute("error", "Phone number already exists.");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Error adding member: " + e.getMessage());
        }

        if ("dashboard".equalsIgnoreCase(next)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard#memberManagement");
        } else {
            // Default: stay on add-member page so admin can register members one-by-one.
            response.sendRedirect(request.getContextPath() + "/views/admin/member_management.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}