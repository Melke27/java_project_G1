<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.IdirGroup" %>
<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Idir Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin-dashboard.css" />
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
    String labelMyProfile = isAm ? "የግል መረጃዬ" : "My Profile";
    String labelLogout = isAm ? "ውጣ" : "Logout";

    request.setAttribute("activePage", "idir.manage");
%>

<%@ include file="_sidebar.jspf" %>

<div class="main-content" id="mainContent">
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
</div>
</body>
</html>
