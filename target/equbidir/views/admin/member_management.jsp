<%@ page import="com.equbidir.model.Member" %>
<%@ page import="com.equbidir.dao.MemberDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Management - Equb & Idir Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-dashboard.css">
</head>
<body>
<%
    Member admin = (Member) session.getAttribute("user");
    if (admin == null || !"admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }

    MemberDAO memberDAO = new MemberDAO();
    List<Member> members = memberDAO.getAllMembers();

    String search = request.getParameter("search");
    if (search != null && !search.trim().isEmpty()) {
        search = search.trim().toLowerCase();
        List<Member> filtered = new ArrayList<>();
        for (Member m : members) {
            if (m.getFullName().toLowerCase().contains(search) ||
                    m.getPhone().contains(search) ||
                    (m.getAddress() != null && m.getAddress().toLowerCase().contains(search))) {
                filtered.add(m);
            }
        }
        members = filtered;
    }
%>
<div class="admin-container">
    <div class="header">
        <h1>Member Management</h1>
        <div class="header-buttons">
            <a href="<%= request.getContextPath() %>/views/admin/dashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <div class="members-section">
        <div class="section-header">
            <h2><i class="fas fa-users"></i> All Members</h2>
            <a href="<%= request.getContextPath() %>/views/admin/add-member.jsp" class="add-btn">
                <i class="fas fa-user-plus"></i> Add New Member
            </a>
        </div>

        <form class="search-bar" method="get">
            <input type="text" name="search" class="search-input" placeholder="Search by name, phone, or address..."
                   value="<%= search != null ? search : "" %>">
            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> Search
            </button>
        </form>

        <% if (members.isEmpty()) { %>
        <div class="no-results">
            <i class="fas fa-users-slash"></i>
            <p>No members found.</p>
        </div>
        <% } else { %>
        <div class="table-container">
            <table class="members-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Member m : members) { %>
                <tr>
                    <td>#<%= m.getMemberId() %></td>
                    <td><%= m.getFullName() %></td>
                    <td><%= m.getPhone() %></td>
                    <td><%= m.getAddress() != null ? m.getAddress() : "-" %></td>
                    <td>
                                <span class="role-badge <%= "admin".equalsIgnoreCase(m.getRole()) ? "admin" : "member" %>">
                                    <%= "admin".equalsIgnoreCase(m.getRole()) ? "Administrator" : "Member" %>
                                </span>
                    </td>
                    <td class="actions">
                        <a href="<%= request.getContextPath() %>/views/admin/edit-member.jsp?id=<%= m.getMemberId() %>" class="edit-btn">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="<%= request.getContextPath() %>/delete-member?id=<%= m.getMemberId() %>" class="delete-btn"
                           onclick="return confirm('Delete <%= m.getFullName() %>?')">
                            <i class="fas fa-trash"></i>
                        </a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>