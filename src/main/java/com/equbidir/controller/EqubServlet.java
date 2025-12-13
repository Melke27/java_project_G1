package com.equbidir.controller;

import com.equbidir.dao.EqubDAO;
import com.equbidir.dao.MemberDAO;
import com.equbidir.model.EqubGroup;
import com.equbidir.model.Contribution;
import com.equbidir.model.Rotation;
import com.equbidir.model.Member;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "EqubServlet", urlPatterns = {"/admin/equb"})
public class EqubServlet extends HttpServlet {

    private final EqubDAO equbDAO = new EqubDAO();
    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String groupIdParam = request.getParameter("groupId");

            if ("view".equals(action) && groupIdParam != null) {
                // View specific group details
                int groupId = Integer.parseInt(groupIdParam);
                EqubGroup group = equbDAO.findGroupById(groupId);
                List<Contribution> contributions = equbDAO.getContributionsByGroup(groupId);
                List<Rotation> rotations = equbDAO.getRotationsByGroup(groupId);
                List<Member> allMembers = memberDAO.findAll();

                request.setAttribute("group", group);
                request.setAttribute("contributions", contributions);
                request.setAttribute("rotations", rotations);
                request.setAttribute("allMembers", allMembers);
            } else if ("generateRotation".equals(action) && groupIdParam != null) {
                // Generate rotation schedule
                int groupId = Integer.parseInt(groupIdParam);
                equbDAO.generateRotationSchedule(groupId);
                response.sendRedirect(request.getContextPath() + "/admin/equb?action=view&groupId=" + groupId);
                return;
            } else if ("completeGroup".equals(action) && groupIdParam != null) {
                // Mark group as completed
                int groupId = Integer.parseInt(groupIdParam);
                equbDAO.markGroupCompleted(groupId);
                response.sendRedirect(request.getContextPath() + "/admin/equb");
                return;
            }

            // Default: list all groups
            List<EqubGroup> groups = equbDAO.findAllGroups();
            List<Member> allMembers = memberDAO.findAll();
            request.setAttribute("groups", groups);
            request.setAttribute("allMembers", allMembers);
            request.getRequestDispatcher("/views/admin/equb_management.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load Equb data", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if ("createGroup".equals(action)) {
                createGroup(request, response);
            } else if ("updateGroup".equals(action)) {
                updateGroup(request, response);
            } else if ("addContribution".equals(action)) {
                addContribution(request, response);
            } else if ("updateRotation".equals(action)) {
                updateRotation(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/equb");
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to process Equb operation", e);
        }
    }

    private void createGroup(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String name = request.getParameter("name");
        BigDecimal contributionAmount = new BigDecimal(request.getParameter("contributionAmount"));
        String frequency = request.getParameter("frequency");
        LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));

        EqubGroup group = new EqubGroup(name, contributionAmount, frequency, startDate);
        int groupId = equbDAO.createGroup(group);

        // After creating group, if members are selected, add them to the group
        String[] memberIds = request.getParameterValues("memberIds");
        if (memberIds != null && memberIds.length > 0) {
            addMembersToGroup(groupId, memberIds);
        }

        response.sendRedirect(request.getContextPath() + "/admin/equb?action=view&groupId=" + groupId);
    }

    private void updateGroup(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        BigDecimal contributionAmount = new BigDecimal(request.getParameter("contributionAmount"));
        String frequency = request.getParameter("frequency");
        LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
        boolean completed = "on".equals(request.getParameter("completed"));

        EqubGroup group = new EqubGroup(id, name, contributionAmount, frequency, startDate, completed);
        equbDAO.updateGroup(group);

        response.sendRedirect(request.getContextPath() + "/admin/equb?action=view&groupId=" + id);
    }

    private void addContribution(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int equbGroupId = Integer.parseInt(request.getParameter("equbGroupId"));
        int memberId = Integer.parseInt(request.getParameter("memberId"));
        BigDecimal amount = new BigDecimal(request.getParameter("amount"));
        LocalDate paymentDate = LocalDate.parse(request.getParameter("paymentDate"));

        Contribution contribution = new Contribution(equbGroupId, memberId, amount, paymentDate);
        equbDAO.addContribution(contribution);

        response.sendRedirect(request.getContextPath() + "/admin/equb?action=view&groupId=" + equbGroupId);
    }

    private void updateRotation(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int rotationId = Integer.parseInt(request.getParameter("rotationId"));
        int newPosition = Integer.parseInt(request.getParameter("newPosition"));
        String groupIdParam = request.getParameter("groupId");

        equbDAO.updateRotationPosition(rotationId, newPosition);

        if (groupIdParam != null) {
            response.sendRedirect(request.getContextPath() + "/admin/equb?action=view&groupId=" + groupIdParam);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/equb");
        }
    }

    private void addMembersToGroup(int groupId, String[] memberIds) throws SQLException {
        if (memberIds != null && memberIds.length > 0) {
            int[] ids = new int[memberIds.length];
            for (int i = 0; i < memberIds.length; i++) {
                ids[i] = Integer.parseInt(memberIds[i]);
            }
            equbDAO.addMembersToGroup(groupId, ids);
        }
    }
}

