<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.IdirGroup" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Idir Expenses</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css" />
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
    <a href="<%= ctx %>/admin/expenses" class="active"><%= labelExpenses %></a>
    <a href="<%= ctx %>/views/admin/reports.jsp"><%= labelReports %></a>
</div>

<div class="container">
    <h1><%= isAm ? "የእድር ወጪ አስተዳደር" : "Idir Expense Management" %></h1>
    <a class="link" href="<%=request.getContextPath()%>/admin/dashboard">← Back to Dashboard</a>

    <div class="card">
        <h2><%= isAm ? "የእድር ቡድን ይምረጡ" : "Select Idir Group" %></h2>
        <form method="get" action="<%=request.getContextPath()%>/admin/expenses">
            <select name="idir_id" required>
                <option value="">-- Select --</option>
                <%
                    List<IdirGroup> groups = (List<IdirGroup>) request.getAttribute("groups");
                    Integer selectedIdirId = (Integer) request.getAttribute("selectedIdirId");
                    if (groups != null) {
                        for (IdirGroup g : groups) {
                %>
                    <option value="<%=g.getIdirId()%>" <%= (selectedIdirId != null && selectedIdirId == g.getIdirId()) ? "selected" : "" %>><%=g.getIdirName()%></option>
                <%
                        }
                    }
                %>
            </select>
            <button class="btn" type="submit"><%= isAm ? "ክፈት" : "Open" %></button>
        </form>
    </div>

    <% Integer idirId = (Integer) request.getAttribute("selectedIdirId"); %>
    <% if (idirId != null) { %>
        <div class="card">
            <h2>
                <%= isAm ? "ወጪ አክል (የእድር መለያ፡ " : "Add Expense (Idir ID: " %>
                <%= idirId %>)
            </h2>
            <form method="post" action="<%=request.getContextPath()%>/admin/expenses">
                <input type="hidden" name="idir_id" value="<%=idirId%>" />
                <label><%= isAm ? "መጠን" : "Amount" %></label>
                <input type="number" step="0.01" name="amount" required />
                <label><%= isAm ? "መግለጫ" : "Description" %></label>
                <input type="text" name="description" />
                <label><%= isAm ? "ቀን (Calendar)" : "Date (Calendar)" %></label>
                <input type="date" name="expense_date" required />
                <small class="muted">
                    <%= isAm ? "ቀኑን ከካሌንደሩ ይምረጡ።" : "Select the date from the calendar." %>
                </small>
                <button class="btn btn-primary" type="submit">
                    <%= isAm ? "ወጪውን አስቀምጥ" : "Save Expense" %>
                </button>
            </form>
        </div>

        <div class="card">
            <h2><%= isAm ? "ወጪዎች" : "Expenses" %></h2>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Amount</th>
                    <th>Description</th>
                    <th>Date</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<String[]> expenses = (List<String[]>) request.getAttribute("expenses");
                    if (expenses != null) {
                        for (String[] r : expenses) {
                %>
                    <tr>
                        <td><%=r[0]%></td>
                        <td><%=r[1]%></td>
                        <td><%=r[2] == null ? "" : r[2] %></td>
                        <td><%=r[3]%></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>
</body>
</html>
