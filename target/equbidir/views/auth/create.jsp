<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Equb & Idir Management System - Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/login.css">
    <style>
        .error-message {
            background: #ffeeee;
            color: #d8000c;
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            margin: 20px 0;
            font-weight: 600;
            border: 1px solid #ffbaba;
        }
        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            margin: 20px 0;
            font-weight: 600;
            border: 1px solid #c8e6c9;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-section">
        <div class="logo">Equb & Idir</div>
        <p class="tagline">Securely manage your traditional savings and community support groups</p>
        <h1>Create Account</h1>

        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
        <div class="error-message"><%= error %></div>
        <% } else if (success != null) { %>
        <div class="success-message"><%= success %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register" method="post">
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="fullName" placeholder="Full Name" required>
            </div>
            <div class="input-group">
                <i class="fas fa-phone"></i>
                <input type="tel" name="phone" placeholder="Phone Number (e.g. 0911223344)" required>
            </div>
            <div class="input-group">
                <i class="fas fa-map-marker-alt"></i>
                <input type="text" name="address" placeholder="Address (City, Kebele, House No.)" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
            </div>
            <button type="submit" class="submit-btn">Create Account</button>
            <p class="signin-link">Already have an account? <a href="<%= request.getContextPath() %>/views/auth/login.jsp">Sign in</a></p>
        </form>
    </div>
    <div class="info-section">
        <div class="info-content">
            <h2>Welcome to Equb & Idir Management</h2>
            <p>Digitize your Equb and Idir operations with a secure, easy-to-use platform designed for accurate tracking and seamless management.</p>
            <ul class="features">
                <li><i class="fas fa-check-circle"></i> Automate contribution tracking and payouts</li>
                <li><i class="fas fa-check-circle"></i> Manage members, schedules, and rotations in one place</li>
                <li><i class="fas fa-check-circle"></i> Keep records safe and transparent</li>
                <li><i class="fas fa-check-circle"></i> Streamline reporting and reduce errors</li>
            </ul>
            <p class="footer-text">Join thousands preserving Ethiopian traditions efficiently and securely.</p>
        </div>
    </div>
</div>
</body>
</html>