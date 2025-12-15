<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.IdirGroup" %>
<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Idir Expenses - Equb & Idir</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-dashboard.css">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; padding: 0; font-family: 'Poppins', sans-serif; background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%); min-height: 100vh; overflow-x: hidden; }
        .hamburger { position: fixed; top: 20px; left: 20px; font-size: 28px; color: #1e4d2b; background: white; width: 50px; height: 50px; border-radius: 50%; box-shadow: 0 4px 15px rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: center; cursor: pointer; z-index: 1002; }
        .overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 999; }
        .overlay.active { display: block; }
        .sidebar { width: 280px; background: #1e4d2b; color: white; padding: 30px 20px; position: fixed; height: 100%; left: -300px; top: 0; box-shadow: 5px 0 15px rgba(0,0,0,0.1); transition: left 0.4s ease; z-index: 1000; }
        .sidebar.active { left: 0; }
        .sidebar-header { text-align: center; margin-bottom: 50px; }
        .sidebar-header h2 { margin: 0; font-size: 26px; color: #c9a227; }
        .sidebar-menu { list-style: none; padding: 0; }
        .sidebar-menu li { margin: 12px 0; }
        .sidebar-menu a { color: white; text-decoration: none; display: flex; align-items: center; padding: 14px 18px; border-radius: 12px; transition: 0.3s; font-size: 16px; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background: #c9a227; color: #1e4d2b; }
        .sidebar-menu i { margin-right: 14px; font-size: 20px; width: 28px; text-align: center; }
        .main-content { padding: 20px; width: 100%; transition: filter 0.4s ease; }
        .main-content.blurred { filter: blur(5px); }
        .lang-selector { margin-top: 40px; text-align: center; padding: 20px; background: rgba(255,255,255,0.1); border-radius: 16px; }
        .lang-selector label { display: block; margin-bottom: 12px; font-weight: 600; color: #c9a227; }
        .lang-options { display: flex; justify-content: center; gap: 20px; }
        .lang-option { text-align: center; cursor: pointer; transition: 0.3s; }
        .lang-option:hover { transform: translateY(-5px); }
        .lang-option img { width: 48px; height: 48px; border-radius: 50%; box-shadow: 0 4px 10px rgba(0,0,0,0.3); border: 3px solid transparent; transition: 0.3s; }
        .lang-option:hover img { border-color: #c9a227; }
        .lang-option span { display: block; margin-top: 8px; font-size: 14px; font-weight: 600; }
        .lang-option.active img { border-color: #c9a227; transform: scale(1.1); }
        .welcome-header { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; margin-top: 30px; }
        .welcome-header h1 { color: #1e4d2b; margin: 0; font-size: 28px; }
        .card { background: white; padding: 30px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); margin-bottom: 30px; }
        .card h2 { color: #1e4d2b; border-bottom: 2px solid #c9a227; padding-bottom: 12px; margin-top: 0; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #1e4d2b; }
        .form-group input, .form-group select { width: 100%; padding: 14px 16px; border: 1px solid #ddd; border-radius: 12px; font-size: 16px; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #c9a227; box-shadow: 0 0 0 3px rgba(201,162,39,0.1); }
        .btn-primary { padding: 14px 28px; background: #1e4d2b; color: white; border: none; border-radius: 12px; font-weight: 600; cursor: pointer; }
        .btn-primary:hover { background: #c9a227; color: #1e4d2b; }
        .table-container { overflow-x: auto; margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; min-width: 600px; }
        th { background: #1e4d2b; color: white; padding: 16px; text-align: left; }
        td { padding: 16px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f8fafc; }
        .back-btn { display: inline-block; padding: 12px 24px; background: #1e4d2b; color: white; text-decoration: none; border-radius: 12px; font-weight: 600; }
        .back-btn:hover { background: #c9a227; color: #1e4d2b; }
        .placeholder { text-align: center; color: #888; padding: 60px 20px; }
        .placeholder i { font-size: 64px; color: #c9a227; margin-bottom: 20px; }
    </style>
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

    String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
    String labelMembers = isAm ? "አባላት" : "Members";
    String labelEqub = isAm ? "እቁብ" : "Equb";
    String labelIdir = isAm ? "እድር" : "Idir";
    String labelExpenses = isAm ? "ወጪዎች" : "Expenses";
    String labelReports = isAm ? "ሪፖርቶች" : "Reports";
    String labelMyProfile = isAm ? "የግል መረጃዬ" : "My Profile";
    String labelLogout = isAm ? "ውጣ" : "Logout";

    request.setAttribute("activePage", "expenses");

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message");
    session.removeAttribute("error");

    List<IdirGroup> groups = (List<IdirGroup>) request.getAttribute("groups");
    if (groups == null) groups = java.util.Collections.emptyList();

    Integer selectedIdirId = (Integer) request.getAttribute("selectedIdirId");

    @SuppressWarnings("unchecked")
    List<String[]> expenses = (List<String[]>) request.getAttribute("expenses");
    if (expenses == null) expenses = java.util.Collections.emptyList();
%>

<%@ include file="_sidebar.jspf" %>

<!-- Main Content -->
<div class="main-content" id="mainContent">
    <div class="welcome-header">
        <h1><i class="fas fa-receipt"></i> <%= isAm ? "የእድር ወጪ አስተዳደር" : "Idir Expense Management" %></h1>
        <a href="<%= ctx %>/admin/dashboard" class="back-btn">
            <i class="fas fa-arrow-left"></i> <%= isAm ? "ወደ ዳሽቦርድ" : "Back to Dashboard" %>
        </a>
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

    <!-- Select Idir Group -->
    <div class="card">
        <h2><i class="fas fa-heart"></i> <%= isAm ? "የእድር ቡድን ይምረጡ" : "Select Idir Group" %></h2>
        <form method="get" action="<%= ctx %>/admin/expenses" style="margin-top:20px;">
            <div class="form-group">
                <label><%= isAm ? "ቡድን" : "Group" %></label>
                <select name="idir_id" required style="max-width:400px;">
                    <option value="">-- <%= isAm ? "ይምረጡ" : "Select" %> --</option>
                    <% for (IdirGroup g : groups) { %>
                    <option value="<%= g.getIdirId() %>" <%= (selectedIdirId != null && selectedIdirId.equals(g.getIdirId())) ? "selected" : "" %>>
                        <%= g.getIdirName() %>
                    </option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn-primary">
                <i class="fas fa-folder-open"></i> <%= isAm ? "ክፈት" : "Open" %>
            </button>
        </form>
    </div>

    <!-- Expense Management for Selected Group -->
    <% if (selectedIdirId != null) { %>
    <div class="card">
        <h2><i class="fas fa-plus-circle"></i>
            <%= isAm ? "ወጪ አክል (የእድር መለያ፡ " : "Add Expense (Idir ID: " %><%= selectedIdirId %>)
        </h2>
        <form method="post" action="<%= ctx %>/admin/expenses">
            <input type="hidden" name="idir_id" value="<%= selectedIdirId %>" />

            <div class="form-group">
                <label><%= isAm ? "መጠን (ብር)" : "Amount (ETB)" %></label>
                <input type="number" step="0.01" name="amount" required placeholder="0.00" />
            </div>

            <div class="form-group">
                <label><%= isAm ? "መግለጫ" : "Description" %></label>
                <input type="text" name="description" placeholder="<%= isAm ? "ምክንያት (አማራጭ)" : "Reason (optional)" %>" />
            </div>

            <div class="form-group">
                <label><%= isAm ? "ቀን" : "Date" %></label>
                <input type="date" name="expense_date" required />
            </div>

            <button type="submit" class="btn-primary">
                <i class="fas fa-save"></i> <%= isAm ? "ወጪውን አስቀምጥ" : "Save Expense" %>
            </button>
        </form>
    </div>

    <div class="card">
        <h2><i class="fas fa-list-alt"></i> <%= isAm ? "የተመዘገቡ ወጪዎች" : "Recorded Expenses" %></h2>

        <% if (expenses.isEmpty()) { %>
        <div class="placeholder">
            <i class="fas fa-receipt"></i>
            <p><%= isAm ? "ምንም ወጪ አልተመዘገበም።" : "No expenses recorded yet." %></p>
        </div>
        <% } else { %>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th><%= isAm ? "መጠን" : "Amount" %></th>
                    <th><%= isAm ? "መግለጫ" : "Description" %></th>
                    <th><%= isAm ? "ቀን" : "Date" %></th>
                </tr>
                </thead>
                <tbody>
                <% for (String[] r : expenses) { %>
                <tr>
                    <td><%= r[0] %></td>
                    <td><%= String.format("%,.2f", Double.parseDouble(r[1])) %> ETB</td>
                    <td><%= r[2] != null && !r[2].isEmpty() ? r[2] : "<em style='color:#888;'>No description</em>" %></td>
                    <td><%= r[3] %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
    <% } %>
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
</script>

</body>
</html>