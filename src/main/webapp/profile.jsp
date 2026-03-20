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

    String userEmail = (String) session.getAttribute("userEmail");
    String username = (String) session.getAttribute("username");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String fullName = username;
    String email = userEmail;
    String accountType = "Farmer Account";
    String memberSince = "2024";
    Timestamp lastLogin = null;
    String accountStatus = "Active";

    int activeCropsCount = 0;
    int historyCropsCount = 0;
    int totalCropsCount = 0;
    double successRate = 0;

    List<Map<String, String>> recentActivities = new ArrayList<>();

    try {
        conn = DBConnection.getConnection();

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

        String activeCropsQuery = "SELECT COUNT(*) as count FROM add_crop WHERE username = ?";
        pstmt = conn.prepareStatement(activeCropsQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();
        if (rs.next()) activeCropsCount = rs.getInt("count");
        rs.close();
        pstmt.close();

        String historyCropsQuery = "SELECT COUNT(*) as count FROM history_crop WHERE username = ?";
        pstmt = conn.prepareStatement(historyCropsQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();
        if (rs.next()) historyCropsCount = rs.getInt("count");
        rs.close();
        pstmt.close();

        totalCropsCount = activeCropsCount + historyCropsCount;
        if (totalCropsCount > 0) successRate = Math.round((historyCropsCount * 100.0 / totalCropsCount) * 100) / 100.0;

        String recentActivityQuery = "SELECT 'Added' as action, crop_name, crop_dates as activity_date FROM add_crop WHERE username = ? " +
                "UNION ALL SELECT 'Completed' as action, crop_name, crop_dates as activity_date FROM history_crop WHERE username = ? " +
                "ORDER BY activity_date DESC";

        pstmt = conn.prepareStatement(recentActivityQuery);
        pstmt.setString(1, username);
        pstmt.setString(2, username);
        rs = pstmt.executeQuery();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        int activityCount = 0;

        while (rs.next() && activityCount < 3) {
            Map<String, String> activity = new HashMap<>();
            activity.put("action", rs.getString("action"));
            activity.put("cropName", rs.getString("crop_name") != null ? rs.getString("crop_name") : "Unknown Crop");
            java.sql.Date activityDate = rs.getDate("activity_date");
            activity.put("date", activityDate != null ? dateFormat.format(activityDate) : "Unknown date");
            recentActivities.add(activity);
            activityCount++;
        }
    } catch (Exception e) {
        System.out.println("Database error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
    <title>User Profile | AgroInsights</title>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
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
            overflow-x: hidden;
        }

        .profile-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        @media (max-width: 768px) {
            .profile-container {
                margin: 1rem auto;
            }
        }

        .welcome-banner {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            color: white;
            padding: 2rem;
            border-radius: var(--radius);
            margin-bottom: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        @media (max-width: 768px) {
            .welcome-banner {
                padding: 1.5rem;
            }
        }

        .welcome-banner h1 {
            font-size: clamp(1.3rem, 5vw, 2.5rem);
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .welcome-banner p {
            font-size: clamp(0.8rem, 3vw, 1.1rem);
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        .profile-content {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 2rem;
        }

        @media (max-width: 900px) {
            .profile-content {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
        }

        .sidebar-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            position: sticky;
            top: 2rem;
        }

        @media (max-width: 900px) {
            .sidebar-card {
                position: static;
                padding: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .sidebar-card {
                padding: 1rem;
            }
        }

        .user-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            font-weight: 600;
            box-shadow: 0 8px 25px rgba(46, 125, 50, 0.3);
        }

        @media (max-width: 480px) {
            .user-avatar {
                width: 80px;
                height: 80px;
                font-size: 2rem;
            }
        }

        .user-info {
            width: 100%;
            text-align: center;
        }

        .user-info h2 {
            color: var(--text-dark);
            margin-bottom: 0.3rem;
            font-size: clamp(1.1rem, 4vw, 1.5rem);
            word-break: break-word;
        }

        .user-info p {
            color: var(--text-light);
            margin-bottom: 1.5rem;
            word-break: break-word;
            font-size: clamp(0.75rem, 2.5vw, 0.85rem);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.8rem;
            margin-bottom: 1.5rem;
        }

        .stat-item {
            background: var(--light-bg);
            padding: 0.8rem;
            border-radius: 12px;
            text-align: center;
        }

        .stat-number {
            font-size: clamp(1.1rem, 4vw, 1.5rem);
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.2rem;
        }

        .stat-label {
            font-size: clamp(0.65rem, 2.5vw, 0.75rem);
            color: var(--text-light);
        }

        .actions-grid {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
        }

        .btn-action {
            padding: 0.8rem;
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
            font-size: clamp(0.8rem, 2.5vw, 0.9rem);
        }

        .btn-action:hover {
            background: var(--primary-color);
            color: white;
            transform: translateX(5px);
            border-color: var(--primary-color);
        }

        .main-content {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .info-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
        }

        @media (max-width: 480px) {
            .info-card {
                padding: 1rem;
            }
        }

        .info-card h3 {
            color: var(--text-dark);
            margin-bottom: 1rem;
            font-size: clamp(1rem, 4vw, 1.3rem);
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding-bottom: 0.8rem;
            border-bottom: 2px solid var(--border-color);
            flex-wrap: wrap;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }

        @media (max-width: 600px) {
            .info-grid {
                grid-template-columns: 1fr;
                gap: 0.8rem;
            }
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .info-label {
            color: var(--text-light);
            font-size: clamp(0.7rem, 2.5vw, 0.8rem);
            font-weight: 500;
        }

        .info-value {
            color: var(--text-dark);
            font-size: clamp(0.8rem, 2.5vw, 0.95rem);
            font-weight: 600;
            word-break: break-word;
        }

        .recent-activity {
            list-style: none;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.8rem;
            border-bottom: 1px solid var(--border-color);
            transition: var(--transition);
            flex-wrap: wrap;
        }

        @media (max-width: 480px) {
            .activity-item {
                gap: 0.8rem;
                padding: 0.8rem 0.5rem;
            }
        }

        .activity-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(46, 125, 50, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            flex-shrink: 0;
        }

        @media (max-width: 480px) {
            .activity-icon {
                width: 30px;
                height: 30px;
            }
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            color: var(--text-dark);
            font-size: clamp(0.8rem, 2.5vw, 0.9rem);
            word-break: break-word;
        }

        .activity-time {
            font-size: 0.7rem;
            color: var(--text-light);
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
                    <div><i class='bx bx-plus-circle'></i> <span>Add Current Crop</span></div>
                    <i class='bx bx-chevron-right'></i>
                </a>
                <a href="viewCrops.jsp" class="btn-action">
                    <div><i class='bx bx-history'></i> <span>View Your Crops</span></div>
                    <i class='bx bx-chevron-right'></i>
                </a>
                <a href="currentCrop.jsp" class="btn-action">
                    <div><i class='bx bx-leaf'></i> <span>Current Crops</span></div>
                    <i class='bx bx-chevron-right'></i>
                </a>
                <a href="historyCrop.jsp" class="btn-action">
                    <div><i class='bx bx-calendar'></i> <span>Crop History</span></div>
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
                        <div class="info-value"><%= lastLogin != null ? lastLogin.toString() : new java.util.Date().toString() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Account Status</div>
                        <div class="info-value" style="color: var(--primary-color);"><i class='bx bx-check-circle'></i> <%= accountStatus %></div>
                    </div>
                </div>
            </div>

            <div class="info-card">
                <h3><i class='bx bxs-time-five'></i> Recent Activity</h3>
                <ul class="recent-activity">
                    <% if (recentActivities.isEmpty()) { %>
                    <li class="activity-item">
                        <div class="activity-icon"><i class='bx bx-info-circle'></i></div>
                        <div class="activity-content">
                            <div class="activity-title">No recent activities found</div>
                            <div class="activity-time">Start by adding your first crop!</div>
                        </div>
                    </li>
                    <% } else { %>
                    <% for (Map<String, String> activity : recentActivities) { %>
                    <li class="activity-item">
                        <div class="activity-icon"><i class='bx <%= activity.get("action").equals("Added") ? "bx-plus-circle" : "bx-check-circle" %>'></i></div>
                        <div class="activity-content">
                            <div class="activity-title"><%= activity.get("action") %> <%= activity.get("cropName") %> crop</div>
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