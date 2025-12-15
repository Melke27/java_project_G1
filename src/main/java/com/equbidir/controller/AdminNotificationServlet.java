package com.equbidir.controller;

import com.equbidir.dao.NotificationDAO;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminNotificationServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Member user = session == null ? null : (Member) session.getAttribute("user");

        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String title = request.getParameter("title");
        String message = request.getParameter("message");

        if (title == null || title.trim().isEmpty() || message == null || message.trim().isEmpty()) {
            session.setAttribute("error", "Notification title and message are required.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard#notifications");
            return;
        }

        try {
            notificationDAO.createNotification(title.trim(), message.trim(), user.getMemberId());
            session.setAttribute("message", "Notification posted successfully.");
        } catch (Exception e) {
            session.setAttribute("error", "Failed to post notification: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard#notifications");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard#notifications");
    }
}
