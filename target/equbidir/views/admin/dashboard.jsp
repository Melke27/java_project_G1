<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css" />
</head>
<body>
<div class="container">
    <h1>Admin Dashboard</h1>
    <div class="nav">
        <a class="btn" href="<%=request.getContextPath()%>/admin/members">Member Management</a>
        <a class="btn" href="<%=request.getContextPath()%>/admin/equb">Equb Management</a>
        <a class="btn" href="<%=request.getContextPath()%>/admin/idir">Idir Management</a>
        <a class="btn" href="<%=request.getContextPath()%>/admin/expenses">Idir Expenses</a>
    </div>

    <div class="card">
        <p>Use the buttons above to manage members, groups, approve payments, and generate rotation schedules.</p>
    </div>
</div>
</body>
</html>
