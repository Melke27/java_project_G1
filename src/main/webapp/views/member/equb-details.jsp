<%@ page import="com.equbidir.model.Member" %>
<%@ page import="com.equbidir.model.EqubMemberInfo" %>
<%@ page import="com.equbidir.dao.MemberDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Equb Group - Equb & Idir</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dashboard.css">
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
        .card h2 { color: #1e4d2b; border-bottom: 2px solid #c9a227; padding-bottom: 12px; }
        .placeholder { text-align: center; color: #888; padding: 60px 20px; font-size: 18px; }
        .placeholder i { font-size: 64px; color: #c9a227; margin-bottom: 20px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0; }
        .info-item { background: #f8fafc; padding: 20px; border-radius: 12px; text-align: center; }
        .info-item strong { color: #1e4d2b; display: block; margin-bottom: 8px; font-size: 16px; }
        .info-item span { font-size: 20px; font-weight: 600; color: #2d3436; }
        .highlight { color: #c9a227; font-size: 28px; font-weight: bold; }
        .back-btn { display: inline-block; margin: 20px 0; padding: 12px 24px; background: #1e4d2b; color: white; text-decoration: none; border-radius: 12px; font-weight: 600; }
        .back-btn:hover { background: #c9a227; color: #1e4d2b; }
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

    MemberDAO memberDAO = new MemberDAO();
    EqubMemberInfo equbInfo = memberDAO.getMemberEqubInfo(user.getMemberId());

    String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
    String labelMyEqub = isAm ? "የእቁብ ቡድኔ" : "My Equb Group";
    String labelMyIdir = isAm ? "የእድር ቡድኔ" : "My Idir Group";
    String labelProfile = isAm ? "የግል መረጃዬ" : "My Profile";
    String labelHistoryTitle = isAm ? "የመዋጮ ታሪክ" : "Contribution History";
    String labelLogout = isAm ? "ውጣ" : "Logout";
    String labelNotAssigned = isAm ? "እስካሁን ወደ ምንም የእቁብ ቡድን አልተመደቡም።" : "You are not assigned to any Equb group yet.";
    String labelContactAdmin = isAm ? "ለመቀላቀል አስተዳዳሪዎን ያነጋግሩ።" : "Contact your administrator to join one.";
    String labelGroupName = isAm ? "የቡድን ስም" : "Group Name";
    String labelContribution = isAm ? "የመዋጮ መጠን" : "Contribution Amount";
    String labelFrequency = isAm ? "ድግግሞሽ" : "Frequency";
    String labelTotalMembers = isAm ? "ጠቅላላ አባላት" : "Total Members";
    String labelYourPosition = isAm ? "የእርስዎ ቦታ" : "Your Position";
    String labelPaymentStatus = isAm ? "የክፍያ ሁኔታ" : "Payment Status";
    String labelBack = isAm ? "ወደ ዳሽቦርድ" : "Back to Dashboard";
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
        <li><a href="<%= request.getContextPath() %>/views/member/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> <%= labelDashboard %></a></li>
        <li><a href="<%= request.getContextPath() %>/member/equb-details" class="active"><i class="fas fa-handshake"></i> <%= labelMyEqub %></a></li>
        <li><a href="<%= request.getContextPath() %>/member/idir-details"><i class="fas fa-heart"></i> <%= labelMyIdir %></a></li>
        <li><a href="<%= request.getContextPath() %>/views/member/profile.jsp"><i class="fas fa-user"></i> <%= labelProfile %></a></li>
        <li><a href="<%= request.getContextPath() %>/member/contribution-history"><i class="fas fa-history"></i> <%= labelHistoryTitle %></a></li>
        <li><a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> <%= labelLogout %></a></li>
    </ul>

    <div class="lang-selector">
        <label><%= isAm ? "ቋንቋ ይምረጡ" : "Select Language" %></label>
        <div class="lang-options">
            <div class="lang-option <%= !isAm ? "active" : "" %>" onclick="window.location='<%= request.getContextPath() %>/lang?lang=en'">
                <img src="https://flagcdn.com/w80/gb.png" alt="English">
                <span>English</span>
            </div>
            <div class="lang-option <%= isAm ? "active" : "" %>" onclick="window.location='<%= request.getContextPath() %>/lang?lang=am'">
                <img src="https://flagcdn.com/w80/et.png" alt="አማርኛ">
                <span>አማርኛ</span>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="main-content" id="mainContent">
    <div class="welcome-header">
        <h1><%= labelMyEqub %></h1>
        <a href="<%= request.getContextPath() %>/views/member/dashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> <%= labelBack %>
        </a>
    </div>

    <% if (equbInfo == null) { %>
    <div class="card placeholder">
        <i class="fas fa-users"></i>
        <p><strong><%= labelNotAssigned %></strong><br><%= labelContactAdmin %></p>
    </div>
    <% } else { %>
    <div class="card">
        <h2><i class="fas fa-handshake"></i> <%= equbInfo.getEqubName() %></h2>

        <div class="info-grid">
            <div class="info-item">
                <strong><%= labelGroupName %></strong>
                <span><%= equbInfo.getEqubName() %></span>
            </div>
            <div class="info-item">
                <strong><%= labelContribution %></strong>
                <span><%= String.format("%,.2f", equbInfo.getAmount()) %> ETB</span>
            </div>
            <div class="info-item">
                <strong><%= labelFrequency %></strong>
                <span><%= equbInfo.getFrequency() %></span>
            </div>
            <div class="info-item">
                <strong><%= labelTotalMembers %></strong>
                <span><%= equbInfo.getTotalMembers() %></span>
            </div>
            <div class="info-item">
                <strong><%= labelPaymentStatus %></strong>
                <span class="<%= "paid".equals(equbInfo.getPaymentStatus()) ? "highlight" : "" %>">
                        <%= "paid".equals(equbInfo.getPaymentStatus())
                                ? (isAm ? "ተከፍሏል" : "Paid")
                                : (isAm ? "አልተከፈለም" : "Unpaid") %>
                    </span>
            </div>
        </div>

        <% if (equbInfo.getRotationPosition() != null) { %>
        <div style="text-align: center; margin: 40px 0; padding: 30px; background: #f8fafc; border-radius: 16px;">
            <strong style="font-size: 20px; color: #1e4d2b;"><%= labelYourPosition %>:</strong><br>
            <span class="highlight">
                        <%= equbInfo.getRotationPosition() %>
                        <%= isAm ? "ኛ" :
                                (equbInfo.getRotationPosition() == 1 ? "st" :
                                        equbInfo.getRotationPosition() == 2 ? "nd" :
                                                equbInfo.getRotationPosition() == 3 ? "rd" : "th") %>
                    </span>
            <p style="margin: 20px 0 0; font-size: 17px; color: #636e72;">
                <%= isAm
                        ? "ገንዘቡን በ " + equbInfo.getRotationPosition() + " ወር ውስጥ ትቀበላለህ።"
                        : "You will receive the pot in " + equbInfo.getRotationPosition() + " month(s)." %>
            </p>
        </div>
        <% } else { %>
        <div style="text-align: center; padding: 30px; color: #e67e22; background: #fef9e7; border-radius: 16px;">
            <i class="fas fa-clock" style="font-size: 40px; margin-bottom: 15px;"></i>
            <p style="font-size: 17px;"><%= isAm ? "የማዞሪያ ቦታዎ ገና አልተወሰነም።" : "Your rotation position has not been set yet." %></p>
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