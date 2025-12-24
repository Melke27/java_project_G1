<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Equb & Idir</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; padding: 0; font-family: 'Poppins', sans-serif; background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%); min-height: 100vh; overflow-x: hidden; }
        .hamburger { position: fixed; top: 20px; left: 20px; font-size: 28px; color: #1e4d2b; background: white; width: 50px; height: 50px; border-radius: 50%; box-shadow: 0 4px 15px rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: center; cursor: pointer; z-index: 1002; }
        .overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 999; }
        .overlay.active { display: block; }
        .sidebar { width: 280px; background: #1e4d2b; color: white; padding: 30px 20px; position: fixed; height: 100%; left: -300px; top: 0; box-shadow: 5px 0 15px rgba(0,0,0,0.1); transition: left 0.4s ease; z-index: 1000; }
        .sidebar.active { left: 0; }
        .main-content { padding: 20px; margin-left: 0; transition: margin-left 0.4s ease; width: 100%; }
        .welcome-header { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); margin: 30px 0; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .welcome-header h1 { color: #1e4d2b; margin: 0; font-size: 28px; display: flex; align-items: center; gap: 12px; }
        .back-btn { display: inline-block; padding: 12px 24px; background: #1e4d2b; color: white; text-decoration: none; border-radius: 12px; font-weight: 600; }
        .back-btn:hover { background: #c9a227; color: #1e4d2b; }
        .card { background: white; padding: 30px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); margin-bottom: 30px; }
        .card h2 { color: #1e4d2b; border-bottom: 2px solid #c9a227; padding-bottom: 12px; margin-top: 0; font-size: 22px; display: flex; align-items: center; gap: 10px; }
        .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin: 30px 0; }
        .summary-card { background: #f8fafc; padding: 25px; border-radius: 16px; text-align: center; border-left: 5px solid #c9a227; }
        .summary-card h3 { color: #1e4d2b; margin: 0 0 10px 0; font-size: 18px; }
        .summary-card .amount { font-size: 32px; font-weight: bold; color: #c9a227; }
        .table-container { overflow-x: auto; margin-top: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; background: white; }
        th { background: #1e4d2b; color: white; padding: 16px; text-align: left; font-weight: 600; }
        td { padding: 16px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f8fafc; }
        .no-data { text-align: center; padding: 60px 20px; color: #888; }
        .no-data i { font-size: 60px; color: #c9a227; margin-bottom: 20px; }
    </style>
</head>
<body>

<%
    com.equbidir.model.Member currentUser = (com.equbidir.model.Member) session.getAttribute("user");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "en";
    boolean isAm = "am".equals(lang);

    String ctx = request.getContextPath();
%>

<%@ include file="_sidebar.jspf" %>

<div class="main-content" id="mainContent">
    <div class="welcome-header">
        <h1><i class="fas fa-chart-bar"></i> <%= isAm ? "ሪፖርቶች" : "Reports" %></h1>
        <a href="<%= ctx %>/admin/dashboard" class="back-btn">
            <i class="fas fa-arrow-left"></i> <%= isAm ? "ወደ ዳሽቦርድ" : "Back to Dashboard" %>
        </a>
    </div>

    <!-- Summary Cards -->
    <div class="summary-grid">
        <div class="summary-card">
            <h3><%= isAm ? "ጠቅላላ ወጪዎች" : "Total Expenses" %></h3>
            <div class="amount">
                <fmt:formatNumber value="${totalExpenses}" type="currency" currencySymbol="ETB " />
            </div>
        </div>
        <div class="summary-card">
            <h3><%= isAm ? "የእድር ፈንድ ቀሪ መጠን" : "Current Idir Fund Balance" %></h3>
            <div class="amount">
                <fmt:formatNumber value="${fundBalance}" type="currency" currencySymbol="ETB " />
            </div>
        </div>
        <div class="summary-card">
            <h3><%= isAm ? "ጠቅላላ አባላት" : "Total Members" %></h3>
            <div class="amount"><c:out value="${totalMembers}" /></div>
        </div>
        <div class="summary-card">
            <h3><%= isAm ? "ንቁ የእቁብ ቡድኖች" : "Active Equb Groups" %></h3>
            <div class="amount"><c:out value="${activeEqubGroups}" /></div>
        </div>
    </div>

    <!-- Expenses by Category -->
    <div class="card">
        <h2><i class="fas fa-pie-chart"></i> <%= isAm ? "ወጪዎች በካቴጎሪ" : "Expenses by Category" %></h2>
        <c:choose>
            <c:when test="${empty categoryTotals}">
                <div class="no-data">
                    <i class="fas fa-chart-pie"></i>
                    <p><%= isAm ? "ምንም ወጪ ካቴጎሪ የለም።" : "No expense categories recorded yet." %></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th><%= isAm ? "ካቴጎሪ" : "Category" %></th>
                            <th><%= isAm ? "ጠቅላላ ወጪ" : "Total Spent" %></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="entry" items="${categoryTotals}">
                            <tr>
                                <td><strong><c:out value="${entry.key}" /></strong></td>
                                <td><fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="ETB " /></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Monthly Expense Summary -->
    <div class="card">
        <h2><i class="fas fa-calendar-alt"></i> <%= isAm ? "ወርሃዊ ወጪ ማጠቃለያ" : "Monthly Expense Summary" %></h2>
        <c:choose>
            <c:when test="${empty monthlyTotals}">
                <div class="no-data">
                    <i class="fas fa-calendar-times"></i>
                    <p><%= isAm ? "ምንም ወርሃዊ ወጪ የለም።" : "No monthly expense data available." %></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th><%= isAm ? "ወር" : "Month" %></th>
                            <th><%= isAm ? "ጠቅላላ ወጪ" : "Total Spent" %></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="entry" items="${monthlyTotals}">
                            <tr>
                                <td><strong><c:out value="${entry.key}" /></strong></td>
                                <td><fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="ETB " /></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- All Expenses List -->
    <div class="card">
        <h2><i class="fas fa-receipt"></i> <%= isAm ? "ሁሉም ወጪዎች" : "All Expenses" %></h2>
        <c:choose>
            <c:when test="${empty expenses}">
                <div class="no-data">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <p><%= isAm ? "ምንም ወጪ የለም።" : "No expenses recorded." %></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th><%= isAm ? "ቀን" : "Date" %></th>
                            <th><%= isAm ? "ካቴጎሪ" : "Category" %></th>
                            <th><%= isAm ? "መግለጫ" : "Description" %></th>
                            <th><%= isAm ? "መጠን" : "Amount" %></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="expense" items="${expenses}">
                            <tr>
                                <td><fmt:formatDate value="${expense.date}" pattern="MMM dd, yyyy" /></td>
                                <td><strong><c:out value="${expense.category}" /></strong></td>
                                <td><c:out value="${expense.description}" /></td>
                                <td><fmt:formatNumber value="${expense.amount}" type="currency" currencySymbol="ETB " /></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('overlay');
        const mainContent = document.getElementById('mainContent');

        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
    }
</script>

</body>
</html>