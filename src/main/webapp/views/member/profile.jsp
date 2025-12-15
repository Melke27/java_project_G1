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
        .lang-switch {
            position: absolute;
            top: 16px;
            right: 24px;
            font-size: 14px;
        }
        .lang-switch a {
            color: #555;
            text-decoration: none;
            margin: 0 8px;
            font-weight: 600;
        }
        .lang-switch a.active {
            color: #1e4d2b;
            text-decoration: underline;
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

    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "en";
    boolean isAm = "am".equals(lang);

    // Read messages from request attributes
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String passwordSuccess = (String) request.getAttribute("passwordSuccess");
    String passwordError = (String) request.getAttribute("passwordError");

    // Determine active tab
    String activeTab = "personal";
    if (passwordSuccess != null || passwordError != null) {
        activeTab = "password";
    } else if (success != null || error != null) {
        activeTab = "personal";
    }

    String dashboardPath = "admin".equalsIgnoreCase(user.getRole())
            ? "/admin/dashboard"
            : "/member/dashboard";
%>

<div class="profile-container">
    <div class="lang-switch">
        <span><%= isAm ? "ቋንቋ" : "Language" %>:</span>
        <a href="<%= request.getContextPath() %>/lang?lang=en" class="<%= !isAm ? "active" : "" %>">English</a> |
        <a href="<%= request.getContextPath() %>/lang?lang=am" class="<%= isAm ? "active" : "" %>">አማርኛ</a>
    </div>

    <div class="header">
        <h1><%= isAm ? "የግል መረጃዬ" : "My Profile" %></h1>
        <div class="btn-group">
            <a href="<%= request.getContextPath() %><%= dashboardPath %>" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                <%= isAm ? "ወደ ዳሽቦርድ ተመለስ" : "Back to Dashboard" %>
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                <%= isAm ? "ውጣ" : "Logout" %>
            </a>
        </div>
    </div>

    <div class="profile-card">
        <div class="tab-buttons">
            <button class="tab-btn <%= "personal".equals(activeTab) ? "active" : "" %>" onclick="openTab('personal')">
                <%= isAm ? "የግል መረጃ" : "Personal Information" %>
            </button>
            <button class="tab-btn <%= "password".equals(activeTab) ? "active" : "" %>" onclick="openTab('password')">
                <%= isAm ? "የይለፍ ቃል ቀይር" : "Change Password" %>
            </button>
        </div>

        <!-- Personal Information Tab -->
        <div id="personal" class="tab-content <%= "personal".equals(activeTab) ? "active" : "" %>">
            <h2><i class="fas fa-user-edit"></i> <%= isAm ? "የግል መረጃ" : "Personal Information" %></h2>

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
                    <label for="fullName"><%= isAm ? "ሙሉ ስም" : "Full Name" %></label>
                    <input type="text" id="fullName" name="fullName"
                           value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="phone"><%= isAm ? "ስልክ ቁጥር" : "Phone Number" %></label>
                    <input type="tel" id="phone" name="phone"
                           value="<%= user.getPhone() != null ? user.getPhone() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="address">
                        <%= isAm ? "አድራሻ (ከተማ፣ ቀበሌ፣ ቤት ቁጥር)" : "Address (City, Kebele, House No.)" %>
                    </label>
                    <input type="text" id="address" name="address"
                           value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                </div>

                <div class="btn-group">
                    <button type="submit" class="save-btn">
                        <i class="fas fa-save"></i>
                        <%= isAm ? "ለውጦችን አስቀምጥ" : "Save Changes" %>
                    </button>
                    <a href="<%= request.getContextPath() %><%= dashboardPath %>" class="cancel-btn">
                        <%= isAm ? "ተው" : "Cancel" %>
                    </a>
                </div>
            </form>
        </div>

        <!-- Change Password Tab -->
        <div id="password" class="tab-content <%= "password".equals(activeTab) ? "active" : "" %>">
            <h2><i class="fas fa-key"></i> <%= isAm ? "የይለፍ ቃል ቀይር" : "Change Password" %></h2>

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
                    <label for="currentPassword"><%= isAm ? "አሁን ያለው የይለፍ ቃል" : "Current Password" %></label>
                    <div style="position: relative;">
                        <input type="password" id="currentPassword" name="currentPassword" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePass('currentPassword')"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="newPassword"><%= isAm ? "አዲስ የይለፍ ቃል" : "New Password" %></label>
                    <div style="position: relative;">
                        <input type="password" id="newPassword" name="newPassword" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePass('newPassword')"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmNewPassword"><%= isAm ? "አዲሱን የይለፍ ቃል ደግመህ ጻፍ" : "Confirm New Password" %></label>
                    <div style="position: relative;">
                        <input type="password" id="confirmNewPassword" name="confirmNewPassword" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePass('confirmNewPassword')"></i>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="save-btn">
                        <i class="fas fa-lock"></i>
                        <%= isAm ? "የይለፍ ቃል አዘምን" : "Update Password" %>
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