<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard - Equb & Idir</title>
<<<<<<< HEAD
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dashboard.css">
=======
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
>>>>>>> origin/main
</head>
<body>
<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<<<<<<< HEAD
<div class="dashboard-container">
    <div class="header">
        <h1>Welcome back, <%= user.getFullName() %>!</h1>
        <div class="header-buttons">
            <a href="<%= request.getContextPath() %>/views/member/profile.jsp" class="profile-btn">
                <i class="fas fa-user-cog"></i> My Profile
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
=======
<div class="container">
    <div class="header-row">
        <h1>Member Dashboard</h1>
        <div class="nav">
            <a class="btn" href="<%= request.getContextPath() %>/views/member/profile.jsp">My Profile</a>
            <a class="btn" href="<%= request.getContextPath() %>/logout">Logout</a>
>>>>>>> origin/main
        </div>
    </div>

    <div class="grid">
<<<<<<< HEAD
        <!-- Personal Information -->
        <div class="card">
            <h2><i class="fas fa-user"></i> Personal Information</h2>
            <div class="info-item"><strong>Full Name:</strong> <%= user.getFullName() %></div>
            <div class="info-item"><strong>Phone:</strong> <%= user.getPhone() %></div>
            <div class="info-item"><strong>Member ID:</strong> #<%= user.getMemberId() %></div>
            <div class="info-item"><strong>Role:</strong> <%= "admin".equalsIgnoreCase(user.getRole()) ? "Administrator" : "Member" %></div>
        </div>

        <!-- My Equb Groups -->
        <div class="card">
            <h2><i class="fas fa-users"></i> My Equb Groups</h2>
            <div class="placeholder">
                <i class="fas fa-info-circle"></i>
                <p>No Equb groups assigned yet.<br>Contact your admin to join one.</p>
            </div>
        </div>

        <!-- My Idir Group -->
        <div class="card">
            <h2><i class="fas fa-hands-helping"></i> My Idir Group</h2>
            <div class="placeholder">
                <i class="fas fa-info-circle"></i>
                <p>No Idir group assigned yet.<br>Your community support will appear here.</p>
            </div>
        </div>

        <!-- Contribution History -->
        <div class="card">
            <h2><i class="fas fa-history"></i> Contribution History</h2>
            <div class="placeholder">
                <i class="fas fa-clock"></i>
                <p>Your payment history will be displayed here once contributions begin.</p>
            </div>
=======
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
>>>>>>> origin/main
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/assets/js/dashboard.js"></script>
</body>
</html>