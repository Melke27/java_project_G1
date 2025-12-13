package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import com.equbidir.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");

        if (phone == null || password == null || phone.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Phone and password are required");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
            return;
        }

        try {
            String passwordHash = SecurityUtil.sha256(password);
            Member user = memberDAO.authenticate(phone.trim(), passwordHash);
            if (user == null) {
                req.setAttribute("error", "Invalid login");
                req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            if ("admin".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/views/member/dashboard.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
