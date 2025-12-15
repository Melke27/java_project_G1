package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

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
            Member member = memberDAO.authenticate(phone.trim(), password);
            if (member == null) {
                request.setAttribute("error", "Incorrect phone number or password.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", member);
            session.setAttribute("role", member.getRole());

            if ("admin".equalsIgnoreCase(member.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/member/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed. Please try again later.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
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
                response.sendRedirect(request.getContextPath() + "/member/dashboard");
            }
            return;
        }

        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }
}
