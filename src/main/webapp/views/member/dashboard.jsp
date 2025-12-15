<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>

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
        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%);
            min-height: 100vh;
            display: flex;
        }
        .sidebar {
            width: 260px;
            background: #1e4d2b;
            color: white;
            padding: 30px 20px;
            position: fixed;
            height: 100%;
            left: 0;
            top: 0;
            box-shadow: 5px 0 15px rgba(0,0,0,0.1);
            z-index: 100;
        }
        .sidebar-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .sidebar-header h2 {
            margin: 0;
            font-size: 24px;
            color: #c9a227;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
        }
        .sidebar-menu li {
            margin: 15px 0;
        }
        .sidebar-menu a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border-radius: 10px;
            transition: 0.3s;
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: #c9a227;
            color: #1e4d2b;
        }
        .sidebar-menu i {
            margin-right: 12px;
            font-size: 18px;
        }
        .main-content {
            margin-left: 260px;
            padding: 40px;
            width: calc(100% - 260px);
        }
        .lang-switch {
            margin-top: 30px;
            text-align: center;
            font-size: 14px;
        }
        .lang-switch a {
            color: #c9a227;
            text-decoration: none;
            margin: 0 8px;
            font-weight: 600;
        }
        .lang-switch a.active {
            text-decoration: underline;
        }
        .welcome-header {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .welcome-header h1 {
            color: #1e4d2b;
            margin: 0;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 25px;
        }
        .card {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        .card h2 {
            color: #1e4d2b;
            border-bottom: 2px solid #c9a227;
            padding-bottom: 10px;
            margin-top: 0;
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
        .calendar {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .calendar th {
            background: #1e4d2b;
            color: white;
            padding: 10px;
        }
        .calendar td {
            text-align: center;
            padding: 15px;
            border: 1px solid #eee;
        }
        .calendar td.today {
            background: #c9a227;
            color: white;
            font-weight: bold;
            border-radius: 8px;
        }
        .calendar td.other-month {
            color: #ccc;
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
    String enClass = isAm ? "" : "active";
    String amClass = isAm ? "active" : "";

    // Labels
    String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
    String labelProfile = isAm ? "የግል መረጃዬ" : "My Profile";
    String labelLogout = isAm ? "ውጣ" : "Logout";
    String labelWelcome = isAm ? "እንኳን በደህና መጡ፣ " : "Welcome back, ";
    String labelPersonalInfo = isAm ? "የግል መረጃ" : "Personal Information";
    String labelEqubTitle = isAm ? "የእቁብ ቡድኖቼ" : "My Equb Groups";
    String labelIdirTitle = isAm ? "የእድር ቡድኔ" : "My Idir Group";
    String labelHistoryTitle = isAm ? "የመዋጮ ታሪክ" : "Contribution History";
    String labelCalendar = isAm ? "የወሩ ቀን መቁጠሪያ" : "Monthly Calendar";

    // Calendar logic
    Calendar cal = Calendar.getInstance();
    int currentYear = cal.get(Calendar.YEAR);
    int currentMonth = cal.get(Calendar.MONTH);
    int currentDay = cal.get(Calendar.DAY_OF_MONTH);

    cal.set(Calendar.DAY_OF_MONTH, 1);
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    String[] daysAm = {"እሑድ", "ሰኞ", "ማክሰኞ", "ረቡዕ", "ሐሙስ", "ዓርብ", "ቅዳሜ"};
    String[] daysEn = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
    String[] days = isAm ? daysAm : daysEn;
%>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <h2>Equb & Idir</h2>
    </div>
    <ul class="sidebar-menu">
        <li><a href="<%= ctx %>/views/member/dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> <%= labelDashboard %></a></li>
        <li><a href="<%= ctx %>/views/member/profile.jsp"><i class="fas fa-user"></i> <%= labelProfile %></a></li>
        <li><a href="<%= ctx %>/logout"><i class="fas fa-sign-out-alt"></i> <%= labelLogout %></a></li>
    </ul>
    <div class="lang-switch">
        <span><%= isAm ? "ቋንቋ" : "Language" %>:</span><br>
        <a href="<%= ctx %>/lang?lang=en" class="<%= enClass %>">English</a> |
        <a href="<%= ctx %>/lang?lang=am" class="<%= amClass %>">አማርኛ</a>
    </div>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="welcome-header">
        <h1><%= labelWelcome %><%= user.getFullName() %>!</h1>
        <div style="color: #666;">
            <i class="fas fa-calendar-day"></i>
            <%= new SimpleDateFormat(isAm ? "dd MMMM yyyy" : "MMMM dd, yyyy", isAm ? new Locale("am", "ET") : Locale.ENGLISH)
                    .format(cal.getTime()) %>
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

        <!-- Calendar -->
        <div class="card">
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
                        // Print empty cells for days before month starts
                        for (int i = 1; i < firstDayOfWeek; i++) {
                            out.print("<td class='other-month'></td>");
                        }
                        // Print days of month
                        for (int day = 1; day <= daysInMonth; day++) {
                            String dayClass = (day == currentDay) ? "today" : "";
                    %>
                    <td class="<%= dayClass %>"><%= day %></td>
                    <%
                            if ((day + firstDayOfWeek - 1) % 7 == 0) {
                                out.print("</tr><tr>");
                            }
                        }
                        // Fill remaining cells
                        int remaining = (daysInMonth + firstDayOfWeek - 1) % 7;
                        if (remaining != 0) {
                            for (int i = remaining; i < 7; i++) {
                                out.print("<td class='other-month'></td>");
                            }
                        }
                    %>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- My Equb Groups -->
        <div class="card">
            <h2><i class="fas fa-handshake"></i> <%= labelEqubTitle %></h2>
            <div class="placeholder">
                <i class="fas fa-users"></i>
                <p><%= isAm
                        ? "እስካሁን ምንም የእቁብ ቡድን አልተመደበልህም።<br>ለመቀላቀል ከአስተዳዳሪዎ ጋር ያነጋግሩ።"
                        : "No Equb groups assigned yet.<br>Contact your admin to join one." %>
                </p>
            </div>
        </div>

        <!-- My Idir Group -->
        <div class="card">
            <h2><i class="fas fa-heart"></i> <%= labelIdirTitle %></h2>
            <div class="placeholder">
                <i class="fas fa-hands-helping"></i>
                <p><%= isAm
                        ? "እስካሁን ምንም የእድር ቡድን አልተመደበልህም።<br>የማህበረሰብ ድጋፍህ እዚህ ይታያል።"
                        : "No Idir group assigned yet.<br>Your community support will appear here." %>
                </p>
            </div>
        </div>

        <!-- Contribution History -->
        <div class="card">
            <h2><i class="fas fa-history"></i> <%= labelHistoryTitle %></h2>
            <div class="placeholder">
                <i class="fas fa-clock"></i>
                <p><%= isAm
                        ? "መዋጮ መጀመሪያ ከተፈጠረ በኋላ የክፍያ ታሪክህ እዚህ ይታያል።"
                        : "Your payment history will be displayed here once contributions begin." %>
                </p>
            </div>
        </div>
    </div>
</div>

</body>
</html>