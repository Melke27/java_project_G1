package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

<<<<<<< HEAD
import com.equbidir.model.Member;
import com.equbidir.util.DatabaseConnection;
import com.equbidir.util.SecurityUtil;

@WebServlet("/login")
=======
>>>>>>> origin/main
public class LoginServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

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

        try {
<<<<<<< HEAD
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
                    Member member = new Member(memberId, fullName, phone.trim(), "", role);

                    HttpSession session = request.getSession();
                    session.setAttribute("user", member);

                    // Role-based redirection
                    if ("admin".equalsIgnoreCase(role)) {
                        response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/views/member/dashboard.jsp");
                    }
                } else {
                    request.setAttribute("error", "Incorrect password.");
                    request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "No account found with this phone number.");
=======
            Member member = memberDAO.authenticate(phone.trim(), password);
            if (member == null) {
                request.setAttribute("error", "Incorrect phone number or password.");
>>>>>>> origin/main
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", member);
            session.setAttribute("role", member.getRole());

            if ("admin".equalsIgnoreCase(member.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/member/dashboard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed. Please try again later.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
<<<<<<< HEAD
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (pst != null) pst.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
=======
>>>>>>> origin/main
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String role = String.valueOf(session.getAttribute("role"));
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/member/dashboard.jsp");
            }
            return;
        }

        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }
}
