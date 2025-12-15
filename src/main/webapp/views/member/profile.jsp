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
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%);
            min-height: 100vh;
            overflow-x: hidden;
        }
        .hamburger {
            position: fixed;
            top: 20px;
            left: 20px;
            font-size: 28px;
            color: #1e4d2b;
            background: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1002;
        }
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
        .overlay.active {
            display: block;
        }
        .sidebar {
            width: 280px;
            background: #1e4d2b;
            color: white;
            padding: 30px 20px;
            position: fixed;
            height: 100%;
            left: -300px;
            top: 0;
            box-shadow: 5px 0 15px rgba(0,0,0,0.1);
            transition: left 0.4s ease;
            z-index: 1000;
        }
        .sidebar.active {
            left: 0;
        }
        .sidebar-header {
            text-align: center;
            margin-bottom: 50px;
        }
        .sidebar-header h2 {
            margin: 0;
            font-size: 26px;
            color: #c9a227;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
        }
        .sidebar-menu li {
            margin: 12px 0;
        }
        .sidebar-menu a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            padding: 14px 18px;
            border-radius: 12px;
            transition: 0.3s;
            font-size: 16px;
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: #c9a227;
            color: #1e4d2b;
        }
        .sidebar-menu i {
            margin-right: 14px;
            font-size: 20px;
            width: 28px;
            text-align: center;
        }
        .main-content {
            padding: 20px;
            width: 100%;
            transition: filter 0.4s ease;
        }
        .main-content.blurred {
            filter: blur(5px);
        }
        .lang-selector {
            margin-top: 40px;
            text-align: center;
            padding: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 16px;
        }
        .lang-selector label {
            display: block;
            margin-bottom: 12px;
            font-weight: 600;
            color: #c9a227;
        }
        .lang-options {
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .lang-option {
            text-align: center;
            cursor: pointer;
            transition: 0.3s;
        }
        .lang-option:hover {
            transform: translateY(-5px);
        }
        .lang-option img {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            border: 3px solid transparent;
            transition: 0.3s;
        }
        .lang-option:hover img {
            border-color: #c9a227;
        }
        .lang-option span {
            display: block;
            margin-top: 8px;
            font-size: 14px;
            font-weight: 600;
        }
        .lang-option.active img {
            border-color: #c9a227;
            transform: scale(1.1);
        }
        .welcome-header {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 30px;
        }
        .welcome-header h1 {
            color: #1e4d2b;
            margin: 0;
            font-size: 28px;
        }
        .card {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        .card h2 {
            color: #1e4d2b;
            border-bottom: 2px solid #c9a227;
            padding-bottom: 12px;
            margin-top: 0;
        }
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
        .tab-buttons {
            display: flex;
            margin-bottom: 30px;
            background: #f8fafc;
            border-radius: 12px;
            overflow: hidden;
        }
        .tab-btn {
            flex: 1;
            padding: 16px;
            background: none;
            border: none;
            font-size: 18px;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            transition: 0.3s;
        }
        .tab-btn:hover {
            background: #eee;
        }
        .tab-btn.active {
            background: #1e4d2b;
            color: white;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1e4d2b;
        }
        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #ddd;
            border-radius: 12px;
            font-size: 16px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #c9a227;
            box-shadow: 0 0 0 3px rgba(201,162,39,0.1);
        }
        .form-group {
            position: relative;
        }
        .toggle-password {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #666;
            font-size: 18px;
        }
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .save-btn {
            padding: 14px 28px;
            background: #1e4d2b;
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            font-size: 16px;
        }
        .save-btn:hover {
            background: #c9a227;
            color: #1e4d2b;
        }
        .cancel-btn {
            padding: 14px 28px;
            background: #eee;
            color: #1e4d2b;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            text-align: center;
        }
        .cancel-btn:hover {
            background: #ddd;
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

    String ctx = request.getContextPath();

    String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
    String labelMyEqub = isAm ? "የእቁብ ቡድኔ" : "My Equb Group";
    String labelMyIdir = isAm ? "የእድር ቡድኔ" : "My Idir Group";
    String labelProfile = isAm ? "የግል መረጃዬ" : "My Profile";
    String labelHistory = isAm ? "የመዋጮ ታሪክ" : "Contribution History";
    String labelLogout = isAm ? "ውጣ" : "Logout";

    String dashboardPath = "admin".equalsIgnoreCase(user.getRole())
            ? "/views/admin/dashboard.jsp"
            : "/views/member/dashboard.jsp";

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String passwordSuccess = (String) request.getAttribute("passwordSuccess");
    String passwordError = (String) request.getAttribute("passwordError");

    String activeTab = "personal";
    if (passwordSuccess != null || passwordError != null) {
        activeTab = "password";
    } else if (success != null || error != null) {
        activeTab = "personal";
    }
<<<<<<< HEAD
=======

    String dashboardPath = "admin".equalsIgnoreCase(user.getRole())
            ? "/admin/dashboard"
            : "/member/dashboard";
>>>>>>> c99eacf69167d2599f411623f0789eacee5c68dd
%>

<!-- Dark Overlay -->
<div class="overlay" id="overlay" onclick="toggleSidebar()"></div>

<!-- Hamburger Button -->
<div class="hamburger" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
</div>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h2>Equb & Idir</h2>
    </div>
    <ul class="sidebar-menu">
        <li><a href="<%= ctx %>/views/member/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> <%= labelDashboard %></a></li>
        <li><a href="<%= ctx %>/member/equb-details"><i class="fas fa-handshake"></i> <%= labelMyEqub %></a></li>
        <li><a href="<%= ctx %>/member/idir-details"><i class="fas fa-heart"></i> <%= labelMyIdir %></a></li>
        <li><a href="<%= ctx %>/views/member/profile.jsp" class="active"><i class="fas fa-user"></i> <%= labelProfile %></a></li>
        <li><a href="<%= ctx %>/member/contribution-history"><i class="fas fa-history"></i> <%= labelHistory %></a></li>
        <li><a href="<%= ctx %>/logout"><i class="fas fa-sign-out-alt"></i> <%= labelLogout %></a></li>
    </ul>

    <div class="lang-selector">
        <label><%= isAm ? "ቋንቋ ይምረጡ" : "Select Language" %></label>
        <div class="lang-options">
            <div class="lang-option <%= !isAm ? "active" : "" %>" onclick="window.location='<%= ctx %>/lang?lang=en'">
                <img src="https://flagcdn.com/w80/gb.png" alt="English">
                <span>English</span>
            </div>
            <div class="lang-option <%= isAm ? "active" : "" %>" onclick="window.location='<%= ctx %>/lang?lang=am'">
                <img src="https://flagcdn.com/w80/et.png" alt="አማርኛ">
                <span>አማርኛ</span>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="main-content" id="mainContent">
    <div class="welcome-header">
        <h1><%= isAm ? "የግል መረጃዬ" : "My Profile" %></h1>
        <a href="<%= request.getContextPath() %><%= dashboardPath %>" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            <%= isAm ? "ወደ ዳሽቦርድ ተመለስ" : "Back to Dashboard" %>
        </a>
    </div>

    <div class="card">
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
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('overlay');
        const mainContent = document.getElementById('mainContent');

        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
        mainContent.classList.toggle('blurred');
    }

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