<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Member Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css" />
</head>
<body>
<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<div class="container">
    <h1>Member Dashboard</h1>
    <div class="card">
        <p>Welcome, <strong><%=user.getFullName()%></strong></p>
        <p>Phone: <%=user.getPhone()%></p>
        <p>Role: <%=user.getRole()%></p>
    </div>
</div>
</body>
</html>
