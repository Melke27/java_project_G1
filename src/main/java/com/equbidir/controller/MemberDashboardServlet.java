package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.dao.NotificationDAO;
import com.equbidir.model.ContributionRecord;
import com.equbidir.model.EqubMembership;
import com.equbidir.model.IdirMembership;
import com.equbidir.model.Member;
import com.equbidir.model.Notification;

import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

public class MemberDashboardServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Member user = session == null ? null : (Member) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // If an admin hits /member/dashboard by mistake, send them to admin dashboard.
        if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            List<EqubMembership> equbMemberships = memberDAO.getEqubMemberships(user.getMemberId());
            List<IdirMembership> idirMemberships = memberDAO.getIdirMemberships(user.getMemberId());
            List<Notification> notifications = notificationDAO.getLatestNotifications(10);
            List<Member> admins = memberDAO.getAdmins();
            List<ContributionRecord> contributionHistory = memberDAO.getContributionHistory(user.getMemberId(), 20);

            request.setAttribute("equbMemberships", equbMemberships);
            request.setAttribute("idirMemberships", idirMemberships);
            request.setAttribute("notifications", notifications);
            request.setAttribute("admins", admins);
            request.setAttribute("contributionHistory", contributionHistory);

        } catch (Exception e) {
            // Render the dashboard even if DB is not available.
            request.setAttribute("equbMemberships", Collections.emptyList());
            request.setAttribute("idirMemberships", Collections.emptyList());
            request.setAttribute("notifications", Collections.emptyList());
            request.setAttribute("admins", Collections.emptyList());
            request.setAttribute("contributionHistory", Collections.emptyList());
            request.setAttribute("dashboardError", "Dashboard data unavailable: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/member/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
