<%@ page import="java.util.List" %>
<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Member Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css" />
</head>
<body>
<div class="container">
    <h1>Member Management</h1>
    <a class="link" href="<%=request.getContextPath()%>/admin/dashboard">← Back to Dashboard</a>

    <div class="card">
        <h2>Add Member</h2>
        <form method="post" action="<%=request.getContextPath()%>/admin/members">
            <input type="hidden" name="action" value="create" />
            <label>Full Name</label>
            <input type="text" name="full_name" required />

            <label>Phone</label>
            <input type="text" name="phone" required />

            <label>Address</label>
            <input type="text" name="address" />

            <label>Role</label>
            <select name="role">
                <option value="member">member</option>
                <option value="admin">admin</option>
            </select>

            <label>Password (optional, default 123456)</label>
            <input type="password" name="password" />

            <button class="btn btn-primary" type="submit">Create</button>
        </form>
    </div>

    <div class="card">
        <h2>All Members</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Address</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Member> members = (List<Member>) request.getAttribute("members");
                if (members != null) {
                    for (Member m : members) {
            %>
                <tr>
                    <td><%= m.getMemberId() %></td>
                    <td><%= m.getFullName() %></td>
                    <td><%= m.getPhone() %></td>
                    <td><%= m.getAddress() == null ? "" : m.getAddress() %></td>
                    <td><%= m.getRole() %></td>
                    <td>
                        <form class="inline" method="post" action="<%=request.getContextPath()%>/admin/members">
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="member_id" value="<%=m.getMemberId()%>" />
                            <button class="btn btn-danger" type="submit">Delete</button>
                        </form>

                        <details>
                            <summary class="link">Update</summary>
                            <form method="post" action="<%=request.getContextPath()%>/admin/members">
                                <input type="hidden" name="action" value="update" />
                                <input type="hidden" name="member_id" value="<%=m.getMemberId()%>" />
                                <label>Full Name</label>
                                <input type="text" name="full_name" value="<%=m.getFullName()%>" required />
                                <label>Phone</label>
                                <input type="text" name="phone" value="<%=m.getPhone()%>" required />
                                <label>Address</label>
                                <input type="text" name="address" value="<%=m.getAddress()==null?"":m.getAddress()%>" />
                                <label>Role</label>
                                <select name="role">
                                    <option value="member" <%= "member".equalsIgnoreCase(m.getRole()) ? "selected" : "" %>>member</option>
                                    <option value="admin" <%= "admin".equalsIgnoreCase(m.getRole()) ? "selected" : "" %>>admin</option>
                                </select>
                                <button class="btn" type="submit">Save</button>
                            </form>
                        </details>

                        <details>
                            <summary class="link">Reset Password</summary>
                            <form method="post" action="<%=request.getContextPath()%>/admin/members">
                                <input type="hidden" name="action" value="reset_password" />
                                <input type="hidden" name="member_id" value="<%=m.getMemberId()%>" />
                                <label>New Password</label>
                                <input type="password" name="password" required />
                                <button class="btn" type="submit">Reset</button>
                            </form>
                        </details>
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
</body>
</html>
