<<<<<<< HEAD
<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.IdirGroup" %>
<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
=======
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.IdirGroup" %>
<%
    List<IdirGroup> groups = (List<IdirGroup>) request.getAttribute("groups");
    IdirGroup selectedGroup = (IdirGroup) request.getAttribute("selectedGroup");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
>>>>>>> 02b51aac394f9d81545be5c42cde5eaebbec63e2
<!DOCTYPE html>
<html>
<head>
    <title>Idir Management</title>
<<<<<<< HEAD
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css" />
</head>
<body>
<div class="container">
    <h1>Idir Management</h1>
    <a class="link" href="<%=request.getContextPath()%>/admin/dashboard">← Back to Dashboard</a>

    <div class="grid">
        <div class="card">
            <h2>Create Idir Group</h2>
            <form method="post" action="<%=request.getContextPath()%>/admin/idir">
                <input type="hidden" name="action" value="create_group" />
                <label>Idir Name</label>
                <input type="text" name="idir_name" required />
                <label>Monthly Payment</label>
                <input type="number" step="0.01" name="monthly_payment" required />
                <button class="btn btn-primary" type="submit">Create</button>
            </form>
        </div>

        <div class="card">
            <h2>Groups</h2>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Monthly</th>
                    <th>Open</th>
                    <th>Delete</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<IdirGroup> groups = (List<IdirGroup>) request.getAttribute("groups");
                    if (groups != null) {
                        for (IdirGroup g : groups) {
                %>
                    <tr>
                        <td><%=g.getIdirId()%></td>
                        <td><%=g.getIdirName()%></td>
                        <td><%=g.getMonthlyPayment()%></td>
                        <td><a class="link" href="<%=request.getContextPath()%>/admin/idir?idir_id=<%=g.getIdirId()%>">Open</a></td>
                        <td>
                            <form class="inline" method="post" action="<%=request.getContextPath()%>/admin/idir">
                                <input type="hidden" name="action" value="delete_group" />
                                <input type="hidden" name="idir_id" value="<%=g.getIdirId()%>" />
                                <button class="btn btn-danger" type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <% Integer selectedIdirId = (Integer) request.getAttribute("selectedIdirId"); %>
    <% if (selectedIdirId != null) { %>
        <div class="card">
            <h2>Group Members (Idir ID: <%=selectedIdirId%>)</h2>

            <h3>Add Member to this Idir</h3>
            <form method="post" action="<%=request.getContextPath()%>/admin/idir">
                <input type="hidden" name="action" value="add_member" />
                <input type="hidden" name="idir_id" value="<%=selectedIdirId%>" />
                <label>Select Member</label>
                <select name="member_id">
                    <%
                        List<Member> allMembers = (List<Member>) request.getAttribute("allMembers");
                        if (allMembers != null) {
                            for (Member m : allMembers) {
                    %>
                        <option value="<%=m.getMemberId()%>"><%=m.getFullName()%> (<%=m.getPhone()%>)</option>
                    <%
                            }
                        }
                    %>
                </select>
                <button class="btn" type="submit">Add</button>
            </form>

            <h3>Approve Payments</h3>
            <table>
                <thead>
                <tr>
                    <th>Member ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th>Approve</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<String[]> idirMembers = (List<String[]>) request.getAttribute("idirMembers");
                    if (idirMembers != null) {
                        for (String[] r : idirMembers) {
                %>
                    <tr>
                        <td><%=r[0]%></td>
                        <td><%=r[1]%></td>
                        <td><%=r[2]%></td>
                        <td><%=r[3]%></td>
                        <td>
                            <form class="inline" method="post" action="<%=request.getContextPath()%>/admin/idir">
                                <input type="hidden" name="action" value="approve_payment" />
                                <input type="hidden" name="idir_id" value="<%=selectedIdirId%>" />
                                <input type="hidden" name="member_id" value="<%=r[0]%>" />
                                <button class="btn" type="submit">Approve</button>
                            </form>
                        </td>
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
=======
    <style>
        body { font-family: Arial, sans-serif; margin: 24px; }
        h2 { margin-top: 32px; }
        .flash { padding: 10px; margin-bottom: 12px; border-radius: 4px; }
        .flash.success { background: #e8f5e9; color: #2e7d32; border: 1px solid #2e7d32; }
        .flash.error { background: #ffebee; color: #c62828; border: 1px solid #c62828; }
        form { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: bold; }
        input, button, select { padding: 8px; margin-bottom: 10px; width: 100%; max-width: 360px; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f5f5f5; }
        .actions { display: flex; gap: 8px; }
        .card { border: 1px solid #ddd; padding: 16px; border-radius: 6px; margin-top: 12px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 12px; }
    </style>
</head>
<body>
<h1>Idir Management</h1>

<% if (message != null) { %>
    <div class="flash success"><%= message %></div>
<% } %>
<% if (error != null) { %>
    <div class="flash error"><%= error %></div>
<% } %>

<div class="grid">
    <div class="card">
        <h2>Create Idir Group</h2>
        <form method="post" action="<%= ctx %>/admin/idir">
            <input type="hidden" name="action" value="createGroup"/>
            <label for="name">Group Name</label>
            <input type="text" id="name" name="name" required placeholder="e.g., Neighborhood Idir"/>

            <label for="monthlyContribution">Monthly Contribution</label>
            <input type="number" step="0.01" id="monthlyContribution" name="monthlyContribution" required placeholder="1000.00"/>

            <button type="submit">Create Group</button>
        </form>
    </div>

    <div class="card">
        <h2>Groups</h2>
        <table>
            <thead>
            <tr>
                <th>Name</th>
                <th>Monthly Contribution</th>
                <th>Balance</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% if (groups == null || groups.isEmpty()) { %>
                <tr><td colspan="4">No groups created yet.</td></tr>
            <% } else {
                for (IdirGroup group : groups) { %>
                    <tr>
                        <td><%= group.getName() %></td>
                        <td><%= String.format("%.2f", group.getMonthlyContribution()) %></td>
                        <td><%= String.format("%.2f", group.getBalance()) %></td>
                        <td>
                            <div class="actions">
                                <a href="<%= ctx %>/admin/idir?groupId=<%= group.getId() %>">Open</a>
                                <form method="post" action="<%= ctx %>/admin/idir" onsubmit="return confirm('Delete this group?');">
                                    <input type="hidden" name="action" value="deleteGroup"/>
                                    <input type="hidden" name="id" value="<%= group.getId() %>"/>
                                    <button type="submit">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
            <%  }
            } %>
            </tbody>
        </table>
    </div>
</div>

<% if (selectedGroup != null) { %>
    <div class="card">
        <h2>Manage Group: <%= selectedGroup.getName() %></h2>
        <form method="post" action="<%= ctx %>/admin/idir">
            <input type="hidden" name="action" value="updateGroup"/>
            <input type="hidden" name="id" value="<%= selectedGroup.getId() %>"/>

            <label for="editName">Group Name</label>
            <input type="text" id="editName" name="name" required value="<%= selectedGroup.getName() %>"/>

            <label for="editMonthlyContribution">Monthly Contribution</label>
            <input type="number" step="0.01" id="editMonthlyContribution" name="monthlyContribution" required value="<%= selectedGroup.getMonthlyContribution() %>"/>

            <button type="submit">Update Group</button>
        </form>

        <h3>Record Payment</h3>
        <form method="post" action="<%= ctx %>/admin/idir">
            <input type="hidden" name="action" value="recordPayment"/>
            <input type="hidden" name="groupId" value="<%= selectedGroup.getId() %>"/>

            <label for="member">Member Name</label>
            <input type="text" id="member" name="member" required placeholder="Member full name"/>

            <label for="paymentAmount">Amount</label>
            <input type="number" step="0.01" id="paymentAmount" name="amount" required placeholder="500.00"/>

            <label for="paymentDate">Payment Date</label>
            <input type="date" id="paymentDate" name="date"/>

            <button type="submit">Record Payment</button>
        </form>

        <h3>Record Expense</h3>
        <form method="post" action="<%= ctx %>/admin/idir">
            <input type="hidden" name="action" value="recordExpense"/>
            <input type="hidden" name="groupId" value="<%= selectedGroup.getId() %>"/>

            <label for="description">Description</label>
            <input type="text" id="description" name="description" required placeholder="Expense description"/>

            <label for="expenseAmount">Amount</label>
            <input type="number" step="0.01" id="expenseAmount" name="amount" required placeholder="250.00"/>

            <label for="expenseDate">Expense Date</label>
            <input type="date" id="expenseDate" name="date"/>

            <button type="submit">Record Expense</button>
        </form>

        <h3>Summary</h3>
        <p><strong>Monthly Contribution:</strong> <%= String.format("%.2f", selectedGroup.getMonthlyContribution()) %></p>
        <p><strong>Total Payments:</strong> <%= String.format("%.2f", selectedGroup.getTotalPayments()) %></p>
        <p><strong>Total Expenses:</strong> <%= String.format("%.2f", selectedGroup.getTotalExpenses()) %></p>
        <p><strong>Current Balance:</strong> <%= String.format("%.2f", selectedGroup.getBalance()) %></p>

        <div class="grid">
            <div>
                <h4>Payments</h4>
                <table>
                    <thead>
                    <tr><th>Member</th><th>Amount</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                    <% List<IdirGroup.Payment> payments = selectedGroup.getPayments();
                       if (payments.isEmpty()) { %>
                        <tr><td colspan="3">No payments yet.</td></tr>
                    <% } else {
                           for (IdirGroup.Payment payment : payments) { %>
                        <tr>
                            <td><%= payment.getMember() %></td>
                            <td><%= String.format("%.2f", payment.getAmount()) %></td>
                            <td><%= payment.getPaidDate() %></td>
                        </tr>
                    <%   }
                       } %>
                    </tbody>
                </table>
            </div>
            <div>
                <h4>Expenses</h4>
                <table>
                    <thead>
                    <tr><th>Description</th><th>Amount</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                    <% List<IdirGroup.Expense> expenses = selectedGroup.getExpenses();
                       if (expenses.isEmpty()) { %>
                        <tr><td colspan="3">No expenses yet.</td></tr>
                    <% } else {
                           for (IdirGroup.Expense expense : expenses) { %>
                        <tr>
                            <td><%= expense.getDescription() %></td>
                            <td><%= String.format("%.2f", expense.getAmount()) %></td>
                            <td><%= expense.getSpentDate() %></td>
                        </tr>
                    <%   }
                       } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<% } %>
</body>
</html>

>>>>>>> 02b51aac394f9d81545be5c42cde5eaebbec63e2
