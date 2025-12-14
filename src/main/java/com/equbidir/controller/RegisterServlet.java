package com.equbidir.controller;

import com.equbidir.util.DatabaseConnection;
import com.equbidir.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (fullName == null || phone == null || address == null || password == null || confirmPassword == null ||
                fullName.trim().isEmpty() || phone.trim().isEmpty() || address.trim().isEmpty() ||
                password.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/views/auth/create.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/views/auth/create.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/views/auth/create.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();

            String checkSql = "SELECT phone FROM members WHERE phone = ?";
            checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, phone.trim());
            rs = checkPs.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Phone number already registered.");
                request.getRequestDispatcher("/views/auth/create.jsp").forward(request, response);
                return;
            }

            String hashedPassword = SecurityUtil.hashPassword(password);
            String insertSql = "INSERT INTO members (full_name, phone, address, password_hash, role) VALUES (?, ?, ?, ?, 'member')";
            insertPs = conn.prepareStatement(insertSql);
            insertPs.setString(1, fullName.trim());
            insertPs.setString(2, phone.trim());
            insertPs.setString(3, address.trim());
            insertPs.setString(4, hashedPassword);

            int rows = insertPs.executeUpdate();
            if (rows > 0) {
                request.setAttribute("success", "Account created successfully! You can now sign in.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/views/auth/create.jsp").forward(request, response);
            }

        } catch (Exception e) {
        e.printStackTrace();  // This prints full details to IntelliJ/Tomcat console
        request.setAttribute("error", "Registration failed: " + e.getMessage());
        request.getRequestDispatcher("/views/auth/create.jsp").forward(request, response);
    } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (checkPs != null) checkPs.close(); } catch (SQLException e) {}
            try { if (insertPs != null) insertPs.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/create.jsp").forward(request, response);
    }
}