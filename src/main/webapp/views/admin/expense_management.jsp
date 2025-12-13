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
<div class="container">
    <h1>Idir Expense Management</h1>
    <a class="link" href="<%=request.getContextPath()%>/admin/dashboard">← Back to Dashboard</a>

    <div class="card">
        <h2>Select Idir Group</h2>
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
            <button class="btn" type="submit">Open</button>
        </form>
    </div>

    <% Integer idirId = (Integer) request.getAttribute("selectedIdirId"); %>
    <% if (idirId != null) { %>
        <div class="card">
            <h2>Add Expense (Idir ID: <%=idirId%>)</h2>
            <form method="post" action="<%=request.getContextPath()%>/admin/expenses">
                <input type="hidden" name="idir_id" value="<%=idirId%>" />
                <label>Amount</label>
                <input type="number" step="0.01" name="amount" required />
                <label>Description</label>
                <input type="text" name="description" />
                <label>Date</label>
                <input type="date" name="expense_date" required />
                <button class="btn btn-primary" type="submit">Save Expense</button>
            </form>
        </div>

        <div class="card">
            <h2>Expenses</h2>
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
