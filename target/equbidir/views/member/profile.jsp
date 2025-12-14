<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Equb & Idir</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/profile.css">
    <style>
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 18px;
            border-radius: 12px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid #c3e6cb;
            font-weight: 600;
            font-size: 16px;
        }
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 18px;
            border-radius: 12px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid #f5c6cb;
            font-weight: 600;
            font-size: 16px;
        }
    </style>
</head>
<body>

<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }

    // Read messages from request attributes (servlets use forward)
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String passwordSuccess = (String) request.getAttribute("passwordSuccess");
    String passwordError = (String) request.getAttribute("passwordError");

    // Determine which tab should be active
    String activeTab = "personal"; // default
    if (passwordSuccess != null || passwordError != null) {
        activeTab = "password";
    } else if (success != null || error != null) {
        activeTab = "personal";
    }

    String dashboardPath = "admin".equalsIgnoreCase(user.getRole())
            ? "/views/admin/dashboard.jsp"
            : "/views/member/dashboard.jsp";
%>

<div class="profile-container">
    <div class="header">
        <h1>My Profile</h1>
        <div class="btn-group">
            <a href="<%= request.getContextPath() %><%= dashboardPath %>" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <div class="profile-card">
        <div class="tab-buttons">
            <button class="tab-btn <%= "personal".equals(activeTab) ? "active" : "" %>" onclick="openTab('personal')">Personal Information</button>
            <button class="tab-btn <%= "password".equals(activeTab) ? "active" : "" %>" onclick="openTab('password')">Change Password</button>
        </div>

        <!-- Personal Information Tab -->
        <div id="personal" class="tab-content <%= "personal".equals(activeTab) ? "active" : "" %>">
            <h2><i class="fas fa-user-edit"></i> Personal Information</h2>

            <% if (success != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle fa-lg" style="margin-right: 10px;"></i>
                <%= success %>
            </div>
            <% } %>

            <% if (error != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle fa-lg" style="margin-right: 10px;"></i>
                <%= error %>
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/profile" method="post">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName"
                           value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone"
                           value="<%= user.getPhone() != null ? user.getPhone() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="address">Address (City, Kebele, House No.)</label>
                    <input type="text" id="address" name="address"
                           value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                </div>

                <div class="btn-group">
                    <button type="submit" class="save-btn">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                    <a href="<%= request.getContextPath() %><%= dashboardPath %>" class="cancel-btn">
                        Cancel
                    </a>
                </div>
            </form>
        </div>

        <!-- Change Password Tab -->
        <div id="password" class="tab-content <%= "password".equals(activeTab) ? "active" : "" %>">
            <h2><i class="fas fa-key"></i> Change Password</h2>

            <% if (passwordSuccess != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle fa-lg" style="margin-right: 10px;"></i>
                <%= passwordSuccess %>
            </div>
            <% } %>

            <% if (passwordError != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle fa-lg" style="margin-right: 10px;"></i>
                <%= passwordError %>
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/change-password" method="post">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <div style="position: relative;">
                        <input type="password" id="currentPassword" name="currentPassword" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePass('currentPassword')"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <div style="position: relative;">
                        <input type="password" id="newPassword" name="newPassword" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePass('newPassword')"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmNewPassword">Confirm New Password</label>
                    <div style="position: relative;">
                        <input type="password" id="confirmNewPassword" name="confirmNewPassword" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePass('confirmNewPassword')"></i>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="save-btn">
                        <i class="fas fa-lock"></i> Update Password
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openTab(tabName) {
        const tabs = document.getElementsByClassName("tab-content");
        for (let i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove("active");
        }
        document.getElementById(tabName).classList.add("active");

        const buttons = document.getElementsByClassName("tab-btn");
        for (let i = 0; i < buttons.length; i++) {
            buttons[i].classList.remove("active");
        }
        event.currentTarget.classList.add("active");
    }

    function togglePass(id) {
        const input = document.getElementById(id);
        const icon = input.nextElementSibling;
        if (input.type === "password") {
            input.type = "text";
            icon.classList.replace("fa-eye", "fa-eye-slash");
        } else {
            input.type = "password";
            icon.classList.replace("fa-eye-slash", "fa-eye");
        }
    }
</script>

</body>
</html>