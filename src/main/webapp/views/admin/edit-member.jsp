<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Member - Admin</title>
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
    String labelMyProfile = isAm ? "የግል መረጃዬ" : "My Profile";
    String labelLogout = isAm ? "ውጣ" : "Logout";

    request.setAttribute("activePage", "members.list");

    Member currentUser = (Member) session.getAttribute("user");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }

    Member memberToEdit = (Member) request.getAttribute("memberToEdit");
    if (memberToEdit == null) {
        response.sendRedirect(ctx + "/admin/dashboard");
        return;
    }

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message");
    session.removeAttribute("error");
%>

<%@ include file="_sidebar.jspf" %>

<div class="main-content" id="mainContent">
    <div class="dashboard-container">
    <div class="header">
        <h1><i class="fas fa-user-pen"></i> <%= isAm ? "አባል አርትዕ" : "Edit Member" %></h1>
        <div class="header-buttons">
            <a href="<%= ctx %>/admin/dashboard" class="profile-btn">
                <i class="fas fa-tachometer-alt"></i> <%= isAm ? "ዳሽቦርድ" : "Dashboard" %>
            </a>
            <a href="<%= ctx %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> <%= isAm ? "ውጣ" : "Logout" %>
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
        <h2><i class="fas fa-id-card"></i> <%= isAm ? "የአባል መረጃ" : "Member Details" %></h2>

        <form method="post" action="<%= ctx %>/admin/update-member" style="margin-top: 24px;">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="member_id" value="<%= memberToEdit.getMemberId() %>" />

            <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                <i class="fas fa-user"></i> <%= isAm ? "ሙሉ ስም" : "Full Name" %>
            </label>
            <input type="text" name="full_name" required
                   value="<%= memberToEdit.getFullName() != null ? memberToEdit.getFullName() : "" %>"
                   style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:16px;" />

            <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                <i class="fas fa-phone"></i> <%= isAm ? "ስልክ" : "Phone" %>
            </label>
            <input type="text" name="phone" required
                   value="<%= memberToEdit.getPhone() != null ? memberToEdit.getPhone() : "" %>"
                   style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:16px;" />

            <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                <i class="fas fa-location-dot"></i> <%= isAm ? "አድራሻ" : "Address" %>
            </label>
            <input type="text" name="address"
                   value="<%= memberToEdit.getAddress() != null ? memberToEdit.getAddress() : "" %>"
                   style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:16px;" />

            <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                <i class="fas fa-user-shield"></i> <%= isAm ? "ሚና" : "Role" %>
            </label>
            <select name="role" style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:22px;">
                <option value="member" <%= "member".equalsIgnoreCase(memberToEdit.getRole()) ? "selected" : "" %>>member</option>
                <option value="admin" <%= "admin".equalsIgnoreCase(memberToEdit.getRole()) ? "selected" : "" %>>admin</option>
            </select>

            <div style="display:flex;justify-content:flex-end;gap:12px;flex-wrap:wrap;">
                <a href="<%= ctx %>/admin/dashboard" style="color:#666;text-decoration:none;font-weight:500;">
                    <%= isAm ? "ተመለስ" : "Cancel" %>
                </a>
                <button type="submit" class="profile-btn" style="padding:14px 32px;font-size:16px;border:none;cursor:pointer;">
                    <i class="fas fa-save"></i> <%= isAm ? "አስቀምጥ" : "Save Changes" %>
                </button>
            </div>
        </form>
    </div>

    <div class="card" style="margin-top: 24px;">
        <h2><i class="fas fa-key"></i> <%= isAm ? "የይለፍ ቃል አድስ" : "Reset Password" %></h2>
        <form method="post" action="<%= ctx %>/admin/update-member" style="margin-top: 24px;">
            <input type="hidden" name="action" value="reset_password" />
            <input type="hidden" name="member_id" value="<%= memberToEdit.getMemberId() %>" />

            <label style="display:block;margin-bottom:8px;font-weight:600;color:#1e4d2b;">
                <i class="fas fa-lock"></i> <%= isAm ? "አዲስ የይለፍ ቃል" : "New Password" %>
            </label>
            <input type="text" name="password" required
                   style="width:100%;padding:14px;border:1px solid #ddd;border-radius:12px;font-size:16px;margin-bottom:22px;"
                   placeholder="<%= isAm ? "አዲስ የይለፍ ቃል ያስገቡ" : "Enter new password" %>" />

            <div style="display:flex;justify-content:flex-end;gap:12px;flex-wrap:wrap;">
                <button type="submit" class="profile-btn" style="padding:14px 32px;font-size:16px;border:none;cursor:pointer;">
                    <i class="fas fa-rotate"></i> <%= isAm ? "አድስ" : "Reset" %>
                </button>
            </div>
        </form>
    </div>
    </div>
</div>

</body>
</html>
