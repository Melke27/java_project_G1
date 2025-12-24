<%@ page import="com.equbidir.model.Member" %>
<%@ page import="com.equbidir.model.IdirMembership" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Idir Groups - Equb & Idir</title>
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
    .welcome-header { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; margin-top: 30px; }
    .welcome-header h1 { color: #1e4d2b; margin: 0; font-size: 28px; }
    .placeholder { text-align: center; color: #888; padding: 80px 20px; font-size: 18px; }
    .placeholder i { font-size: 80px; color: #c9a227; margin-bottom: 20px; }
    .idir-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 25px; margin-top: 20px; }
    .idir-card { background: #f8fafc; border-radius: 16px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-left: 5px solid #27ae60; position: relative; }
    .idir-card h3 { color: #1e4d2b; margin: 0 0 20px 0; font-size: 22px; }
    .idir-info { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px; }
    .idir-info div strong { color: #1e4d2b; font-size: 15px; display: block; margin-bottom: 5px; }
    .idir-info div span { font-size: 18px; font-weight: 600; color: #2d3436; }
    .status-paid { color: #27ae60; font-weight: bold; }
    .status-unpaid { color: #e74c3c; font-weight: bold; }
    .fund-balance { text-align: center; padding: 20px; background: white; border-radius: 12px; margin-top: 20px; }
    .fund-amount { font-size: 32px; color: #27ae60; font-weight: bold; margin: 10px 0; }
    .back-btn { display: inline-block; padding: 12px 24px; background: #1e4d2b; color: white; text-decoration: none; border-radius: 12px; font-weight: 600; }
    .back-btn:hover { background: #c9a227; color: #1e4d2b; }

    .view-members-btn {
      margin-top: 20px;
      padding: 14px;
      background: #1e4d2b;
      color: white;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      font-weight: 600;
      width: 100%;
      font-size: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: 0.3s;
      position: relative;
      z-index: 20;
    }
    .view-members-btn:hover {
      background: #27ae60;
    }

    .members-panel-wrapper {
      position: relative;
    }
    .members-panel {
      position: absolute;
      left: 0;
      right: 0;
      bottom: 70px;
      background: white;
      border-radius: 12px;
      box-shadow: 0 -4px 15px rgba(0,0,0,0.1);
      max-height: 0;
      overflow: hidden;
      transition: max-height 0.5s ease;
      z-index: 10;
      padding: 0 20px;
    }
    .members-panel.open {
      max-height: 400px;
      padding: 20px;
    }
    .members-panel ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .members-panel li {
      padding: 12px 0;
      border-bottom: 1px solid #eee;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .members-panel li:last-child {
      border-bottom: none;
    }
    .members-panel .name {
      font-weight: 600;
      color: #1e4d2b;
    }
    .members-panel .phone {
      color: #666;
      font-size: 14px;
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

  @SuppressWarnings("unchecked")
  List<IdirMembership> idirMemberships = (List<IdirMembership>) request.getAttribute("idirMemberships");
  if (idirMemberships == null) idirMemberships = java.util.Collections.emptyList();

  String labelDashboard = isAm ? "ዳሽቦርድ" : "Dashboard";
  String labelMyEqub = isAm ? "የእቁብ ቡድኖቼ" : "My Equb Groups";
  String labelMyIdir = isAm ? "የእድር ቡድኖቼ" : "My Idir Groups";
  String labelProfile = isAm ? "የግል መረጃዬ" : "My Profile";
  String labelHistoryTitle = isAm ? "የመዋጮ ታሪክ" : "Contribution History";
  String labelLogout = isAm ? "ውጣ" : "Logout";
  String labelNotAssigned = isAm ? "እስካሁን ወደ ምንም የእድር ቡድን አልተመደቡም።" : "You are not assigned to any Idir group yet.";
  String labelContactAdmin = isAm ? "ለመቀላቀል አስተዳዳሪዎን ያነጋግሩ።" : "Contact your administrator to join one.";
  String labelMonthlyPayment = isAm ? "ወርሃዊ ክፍያ" : "Monthly Payment";
  String labelPaymentStatus = isAm ? "የክፍያ ሁኔታ" : "Payment Status";
  String labelFundBalance = isAm ? "የፈንድ ቀሪ መጠን" : "Fund Balance";
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
    <li><a href="<%= request.getContextPath() %>/member/dashboard"><i class="fas fa-tachometer-alt"></i> <%= labelDashboard %></a></li>
    <li><a href="<%= request.getContextPath() %>/member/equb-details"><i class="fas fa-handshake"></i> <%= labelMyEqub %></a></li>
    <li><a href="<%= request.getContextPath() %>/member/idir-details" class="active"><i class="fas fa-heart"></i> <%= labelMyIdir %></a></li>
    <li><a href="<%= request.getContextPath() %>/member/contribution-history"><i class="fas fa-history"></i> <%= labelHistoryTitle %></a></li>
    <li><a href="<%= request.getContextPath() %>/views/member/profile.jsp"><i class="fas fa-user"></i> <%= labelProfile %></a></li>
    <li><a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> <%= labelLogout %></a></li>
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
    <h1><%= labelMyIdir %></h1>
    <a href="<%= request.getContextPath() %>/member/dashboard" class="back-btn">
      <i class="fas fa-arrow-left"></i> <%= labelBack %>
    </a>
  </div>

  <% if (idirMemberships.isEmpty()) { %>
  <div class="card placeholder">
    <i class="fas fa-hands-helping"></i>
    <p><strong><%= labelNotAssigned %></strong><br><%= labelContactAdmin %></p>
  </div>
  <% } else { %>
  <div class="idir-grid">
    <% for (IdirMembership idir : idirMemberships) { %>
    <div class="idir-card">
      <h3><i class="fas fa-heart"></i> <%= idir.getIdirName() %></h3>

      <div class="idir-info">
        <div>
          <strong><%= labelMonthlyPayment %></strong>
          <span><%= String.format("%,.2f", idir.getMonthlyPayment()) %> ETB</span>
        </div>
        <div>
          <strong><%= labelPaymentStatus %></strong>
          <span class="<%= "paid".equals(idir.getPaymentStatus()) ? "status-paid" : "status-unpaid" %>">
                            <%= "paid".equals(idir.getPaymentStatus())
                                    ? (isAm ? "ተከፍሏል" : "Paid")
                                    : (isAm ? "አልተከፈለም" : "Unpaid") %>
                        </span>
        </div>
      </div>

      <div class="fund-balance">
        <strong><%= labelFundBalance %></strong>
        <div class="fund-amount">
          <%= String.format("%,.2f", idir.getFundBalance()) %> ETB
        </div>
        <p style="margin:10px 0 0; color:#666;">
          <%= isAm ? "ጠቅላላ አባላት: " : "Total Members: " %><%= idir.getTotalMembers() %>
        </p>
      </div>

      <!-- View Members Button -->
      <div class="members-panel-wrapper">
        <button class="view-members-btn" type="button" id="toggle-btn-<%= idir.getIdirId() %>">
          <i class="fas fa-users"></i> View Members
        </button>

        <div class="members-panel" id="panel-<%= idir.getIdirId() %>">
          <% if (idir.getGroupMembers().isEmpty()) { %>
          <p style="text-align:center; color:#888; padding:40px 20px;">
            <%= isAm ? "ቡድኑ ባዶ ነው።" : "No members in this group yet." %>
          </p>
          <% } else { %>
          <ul>
            <% for (Member member : idir.getGroupMembers()) { %>
            <li>
              <div>
                <span class="name"><%= member.getFullName() %></span>
                <span class="phone"><%= member.getPhone() %></span>
              </div>
            </li>
            <% } %>
          </ul>
          <% } %>
        </div>
      </div>

      <script>
        document.getElementById("toggle-btn-<%= idir.getIdirId() %>").addEventListener("click", function() {
          const panel = document.getElementById("panel-<%= idir.getIdirId() %>");
          panel.classList.toggle("open");
          if (panel.classList.contains("open")) {
            this.innerHTML = '<i class="fas fa-chevron-up"></i> Hide Members';
          } else {
            this.innerHTML = '<i class="fas fa-users"></i> View Members';
          }
        });
      </script>
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