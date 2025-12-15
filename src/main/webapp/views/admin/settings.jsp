<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Settings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-dashboard.css">
</head>
<body>
<%
    Member currentUser = (Member) session.getAttribute("user");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "en";
    boolean isAm = "am".equals(lang);

    String ctx = request.getContextPath();

    // Labels (kept for now; can be simplified to English-only if you want)
    String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
    String labelMembers = isAm ? "አባላት" : "Members";
    String labelEqub = isAm ? "እቁብ" : "Equb";
    String labelIdir = isAm ? "እድር" : "Idir";
    String labelExpenses = isAm ? "ወጪዎች" : "Expenses";
    String labelReports = isAm ? "ሪፖርቶች" : "Reports";
    String labelLogout = isAm ? "ውጣ" : "Logout";

    request.setAttribute("activePage", "settings");

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message");
    session.removeAttribute("error");
%>

<%@ include file="_sidebar.jspf" %>

<div class="main-content" id="mainContent">
    <div class="dashboard-container">
        <div class="header">
            <h1><i class="fas fa-gear"></i> <%= isAm ? "ቅንብሮች" : "Settings" %></h1>
            <div class="header-buttons">
                <a href="<%= ctx %>/admin/dashboard" class="profile-btn">
                    <i class="fas fa-tachometer-alt"></i> <%= isAm ? "ዳሽቦርድ" : "Dashboard" %>
                </a>
                <a href="<%= ctx %>/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> <%= labelLogout %>
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
            <h2><i class="fas fa-key"></i> <%= isAm ? "የይለፍ ቃል ቀይር" : "Change Password" %></h2>
            <form method="post" action="<%= ctx %>/admin/settings" style="margin-top: 24px;">
                <input type="hidden" name="action" value="change_password" />

                <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                    <i class="fas fa-lock"></i> <%= isAm ? "አሁን ያለው የይለፍ ቃል" : "Current Password" %>
                </label>
                <input type="password" name="currentPassword" required
                       style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:16px;" />

                <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                    <i class="fas fa-lock"></i> <%= isAm ? "አዲስ የይለፍ ቃል" : "New Password" %>
                </label>
                <input type="password" name="newPassword" required
                       style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:16px;" />

                <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                    <i class="fas fa-lock"></i> <%= isAm ? "አዲሱን ደግመህ ጻፍ" : "Confirm New Password" %>
                </label>
                <input type="password" name="confirmNewPassword" required
                       style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:22px;" />

                <div style="display:flex;justify-content:flex-end;gap:12px;flex-wrap:wrap;">
                    <button type="submit" class="profile-btn" style="padding:14px 32px;font-size:16px;border:none;cursor:pointer;">
                        <i class="fas fa-save"></i> <%= isAm ? "አስቀምጥ" : "Update Password" %>
                    </button>
                </div>
            </form>
        </div>

        <div class="card" style="margin-top: 24px;">
            <h2><i class="fas fa-circle-info"></i> <%= isAm ? "ስርዓት መረጃ" : "System Info" %></h2>
            <p style="color:#555;">
                <strong><%= isAm ? "መግለጫ" : "Note" %>:</strong>
                <%= isAm ? "እዚህ ላይ የአስተዳዳሪ ቅንብሮችን ታስተካክላሉ።" : "Use this page to manage admin settings." %>
            </p>
        </div>
    </div>
</div>

</body>
</html>
