<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.EqubGroup" %>
<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Equb Management</title>
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
    <a href="<%= ctx %>/admin/equb" class="active"><%= labelEqub %></a>
    <a href="<%= ctx %>/admin/idir"><%= labelIdir %></a>
    <a href="<%= ctx %>/admin/expenses"><%= labelExpenses %></a>
    <a href="<%= ctx %>/views/admin/reports.jsp"><%= labelReports %></a>
</div>

<div class="container">
    <h1>Equb Management</h1>
    <a class="link" href="<%=request.getContextPath()%>/admin/dashboard">← Back to Dashboard</a>

    <div class="grid">
        <div class="card">
            <h2>Create Equb Group</h2>
            <form method="post" action="<%=request.getContextPath()%>/admin/equb">
                <input type="hidden" name="action" value="create_group" />
                <label>Equb Name</label>
                <input type="text" name="equb_name" required />
                <label>Amount</label>
                <input type="number" step="0.01" name="amount" required />
                <label>Frequency</label>
                <select name="frequency">
                    <option value="daily">daily</option>
                    <option value="weekly">weekly</option>
                    <option value="monthly" selected>monthly</option>
                </select>
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
                    <th>Amount</th>
                    <th>Frequency</th>
                    <th>Open</th>
                    <th>Delete</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<EqubGroup> groups = (List<EqubGroup>) request.getAttribute("groups");
                    if (groups != null) {
                        for (EqubGroup g : groups) {
                %>
                    <tr>
                        <td><%=g.getEqubId()%></td>
                        <td><%=g.getEqubName()%></td>
                        <td><%=g.getAmount()%></td>
                        <td><%=g.getFrequency()%></td>
                        <td><a class="link" href="<%=request.getContextPath()%>/admin/equb?equb_id=<%=g.getEqubId()%>">Open</a></td>
                        <td>
                            <form class="inline" method="post" action="<%=request.getContextPath()%>/admin/equb">
                                <input type="hidden" name="action" value="delete_group" />
                                <input type="hidden" name="equb_id" value="<%=g.getEqubId()%>" />
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

    <% Integer selectedEqubId = (Integer) request.getAttribute("selectedEqubId"); %>
    <% if (selectedEqubId != null) { %>
        <div class="card">
            <h2>Group Members (Equb ID: <%=selectedEqubId%>)</h2>

            <h3>Add Member to this Equb</h3>
            <form method="post" action="<%=request.getContextPath()%>/admin/equb">
                <input type="hidden" name="action" value="add_member" />
                <input type="hidden" name="equb_id" value="<%=selectedEqubId%>" />
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

            <h3>Rotation</h3>
            <form class="inline" method="post" action="<%=request.getContextPath()%>/admin/equb">
                <input type="hidden" name="action" value="generate_rotation" />
                <input type="hidden" name="equb_id" value="<%=selectedEqubId%>" />
                <input type="hidden" name="mode" value="fixed" />
                <button class="btn" type="submit">Generate Fixed Rotation</button>
            </form>
            <form class="inline" method="post" action="<%=request.getContextPath()%>/admin/equb">
                <input type="hidden" name="action" value="generate_rotation" />
                <input type="hidden" name="equb_id" value="<%=selectedEqubId%>" />
                <input type="hidden" name="mode" value="random" />
                <button class="btn" type="submit">Generate Random Rotation</button>
            </form>

            <h3>Approve Payments</h3>
            <table>
                <thead>
                <tr>
                    <th>Member ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th>Rotation</th>
                    <th>Approve</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<String[]> equbMembers = (List<String[]>) request.getAttribute("equbMembers");
                    if (equbMembers != null) {
                        for (String[] r : equbMembers) {
                %>
                    <tr>
                        <td><%=r[0]%></td>
                        <td><%=r[1]%></td>
                        <td><%=r[2]%></td>
                        <td><%=r[3]%></td>
                        <td><%=r[4]%></td>
                        <td>
                            <form class="inline" method="post" action="<%=request.getContextPath()%>/admin/equb">
                                <input type="hidden" name="action" value="approve_payment" />
                                <input type="hidden" name="equb_id" value="<%=selectedEqubId%>" />
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
