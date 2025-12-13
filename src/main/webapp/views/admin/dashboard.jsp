<%@ page import="com.equbidir.model.Member" %>
<%@ page import="com.equbidir.dao.MemberDAO" %>
<%@ page import="java.util.List" %>
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
    Member admin = (Member) session.getAttribute("user");
    if (admin == null || !"admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }

    MemberDAO memberDAO = new MemberDAO();
    List<Member> members = memberDAO.getAllMembers();
%>
<div class="admin-container">
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

    <div class="admin-content">
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Members</h3>
                <p class="stat-number"><%= members.size() %></p>
            </div>
            <div class="stat-card">
                <h3>Active Equb Groups</h3>
                <p class="stat-number placeholder">0</p>
            </div>
            <div class="stat-card">
                <h3>Active Idir Groups</h3>
                <p class="stat-number placeholder">0</p>
            </div>
            <div class="stat-card">
                <h3>Total Contributions</h3>
                <p class="stat-number placeholder">Coming Soon</p>
            </div>
        </div>

        <div class="members-section">
            <div class="section-header">
                <h2><i class="fas fa-users"></i> Member Management</h2>
                <a href="<%= request.getContextPath() %>/views/admin/member_management.jsp" class="add-btn">
                    <i class="fas fa-user-plus"></i> Add New Member
                </a>
            </div>

            <% if (members.isEmpty()) { %>
            <div class="placeholder-card">
                <i class="fas fa-info-circle"></i>
                <p>No members registered yet.</p>
            </div>
            <% } else { %>
            <div class="table-container">
                <table class="members-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Member m : members) { %>
                    <tr>
                        <td>#<%= m.getMemberId() %></td>
                        <td><%= m.getFullName() %></td>
                        <td><%= m.getPhone() %></td>
                        <td><%= m.getAddress() != null ? m.getAddress() : "-" %></td>
                        <td>
                                    <span class="role-badge <%= "admin".equalsIgnoreCase(m.getRole()) ? "admin" : "member" %>">
                                        <%= "admin".equalsIgnoreCase(m.getRole()) ? "Administrator" : "Member" %>
                                    </span>
                        </td>
                        <td class="actions">
                            <a href="<%= request.getContextPath() %>/views/admin/edit-member.jsp?id=<%= m.getMemberId() %>" class="edit-btn" title="Edit">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="<%= request.getContextPath() %>/delete-member?id=<%= m.getMemberId() %>" class="delete-btn" title="Delete" onclick="return confirm('Are you sure you want to delete <%= m.getFullName() %>?')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>