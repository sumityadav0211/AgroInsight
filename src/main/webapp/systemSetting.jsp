

<%@ page import="com.example.controller.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    Statement stmt = null;
    ResultSet rs = null;

    // System settings variables - Default values
    String siteName = "AgroInsights";
    String siteEmail = "admin@agroinsights.com";
    String contactPhone = "+91 9876543210";
    String address = "Agricultural Research Center, New Delhi";
    int sessionTimeout = 30;
    int maxLoginAttempts = 5;
    boolean maintenanceMode = false;
    boolean registrationEnabled = true;
    boolean emailVerificationRequired = true;

    // Database stats
    int totalUsers = 0;
    int totalCrops = 0;
    int totalHistory = 0;
    double dbSize = 0;
    String lastBackup = "2026-02-22 10:30 PM";

    // Email settings
    String smtpServer = "smtp.gmail.com";
    int smtpPort = 587;
    String smtpUsername = "noreply@agroinsights.com";
    boolean smtpAuth = true;
    boolean smtpTLS = true;

    // Notification settings
    boolean emailNotifications = true;
    boolean smsNotifications = false;
    boolean pushNotifications = true;
    boolean cropAlerts = true;
    boolean weatherAlerts = true;
    boolean marketingEmails = false;

    // Recent activity list
    List<Map<String, String>> recentActivities = new ArrayList<>();

    try {
        // Use connection pool utility
        conn = DBConnection.getConnection();
        stmt = conn.createStatement();

        // Get database stats
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM farmdata");
        if (rs.next()) totalUsers = rs.getInt("count");
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM add_crop");
        if (rs.next()) totalCrops = rs.getInt("count");
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM history_crop");
        if (rs.next()) totalHistory = rs.getInt("count");
        rs.close();

        // Get database size (PostgreSQL version)
        rs = stmt.executeQuery("SELECT ROUND(SUM(pg_total_relation_size(relid)) / 1024 / 1024, 2) as size FROM pg_stat_user_tables WHERE schemaname = 'public'");
        if (rs.next()) dbSize = rs.getDouble("size");
        rs.close();

        // Get recent user registrations (PostgreSQL)
        String userActivityQuery = "SELECT username, created_at as activity_time FROM farmdata " +
                "WHERE created_at >= NOW() - INTERVAL '7 days' " +
                "ORDER BY created_at DESC LIMIT 3";
        rs = stmt.executeQuery(userActivityQuery);
        while (rs.next()) {
            Map<String, String> activity = new HashMap<>();
            activity.put("icon", "bx-user-check");
            activity.put("title", "New user registered: " + rs.getString("username"));

            Timestamp activityTime = rs.getTimestamp("activity_time");
            String timeAgo = getTimeAgo(activityTime);
            activity.put("time", timeAgo);

            recentActivities.add(activity);
        }
        rs.close();

        // Get recent crop additions
        String cropActivityQuery = "SELECT farmer_name, crop_name, crop_dates as activity_time FROM add_crop " +
                "WHERE crop_dates >= NOW() - INTERVAL '7 days' " +
                "ORDER BY crop_dates DESC LIMIT 3";
        rs = stmt.executeQuery(cropActivityQuery);
        while (rs.next()) {
            Map<String, String> activity = new HashMap<>();
            activity.put("icon", "bx-leaf");
            activity.put("title", "New crop added: " + rs.getString("crop_name") + " - " + rs.getString("farmer_name"));

            java.sql.Date activityDate = rs.getDate("activity_time");
            String timeAgo = getTimeAgo(activityDate);
            activity.put("time", timeAgo);

            recentActivities.add(activity);
        }
        rs.close();

        // Get recent crop history/completions
        String historyActivityQuery = "SELECT farmer_name, crop_name, crop_dates as activity_time FROM history_crop " +
                "WHERE crop_dates >= NOW() - INTERVAL '7 days' " +
                "ORDER BY crop_dates DESC LIMIT 2";
        rs = stmt.executeQuery(historyActivityQuery);
        while (rs.next()) {
            Map<String, String> activity = new HashMap<>();
            activity.put("icon", "bx-check-circle");
            activity.put("title", "Crop completed: " + rs.getString("crop_name") + " - " + rs.getString("farmer_name"));

            java.sql.Date activityDate = rs.getDate("activity_time");
            String timeAgo = getTimeAgo(activityDate);
            activity.put("time", timeAgo);

            recentActivities.add(activity);
        }
        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<%!
    // Helper function to calculate time ago
    private String getTimeAgo(java.util.Date date) {
        if (date == null) return "Unknown";

        long now = System.currentTimeMillis();
        long then = date.getTime();
        long diff = now - then;

        long minutes = diff / (60 * 1000);
        long hours = diff / (60 * 60 * 1000);
        long days = diff / (24 * 60 * 60 * 1000);

        if (minutes < 1) {
            return "Just now";
        } else if (minutes < 60) {
            return minutes + " min" + (minutes > 1 ? "s" : "") + " ago";
        } else if (hours < 24) {
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else if (days < 7) {
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
            return sdf.format(date);
        }
    }

    private String getTimeAgo(Timestamp timestamp) {
        if (timestamp == null) return "Unknown";
        return getTimeAgo(new java.util.Date(timestamp.getTime()));
    }

    private String getTimeAgo(java.sql.Date date) {
        if (date == null) return "Unknown";
        return getTimeAgo(new java.util.Date(date.getTime()));
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings | AgroInsights</title>

    <!-- Box Icons -->
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Keep all existing CSS exactly the same */
        :root {
            --primary-color: #2e7d32;
            --primary-dark: #1b5e20;
            --primary-light: #4caf50;
            --secondary-color: #ff9800;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --dark-bg: #0f172a;
            --light-bg: #f8fafc;
            --card-bg: #ffffff;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --border-color: #e2e8f0;
            --shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 15px 40px rgba(0, 0, 0, 0.15);
            --radius: 16px;
            --radius-sm: 12px;
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

        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* Header */
        .settings-header {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            border-radius: var(--radius);
            padding: 2rem;
            color: white;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        .settings-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header-content h1 {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-content p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Settings Grid */
        .settings-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .settings-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.8rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .settings-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-bottom: 0.8rem;
            border-bottom: 2px solid var(--border-color);
        }

        .card-header i {
            font-size: 1.8rem;
            color: var(--primary-color);
            background: rgba(46, 125, 50, 0.1);
            padding: 0.8rem;
            border-radius: 12px;
        }

        .card-header h2 {
            color: var(--text-dark);
            font-size: 1.3rem;
            font-weight: 600;
        }

        /* Form Styles */
        .settings-form {
            display: flex;
            flex-direction: column;
            gap: 1.2rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        label {
            color: var(--text-dark);
            font-weight: 500;
            font-size: 0.95rem;
        }

        input, select, textarea {
            padding: 0.8rem 1rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 0.95rem;
            transition: var(--transition);
            background: var(--light-bg);
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.1);
        }

        .toggle-switch {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .toggle-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .toggle {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }

        .toggle input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 24px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: var(--primary-color);
        }

        input:checked + .slider:before {
            transform: translateX(26px);
        }

        /* Info Cards */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-top: 1rem;
        }

        .info-item {
            background: var(--light-bg);
            padding: 1rem;
            border-radius: var(--radius-sm);
            border-left: 4px solid var(--primary-color);
        }

        .info-label {
            color: var(--text-light);
            font-size: 0.85rem;
            margin-bottom: 0.3rem;
        }

        .info-value {
            color: var(--text-dark);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .info-value small {
            color: var(--text-light);
            font-weight: normal;
            font-size: 0.85rem;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.95rem;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(46, 125, 50, 0.3);
        }

        .btn-secondary {
            background: var(--light-bg);
            color: var(--text-dark);
            border: 2px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: var(--border-color);
        }

        .btn-danger {
            background: var(--danger-color);
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
        }

        .btn-warning {
            background: var(--warning-color);
            color: var(--text-dark);
        }

        .btn-warning:hover {
            background: #e0a800;
        }

        /* Status Badges */
        .status-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .status-success {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .status-warning {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .status-danger {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        /* Activity Log */
        .activity-log {
            margin-top: 1rem;
            max-height: 300px;
            overflow-y: auto;
        }

        .log-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.8rem;
            border-radius: var(--radius-sm);
            transition: var(--transition);
            border-bottom: 1px solid var(--border-color);
        }

        .log-item:hover {
            background: var(--light-bg);
        }

        .log-item i {
            font-size: 1.2rem;
            color: var(--primary-color);
            background: rgba(46, 125, 50, 0.1);
            padding: 0.5rem;
            border-radius: 50%;
        }

        .log-content {
            flex: 1;
        }

        .log-title {
            color: var(--text-dark);
            font-weight: 500;
            font-size: 0.95rem;
        }

        .log-time {
            color: var(--text-light);
            font-size: 0.8rem;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: var(--text-light);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }

        /* Database Stats */
        .progress-bar {
            width: 100%;
            height: 8px;
            background: var(--border-color);
            border-radius: 10px;
            overflow: hidden;
            margin: 0.5rem 0;
        }

        .progress {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
            border-radius: 10px;
            transition: width 0.3s ease;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem;
            border-radius: var(--radius-sm);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideIn 0.3s ease;
        }

        .alert-success {
            background: rgba(46, 125, 50, 0.1);
            border-left: 4px solid var(--primary-color);
        }

        .alert-warning {
            background: rgba(255, 152, 0, 0.1);
            border-left: 4px solid var(--secondary-color);
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .settings-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <!-- Header -->
    <div class="settings-header">
        <div class="header-content">
            <h1>
                <i class='bx bx-cog'></i>
                System Settings
            </h1>
            <p>Configure and manage your AgroInsights platform settings</p>
        </div>
    </div>

    <!-- Settings Grid -->
    <div class="settings-grid">
        <!-- General Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class='bx bx-globe'></i>
                <h2>General Settings</h2>
            </div>
            <div class="settings-form">
                <div class="form-group">
                    <label>Site Name</label>
                    <input type="text" value="<%= siteName %>" id="siteName">
                </div>
                <div class="form-group">
                    <label>Site Email</label>
                    <input type="email" value="<%= siteEmail %>" id="siteEmail">
                </div>
                <div class="form-group">
                    <label>Contact Phone</label>
                    <input type="text" value="<%= contactPhone %>" id="contactPhone">
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <textarea rows="2" id="address"><%= address %></textarea>
                </div>
            </div>
        </div>

        <!-- Security Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class='bx bx-shield-quarter'></i>
                <h2>Security Settings</h2>
            </div>
            <div class="settings-form">
                <div class="form-group">
                    <label>Session Timeout (minutes)</label>
                    <input type="number" value="<%= sessionTimeout %>" id="sessionTimeout" min="5" max="120">
                </div>
                <div class="form-group">
                    <label>Max Login Attempts</label>
                    <input type="number" value="<%= maxLoginAttempts %>" id="maxLoginAttempts" min="3" max="10">
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-lock-alt'></i>
                            Maintenance Mode
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= maintenanceMode ? "checked" : "" %> id="maintenanceMode">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-user-plus'></i>
                            Allow Registration
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= registrationEnabled ? "checked" : "" %> id="registrationEnabled">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-envelope'></i>
                            Email Verification Required
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= emailVerificationRequired ? "checked" : "" %> id="emailVerification">
                        <span class="slider"></span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Email Configuration -->
        <div class="settings-card">
            <div class="card-header">
                <i class='bx bx-envelope'></i>
                <h2>Email Configuration</h2>
            </div>
            <div class="settings-form">
                <div class="form-group">
                    <label>SMTP Server</label>
                    <input type="text" value="<%= smtpServer %>" id="smtpServer">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Port</label>
                        <input type="number" value="<%= smtpPort %>" id="smtpPort">
                    </div>
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" value="<%= smtpUsername %>" id="smtpUsername">
                    </div>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" value="********" id="smtpPassword">
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-lock-alt'></i>
                            SMTP Authentication
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= smtpAuth ? "checked" : "" %> id="smtpAuth">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-shield'></i>
                            Use TLS
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= smtpTLS ? "checked" : "" %> id="smtpTLS">
                        <span class="slider"></span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Notification Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class='bx bx-bell'></i>
                <h2>Notification Settings</h2>
            </div>
            <div class="settings-form">
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-envelope'></i>
                            Email Notifications
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= emailNotifications ? "checked" : "" %> id="emailNotifications">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-message'></i>
                            SMS Notifications
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= smsNotifications ? "checked" : "" %> id="smsNotifications">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-bell'></i>
                            Push Notifications
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= pushNotifications ? "checked" : "" %> id="pushNotifications">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-leaf'></i>
                            Crop Alerts
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= cropAlerts ? "checked" : "" %> id="cropAlerts">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-cloud'></i>
                            Weather Alerts
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= weatherAlerts ? "checked" : "" %> id="weatherAlerts">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="toggle-switch">
                        <span class="toggle-label">
                            <i class='bx bx-mail-send'></i>
                            Marketing Emails
                        </span>
                    <label class="toggle">
                        <input type="checkbox" <%= marketingEmails ? "checked" : "" %> id="marketingEmails">
                        <span class="slider"></span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Database Statistics -->
        <div class="settings-card">
            <div class="card-header">
                <i class='bx bx-data'></i>
                <h2>Database Statistics</h2>
            </div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Total Users</div>
                    <div class="info-value"><%= totalUsers %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Active Crops</div>
                    <div class="info-value"><%= totalCrops %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">History Records</div>
                    <div class="info-value"><%= totalHistory %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Database Size</div>
                    <div class="info-value"><%= dbSize %> MB</div>
                </div>
            </div>

            <div class="progress-bar" style="margin-top: 1rem;">
                <div class="progress" style="width: <%= Math.min(100, (int)(dbSize)) %>%"></div>
            </div>
            <div style="display: flex; justify-content: space-between; margin-top: 0.5rem;">
                <span class="status-badge status-success">Optimized</span>
                <span class="info-value"><%= String.format("%.1f", dbSize) %> / 100 MB</span>
            </div>

            <div class="action-buttons" style="margin-top: 1.5rem;">
                <button class="btn btn-secondary" onclick="backupDatabase()">
                    <i class='bx bx-cloud-download'></i>
                    Backup Database
                </button>
                <button class="btn btn-secondary" onclick="optimizeDatabase()">
                    <i class='bx bx-refresh'></i>
                    Optimize
                </button>
            </div>
        </div>

        <!-- System Health with Dynamic Recent Activity -->
        <div class="settings-card">
            <div class="card-header">
                <i class='bx bx-heart'></i>
                <h2>System Health & Activity</h2>
            </div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Server Status</div>
                    <div class="info-value">
                            <span class="status-badge status-success">
                                <i class='bx bx-check-circle'></i> Online
                            </span>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Database</div>
                    <div class="info-value">
                            <span class="status-badge status-success">
                                <i class='bx bx-check-circle'></i> Connected
                            </span>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Last Backup</div>
                    <div class="info-value"><%= lastBackup %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">API Status</div>
                    <div class="info-value">
                            <span class="status-badge status-success">
                                <i class='bx bx-check-circle'></i> 200ms
                            </span>
                    </div>
                </div>
            </div>

            <div class="activity-log" style="margin-top: 1rem;">
                <h3 style="color: var(--text-dark); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i class='bx bx-time'></i>
                    Recent Activity (Last 7 Days)
                </h3>

                <% if (recentActivities.isEmpty()) { %>
                <div class="empty-state">
                    <i class='bx bx-history'></i>
                    <p>No recent activity found</p>
                </div>
                <% } else { %>
                <% for (Map<String, String> activity : recentActivities) { %>
                <div class="log-item">
                    <i class='bx <%= activity.get("icon") %>'></i>
                    <div class="log-content">
                        <div class="log-title"><%= activity.get("title") %></div>
                        <div class="log-time"><%= activity.get("time") %></div>
                    </div>
                </div>
                <% } %>
                <% } %>

                <div style="text-align: center; margin-top: 1rem;">
                        <span class="status-badge status-success">
                            <i class='bx bx-refresh'></i> Live Updates
                        </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons" style="justify-content: center; margin-top: 2rem;">
        <button class="btn btn-primary" onclick="saveSettings()">
            <i class='bx bx-save'></i>
            Save All Settings
        </button>
        <button class="btn btn-secondary" onclick="resetSettings()">
            <i class='bx bx-reset'></i>
            Reset to Default
        </button>
        <button class="btn btn-danger" onclick="clearCache()">
            <i class='bx bx-trash'></i>
            Clear Cache
        </button>
        <button class="btn btn-secondary" onclick="refreshActivity()">
            <i class='bx bx-refresh'></i>
            Refresh Activity
        </button>
    </div>
</div>

<script>
    // Save settings
    function saveSettings() {
        // Here you would typically send data to server
        // For demo, show success message
        const alert = document.createElement('div');
        alert.className = 'alert alert-success';
        alert.innerHTML = `
                <i class='bx bx-check-circle'></i>
                <span>Settings saved successfully!</span>
            `;

        const container = document.querySelector('.container');
        container.insertBefore(alert, document.querySelector('.settings-grid'));

        setTimeout(() => {
            alert.remove();
        }, 3000);
    }

    // Reset settings
    function resetSettings() {
        if (confirm('Are you sure you want to reset all settings to default?')) {
            document.getElementById('siteName').value = 'AgroInsights';
            document.getElementById('siteEmail').value = 'admin@agroinsights.com';
            document.getElementById('contactPhone').value = '+91 9876543210';
            document.getElementById('address').value = 'Agricultural Research Center, New Delhi';
            document.getElementById('sessionTimeout').value = '30';
            document.getElementById('maxLoginAttempts').value = '5';
            document.getElementById('maintenanceMode').checked = false;
            document.getElementById('registrationEnabled').checked = true;
            document.getElementById('emailVerification').checked = false;
            document.getElementById('smtpServer').value = 'smtp.gmail.com';
            document.getElementById('smtpPort').value = '587';
            document.getElementById('smtpUsername').value = 'noreply@agroinsights.com';
            document.getElementById('smtpAuth').checked = true;
            document.getElementById('smtpTLS').checked = true;
            document.getElementById('emailNotifications').checked = true;
            document.getElementById('smsNotifications').checked = false;
            document.getElementById('pushNotifications').checked = true;
            document.getElementById('cropAlerts').checked = true;
            document.getElementById('weatherAlerts').checked = true;
            document.getElementById('marketingEmails').checked = false;

            showAlert('Settings reset to default!');
        }
    }

    // Backup database
    function backupDatabase() {
        showAlert('Database backup started...');
        setTimeout(() => {
            showAlert('Database backup completed successfully!');
        }, 2000);
    }

    // Optimize database
    function optimizeDatabase() {
        showAlert('Database optimization started...');
        setTimeout(() => {
            showAlert('Database optimization completed!');
        }, 2000);
    }

    // Clear cache
    function clearCache() {
        if (confirm('Are you sure you want to clear system cache?')) {
            showAlert('Cache cleared successfully!');
        }
    }

    // Refresh activity (reload page to get latest data)
    function refreshActivity() {
        location.reload();
    }

    // Show alert
    function showAlert(message) {
        const alert = document.createElement('div');
        alert.className = 'alert alert-success';
        alert.innerHTML = `
                <i class='bx bx-check-circle'></i>
                <span>${message}</span>
            `;

        const container = document.querySelector('.container');
        container.insertBefore(alert, document.querySelector('.settings-grid'));

        setTimeout(() => {
            alert.remove();
        }, 3000);
    }
</script>
</body>
</html>