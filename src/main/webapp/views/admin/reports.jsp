<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
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
%>

<div class="admin-nav">
    <div class="lang-switch">
        <span><%= labelLanguage %>:</span>
        <a href="<%= ctx %>/lang?lang=en" class="<%= enClass %>">English</a>|
        <a href="<%= ctx %>/lang?lang=am" class="<%= amClass %>">አማርኛ</a>
    </div>
    <a href="<%= ctx %>/admin/dashboard"><%= labelDashboard %></a>
    <a href="<%= ctx %>/admin/members"><%= labelMembers %></a>
    <a href="<%= ctx %>/admin/equb"><%= labelEqub %></a>
    <a href="<%= ctx %>/admin/idir"><%= labelIdir %></a>
    <a href="<%= ctx %>/admin/expenses"><%= labelExpenses %></a>
    <a href="<%= ctx %>/views/admin/reports.jsp" class="active"><%= labelReports %></a>
</div>

<h2>Reports</h2>

<section>
    <h3>Expense Summary</h3>
    <p>Total expenses: <strong><c:out value="${totalExpenses}" /></strong></p>
    <p>Current Idir fund balance: <strong><c:out value="${fundBalance}" /></strong></p>
</section>

<section>
    <h3>Expenses by Category</h3>
    <table border="1" cellpadding="6" cellspacing="0">
        <thead>
        <tr>
            <th>Category</th>
            <th>Total Spent</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="entry" items="${categoryTotals}">
            <tr>
                <td><c:out value="${entry.key}" /></td>
                <td><c:out value="${entry.value}" /></td>
            </tr>
        </c:forEach>
        <c:if test="${empty categoryTotals}">
            <tr><td colspan="2">No data</td></tr>
        </c:if>
        </tbody>
    </table>
</section>

<section>
    <h3>Monthly Rotation Summary</h3>
    <table border="1" cellpadding="6" cellspacing="0">
        <thead>
        <tr>
            <th>Month</th>
            <th>Total Spent</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="entry" items="${monthlyTotals}">
            <tr>
                <td><c:out value="${entry.key}" /></td>
                <td><c:out value="${entry.value}" /></td>
            </tr>
        </c:forEach>
        <c:if test="${empty monthlyTotals}">
            <tr><td colspan="2">No monthly data</td></tr>
        </c:if>
        </tbody>
    </table>
</section>

<section>
    <h3>All Expenses</h3>
    <table border="1" cellpadding="6" cellspacing="0">
        <thead>
        <tr>
            <th>Date</th>
            <th>Category</th>
            <th>Description</th>
            <th>Amount</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="expense" items="${expenses}">
            <tr>
                <td><c:out value="${expense.date}" /></td>
                <td><c:out value="${expense.category}" /></td>
                <td><c:out value="${expense.description}" /></td>
                <td><c:out value="${expense.amount}" /></td>
            </tr>
        </c:forEach>
        <c:if test="${empty expenses}">
            <tr><td colspan="4">No expenses recorded.</td></tr>
        </c:if>
        </tbody>
    </table>
</section>
</body>
</html>

