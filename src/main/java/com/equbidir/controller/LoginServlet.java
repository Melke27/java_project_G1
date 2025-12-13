package com.equbidir.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.equbidir.util.DatabaseConnection;
import com.equbidir.util.SecurityUtil;

@WebServlet("/equbidir/views/auth/login.jsp")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        if (phone == null || password == null || phone.trim().isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Phone number and password are required.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();

            String sql = "SELECT member_id, full_name, password_hash, role FROM members WHERE phone = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, phone.trim());

            rs = pst.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String fullName = rs.getString("full_name");
                String role = rs.getString("role");
                int memberId = rs.getInt("member_id");

                if (SecurityUtil.checkPassword(password, storedHash)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("memberId", memberId);
                    session.setAttribute("fullName", fullName);
                    session.setAttribute("phone", phone.trim());
                    session.setAttribute("role", role);

                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                } else {
                    request.setAttribute("error", "Incorrect password.");
                    request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "No account found with this phone number.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed. Please try again later.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignored */ }
            try { if (pst != null) pst.close(); } catch (SQLException e) { /* ignored */ }
            try { if (conn != null) conn.close(); } catch (SQLException e) { /* ignored */ }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }
}