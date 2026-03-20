<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgroInsights - Farmer's Hub</title>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #2e7d32;
            --primary-dark: #1b5e20;
            --primary-light: #4caf50;
            --secondary-color: #ff9800;
            --accent-color: #2196f3;
            --danger-color: #dc3545;
            --dark-bg: #0f172a;
            --light-bg: #f8fafc;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --white: #ffffff;
            --gray-light: #f1f5f9;
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            --shadow-lg: 0 10px 40px rgba(0, 0, 0, 0.1);
            --radius: 10px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: var(--light-bg);
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 5%;
            background: var(--white);
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.98);
            min-height: 70px;
            gap: 2rem;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            flex-shrink: 0;
            min-width: 200px;
        }

        .logo-icon {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.6rem;
            box-shadow: 0 4px 12px rgba(46, 125, 50, 0.25);
            flex-shrink: 0;
        }

        .logo-text {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
            white-space: nowrap;
        }

        .logo-main {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logo-sub {
            font-size: 0.75rem;
            color: var(--text-light);
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        /* Navigation Center Section */
        .nav-center {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-width: 0; /* Allow shrinking */
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 0.8rem;
            align-items: center;
            background: var(--gray-light);
            padding: 0.5rem;
            border-radius: 50px;
            box-shadow: inset 0 2px 10px rgba(0, 0, 0, 0.05);
            max-width: 100%;
            overflow: hidden;
        }

        .nav-item {
            flex-shrink: 0;
        }

        .nav-link {
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 500;
            font-size: 0.9rem;
            padding: 0.6rem 1.2rem;
            border-radius: 50px;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
            min-width: 0;
        }

        .nav-link i {
            font-size: 1rem;
            opacity: 0.8;
            flex-shrink: 0;
        }

        .nav-link span {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .nav-link:hover {
            color: var(--primary-dark);
            background: rgba(255, 255, 255, 0.9);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .nav-link.active {
            color: var(--white);
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(46, 125, 50, 0.25);
        }

        .nav-link.active i {
            color: var(--white);
            opacity: 1;
        }

        /* User Actions Section */
        .user-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-shrink: 0;
            min-width: 250px;
            justify-content: flex-end;
        }

        /* Profile Section */
        .profile-section {
            display: flex;
            align-items: center;
            gap: 1rem;
            width: 100%;
            justify-content: flex-end;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            background: rgba(46, 125, 50, 0.08);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            transition: var(--transition);
            text-decoration: none;
            flex-shrink: 0;
            max-width: 220px;
        }

        .user-profile:hover {
            background: rgba(46, 125, 50, 0.15);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(46, 125, 50, 0.1);
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
        }

        .user-info {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .user-name {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.9rem;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .user-role {
            font-size: 0.7rem;
            color: var(--text-light);
            font-weight: 500;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .admin-badge {
            background: var(--secondary-color);
            color: white;
            padding: 0.15rem 0.5rem;
            border-radius: 12px;
            font-size: 0.65rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 2px;
        }

        /* Logout Button */
        .btn-logout {
            background: var(--danger-color);
            color: white;
            padding: 0.6rem 1.2rem;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: var(--transition);
            flex-shrink: 0;
            font-size: 0.9rem;
        }

        .btn-logout:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.2);
        }

        /* Auth Buttons */
        .auth-buttons {
            display: flex;
            gap: 0.8rem;
            flex-shrink: 0;
        }

        .btn {
            padding: 0.6rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
            cursor: pointer;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .btn-login {
            background: var(--white);
            color: var(--primary-color);
            border: 2px solid var(--primary-light);
        }

        .btn-login:hover {
            background: var(--primary-light);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(46, 125, 50, 0.2);
        }

        .btn-register {
            background: linear-gradient(135deg, var(--secondary-color), #ffb74d);
            color: white;
            border: 2px solid transparent;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 152, 0, 0.3);
        }

        /* Mobile Menu Toggle */
        .menu-toggle {
            display: none;
            flex-direction: column;
            gap: 4px;
            cursor: pointer;
            padding: 0.5rem;
            flex-shrink: 0;
        }

        .menu-toggle span {
            width: 25px;
            height: 3px;
            background: var(--primary-dark);
            border-radius: 2px;
            transition: var(--transition);
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .navbar {
                padding: 1rem 3%;
                gap: 1.5rem;
            }

            .nav-links {
                gap: 0.5rem;
                padding: 0.4rem;
            }

            .nav-link {
                padding: 0.5rem 1rem;
                font-size: 0.85rem;
            }

            .user-profile {
                max-width: 180px;
            }
        }

        @media (max-width: 992px) {
            .nav-center {
                display: none;
            }

            .menu-toggle {
                display: flex;
            }

            .navbar {
                justify-content: space-between;
                gap: 1rem;
            }

            .logo {
                min-width: auto;
            }

            .user-actions {
                min-width: auto;
                justify-content: flex-end;
            }

            .user-profile .user-info {
                display: none;
            }

            .user-profile {
                padding: 0.5rem;
                max-width: auto;
            }

            .btn-logout span {
                display: none;
            }

            .btn-logout {
                padding: 0.6rem;
                width: 40px;
                height: 40px;
                justify-content: center;
            }
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 0.8rem 2%;
                min-height: 60px;
            }

            .logo-text {
                display: none;
            }

            .logo {
                min-width: auto;
            }

            .logo-icon {
                width: 36px;
                height: 36px;
                font-size: 1.4rem;
            }

            .auth-buttons .btn span {
                display: none;
            }

            .auth-buttons .btn {
                padding: 0.6rem;
                width: 40px;
                height: 40px;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .user-avatar {
                width: 32px;
                height: 32px;
                font-size: 0.9rem;
            }

            .btn-logout, .auth-buttons .btn {
                width: 36px;
                height: 36px;
            }
        }

        /* Mobile Menu */
        .mobile-menu {
            position: fixed;
            top: 70px;
            left: 0;
            right: 0;
            background: var(--white);
            padding: 1.5rem;
            box-shadow: var(--shadow-lg);
            border-top: 1px solid rgba(0, 0, 0, 0.1);
            transform: translateY(-100%);
            opacity: 0;
            visibility: hidden;
            transition: var(--transition);
            z-index: 999;
            max-height: calc(100vh - 70px);
            overflow-y: auto;
        }

        .mobile-menu.active {
            transform: translateY(0);
            opacity: 1;
            visibility: visible;
        }

        .mobile-nav-links {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .mobile-nav-link {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.5rem;
            background: var(--gray-light);
            border-radius: var(--radius);
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 500;
            transition: var(--transition);
        }

        .mobile-nav-link.active {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            color: white;
        }

        .mobile-nav-link:hover {
            transform: translateX(5px);
            box-shadow: var(--shadow);
        }

        .mobile-auth-buttons {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
        }

        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .nav-link {
            animation: fadeIn 0.3s ease forwards;
            opacity: 0;
        }

        .nav-link:nth-child(1) { animation-delay: 0.1s; }
        .nav-link:nth-child(2) { animation-delay: 0.2s; }
        .nav-link:nth-child(3) { animation-delay: 0.3s; }
        .nav-link:nth-child(4) { animation-delay: 0.4s; }
        .nav-link:nth-child(5) { animation-delay: 0.5s; }

        /* Mobile Menu Animation */
        .menu-toggle.active span:nth-child(1) {
            transform: rotate(45deg) translate(6px, 6px);
        }

        .menu-toggle.active span:nth-child(2) {
            opacity: 0;
        }

        .menu-toggle.active span:nth-child(3) {
            transform: rotate(-45deg) translate(6px, -6px);
        }

        /* Prevent text overflow */
        .text-truncate {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>

<body>

<%
    // Get session attributes
    String userEmail = (String) session.getAttribute("userEmail");
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    boolean isLoggedIn = userEmail != null;
    boolean isAdmin = "admin".equals(role);
    String currentPage = request.getRequestURI();

    // Get first letter of username for avatar
    String avatarLetter = username != null && !username.isEmpty() ?
            username.substring(0, 1).toUpperCase() : "U";
%>

<nav class="navbar">
    <!-- Logo Section - Left -->
    <div class="logo">
        <div class="logo-icon">
            <i class='bx bx-leaf'></i>
        </div>
        <div class="logo-text">
            <span class="logo-main">AgroInsights</span>
            <span class="logo-sub">Farmer's Intelligent Hub</span>
        </div>
    </div>

    <!-- Navigation Center Section -->
    <div class="nav-center">
        <ul class="nav-links">
            <!-- Always Visible -->
            <li class="nav-item">
                <a href="index.jsp" class="nav-link <%= currentPage.endsWith("index.jsp") ? "active" : "" %>">
                    <i class='bx bx-home'></i>
                    <span>Home</span>
                </a>
            </li>

            <li class="nav-item">
                <a href="agri.jsp" class="nav-link <%= currentPage.endsWith("agri.jsp") ? "active" : "" %>">
                    <i class='bx bx-seed'></i>
                    <span>Agriculture</span>
                </a>
            </li>

            <% if (isLoggedIn && !isAdmin) { %>
            <!-- For Regular Users -->
            <li class="nav-item">
                <a href="currentCrop.jsp" class="nav-link <%= currentPage.endsWith("currentCrop.jsp") ? "active" : "" %>">
                    <i class='bx bx-trending-up'></i>
                    <span>Current Crops</span>
                </a>
            </li>

            <li class="nav-item">
                <a href="historyCrop.jsp" class="nav-link <%= currentPage.endsWith("historyCrop.jsp") ? "active" : "" %>">
                    <i class='bx bx-history'></i>
                    <span>Previous Crops</span>
                </a>
            </li>
            <% } %>

            <% if (!isAdmin) { %>
            <!-- Contact - Hidden for Admin -->
            <li class="nav-item">
                <a href="contact.jsp" class="nav-link <%= currentPage.endsWith("contact.jsp") ? "active" : "" %>">
                    <i class='bx bx-phone'></i>
                    <span>Contact</span>
                </a>
            </li>
            <% } %>

            <% if (isLoggedIn && isAdmin) { %>
            <!-- Admin Links -->
            <li class="nav-item">
                <a href="Admin.jsp" class="nav-link <%= currentPage.endsWith("Admin.jsp") ? "active" : "" %>">
                    <i class='bx bx-dashboard'></i>
                    <span>Dashboard</span>
                </a>
            </li>

            <li class="nav-item">
                <a href="adminUser.jsp" class="nav-link <%= currentPage.endsWith("manageUsers.jsp") ? "active" : "" %>">
                    <i class='bx bx-user-plus'></i>
                    <span>Users</span>
                </a>
            </li>

            <li class="nav-item">
                <a href="analytics.jsp" class="nav-link <%= currentPage.endsWith("reports.jsp") ? "active" : "" %>">
                    <i class='bx bx-bar-chart'></i>
                    <span>Analytics</span>
                </a>
            </li>
            <% } %>
        </ul>
    </div>

    <!-- User Actions Section - Right -->
    <div class="user-actions">
        <% if (isLoggedIn) { %>
        <!-- Profile Section for Logged In Users -->
        <div class="profile-section">
            <a href="<%= isAdmin ? "Admin.jsp" : "profile.jsp" %>" class="user-profile">
                <div class="user-avatar">
                    <%= avatarLetter %>
                </div>
                <div class="user-info">
                    <span class="user-name text-truncate"><%= username %></span>
                    <span class="user-role">
                            <%= isAdmin ? "Administrator" : "Farmer" %>
                        </span>
                </div>
            </a>

            <!-- Logout Button -->
            <a href="logout.jsp" class="btn-logout">
                <i class='bx bx-log-out'></i>
                <span>Logout</span>
            </a>
        </div>
        <% } else { %>
        <!-- Authentication Buttons -->
        <div class="auth-buttons">
            <a href="register.jsp" class="btn btn-login">
                <i class='bx bx-log-in'></i>
                <span>Login</span>
            </a>
            <a href="register.jsp" class="btn btn-register">
                <i class='bx bx-user-plus'></i>
                <span>Register</span>
            </a>
        </div>
        <% } %>
    </div>

    <!-- Mobile Menu Toggle -->
    <div class="menu-toggle" id="menuToggle">
        <span></span>
        <span></span>
        <span></span>
    </div>
</nav>

<!-- Mobile Menu -->
<div class="mobile-menu" id="mobileMenu">
    <div class="mobile-nav-links">
        <a href="index.jsp" class="mobile-nav-link <%= currentPage.endsWith("index.jsp") ? "active" : "" %>">
            <i class='bx bx-home'></i>
            <span>Home</span>
        </a>

        <a href="agri.jsp" class="mobile-nav-link <%= currentPage.endsWith("agri.jsp") ? "active" : "" %>">
            <i class='bx bx-seed'></i>
            <span>Agriculture</span>
        </a>

        <% if (isLoggedIn && !isAdmin) { %>
        <a href="currentCrop.jsp" class="mobile-nav-link <%= currentPage.endsWith("currentCrop.jsp") ? "active" : "" %>">
            <i class='bx bx-trending-up'></i>
            <span>Current Crop</span>
        </a>

        <a href="historyCrop.jsp" class="mobile-nav-link <%= currentPage.endsWith("historyCrop.jsp") ? "active" : "" %>">
            <i class='bx bx-history'></i>
            <span>History</span>
        </a>
        <% } %>

        <% if (!isAdmin) { %>
        <a href="contact.jsp" class="mobile-nav-link <%= currentPage.endsWith("contact.jsp") ? "active" : "" %>">
            <i class='bx bx-phone'></i>
            <span>Contact</span>
        </a>
        <% } %>

        <% if (isLoggedIn && isAdmin) { %>
        <a href="Admin.jsp" class="mobile-nav-link <%= currentPage.endsWith("Admin.jsp") ? "active" : "" %>">
            <i class='bx bx-dashboard'></i>
            <span>Dashboard</span>
        </a>
        <a href="adminUser.jsp" class="mobile-nav-link <%= currentPage.endsWith("manageUsers.jsp") ? "active" : "" %>">
            <i class='bx bx-user-plus'></i>
            <span>Manage Users</span>
        </a>
        <a href="reports.jsp" class="mobile-nav-link <%= currentPage.endsWith("reports.jsp") ? "active" : "" %>">
            <i class='bx bx-bar-chart'></i>
            <span>Analytics</span>
        </a>
        <% } %>
    </div>

    <% if (!isLoggedIn) { %>
    <div class="mobile-auth-buttons">
        <a href="register.jsp" class="btn btn-login" style="width: 100%; justify-content: center;">
            <i class='bx bx-log-in'></i>
            <span>Login</span>
        </a>
        <a href="register.jsp" class="btn btn-register" style="width: 100%; justify-content: center;">
            <i class='bx bx-user-plus'></i>
            <span>Register</span>
        </a>
    </div>
    <% } else { %>
    <div class="profile-section" style="flex-direction: column; width: 100%;">
        <a href="<%= isAdmin ? "Admin.jsp" : "profile.jsp" %>" class="user-profile" style="width: 100%; justify-content: center;">
            <div class="user-avatar">
                <%= avatarLetter %>
            </div>
            <div class="user-info">
                <span class="user-name"><%= username %></span>
                <span class="user-role">
                    <%= isAdmin ? "Administrator" : "Farmer" %>
                </span>
            </div>
        </a>

        <a href="logout.jsp" class="btn-logout" style="width: 100%; justify-content: center; margin-top: 1rem;">
            <i class='bx bx-log-out'></i>
            <span>Logout</span>
        </a>
    </div>
    <% } %>
</div>

<script>
    // Mobile menu toggle
    const menuToggle = document.getElementById('menuToggle');
    const mobileMenu = document.getElementById('mobileMenu');
    const body = document.body;

    menuToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        menuToggle.classList.toggle('active');
        mobileMenu.classList.toggle('active');

        // Prevent body scroll when menu is open
        if (mobileMenu.classList.contains('active')) {
            body.style.overflow = 'hidden';
        } else {
            body.style.overflow = 'auto';
        }
    });

    // Close mobile menu when clicking outside
    document.addEventListener('click', (event) => {
        const isClickInsideMenu = mobileMenu.contains(event.target);
        const isClickOnToggle = menuToggle.contains(event.target);

        if (!isClickInsideMenu && !isClickOnToggle && mobileMenu.classList.contains('active')) {
            menuToggle.classList.remove('active');
            mobileMenu.classList.remove('active');
            body.style.overflow = 'auto';
        }
    });

    // Close mobile menu when clicking a link
    const mobileLinks = document.querySelectorAll('.mobile-nav-link, .btn, .user-profile, .btn-logout');
    mobileLinks.forEach(link => {
        link.addEventListener('click', () => {
            if (mobileMenu.classList.contains('active')) {
                menuToggle.classList.remove('active');
                mobileMenu.classList.remove('active');
                body.style.overflow = 'auto';
            }
        });
    });

    // Handle window resize
    window.addEventListener('resize', () => {
        if (window.innerWidth > 992) {
            menuToggle.classList.remove('active');
            mobileMenu.classList.remove('active');
            body.style.overflow = 'auto';
        }
    });
</script>

</body>
</html>