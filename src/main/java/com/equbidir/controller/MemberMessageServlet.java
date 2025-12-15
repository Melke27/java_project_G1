package com.equbidir.controller;

import com.equbidir.dao.MemberMessageDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class MemberMessageServlet extends HttpServlet {

    private final MemberMessageDAO messageDAO = new MemberMessageDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Member user = session == null ? null : (Member) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String title = request.getParameter("title");
        String message = request.getParameter("message");

        if (title == null || title.trim().isEmpty() || message == null || message.trim().isEmpty()) {
            session.setAttribute("error", "Message title and message are required.");
            response.sendRedirect(request.getContextPath() + "/member/dashboard#contactAdmin");
            return;
        }

        try {
            messageDAO.createMessage(user.getMemberId(), title.trim(), message.trim());
            session.setAttribute("message", "Message sent to admin.");
        } catch (Exception e) {
            session.setAttribute("error", "Failed to send message: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/member/dashboard#contactAdmin");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/member/dashboard#contactAdmin");
    }
}
