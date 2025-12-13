<%@ page import="com.equbidir.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard - Equb & Idir</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f5f7fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        h1 {
            color: #1e4d2b;
            margin-bottom: 30px;
        }
        .card {
            background: #f8fafc;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .card p {
            font-size: 18px;
            margin: 15px 0;
            color: #333;
        }
        .logout-btn {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 30px;
            background: #c9a227;
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }
        .logout-btn:hover {
            background: #b38b1e;
            transform: translateY(-3px);
        }
    </style>
</head>
<body>
<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
%>
<div class="container">
    <h1>Member Dashboard</h1>
    <div class="card">
        <p>Welcome back, <strong><%= user.getFullName() %></strong>!</p>
        <p>Phone: <%= user.getPhone() %></p>
        <p>Role: <%= user.getRole() %></p>
        <p>Member ID: <%= user.getMemberId() %></p>
    </div>
    <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
</div>
</body>
</html>