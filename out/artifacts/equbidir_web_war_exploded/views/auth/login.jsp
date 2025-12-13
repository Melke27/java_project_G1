<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Equb & Idir Management System - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../../assets/css/login.css">
</head>
<body>
<div class="container">
    <div class="form-section">
        <div class="logo">Equb & Idir</div>
        <p class="tagline">Securely manage your traditional savings and community support groups</p>
        <h1>Login to Your Account</h1>
        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="input-group">
                <i class="fas fa-phone"></i>
                <input type="tel" placeholder="Phone Number (e.g. 0911223344)" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" placeholder="Password" required>
            </div>
            <button type="submit" class="submit-btn">Sign In</button>
            <p class="signin-link">Don't have an account? <a href="create.jsp">Sign up</a></p>
        </form>
    </div>
    <div class="info-section">
        <div class="info-content">
            <h2>Welcome Back!</h2>
            <p>Access your Equb and Idir groups with secure, modern tools that honor Ethiopian traditions.</p>
            <ul class="features">
                <li><i class="fas fa-check-circle"></i> Instant access to contributions and payouts</li>
                <li><i class="fas fa-check-circle"></i> View schedules and member updates</li>
                <li><i class="fas fa-check-circle"></i> Transparent and tamper-proof records</li>
                <li><i class="fas fa-check-circle"></i> Real-time notifications</li>
            </ul>
            <p class="footer-text">Preserving community trust in the digital age.</p>
        </div>
    </div>
</div>
</body>
</html>