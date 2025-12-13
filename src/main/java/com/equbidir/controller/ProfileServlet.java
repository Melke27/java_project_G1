package com.equbidir.controller;

import com.equbidir.model.Member;
import com.equbidir.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Member user = (session != null) ? (Member) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Basic validation
        if (fullName == null || phone == null || address == null ||
                fullName.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("error", "Full name and phone are required.");
            request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getConnection();

            String sql = "UPDATE members SET full_name = ?, phone = ?, address = ? WHERE member_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, fullName.trim());
            ps.setString(2, phone.trim());
            ps.setString(3, address.trim());
            ps.setInt(4, user.getMemberId());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // Update the Member object in session with new values
                user.setFullName(fullName.trim());
                user.setPhone(phone.trim());
                user.setAddress(address.trim());

                // Put updated object back into session
                session.setAttribute("user", user);

                request.setAttribute("success", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "No changes made or update failed.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error. Please try again.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error. Please try again later.");
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }

        // Forward back to profile page to show message
        request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
    }

    // Optional: Allow GET to view profile (though form is POST)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Member user = (session != null) ? (Member) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        } else {
            request.getRequestDispatcher("/views/member/profile.jsp").forward(request, response);
        }
    }
}