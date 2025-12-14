package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || phone == null || fullName.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("error", "Full name and phone are required.");
            request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
            return;
        }

        user.setFullName(fullName.trim());
        user.setPhone(phone.trim());
        user.setAddress(address != null ? address.trim() : null);

        try {
            boolean updated = memberDAO.updateMember(user);

            if (updated) {
                request.setAttribute("success", "Personal information updated successfully!");
                session.setAttribute("user", user); // Update session
            } else {
                request.setAttribute("error", "Failed to update information.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
    }
}