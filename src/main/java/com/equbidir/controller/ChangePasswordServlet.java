package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ChangePasswordServlet extends HttpServlet {

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

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (currentPassword == null || newPassword == null || confirmNewPassword == null ||
                currentPassword.isEmpty() || newPassword.isEmpty() || confirmNewPassword.isEmpty()) {

            request.setAttribute("passwordError", "All fields are required.");
            request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("passwordError", "New passwords do not match.");
            request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
            return;
        }

        try {
            boolean currentCorrect = memberDAO.verifyCurrentPassword(user.getMemberId(), currentPassword);

            if (!currentCorrect) {
                request.setAttribute("passwordError", "Current password is incorrect.");
                request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
                return;
            }

            boolean updated = memberDAO.resetPassword(user.getMemberId(), newPassword);

            if (updated) {
                request.setAttribute("passwordSuccess", "Password changed successfully!");
            } else {
                request.setAttribute("passwordError", "Failed to update password.");
            }
        } catch (Exception e) {
            request.setAttribute("passwordError", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
    }
}