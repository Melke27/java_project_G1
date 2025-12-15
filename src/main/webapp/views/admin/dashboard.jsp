<%@ page import="com.equbidir.model.Member" %>
<%@ page import="com.equbidir.dao.MemberDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Equb & Idir</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-dashboard.css">
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
            min-height: 100vh;
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
            margin-top:30px;
        }
        .welcome-header h1 {
            color: #1e4d2b;
            margin: 0;
            font-size: 28px;
        }
        .welcome-header div {
            color: #666;
            font-size: 16px;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-8px);
        }
        .card h2 {
            color: #1e4d2b;
            border-bottom: 2px solid #c9a227;
            padding-bottom: 12px;
            margin-top: 0;
            font-size: 22px;
        }
        .info-item {
            font-size: 36px;
            text-align: center;
            margin: 20px 0;
            color: #1e4d2b;
            font-weight: 700;
        }
        .placeholder {
            text-align: center;
            color: #888;
            padding: 40px 20px;
        }
        .placeholder i {
            font-size: 48px;
            color: #c9a227;
            margin-bottom: 15px;
        }
        .search-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }
        .search-bar input {
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 999px;
            flex: 1;
            min-width: 200px;
            font-size: 16px;
        }
        .search-bar button {
            padding: 12px 24px;
            background: #1e4d2b;
            color: white;
            border: none;
            border-radius: 999px;
            cursor: pointer;
            font-weight: 600;
        }
        .table-container {
            overflow-x: auto;
            margin-top: 10px;
        }
        .members-table {
            width: 100%;
            min-width: 600px;
            border-collapse: collapse;
        }
        .members-table th {
            background: #1e4d2b;
            color: white;
            padding: 16px;
            text-align: left;
        }
        .members-table td {
            padding: 16px;
            border-bottom: 1px solid #eee;
        }
        .members-table tr:hover {
            background: #f8fafc;
        }
        .actions a {
            margin: 0 10px;
            font-size: 18px;
            text-decoration: none;
        }
        .edit-btn { color: #f39c12; }
        .delete-btn { color: #e74c3c; }
        .calendar-container {
            overflow-x: auto;
            margin-top: 20px;
        }
        .calendar {
            width: 100%;
            min-width: 600px;
            border-collapse: collapse;
        }
        .calendar th {
            background: #1e4d2b;
            color: white;
            padding: 12px;
        }
        .calendar td {
            text-align: center;
            padding: 16px;
            border: 1px solid #eee;
        }
        .calendar td.today {
            background: #c9a227;
            color: white;
            font-weight: bold;
            border-radius: 8px;
        }
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

    // Labels (same as before)
    String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
    String labelMembers = isAm ? "አባላት" : "Members";
    String labelEqub = isAm ? "እቁብ" : "Equb";
    String labelIdir = isAm ? "እድር" : "Idir";
    String labelExpenses = isAm ? "ወጪዎች" : "Expenses";
    String labelReports = isAm ? "ሪፖርቶች" : "Reports";
    String labelMyProfile = isAm ? "የግል መረጃዬ" : "My Profile";
    String labelLogout = isAm ? "ውጣ" : "Logout";
    String labelAdminDashboard = isAm ? "የአስተዳዳሪ ዳሽቦርድ" : "Admin Dashboard";
    String labelTotalMembers = isAm ? "ጠቅላላ አባላት" : "Total Members";
    String labelActiveEqub = isAm ? "ንቁ የእቁብ ቡድኖች" : "Active Equb Groups";
    String labelActiveIdir = isAm ? "ንቁ የእድር ቡድኖች" : "Active Idir Groups";
    String labelTotalFund = isAm ? "ጠቅላላ የፈንድ ቀሪ መጠን" : "Total Fund Balance";
    String labelMemberManagement = isAm ? "የአባላት አስተዳደር" : "Member Management";
    String labelAddMember = isAm ? "አዲስ አባል ጨምር" : "Add New Member";
    String labelSearchPlaceholder = isAm ? "በስም ወይም ስልክ ፈልግ" : "Search by name or phone";

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message");
    session.removeAttribute("error");

    String search = request.getParameter("q");

    MemberDAO memberDAO = new MemberDAO();
    List<Member> allMembers = memberDAO.getAllMembers();

    List<Member> regularMembers = new ArrayList<>();
    for (Member m : allMembers) {
        if (m.getRole() == null || !"admin".equalsIgnoreCase(m.getRole())) {
            boolean matches = true;
            if (search != null && !search.trim().isEmpty()) {
                String s = search.trim().toLowerCase();
                String name = m.getFullName() != null ? m.getFullName().toLowerCase() : "";
                String phone = m.getPhone() != null ? m.getPhone().toLowerCase() : "";
                matches = name.contains(s) || phone.contains(s);
            }
            if (matches) {
                regularMembers.add(m);
            }
        }
    }

    int equbGroupsCount = 0;
    int idirGroupsCount = 0;

    Calendar cal = Calendar.getInstance();
    int currentDay = cal.get(Calendar.DAY_OF_MONTH);
    cal.set(Calendar.DAY_OF_MONTH, 1);
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    String[] daysEn = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
    String[] daysAm = {"እሑድ", "ሰኞ", "ማክሰኞ", "ረቡዕ", "ሐሙስ", "ዓርብ", "ቅዳሜ"};
    String[] days = isAm ? daysAm : daysEn;
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
        <li><a href="<%= ctx %>/admin/dashboard" class="active"><i class="fas fa-tachometer-alt"></i> <%= labelDashboard %></a></li>
        <li><a href="<%= ctx %>/admin/members"><i class="fas fa-users"></i> <%= labelMembers %></a></li>
        <li><a href="<%= ctx %>/admin/equb"><i class="fas fa-handshake"></i> <%= labelEqub %></a></li>
        <li><a href="<%= ctx %>/admin/idir"><i class="fas fa-heart"></i> <%= labelIdir %></a></li>
        <li><a href="<%= ctx %>/admin/expenses"><i class="fas fa-money-bill-wave"></i> <%= labelExpenses %></a></li>
        <li><a href="<%= ctx %>/views/admin/reports.jsp"><i class="fas fa-chart-bar"></i> <%= labelReports %></a></li>
    </ul>
    <div style="margin-top: auto; padding-top: 30px; border-top: 1px solid rgba(255,255,255,0.2);">
        <ul class="sidebar-menu">
            <li><a href="<%= ctx %>/views/member/profile.jsp"><i class="fas fa-user-cog"></i> <%= labelMyProfile %></a></li>
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
</div>

<!-- Main Content -->
<div class="main-content" id="mainContent">
    <div class="welcome-header">
        <h1><%= labelAdminDashboard %></h1>
        <div>
            <i class="fas fa-calendar-day"></i>
            <%= new java.text.SimpleDateFormat(isAm ? "dd MMMM yyyy" : "MMMM dd, yyyy").format(new java.util.Date()) %>
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

    <div class="grid">
        <div class="card">
            <h2><i class="fas fa-users"></i> <%= labelTotalMembers %></h2>
            <p class="info-item"><%= regularMembers.size() %></p>
        </div>

        <div class="card">
            <h2><i class="fas fa-handshake"></i> <%= labelActiveEqub %></h2>
            <p class="info-item"><%= equbGroupsCount %></p>
        </div>

        <div class="card">
            <h2><i class="fas fa-heart"></i> <%= labelActiveIdir %></h2>
            <p class="info-item"><%= idirGroupsCount %></p>
        </div>

        <div class="card">
            <h2><i class="fas fa-wallet"></i> <%= labelTotalFund %></h2>
            <p class="placeholder"><%= isAm ? "መዋጮ ከጀመረ በኋላ እዚህ ይታያል" : "Will be available after contributions start" %></p>
        </div>
    </div>

    <!-- Member Management Card -->
    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 16px;">
            <h2><i class="fas fa-users-cog"></i> <%= labelMemberManagement %></h2>
            <div class="search-bar">
                <form method="get" style="display: flex; gap: 12px; flex: 1; min-width: 250px;">
                    <input type="text" name="q" value="<%= search != null ? search : "" %>"
                           placeholder="<%= labelSearchPlaceholder %>">
                    <button type="submit"><i class="fas fa-search"></i> Search</button>
                </form>
                <a href="<%= ctx %>/views/admin/member_management.jsp" class="profile-btn">
                    <i class="fas fa-user-plus"></i> <%= labelAddMember %>
                </a>
            </div>
        </div>

        <% if (regularMembers.isEmpty()) { %>
        <div class="placeholder">
            <i class="fas fa-users"></i>
            <p><%= isAm ? "እስካሁን ምንም መደበኛ አባል የለም።" : "No regular members registered yet." %></p>
        </div>
        <% } else { %>
        <div class="table-container">
            <table class="members-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Full Name</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int rowNum = 1;
                    for (Member m : regularMembers) {
                %>
                <tr>
                    <td>#<%= rowNum++ %></td>
                    <td><%= m.getFullName() != null ? m.getFullName() : "-" %></td>
                    <td><%= m.getPhone() != null ? m.getPhone() : "-" %></td>
                    <td><%= m.getAddress() != null ? m.getAddress() : "-" %></td>
                    <td class="actions">
                        <a href="<%= ctx %>/views/admin/edit-member.jsp?id=<%= m.getMemberId() %>"
                           class="edit-btn" title="Edit">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="<%= ctx %>/admin/delete-member?id=<%= m.getMemberId() %>"
                           class="delete-btn" title="Delete"
                           onclick="return confirm('Are you sure you want to delete <%= m.getFullName() %>?')">
                            <i class="fas fa-trash"></i>
                        </a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- Calendar -->
    <div class="card" style="margin-top: 40px;">
        <h2><i class="fas fa-calendar-alt"></i> <%= isAm ? "የወሩ ቀን መቁጠሪያ" : "Monthly Calendar" %></h2>
        <div class="calendar-container">
            <table class="calendar">
                <thead>
                <tr>
                    <% for (String day : days) { %>
                    <th><%= day %></th>
                    <% } %>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <%
                        for (int i = 1; i < firstDayOfWeek; i++) {
                            out.print("<td></td>");
                        }
                        for (int day = 1; day <= daysInMonth; day++) {
                            String dayClass = (day == currentDay) ? "today" : "";
                    %>
                    <td class="<%= dayClass %>"><%= day %></td>
                    <%
                            if ((day + firstDayOfWeek - 1) % 7 == 0 && day != daysInMonth) {
                                out.print("</tr><tr>");
                            }
                        }
                    %>
                </tr>
                </tbody>
            </table>
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
</script>

</body>
</html>