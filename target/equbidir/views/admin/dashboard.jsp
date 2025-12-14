<%@ page import="com.equbidir.model.Member" %>
<%@ page import="com.equbidir.dao.MemberDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Equb & Idir</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-dashboard.css">
</head>
<body>

<%
    Member currentUser = (Member) session.getAttribute("user");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message");
    session.removeAttribute("error");

    MemberDAO memberDAO = new MemberDAO();
    List<Member> allMembers = memberDAO.getAllMembers();

    List<Member> regularMembers = new ArrayList<>();
    for (Member m : allMembers) {
        if (m.getRole() == null || !"admin".equalsIgnoreCase(m.getRole())) {
            regularMembers.add(m);
        }
    }
%>

<div class="dashboard-container">
    <div class="header">
        <h1>Admin Dashboard</h1>
        <div class="header-buttons">
            <a href="<%= request.getContextPath() %>/views/member/profile.jsp" class="profile-btn">
                <i class="fas fa-user-cog"></i> My Profile
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <% if (message != null) { %>
    <div style="background:#d4edda;color:#155724;padding:18px;border-radius:12px;margin:20px 0;text-align:center;border:1px solid #c3e6cb;font-weight:600;">
        <i class="fas fa-check-circle fa-lg" style="margin-right:10px;"></i>
        <%= message %>
    </div>
    <% } %>

    <% if (error != null) { %>
    <div style="background:#f8d7da;color:#721c24;padding:18px;border-radius:12px;margin:20px 0;text-align:center;border:1px solid #f5c6cb;font-weight:600;">
        <i class="fas fa-exclamation-circle fa-lg" style="margin-right:10px;"></i>
        <%= error %>
    </div>
    <% } %>

    <div class="grid">
        <div class="card">
            <h2><i class="fas fa-users"></i> Total Members</h2>
            <p class="info-item" style="font-size: 36px; text-align: center; margin: 20px 0; color: #1e4d2b;">
                <%= regularMembers.size() %>
            </p>
        </div>

        <div class="card">
            <h2><i class="fas fa-handshake"></i> Active Equb Groups</h2>
            <p class="placeholder">Data coming soon</p>
        </div>

        <div class="card">
            <h2><i class="fas fa-heart"></i> Active Idir Groups</h2>
            <p class="placeholder">Data coming soon</p>
        </div>

        <div class="card">
            <h2><i class="fas fa-wallet"></i> Total Fund Balance</h2>
            <p class="placeholder">Will be available after contributions start</p>
        </div>
    </div>

    <div class="card" style="margin-top: 40px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2><i class="fas fa-users-cog"></i> Member Management</h2>
            <a href="<%= request.getContextPath() %>/views/admin/member_management.jsp"
               class="profile-btn" style="padding: 12px 24px; font-size: 16px;">
                <i class="fas fa-user-plus"></i> Add New Member
            </a>
        </div>

        <% if (regularMembers.isEmpty()) { %>
        <div class="placeholder">
            <i class="fas fa-users"></i>
            <p>No regular members registered yet.</p>
        </div>
        <% } else { %>
        <table class="members-table">
            <thead>
            <tr>
                <th>#</th>
                <th>Full Name</th>
                <th>Phone</th>
                <th>Address</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                int rowNum = 1;
            %>
            <% for (Member m : regularMembers) { %>
            <tr>
                <td>#<%= rowNum %></td>
                <td><%= m.getFullName() != null ? m.getFullName() : "-" %></td>
                <td><%= m.getPhone() != null ? m.getPhone() : "-" %></td>
                <td><%= m.getAddress() != null ? m.getAddress() : "-" %></td>
                <td class="actions">
                    <a href="<%= request.getContextPath() %>/views/admin/edit-member.jsp?id=<%= m.getMemberId() %>"
                       class="edit-btn" title="Edit">
                        <i class="fas fa-edit"></i>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/delete-member?id=<%= m.getMemberId() %>"
                       class="delete-btn" title="Delete"
                       onclick="return confirm('Are you sure you want to delete <%= m.getFullName() %>?')">
                        <i class="fas fa-trash"></i>
                    </a>
                </td>
            </tr>
            <%
                rowNum++;
            %>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

</body>
</html>