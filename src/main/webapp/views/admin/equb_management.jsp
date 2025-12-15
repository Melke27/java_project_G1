<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.EqubGroup" %>
<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Equb Management - Equb & Idir</title>
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
        .btn-danger { padding: 10px 16px; background: #e74c3c; color: white; border: none; border-radius: 12px; font-weight: 600; cursor: pointer; }
        .btn-danger:hover { background: #c0392b; }
        .table-container { overflow-x: auto; margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; min-width: 600px; }
        th { background: #1e4d2b; color: white; padding: 16px; text-align: left; }
        td { padding: 16px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f8fafc; }
        .actions { white-space: nowrap; }
        .actions form { display: inline; }
        .back-btn { display: inline-block; padding: 12px 24px; background: #1e4d2b; color: white; text-decoration: none; border-radius: 12px; font-weight: 600; }
        .back-btn:hover { background: #c9a227; color: #1e4d2b; }
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

    request.setAttribute("activePage", "equb");

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message");
    session.removeAttribute("error");

    List<EqubGroup> groups = (List<EqubGroup>) request.getAttribute("groups");
    if (groups == null) groups = java.util.Collections.emptyList();

    Integer selectedEqubId = (Integer) request.getAttribute("selectedEqubId");

    List<Member> allMembers = (List<Member>) request.getAttribute("allMembers");
    if (allMembers == null) allMembers = java.util.Collections.emptyList();

    @SuppressWarnings("unchecked")
    List<String[]> equbMembers = (List<String[]>) request.getAttribute("equbMembers");
    if (equbMembers == null) equbMembers = java.util.Collections.emptyList();
%>

<%@ include file="_sidebar.jspf" %>

<!-- Main Content -->
<div class="main-content" id="mainContent">
    <div class="welcome-header">
        <h1><i class="fas fa-handshake"></i> <%= isAm ? "የእቁብ አስተዳደር" : "Equb Management" %></h1>
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

    <div class="grid">
        <!-- Create Equb Group -->
        <div class="card">
            <h2><i class="fas fa-plus-circle"></i> <%= isAm ? "አዲስ የእቁብ ቡድን ፍጠር" : "Create Equb Group" %></h2>
            <form method="post" action="<%= ctx %>/admin/equb">
                <input type="hidden" name="action" value="create_group" />

                <div class="form-group">
                    <label><%= isAm ? "የቡድን ስም" : "Equb Name" %></label>
                    <input type="text" name="equb_name" required />
                </div>

                <div class="form-group">
                    <label><%= isAm ? "መጠን (ብር)" : "Amount (ETB)" %></label>
                    <input type="number" step="0.01" name="amount" required />
                </div>

                <div class="form-group">
                    <label><%= isAm ? "ድግግሞሽ" : "Frequency" %></label>
                    <select name="frequency">
                        <option value="daily"><%= isAm ? "በቀን" : "Daily" %></option>
                        <option value="weekly"><%= isAm ? "በሳምንት" : "Weekly" %></option>
                        <option value="monthly" selected><%= isAm ? "በወር" : "Monthly" %></option>
                    </select>
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> <%= isAm ? "ቡድን ፍጠር" : "Create Group" %>
                </button>
            </form>
        </div>

        <!-- List of Groups -->
        <div class="card">
            <h2><i class="fas fa-list"></i> <%= isAm ? "የእቁብ ቡድኖች" : "Equb Groups" %></h2>

            <% if (groups.isEmpty()) { %>
            <div style="text-align:center;padding:40px;color:#888;">
                <i class="fas fa-folder-open" style="font-size:48px;color:#c9a227;margin-bottom:15px;"></i>
                <p><%= isAm ? "ምንም የእቁብ ቡድን የለም።" : "No Equb groups created yet." %></p>
            </div>
            <% } else { %>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th><%= isAm ? "ስም" : "Name" %></th>
                        <th><%= isAm ? "መጠን" : "Amount" %></th>
                        <th><%= isAm ? "ድግግሞሽ" : "Frequency" %></th>
                        <th><%= isAm ? "ክፈት" : "Open" %></th>
                        <th><%= isAm ? "ሰርዝ" : "Delete" %></th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (EqubGroup g : groups) { %>
                    <tr>
                        <td><%= g.getEqubId() %></td>
                        <td><%= g.getEqubName() %></td>
                        <td><%= String.format("%,.2f", g.getAmount()) %> ETB</td>
                        <td><%= g.getFrequency() %></td>
                        <td>
                            <a href="<%= ctx %>/admin/equb?equb_id=<%= g.getEqubId() %>" style="color:#1e4d2b;font-weight:600;">
                                <i class="fas fa-folder-open"></i> <%= isAm ? "ክፈት" : "Open" %>
                            </a>
                        </td>
                        <td class="actions">
                            <form method="post" action="<%= ctx %>/admin/equb" style="display:inline;">
                                <input type="hidden" name="action" value="delete_group" />
                                <input type="hidden" name="equb_id" value="<%= g.getEqubId() %>" />
                                <button type="submit" class="btn-danger" onclick="return confirm('<%= isAm ? "ቡድኑን መሰረዝ ይፈልጋሉ?" : "Are you sure you want to delete this group?" %>')">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Selected Group Management -->
    <% if (selectedEqubId != null) { %>
    <div class="card">
        <h2><i class="fas fa-users"></i> <%= isAm ? "የቡድን አባላት (እቁብ ID: " : "Group Members (Equb ID: " %><%= selectedEqubId %>)</h2>

        <!-- Add Member -->
        <div style="margin-bottom:30px;">
            <h3 style="color:#1e4d2b;margin-bottom:16px;"><%= isAm ? "አባል ጨምር" : "Add Member to this Equb" %></h3>
            <form method="post" action="<%= ctx %>/admin/equb">
                <input type="hidden" name="action" value="add_member" />
                <input type="hidden" name="equb_id" value="<%= selectedEqubId %>" />

                <div class="form-group">
                    <label><%= isAm ? "አባል ምረጥ" : "Select Member" %></label>
                    <select name="member_id" required>
                        <% for (Member m : allMembers) { %>
                        <option value="<%= m.getMemberId() %>"><%= m.getFullName() %> (<%= m.getPhone() %>)</option>
                        <% } %>
                    </select>
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-user-plus"></i> <%= isAm ? "አባል ጨምር" : "Add Member" %>
                </button>
            </form>
        </div>

        <!-- Rotation -->
        <div style="margin-bottom:30px;">
            <h3 style="color:#1e4d2b;margin-bottom:16px;"><%= isAm ? "ማዞሪያ ፍጠር" : "Generate Rotation" %></h3>
            <div style="display:flex;gap:12px;flex-wrap:wrap;">
                <form method="post" action="<%= ctx %>/admin/equb" style="display:inline;">
                    <input type="hidden" name="action" value="generate_rotation" />
                    <input type="hidden" name="equb_id" value="<%= selectedEqubId %>" />
                    <input type="hidden" name="mode" value="fixed" />
                    <button type="submit" class="btn-primary">
                        <%= isAm ? "ተራ ማዞሪያ" : "Fixed Rotation" %>
                    </button>
                </form>
                <form method="post" action="<%= ctx %>/admin/equb" style="display:inline;">
                    <input type="hidden" name="action" value="generate_rotation" />
                    <input type="hidden" name="equb_id" value="<%= selectedEqubId %>" />
                    <input type="hidden" name="mode" value="random" />
                    <button type="submit" class="btn-primary">
                        <%= isAm ? "የዘፈቀደ ማዞሪያ" : "Random Rotation" %>
                    </button>
                </form>
            </div>
        </div>

        <!-- Members Table -->
        <h3 style="color:#1e4d2b;margin-bottom:16px;"><%= isAm ? "አባላት እና ክፍያ ሁኔታ" : "Members & Payment Status" %></h3>
        <% if (equbMembers.isEmpty()) { %>
        <div style="text-align:center;padding:40px;color:#888;">
            <i class="fas fa-users-slash" style="font-size:48px;color:#c9a227;margin-bottom:15px;"></i>
            <p><%= isAm ? "በዚህ ቡድን ውስጥ ምንም አባል የለም።" : "No members in this group yet." %></p>
        </div>
        <% } else { %>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th><%= isAm ? "ስም" : "Name" %></th>
                    <th><%= isAm ? "ስልክ" : "Phone" %></th>
                    <th><%= isAm ? "ሁኔታ" : "Status" %></th>
                    <th><%= isAm ? "ተራ" : "Rotation" %></th>
                    <th><%= isAm ? "አጽድቅ" : "Approve" %></th>
                </tr>
                </thead>
                <tbody>
                <% for (String[] r : equbMembers) { %>
                <tr>
                    <td><%= r[0] %></td>
                    <td><%= r[1] %></td>
                    <td><%= r[2] %></td>
                    <td><%= "paid".equals(r[3]) ? (isAm ? "ተከፍሏል" : "Paid") : (isAm ? "አልተከፈለም" : "Unpaid") %></td>
                    <td><%= r[4] != null ? r[4] : "-" %></td>
                    <td class="actions">
                        <% if ("unpaid".equals(r[3])) { %>
                        <form method="post" action="<%= ctx %>/admin/equb" style="display:inline;">
                            <input type="hidden" name="action" value="approve_payment" />
                            <input type="hidden" name="equb_id" value="<%= selectedEqubId %>" />
                            <input type="hidden" name="member_id" value="<%= r[0] %>" />
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-check"></i> <%= isAm ? "አጽድቅ" : "Approve" %>
                            </button>
                        </form>
                        <% } else { %>
                        <span style="color:#27ae60;font-weight:600;"><%= isAm ? "ተፈቅዷል" : "Approved" %></span>
                        <% } %>
                    </td>
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