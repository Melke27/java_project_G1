<%@ page import="com.equbidir.model.Member" %>
<<<<<<< HEAD
<%@ page import="com.equbidir.dao.MemberDAO" %>
<%@ page import="com.equbidir.model.EqubMemberInfo" %>
<%@ page import="com.equbidir.model.IdirMemberInfo" %>
=======
<%@ page import="com.equbidir.model.EqubMembership" %>
<%@ page import="com.equbidir.model.IdirMembership" %>
<%@ page import="com.equbidir.model.Notification" %>
<%@ page import="java.util.List" %>
>>>>>>> c99eacf69167d2599f411623f0789eacee5c68dd
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard - Equb & Idir</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dashboard.css">
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
            cursor: pointer;
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
        .clickable-card {
            cursor: pointer;
        }
        .group-summary {
            text-align: center;
            padding: 20px 0;
        }
        .group-name {
            font-size: 24px;
            font-weight: bold;
            color: #1e4d2b;
            margin: 10px 0;
        }
        .detail {
            font-size: 16px;
            color: #636e72;
            margin: 8px 0;
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
        .calendar-card {
            grid-column: 1 / -1;
            margin-top: 20px;
        }
        .calendar {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }
        .calendar th, .calendar td {
            text-align: center;
            padding: 12px;
            border: 1px solid #eee;
            font-size: 14px;
        }
        .calendar th {
            background: #1e4d2b;
            color: white;
            font-weight: 600;
        }
        .calendar td.today {
            background: #c9a227;
            color: white;
            font-weight: bold;
            border-radius: 8px;
        }
        @media (max-width: 768px) {
            .calendar th, .calendar td {
                padding: 8px;
                font-size: 13px;
            }
        }
        @media (max-width: 480px) {
            .calendar th, .calendar td {
                padding: 6px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>

<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
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
    String labelHistoryTitle = isAm ? "የመዋጮ ታሪክ" : "Contribution History";
    String labelLogout = isAm ? "ውጣ" : "Logout";
    String labelWelcome = isAm ? "እንኳን በደህና መጡ፣ " : "Welcome back, ";
    String labelPersonalInfo = isAm ? "የግል መረጃ" : "Personal Information";
    String labelEqubTitle = isAm ? "የእቁብ ቡድኖቼ" : "My Equb Groups";
    String labelIdirTitle = isAm ? "የእድር ቡድኔ" : "My Idir Group";
    String labelCalendar = isAm ? "የወሩ ቀን መቁጠሪያ" : "Monthly Calendar";
<<<<<<< HEAD
    String labelNotAssigned = isAm ? "እስካሁን ምንም ቡድን አልተመደበልህም።" : "No group assigned yet.";
    String labelContactAdmin = isAm ? "ለመቀላቀል አስተዳዳሪዎን ያነጋግሩ።" : "Contact your administrator to join one.";

    MemberDAO memberDAO = new MemberDAO();
    EqubMemberInfo equbInfo = memberDAO.getMemberEqubInfo(user.getMemberId());
    IdirMemberInfo idirInfo = memberDAO.getMemberIdirInfo(user.getMemberId());
=======
    String labelNotifications = isAm ? "ማስታወቂያዎች" : "Notifications";
    String labelNotAssigned = isAm ? "እስካሁን ምንም የእቁብ ቡድን አልተመደበልህም።<br>ለመቀላቀል ከአስተዳዳሪዎ ጋር ያነጋግሩ።" : "No Equb groups assigned yet.<br>Contact your admin to join one.";

    String dashboardError = (String) request.getAttribute("dashboardError");

    List<EqubMembership> equbMemberships = (List<EqubMembership>) request.getAttribute("equbMemberships");
    if (equbMemberships == null) equbMemberships = java.util.Collections.emptyList();

    List<IdirMembership> idirMemberships = (List<IdirMembership>) request.getAttribute("idirMemberships");
    if (idirMemberships == null) idirMemberships = java.util.Collections.emptyList();

    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    if (notifications == null) notifications = java.util.Collections.emptyList();
>>>>>>> c99eacf69167d2599f411623f0789eacee5c68dd

    Calendar cal = Calendar.getInstance();
    int currentDay = cal.get(Calendar.DAY_OF_MONTH);
    cal.set(Calendar.DAY_OF_MONTH, 1);
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    String[] daysAm = {"እሑድ", "ሰኞ", "ማክሰኞ", "ረቡዕ", "ሐሙስ", "ዓርብ", "ቅዳሜ"};
    String[] daysEn = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
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
        <li><a href="<%= ctx %>/member/dashboard" class="active"><i class="fas fa-tachometer-alt"></i> <%= labelDashboard %></a></li>
        <li><a href="<%= ctx %>/member/equb-details"><i class="fas fa-handshake"></i> <%= labelMyEqub %></a></li>
        <li><a href="<%= ctx %>/member/idir-details"><i class="fas fa-heart"></i> <%= labelMyIdir %></a></li>
        <li><a href="<%= ctx %>/views/member/profile.jsp"><i class="fas fa-user"></i> <%= labelProfile %></a></li>
        <li><a href="<%= ctx %>/member/contribution-history"><i class="fas fa-history"></i> <%= labelHistoryTitle %></a></li>
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
        <h1><%= labelWelcome %><%= user.getFullName() %>!</h1>
        <div>
            <i class="fas fa-calendar-day"></i>
            <%= new SimpleDateFormat(isAm ? "dd MMMM yyyy" : "MMMM dd, yyyy", isAm ? new Locale("am", "ET") : Locale.ENGLISH)
                    .format(new java.util.Date()) %>
        </div>
    </div>

    <div class="grid">
        <!-- Personal Information -->
        <div class="card">
            <h2><i class="fas fa-user"></i> <%= labelPersonalInfo %></h2>
            <div class="info-item"><strong>Full Name:</strong> <%= user.getFullName() %></div>
            <div class="info-item"><strong>Phone:</strong> <%= user.getPhone() %></div>
            <div class="info-item"><strong>Member ID:</strong> #<%= user.getMemberId() %></div>
            <div class="info-item"><strong>Role:</strong>
                <%= "admin".equalsIgnoreCase(user.getRole()) ? (isAm ? "አስተዳዳሪ" : "Administrator") : (isAm ? "አባል" : "Member") %>
            </div>
        </div>

<<<<<<< HEAD
        <!-- My Equb Group - Clickable Card -->
        <div class="card clickable-card" onclick="window.location='<%= ctx %>/member/equb-details'">
=======
        <!-- Notifications from Admin -->
        <div class="card">
            <h2><i class="fas fa-bell"></i> <%= labelNotifications %></h2>

            <% if (dashboardError != null) { %>
            <div style="background:#fff3cd;color:#856404;padding:14px;border-radius:12px;margin-bottom:14px;border:1px solid #ffeeba;font-weight:600;">
                <i class="fas fa-triangle-exclamation" style="margin-right:10px;"></i>
                <%= dashboardError %>
            </div>
            <% } %>

            <% if (notifications.isEmpty()) { %>
            <div class="placeholder">
                <i class="fas fa-envelope-open-text"></i>
                <p><%= isAm ? "ምንም አዲስ ማስታወቂያ የለም።" : "No new notifications." %></p>
            </div>
            <% } else { %>
            <div style="display:flex; flex-direction:column; gap:12px;">
                <% for (Notification n : notifications) { %>
                <div style="padding:14px 16px; border:1px solid #eee; border-radius:12px;">
                    <div style="display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap;">
                        <div style="font-weight:800; color:#1e4d2b;"><%= n.getTitle() %></div>
                        <div style="color:#666; font-size:13px; font-weight:700;">
                            <%= n.getCreatedAt() != null ? new SimpleDateFormat("MMM dd, yyyy").format(n.getCreatedAt()) : "" %>
                        </div>
                    </div>
                    <div style="color:#666; margin-top:6px;">
                        <%= n.getMessage() %>
                    </div>
                    <% if (n.getCreatedByName() != null) { %>
                    <div style="color:#888; margin-top:10px; font-size:12px; font-weight:700;">
                        <%= isAm ? "ከ" : "From" %>: <%= n.getCreatedByName() %>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>

        <!-- My Equb Groups -->
        <div class="card">
>>>>>>> c99eacf69167d2599f411623f0789eacee5c68dd
            <h2><i class="fas fa-handshake"></i> <%= labelEqubTitle %></h2>
            <% if (equbMemberships.isEmpty()) { %>
            <div class="placeholder">
                <i class="fas fa-users"></i>
                <p><%= labelNotAssigned %><br><%= labelContactAdmin %></p>
            </div>
            <% } else { %>
<<<<<<< HEAD
            <div class="group-summary">
                <div class="group-name"><%= equbInfo.getEqubName() %></div>
                <div class="detail"><%= String.format("%,.2f", equbInfo.getAmount()) %> ETB - <%= equbInfo.getFrequency() %></div>
                <div class="detail"><%= equbInfo.getTotalMembers() %> <%= isAm ? "አባላት" : "Members" %></div>
                <div class="detail" style="margin-top: 20px; color: #1e4d2b; font-weight: bold;">
                    <%= isAm ? "ዝርዝር ለማየት ጠቅ ያድርጉ" : "Click for details" %> →
=======
            <div style="display:flex; flex-direction:column; gap:12px; margin-top:10px;">
                <% for (EqubMembership em : equbMemberships) { %>
                <div style="padding:14px 16px; border:1px solid #eee; border-radius:12px; display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap;">
                    <div>
                        <div style="font-weight:800; color:#1e4d2b;"><%= em.getEqubName() %></div>
                        <div style="color:#666; font-size:14px;">
                            <%= String.format("%,.2f", em.getAmount()) %> ETB • <%= em.getFrequency() %> • <%= em.getPaymentStatus() %>
                            <% if (em.getRotationPosition() != null) { %>
                                • <%= isAm ? "ቦታ" : "Pos" %>: <%= em.getRotationPosition() %>
                            <% } %>
                        </div>
                    </div>
                    <a href="<%= ctx %>/member/equb-details?equb_id=<%= em.getEqubId() %>"
                       style="text-decoration:none; background:#1e4d2b; color:white; padding:10px 14px; border-radius:999px; font-weight:700;">
                        <%= isAm ? "ዝርዝር" : "Details" %>
                    </a>
>>>>>>> c99eacf69167d2599f411623f0789eacee5c68dd
                </div>
                <% } %>
            </div>
            <% } %>
        </div>

<<<<<<< HEAD
        <!-- My Idir Group - Clickable Card -->
        <div class="card clickable-card" onclick="window.location='<%= ctx %>/member/idir-details'">
            <h2><i class="fas fa-heart"></i> <%= labelIdirTitle %></h2>
            <% if (idirInfo == null) { %>
=======
        <!-- My Idir Group(s) -->
        <div class="card">
            <h2><i class="fas fa-heart"></i> <%= labelIdirTitle %></h2>
            <% if (idirMemberships.isEmpty()) { %>
>>>>>>> c99eacf69167d2599f411623f0789eacee5c68dd
            <div class="placeholder">
                <i class="fas fa-hands-helping"></i>
                <p><%= labelNotAssigned %><br><%= labelContactAdmin %></p>
            </div>
            <% } else { %>
<<<<<<< HEAD
            <div class="group-summary">
                <div class="group-name"><%= idirInfo.getIdirName() %></div>
                <div class="detail"><%= String.format("%,.2f", idirInfo.getMonthlyPayment()) %> ETB <%= isAm ? "ወርሃዊ" : "monthly" %></div>
                <div class="detail"><%= idirInfo.getTotalMembers() %> <%= isAm ? "አባላት" : "Members" %></div>
                <div class="detail" style="margin-top: 20px; color: #27ae60; font-weight: bold;">
                    <%= isAm ? "የፈንድ ቀሪ: " : "Fund Balance: " %> <%= String.format("%,.2f", idirInfo.getFundBalance()) %> ETB
                </div>
                <div class="detail" style="margin-top: 20px; color: #1e4d2b; font-weight: bold;">
                    <%= isAm ? "ዝርዝር ለማየት ጠቅ ያድርጉ" : "Click for details" %> →
                </div>
=======
            <div style="display:flex; flex-direction:column; gap:12px; margin-top:10px;">
                <% for (IdirMembership im : idirMemberships) { %>
                <div style="padding:14px 16px; border:1px solid #eee; border-radius:12px;">
                    <div style="font-weight:800; color:#1e4d2b;"><%= im.getIdirName() %></div>
                    <div style="color:#666; font-size:14px; margin-top:6px;">
                        <%= String.format("%,.2f", im.getMonthlyPayment()) %> ETB • <%= im.getPaymentStatus() %>
                    </div>
                </div>
                <% } %>
>>>>>>> c99eacf69167d2599f411623f0789eacee5c68dd
            </div>
            <% } %>
        </div>

        <!-- Contribution History - Clickable Card -->
        <div class="card clickable-card" onclick="window.location='<%= ctx %>/member/contribution-history'">
            <h2><i class="fas fa-history"></i> <%= labelHistoryTitle %></h2>
            <div style="text-align: center; padding: 40px;">
                <div style="font-size: 18px; color: #1e4d2b; margin-bottom: 20px;">
                    <%= isAm ? "የመዋጮ ታሪክዎን ይመልከቱ" : "View your full contribution history" %>
                </div>
                <div style="color: #1e4d2b; font-weight: bold;">
                    <%= isAm ? "ሙሉ ታሪክ ለማየት ጠቅ ያድርጉ →" : "Click to see all payments →" %>
                </div>
            </div>
        </div>
    </div>

    <!-- Full-Width Monthly Calendar -->
    <div class="card calendar-card">
        <h2><i class="fas fa-calendar-alt"></i> <%= labelCalendar %></h2>
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
                %>
                <td></td>
                <%
                    }
                    for (int day = 1; day <= daysInMonth; day++) {
                        String dayClass = (day == currentDay) ? "today" : "";
                %>
                <td class="<%= dayClass %>"><%= day %></td>
                <%
                    if ((day + firstDayOfWeek - 1) % 7 == 0 && day != daysInMonth) {
                %>
            </tr><tr>
                <%
                        }
                    }
                %>
            </tr>
            </tbody>
        </table>
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