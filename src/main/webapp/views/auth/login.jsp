<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Equb & Idir Management System - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/login.css">
    <style>
        .error-message {
            background: #ffeeee;
            color: #d8000c;
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            margin: 20px 0;
            font-weight: 600;
            border: 1px solid #ffbaba;
        }
    </style>
    <style>
        .lang-switch {
            position: absolute;
            top: 16px;
            right: 24px;
            font-size: 14px;
        }
        .lang-switch a {
            color: #555;
            text-decoration: none;
            margin-left: 8px;
            font-weight: 600;
        }
        .lang-switch a.active {
            color: #111;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<%
    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "en";
    boolean isAm = "am".equals(lang);

    // Pre-build placeholder strings to avoid complex expressions inside attributes
    String phonePlaceholder = isAm
            ? "ስልክ ቁጥር (ለምሳሌ 0911223344)"
            : "Phone Number (e.g. 0911223344)";
    String passwordPlaceholder = isAm
            ? "የይለፍ ቃል"
            : "Password";
%>
<div class="container">
    <div class="lang-switch">
        <span><%= isAm ? "ቋንቋ" : "Language" %>:</span>
        <a href="<%= request.getContextPath() %>/lang?lang=en" class="<%= !isAm ? "active" : "" %>">English</a>|
        <a href="<%= request.getContextPath() %>/lang?lang=am" class="<%= isAm ? "active" : "" %>">አማርኛ</a>
    </div>
    <div class="form-section">
        <div class="logo">Equb & Idir</div>
        <p class="tagline">
            <%= isAm
                    ? "የባህላዊ እቁብንና እድርን በዘመናዊ መንገድ የሚያስተዳድር የደህንነት ስርዓት"
                    : "Securely manage your traditional savings and community support groups" %>
        </p>
        <h1><%= isAm ? "ወደ መለያህ ግባ" : "Login to Your Account" %></h1>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error-message"><%= error %></div>
        <% } %>

        <%
            String success = (String) request.getAttribute("success");
            if (success != null) {
        %>
        <div class="success-message"><%= success %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="input-group">
                <i class="fas fa-phone"></i>
                <input type="tel" name="phone"
                       placeholder="<%= phonePlaceholder %>"
                       required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password"
                       placeholder="<%= passwordPlaceholder %>" required>
            </div>
            <button type="submit" class="submit-btn">
                <%= isAm ? "ግባ" : "Sign In" %>
            </button>
        </form>
    </div>
    <div class="info-section">
        <div class="info-content">
            <h2><%= isAm ? "እንኳን በደህና መጡ!" : "Welcome Back!" %></h2>
            <p>
                <%= isAm
                        ? "እቁብና እድር ቡድኖችህን ባህላዊ እሴቶችን በመከበር በደህንነት እና በዘመናዊ መንገድ አስተዳድር።"
                        : "Access your Equb and Idir groups with secure, modern tools that honor Ethiopian traditions." %>
            </p>
            <ul class="features">
                <li><i class="fas fa-check-circle"></i>
                    <%= isAm ? "ወዲያውኑ የመዋጮና የክፍያ መረጃ መመልከት" : "Instant access to contributions and payouts" %>
                </li>
                <li><i class="fas fa-check-circle"></i>
                    <%= isAm ? "መርሃግብሮችንና የአባላት ማሻሻያዎችን በቀላሉ መመልከት" : "View schedules and member updates" %>
                </li>
                <li><i class="fas fa-check-circle"></i>
                    <%= isAm ? "ግልጽ እና እማኝ መዝገቦች" : "Transparent and tamper-proof records" %>
                </li>
                <li><i class="fas fa-check-circle"></i>
                    <%= isAm ? "በቅርብ ጊዜ ማሳወቂያዎች" : "Real-time notifications" %>
                </li>
            </ul>
            <p class="footer-text">
                <%= isAm
                        ? "የማህበረሰብ እምነትን በዲጂታል ዘመን ማከበር የምንረዳበት መድረክ።"
                        : "Preserving community trust in the digital age." %>
            </p>
        </div>
    </div>
</div>
</body>
</html>
