<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.example.controller.DBConnection" %>

<%
    if (session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get user information from session
    String userEmail = (String) session.getAttribute("userEmail");
    String username = (String) session.getAttribute("username");

    // Database connection variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Variables to store user data
    String fullName = username;
    String email = userEmail;
    String accountType = "Farmer Account";
    String memberSince = "2024";
    Timestamp lastLogin = null;
    String accountStatus = "Active";

    // Stats variables
    int activeCropsCount = 0;
    int historyCropsCount = 0;
    int totalCropsCount = 0;
    double successRate = 0;

    // Recent activity list
    List<Map<String, String>> recentActivities = new ArrayList<>();

    try {
        // Use connection pool utility
        conn = DBConnection.getConnection();

        // Fetch user details from farmdata table
        String userQuery = "SELECT * FROM farmdata WHERE email = ?";
        pstmt = conn.prepareStatement(userQuery);
        pstmt.setString(1, userEmail);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            fullName = rs.getString("username");
            email = rs.getString("email");
            Timestamp created = rs.getTimestamp("created_at");
            if (created != null) {
                memberSince = created.toString().substring(0, 10);
            }
            lastLogin = created;
        }
        rs.close();
        pstmt.close();

        // Count active crops
        String activeCropsQuery = "SELECT COUNT(*) as count FROM add_crop WHERE username = ?";
        pstmt = conn.prepareStatement(activeCropsQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            activeCropsCount = rs.getInt("count");
        }
        rs.close();
        pstmt.close();

        // Count history crops
        String historyCropsQuery = "SELECT COUNT(*) as count FROM history_crop WHERE username = ?";
        pstmt = conn.prepareStatement(historyCropsQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            historyCropsCount = rs.getInt("count");
        }
        rs.close();
        pstmt.close();

        // Calculate total crops
        totalCropsCount = activeCropsCount + historyCropsCount;

        // Calculate success rate
        if (totalCropsCount > 0) {
            successRate = Math.round((historyCropsCount * 100.0 / totalCropsCount) * 100) / 100.0;
        }

        // Fetch recent activities from both crop tables (PostgreSQL)
        String recentActivityQuery = "SELECT 'Added' as action, crop_name, crop_dates as activity_date FROM add_crop WHERE username = ? " +
                "UNION ALL " +
                "SELECT 'Completed' as action, crop_name, crop_dates as activity_date FROM history_crop WHERE username = ? " +
                "ORDER BY activity_date DESC";

        pstmt = conn.prepareStatement(recentActivityQuery);
        pstmt.setString(1, username);
        pstmt.setString(2, username);
        rs = pstmt.executeQuery();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        int activityCount = 0;

        while (rs.next() && activityCount < 3) {  // Limit to 3 activities
            Map<String, String> activity = new HashMap<>();
            String action = rs.getString("action");
            String cropName = rs.getString("crop_name");
            java.sql.Date activityDate = rs.getDate("activity_date");

            activity.put("action", action);
            activity.put("cropName", cropName != null ? cropName : "Unknown Crop");
            activity.put("date", activityDate != null ? dateFormat.format(activityDate) : "Unknown date");

            recentActivities.add(activity);
            activityCount++;
        }
    } catch (Exception e) {
        // Log the error
        System.out.println("Database error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        // Close database resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile | AgroInsights</title>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Keep all existing CSS exactly the same */
        :root {
            --primary-color: #2e7d32;
            --primary-dark: #1b5e20;
            --primary-light: #4caf50;
            --secondary-color: #ff9800;
            --danger-color: #dc3545;
            --dark-bg: #0f172a;
            --light-bg: #f8fafc;
            --card-bg: #ffffff;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --border-color: #e2e8f0;
            --shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            --radius: 16px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            min-height: 100vh;
        }

        .profile-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .welcome-banner {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            color: white;
            padding: 3rem 2rem;
            border-radius: var(--radius);
            margin-bottom: 3rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .welcome-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .welcome-banner h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .welcome-banner p {
            font-size: 1.1rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        .profile-content {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 2rem;
        }

        .sidebar-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            position: sticky;
            top: 2rem;
        }

        .user-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            font-weight: 600;
            box-shadow: 0 8px 25px rgba(46, 125, 50, 0.3);
        }

        .user-info {
            width: 100%;
            min-width: 0; /* Allow shrinking */
        }

        .user-info h2 {
            text-align: center;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
            word-break: break-word;
            overflow-wrap: break-word;
            padding: 0 10px;
        }

        .user-info p {
            text-align: center;
            color: var(--text-light);
            margin-bottom: 2rem;
            word-break: break-word;
            overflow-wrap: break-word;
            max-width: 100%;
            padding: 0 10px;
            font-size: clamp(0.8rem, 2vw, 1rem); /* Responsive font size */
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-item {
            background: var(--light-bg);
            padding: 1rem;
            border-radius: 12px;
            text-align: center;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.3rem;
        }

        .stat-label {
            font-size: 0.85rem;
            color: var(--text-light);
        }

        .actions-grid {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .btn-action {
            padding: 1rem;
            background: var(--light-bg);
            border: 2px solid var(--border-color);
            border-radius: 12px;
            color: var(--text-dark);
            font-weight: 500;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: var(--transition);
        }

        .btn-action:hover {
            background: var(--primary-color);
            color: white;
            transform: translateX(5px);
            border-color: var(--primary-color);
        }

        .btn-action i:first-child {
            font-size: 1.3rem;
        }

        .btn-action i:last-child {
            opacity: 0;
            transition: var(--transition);
        }

        .btn-action:hover i:last-child {
            opacity: 1;
        }

        .btn-logout {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
            border-color: rgba(220, 53, 69, 0.2);
        }

        .btn-logout:hover {
            background: var(--danger-color);
            color: white;
            border-color: var(--danger-color);
        }

        .main-content {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .info-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
        }

        .info-card h3 {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--border-color);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            min-width: 0; /* Allows flex item to shrink below content size */
        }

        .info-label {
            color: var(--text-light);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .info-value {
            color: var(--text-dark);
            font-size: 1.1rem;
            font-weight: 600;
            word-break: break-word;
            overflow-wrap: break-word;
        }

        .recent-activity {
            list-style: none;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .activity-item:hover {
            background: var(--light-bg);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(46, 125, 50, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            flex-shrink: 0; /* Prevent icon from shrinking */
        }

        .activity-content {
            flex: 1;
            min-width: 0; /* Allow text to wrap */
        }

        .activity-title {
            font-weight: 500;
            color: var(--text-dark);
            word-break: break-word;
            overflow-wrap: break-word;
        }

        .activity-time {
            font-size: 0.85rem;
            color: var(--text-light);
        }

        @media (max-width: 768px) {
            .profile-content {
                grid-template-columns: 1fr;
            }

            .sidebar-card {
                position: static;
            }

            .welcome-banner h1 {
                font-size: 2rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .user-info p {
                font-size: 0.9rem;
            }
        }

        /* Special styling for email to handle very long addresses */
        .email-address {
            font-size: 0.95rem;
            line-height: 1.4;
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="profile-container">
    <div class="welcome-banner">
        <h1>Welcome back, <%= fullName != null ? fullName : "User" %>! 👋</h1>
        <p>Manage your farm data, track crops, and access all your agricultural insights</p>
    </div>

    <div class="profile-content">
        <div class="sidebar-card">
            <div class="user-avatar">
                <%= fullName != null && fullName.length() > 0 ? fullName.substring(0,1).toUpperCase() : "U" %>
            </div>

            <div class="user-info">
                <h2><%= fullName != null ? fullName : "User" %></h2>
                <p class="email-address"><%= email != null ? email : "" %></p>
            </div>

            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number"><%= activeCropsCount %></div>
                    <div class="stat-label">Active Crops</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><%= historyCropsCount %></div>
                    <div class="stat-label">History</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><%= successRate %>%</div>
                    <div class="stat-label">Success Rate</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><%= totalCropsCount %></div>
                    <div class="stat-label">Total Crops</div>
                </div>
            </div>

            <div class="actions-grid">
                <a href="addcrop.jsp" class="btn-action">
                    <div>
                        <i class='bx bx-plus-circle'></i>
                        <span>Add Current Crop</span>
                    </div>
                    <i class='bx bx-chevron-right'></i>
                </a>

                <a href="viewCrops.jsp" class="btn-action">
                    <div>
                        <i class='bx bx-history'></i>
                        <span>View Your Crops</span>
                    </div>
                    <i class='bx bx-chevron-right'></i>
                </a>

                <a href="currentCrop.jsp" class="btn-action">
                    <div>
                        <i class='bx bx-leaf'></i>
                        <span>Current Crops</span>
                    </div>
                    <i class='bx bx-chevron-right'></i>
                </a>

                <a href="historyCrop.jsp" class="btn-action">
                    <div>
                        <i class='bx bx-calendar'></i>
                        <span>Crop History</span>
                    </div>
                    <i class='bx bx-chevron-right'></i>
                </a>
            </div>
        </div>

        <div class="main-content">
            <div class="info-card">
                <h3><i class='bx bxs-user-detail'></i> Profile Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Full Name</div>
                        <div class="info-value"><%= fullName != null ? fullName : "Not available" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email Address</div>
                        <div class="info-value"><%= email != null ? email : "Not available" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Account Type</div>
                        <div class="info-value"><%= accountType %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Member Since</div>
                        <div class="info-value"><%= memberSince %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Last Login</div>
                        <div class="info-value">
                            <%= lastLogin != null ? lastLogin.toString() : new java.util.Date().toString() %>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Account Status</div>
                        <div class="info-value" style="color: var(--primary-color);">
                            <i class='bx bx-check-circle'></i> <%= accountStatus %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-card">
                <h3><i class='bx bxs-time-five'></i> Recent Activity</h3>
                <ul class="recent-activity">
                    <% if (recentActivities.isEmpty()) { %>
                    <li class="activity-item">
                        <div class="activity-icon">
                            <i class='bx bx-info-circle'></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">No recent activities found</div>
                            <div class="activity-time">Start by adding your first crop!</div>
                        </div>
                    </li>
                    <% } else { %>
                    <% for (Map<String, String> activity : recentActivities) { %>
                    <li class="activity-item">
                        <div class="activity-icon">
                            <i class='bx <%= activity.get("action").equals("Added") ? "bx-plus-circle" : "bx-check-circle" %>'></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">
                                <%= activity.get("action") %> <%= activity.get("cropName") %> crop
                            </div>
                            <div class="activity-time"><%= activity.get("date") %></div>
                        </div>
                    </li>
                    <% } %>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    // Update stats with animation
    const stats = document.querySelectorAll('.stat-number');
    stats.forEach(stat => {
        const targetText = stat.textContent.replace('%', '');
        const target = parseInt(targetText);
        if (!isNaN(target)) {
            let current = 0;
            const increment = target / 20;

            const updateStat = () => {
                current += increment;
                if (current < target) {
                    stat.textContent = Math.round(current) + (stat.textContent.includes('%') ? '%' : '');
                    setTimeout(updateStat, 50);
                } else {
                    stat.textContent = target + (stat.textContent.includes('%') ? '%' : '');
                }
            };

            updateStat();
        }
    });
</script>
</body>
</html>