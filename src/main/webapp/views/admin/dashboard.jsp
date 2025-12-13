<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css" />
</head>
<body>
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
    </div>
</div>
</body>
</html>
