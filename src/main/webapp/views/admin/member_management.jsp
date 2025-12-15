<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Member - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-dashboard.css">
</head>
<body>
<%
    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "en";
    boolean isAm = "am".equals(lang);
    String ctx = request.getContextPath();
    String enClass = isAm ? "" : "active";
    String amClass = isAm ? "active" : "";
    String labelLanguage = isAm ? "ቋንቋ" : "Language";
    String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
    String labelMembers = isAm ? "አባላት" : "Members";
    String labelEqub = isAm ? "እቁብ" : "Equb";
    String labelIdir = isAm ? "እድር" : "Idir";
    String labelExpenses = isAm ? "ወጪዎች" : "Expenses";
    String labelReports = isAm ? "ሪፖርቶች" : "Reports";

    Member currentUser = (Member) session.getAttribute("user");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message");
    session.removeAttribute("error");
%>

<div class="admin-nav">
    <div class="lang-switch">
        <span><%= labelLanguage %>:</span>
        <a href="<%= ctx %>/lang?lang=en" class="<%= enClass %>">English</a>|
        <a href="<%= ctx %>/lang?lang=am" class="<%= amClass %>">አማርኛ</a>
    </div>
    <a href="<%= ctx %>/admin/dashboard"><%= labelDashboard %></a>
    <a href="<%= ctx %>/admin/members" class="active"><%= labelMembers %></a>
    <a href="<%= ctx %>/admin/equb"><%= labelEqub %></a>
    <a href="<%= ctx %>/admin/idir"><%= labelIdir %></a>
    <a href="<%= ctx %>/admin/expenses"><%= labelExpenses %></a>
    <a href="<%= ctx %>/views/admin/reports.jsp"><%= labelReports %></a>
</div>

<div class="dashboard-container">
    <div class="header">
        <h1>Add New Member</h1>
        <div class="header-buttons">
            <a href="<%= request.getContextPath() %>/views/admin/dashboard.jsp" class="profile-btn">
                <i class="fas fa-tachometer-alt"></i> Back to Dashboard
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

    <div class="card">
        <h2><i class="fas fa-user-plus"></i> Member Registration Form</h2>

        <form action="<%= request.getContextPath() %>/admin/add-member" method="post" style="margin-top: 30px;">
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #1e4d2b;">
                    <i class="fas fa-user"></i> Full Name <span style="color: red;">*</span>
                </label>
                <input type="text" name="fullName" required
                       style="width: 100%; padding: 14px; border: 1px solid #ddd; border-radius: 12px; font-size: 16px;"
                       placeholder="Enter full name">
            </div>

            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #1e4d2b;">
                    <i class="fas fa-phone"></i> Phone Number <span style="color: red;">*</span>
                </label>
                <input type="text" name="phone" required
                       style="width: 100%; padding: 14px; border: 1px solid #ddd; border-radius: 12px; font-size: 16px;"
                       placeholder="e.g. 0911223344">
            </div>

            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #1e4d2b;">
                    <i class="fas fa-map-marker-alt"></i> Address (Optional)
                </label>
                <input type="text" name="address"
                       style="width: 100%; padding: 14px; border: 1px solid #ddd; border-radius: 12px; font-size: 16px;"
                       placeholder="Enter residential address">
            </div>

            <div style="margin-bottom: 30px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #1e4d2b;">
                    <i class="fas fa-lock"></i> Initial Password <span style="color: red;">*</span>
                </label>
                <input type="text" name="password" required value="changeme"
                       style="width: 100%; padding: 14px; border: 1px solid #ddd; border-radius: 12px; font-size: 16px;"
                       placeholder="Set a secure password">
                <small style="color: #666; font-size: 14px; display: block; margin-top: 6px;">
                    Default: <strong>changeme</strong> — you can change it here. Member can update it later.
                </small>
            </div>

            <div style="text-align: right;">
                <a href="<%= request.getContextPath() %>/views/admin/dashboard.jsp"
                   style="margin-right: 15px; color: #666; text-decoration: none; font-weight: 500;">
                    Cancel
                </a>
                <button type="submit" class="profile-btn" style="padding: 14px 32px; font-size: 16px; border: none; cursor: pointer;">
                    <i class="fas fa-save"></i> Save Member
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>