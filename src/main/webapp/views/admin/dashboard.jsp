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
<<<<<<< HEAD

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
=======
<%
    Integer membersCount = (Integer) request.getAttribute("membersCount");
    Integer equbGroupsCount = (Integer) request.getAttribute("equbGroupsCount");
    Integer idirGroupsCount = (Integer) request.getAttribute("idirGroupsCount");
    Integer equbUnpaidCount = (Integer) request.getAttribute("equbUnpaidCount");
    Integer idirUnpaidCount = (Integer) request.getAttribute("idirUnpaidCount");
    Integer idirExpensesCount = (Integer) request.getAttribute("idirExpensesCount");
    Double idirExpensesTotal = (Double) request.getAttribute("idirExpensesTotal");
    String dashboardError = (String) request.getAttribute("dashboardError");

    int safeMembers = membersCount == null ? 0 : membersCount;
    int safeEqubGroups = equbGroupsCount == null ? 0 : equbGroupsCount;
    int safeIdirGroups = idirGroupsCount == null ? 0 : idirGroupsCount;
    int safeEqubUnpaid = equbUnpaidCount == null ? 0 : equbUnpaidCount;
    int safeIdirUnpaid = idirUnpaidCount == null ? 0 : idirUnpaidCount;
    int safeIdirExpensesCount = idirExpensesCount == null ? 0 : idirExpensesCount;
    double safeIdirExpensesTotal = idirExpensesTotal == null ? 0.0 : idirExpensesTotal;
%>

<div class="container">
    <div class="header-row">
        <h1>Admin Dashboard</h1>
        <div>
            <a class="btn" href="<%=request.getContextPath()%>/logout">Logout</a>
        </div>
    </div>

    <% if (dashboardError != null) { %>
        <div class="alert alert-danger"><%= dashboardError %></div>
    <% } %>

    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-label">Total Members</div>
            <div class="stat-value"><%= safeMembers %></div>
            <div class="stat-sub"><a class="link" href="<%=request.getContextPath()%>/admin/members">Manage members</a></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Equb Groups</div>
            <div class="stat-value"><%= safeEqubGroups %></div>
            <div class="stat-sub"><a class="link" href="<%=request.getContextPath()%>/admin/equb">Open Equb</a></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Idir Groups</div>
            <div class="stat-value"><%= safeIdirGroups %></div>
            <div class="stat-sub"><a class="link" href="<%=request.getContextPath()%>/admin/idir">Open Idir</a></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Idir Expenses (Total)</div>
            <div class="stat-value"><%= String.format("%.2f", safeIdirExpensesTotal) %></div>
            <div class="stat-sub"><%= safeIdirExpensesCount %> records • <a class="link" href="<%=request.getContextPath()%>/admin/expenses">Manage expenses</a></div>
        </div>
    </div>

    <div class="grid">
        <div class="card">
            <h2>Quick Actions</h2>
            <div class="nav">
                <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/members">Member Management</a>
                <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/equb">Equb Management</a>
                <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/idir">Idir Management</a>
                <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/expenses">Idir Expenses</a>
            </div>
            <p class="muted">Tip: open a group to approve payments and generate rotations.</p>
        </div>

        <div class="card">
            <h2>Payment Alerts</h2>
            <p>Equb unpaid members: <strong><%= safeEqubUnpaid %></strong></p>
            <p>Idir unpaid members: <strong><%= safeIdirUnpaid %></strong></p>
            <p class="muted">Approve payments inside each group screen.</p>
        </div>
>>>>>>> origin/main
    </div>
</div>

</body>
</html>