<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard - Equb & Idir</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>
<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<div class="container">
    <div class="header-row">
        <h1>Member Dashboard</h1>
        <div class="nav">
            <a class="btn" href="<%= request.getContextPath() %>/views/member/profile.jsp">My Profile</a>
            <a class="btn" href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    </div>

    <div class="grid">
        <div class="card">
            <h2>Welcome</h2>
            <p>Welcome back, <strong><%= user.getFullName() %></strong>!</p>
            <p class="muted">Phone: <%= user.getPhone() %></p>
        </div>

        <div class="card">
            <h2>Account</h2>
            <p>Role: <strong><%= user.getRole() %></strong></p>
            <p>Member ID: <strong><%= user.getMemberId() %></strong></p>
            <p class="muted">Use “My Profile” to view your details.</p>
        </div>
    </div>
</div>
</body>
</html>