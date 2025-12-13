<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Equb/Idir</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css" />
</head>
<body>
<div class="container">
    <h1>Equb / Idir Management System</h1>
    <div class="card">
        <h2>Login</h2>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form method="post" action="<%=request.getContextPath()%>/login">
            <label>Phone</label>
            <input type="text" name="phone" placeholder="09..." required />

            <label>Password</label>
            <input type="password" name="password" required />

            <button type="submit" class="btn btn-primary">Login</button>
        </form>

        <p class="muted">Default admin: 0900000000 / admin123</p>
    </div>
</div>
</body>
</html>
