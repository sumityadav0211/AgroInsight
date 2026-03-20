<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.example.controller.DBConnection" %>

<%
    if (session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Database connection variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    List<Map<String, Object>> allUsers = new ArrayList<>();
    List<Map<String, Object>> allCurrentCrops = new ArrayList<>();
    List<Map<String, Object>> allHistoryCrops = new ArrayList<>();

    int totalUsers = 0;
    int totalCurrentCrops = 0;
    int totalHistoryCrops = 0;
    double totalFarmArea = 0;
    int verifiedUsers = 0;

    Map<String, Integer> cropCount = new HashMap<>();
    Map<String, Double> cropArea = new HashMap<>();

    int[] monthlyData = new int[12];

    try {
        conn = DBConnection.getConnection();

        String userQuery = "SELECT id, username, email, email_verified, created_at FROM farmdata ORDER BY created_at DESC";
        pstmt = conn.prepareStatement(userQuery);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> user = new HashMap<>();
            user.put("id", rs.getInt("id"));
            user.put("username", rs.getString("username"));
            user.put("email", rs.getString("email"));
            user.put("email_verified", rs.getBoolean("email_verified"));
            user.put("created_at", rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString() : "");
            allUsers.add(user);
            totalUsers++;
            if (rs.getBoolean("email_verified")) verifiedUsers++;
        }
        rs.close();
        pstmt.close();

        String currentQuery = "SELECT * FROM add_crop ORDER BY crop_dates DESC";
        pstmt = conn.prepareStatement(currentQuery);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> crop = new HashMap<>();
            crop.put("id", rs.getInt("id"));
            crop.put("username", rs.getString("username"));
            crop.put("farmer_name", rs.getString("farmer_name"));
            crop.put("farm_area", rs.getDouble("farm_area"));
            crop.put("crop_name", rs.getString("crop_name"));
            crop.put("contact_number", rs.getString("contact_number"));
            crop.put("crop_dates", rs.getDate("crop_dates") != null ? rs.getDate("crop_dates").toString() : "");
            crop.put("period", rs.getInt("period"));
            allCurrentCrops.add(crop);
            totalCurrentCrops++;
            totalFarmArea += rs.getDouble("farm_area");
            String cropName = rs.getString("crop_name");
            cropCount.put(cropName, cropCount.getOrDefault(cropName, 0) + 1);
            cropArea.put(cropName, cropArea.getOrDefault(cropName, 0.0) + rs.getDouble("farm_area"));
            java.sql.Date cropDateSql = rs.getDate("crop_dates");
            if (cropDateSql != null) {
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(cropDateSql);
                int month = cal.get(java.util.Calendar.MONTH);
                monthlyData[month]++;
            }
        }
        rs.close();
        pstmt.close();

        String historyQuery = "SELECT * FROM history_crop ORDER BY crop_dates DESC";
        pstmt = conn.prepareStatement(historyQuery);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> crop = new HashMap<>();
            crop.put("id", rs.getInt("id"));
            crop.put("username", rs.getString("username"));
            crop.put("farmer_name", rs.getString("farmer_name"));
            crop.put("farm_area", rs.getDouble("farm_area"));
            crop.put("crop_name", rs.getString("crop_name"));
            crop.put("contact_number", rs.getString("contact_number"));
            crop.put("crop_dates", rs.getDate("crop_dates") != null ? rs.getDate("crop_dates").toString() : "");
            crop.put("period", rs.getInt("period"));
            allHistoryCrops.add(crop);
            totalHistoryCrops++;
        }
        rs.close();
        pstmt.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    Set<String> activeUsernames = new HashSet<>();
    for (Map<String, Object> crop : allCurrentCrops) {
        activeUsernames.add((String) crop.get("username"));
    }
    int activeUsers = activeUsernames.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
    <title>Farm Analytics Dashboard | AgroInsights</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
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
            overflow-x: hidden;
        }

        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        @media (max-width: 768px) {
            .container {
                margin: 1rem auto;
                padding: 0 1rem;
            }
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            border-radius: var(--radius);
            padding: 2rem;
            color: white;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        @media (max-width: 768px) {
            .header-section {
                padding: 1.5rem;
            }
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            z-index: 1;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .header-title h1 {
            font-size: clamp(1.3rem, 5vw, 2.5rem);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .header-title p {
            font-size: clamp(0.8rem, 3vw, 1.1rem);
            opacity: 0.9;
        }

        .date-badge {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            padding: 0.8rem 1.5rem;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: clamp(0.8rem, 2.5vw, 1rem);
        }

        @media (max-width: 600px) {
            .date-badge {
                padding: 0.5rem 1rem;
                font-size: 0.75rem;
            }
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 600px) {
            .stats-grid {
                gap: 1rem;
            }
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.2rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.8rem;
        }

        .stat-icon {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: rgba(46, 125, 50, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            color: var(--primary-color);
        }

        @media (max-width: 480px) {
            .stat-icon {
                width: 35px;
                height: 35px;
                font-size: 1rem;
            }
        }

        .stat-value {
            font-size: clamp(1.3rem, 5vw, 2rem);
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.2rem;
        }

        .stat-label {
            color: var(--text-light);
            font-size: clamp(0.7rem, 2.5vw, 0.85rem);
        }

        .selection-section {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
        }

        @media (max-width: 768px) {
            .selection-section {
                padding: 1rem;
            }
        }

        .selection-controls {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 1rem;
            align-items: center;
        }

        @media (max-width: 768px) {
            .selection-controls {
                grid-template-columns: 1fr;
                gap: 0.8rem;
            }
        }

        .user-dropdown {
            position: relative;
        }

        .user-dropdown select {
            width: 100%;
            padding: 0.8rem 1rem 0.8rem 2.5rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: clamp(0.8rem, 2.5vw, 0.9rem);
            background: var(--light-bg);
            cursor: pointer;
            transition: var(--transition);
            appearance: none;
        }

        .user-dropdown i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            pointer-events: none;
        }

        .download-btn {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: clamp(0.8rem, 2.5vw, 0.9rem);
            white-space: nowrap;
        }

        @media (max-width: 600px) {
            .download-btn span {
                display: none;
            }
            .download-btn {
                padding: 0.8rem;
                justify-content: center;
            }
        }

        .btn-all {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
        }

        .btn-selected {
            background: var(--secondary-color);
            color: white;
        }

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 1024px) {
            .chart-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
        }

        .chart-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.2rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border-color);
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .chart-header h3 {
            color: var(--text-dark);
            font-size: clamp(0.9rem, 3vw, 1.1rem);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        canvas {
            max-height: 250px;
            width: 100% !important;
        }

        .tables-section {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
        }

        @media (max-width: 768px) {
            .tables-section {
                padding: 1rem;
            }
        }

        .section-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 0.5rem;
            flex-wrap: wrap;
        }

        .tab-btn {
            padding: 0.6rem 1.2rem;
            background: transparent;
            border: none;
            color: var(--text-light);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-radius: var(--radius-sm);
            font-size: clamp(0.75rem, 2.5vw, 0.85rem);
        }

        @media (max-width: 480px) {
            .tab-btn {
                padding: 0.5rem 0.8rem;
            }
            .tab-btn span {
                display: none;
            }
        }

        .tab-btn.active {
            color: var(--primary-color);
            background: rgba(46, 125, 50, 0.1);
            font-weight: 600;
        }

        .table-container {
            overflow-x: auto;
            max-height: 400px;
            overflow-y: auto;
            border-radius: var(--radius-sm);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }

        th {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            color: white;
            padding: 0.8rem 1rem;
            text-align: left;
            font-weight: 600;
            font-size: clamp(0.7rem, 2.5vw, 0.85rem);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        td {
            padding: 0.8rem 1rem;
            border-bottom: 1px solid var(--border-color);
            font-size: clamp(0.75rem, 2.5vw, 0.85rem);
        }

        .badge {
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            font-size: 0.7rem;
            font-weight: 500;
            display: inline-block;
        }

        .badge-success {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .badge-warning {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .export-options {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }

        .export-btn {
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: clamp(0.75rem, 2.5vw, 0.85rem);
        }

        @media (max-width: 480px) {
            .export-btn {
                flex: 1;
                justify-content: center;
            }
        }

        .export-pdf {
            background: var(--danger-color);
            color: white;
        }

        .export-excel {
            background: var(--primary-color);
            color: white;
        }

        .export-print {
            background: var(--info-color);
            color: white;
        }

        .spinner {
            border: 4px solid rgba(0, 0, 0, 0.1);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border-left-color: var(--primary-color);
            animation: spin 1s linear infinite;
            margin: 20px auto;
            display: none;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .alert {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 1.5rem;
            border-radius: var(--radius-sm);
            background: white;
            box-shadow: var(--shadow-hover);
            display: flex;
            align-items: center;
            gap: 1rem;
            z-index: 1000;
            animation: slideIn 0.3s ease;
            max-width: 350px;
            width: calc(100% - 40px);
        }

        @media (max-width: 480px) {
            .alert {
                left: 20px;
                right: 20px;
                max-width: none;
            }
        }

        .alert-success {
            border-left: 4px solid var(--primary-color);
        }

        .alert-error {
            border-left: 4px solid var(--danger-color);
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="header-section">
        <div class="header-content">
            <div class="header-title">
                <h1><i class='bx bx-bar-chart-alt-2'></i> Farm Analytics Dashboard</h1>
                <p>Comprehensive insights and statistics for all farm operations</p>
            </div>
            <div class="date-badge">
                <i class='bx bx-calendar'></i>
                <%= new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %>
            </div>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-header">
                <div class="stat-icon"><i class='bx bxs-user'></i></div>
                <span class="stat-trend trend-up"><i class='bx bx-trending-up'></i> +12%</span>
            </div>
            <div class="stat-value"><%= totalUsers %></div>
            <div class="stat-label">Total Registered Users</div>
            <div class="stat-trend"><i class='bx bx-check-circle' style="color: var(--primary-color);"></i> <%= verifiedUsers %> Verified</div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div class="stat-icon"><i class='bx bxs-leaf'></i></div>
                <span class="stat-trend trend-up"><i class='bx bx-trending-up'></i> +8%</span>
            </div>
            <div class="stat-value"><%= totalCurrentCrops %></div>
            <div class="stat-label">Active Crops</div>
            <div class="stat-trend"><i class='bx bx-area' style="color: var(--primary-color);"></i> <%= String.format("%.1f", totalFarmArea) %> acres</div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div class="stat-icon"><i class='bx bxs-history'></i></div>
                <span class="stat-trend trend-up"><i class='bx bx-trending-up'></i> +24%</span>
            </div>
            <div class="stat-value"><%= totalHistoryCrops %></div>
            <div class="stat-label">Historical Records</div>
            <div class="stat-trend"><i class='bx bx-check-double' style="color: var(--primary-color);"></i> Completed Crops</div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div class="stat-icon"><i class='bx bxs-calendar'></i></div>
                <span class="stat-trend trend-up"><i class='bx bx-trending-up'></i> +5%</span>
            </div>
            <div class="stat-value"><%= totalUsers > 0 ? String.format("%.1f", (double)totalCurrentCrops / totalUsers) : 0 %></div>
            <div class="stat-label">Avg Crops per User</div>
            <div class="stat-trend"><i class='bx bx-user' style="color: var(--primary-color);"></i> Per Farmer Average</div>
        </div>
    </div>

    <div class="selection-section">
        <div class="selection-header" style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
            <i class='bx bx-filter-alt' style="font-size: 1.3rem; color: var(--primary-color);"></i>
            <h2 style="font-size: clamp(1rem, 4vw, 1.3rem);">Generate Custom Reports</h2>
        </div>

        <div class="selection-controls">
            <div class="user-dropdown">
                <i class='bx bx-user'></i>
                <select id="userSelect">
                    <option value="all">All Users (Complete System Data)</option>
                    <% for (Map<String, Object> user : allUsers) { %>
                    <option value="<%= user.get("username") %>"><%= user.get("username") %> - <%= user.get("email") %></option>
                    <% } %>
                </select>
            </div>
            <button class="download-btn btn-all" onclick="downloadAllData()"><i class='bx bx-download'></i><span>Download All Data</span></button>
            <button class="download-btn btn-selected" onclick="downloadSelectedUser()"><i class='bx bx-user-download'></i><span>Download Selected</span></button>
        </div>

        <div class="export-options">
            <button class="export-btn export-pdf" onclick="exportCurrentViewPDF()"><i class='bx bxs-file-pdf'></i> PDF</button>
            <button class="export-btn export-excel" onclick="exportCurrentViewExcel()"><i class='bx bxs-spreadsheet'></i> Excel</button>
            <button class="export-btn export-print" onclick="window.print()"><i class='bx bx-printer'></i> Print</button>
        </div>
    </div>

    <div class="chart-grid">
        <div class="chart-card">
            <div class="chart-header"><h3><i class='bx bx-pie-chart-alt-2'></i> Crop Distribution</h3></div>
            <canvas id="cropDistributionChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-header"><h3><i class='bx bx-line-chart'></i> Monthly Crop Additions</h3></div>
            <canvas id="monthlyTrendChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-header"><h3><i class='bx bx-bar-chart-alt'></i> Top 5 Crops by Area</h3></div>
            <canvas id="topCropsChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-header"><h3><i class='bx bx-doughnut-chart'></i> User Activity Ratio</h3></div>
            <canvas id="userActivityChart"></canvas>
        </div>
    </div>

    <div class="tables-section">
        <div class="section-tabs">
            <button class="tab-btn active" onclick="switchTable('users')" id="tabUsers"><i class='bx bxs-user-detail'></i><span>Users (<%= totalUsers %>)</span></button>
            <button class="tab-btn" onclick="switchTable('current')" id="tabCurrent"><i class='bx bxs-leaf'></i><span>Current Crops (<%= totalCurrentCrops %>)</span></button>
            <button class="tab-btn" onclick="switchTable('history')" id="tabHistory"><i class='bx bxs-history'></i><span>History Crops (<%= totalHistoryCrops %>)</span></button>
        </div>

        <div id="usersTable" class="table-container">
            <table>
                <thead><tr><th>Username</th><th>Email</th><th>Status</th><th>Registered On</th><th>Crops Count</th></tr></thead>
                <tbody>
                <% for (Map<String, Object> user : allUsers) {
                    String username = (String) user.get("username");
                    int userCropCount = 0;
                    for (Map<String, Object> crop : allCurrentCrops) {
                        if (username.equals(crop.get("username"))) userCropCount++;
                    }
                %>
                <tr><td><strong><%= username %></strong></td><td><%= user.get("email") %></td><td><span class="badge badge-success"><i class='bx bx-check-circle'></i> Verified</span></td><td><%= user.get("created_at") %></td><td><%= userCropCount %></td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div id="currentTable" class="table-container" style="display: none;">
            <table>
                <thead><tr><th>Farmer Name</th><th>Username</th><th>Crop</th><th>Area (acres)</th><th>Contact</th><th>Planted On</th><th>Period</th></tr></thead>
                <tbody>
                <% for (Map<String, Object> crop : allCurrentCrops) { %>
                <tr><td><strong><%= crop.get("farmer_name") %></strong></td><td><%= crop.get("username") %></td><td><%= crop.get("crop_name") %></td><td><%= String.format("%.1f", crop.get("farm_area")) %></td><td><%= crop.get("contact_number") %></td><td><%= crop.get("crop_dates") %></td><td><%= crop.get("period") %> months</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div id="historyTable" class="table-container" style="display: none;">
            <table>
                <thead><tr><th>Farmer Name</th><th>Username</th><th>Crop</th><th>Area (acres)</th><th>Contact</th><th>Planted On</th><th>Period</th><th>Status</th></tr></thead>
                <tbody>
                <% for (Map<String, Object> crop : allHistoryCrops) { %>
                <tr><td><strong><%= crop.get("farmer_name") %></strong></td><td><%= crop.get("username") %></td><td><%= crop.get("crop_name") %></td><td><%= String.format("%.1f", crop.get("farm_area")) %></td><td><%= crop.get("contact_number") %></td><td><%= crop.get("crop_dates") %></td><td><%= crop.get("period") %> months</td><td><span class="badge badge-warning">Completed</span></td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="alertContainer"></div>
<div class="spinner" id="loadingSpinner"></div>

<script>
    const cropLabels = [<% int idx = 0; for (Map.Entry<String, Integer> entry : cropCount.entrySet()) { if (idx++ > 0) out.print(","); out.print("'" + entry.getKey() + "'"); } %>];
    const cropData = [<% idx = 0; for (Map.Entry<String, Integer> entry : cropCount.entrySet()) { if (idx++ > 0) out.print(","); out.print(entry.getValue()); } %>];
    const cropAreaLabels = []; const cropAreaValues = [];
    <% List<Map.Entry<String, Double>> sortedAreas = new ArrayList<>(cropArea.entrySet()); Collections.sort(sortedAreas, (a, b) -> b.getValue().compareTo(a.getValue())); int limit = Math.min(5, sortedAreas.size()); for (int i = 0; i < limit; i++) { Map.Entry<String, Double> entry = sortedAreas.get(i); %> cropAreaLabels.push('<%= entry.getKey() %>'); cropAreaValues.push(<%= entry.getValue() %>); <% } %>
    const monthlyData = [<%= monthlyData[0] %>, <%= monthlyData[1] %>, <%= monthlyData[2] %>, <%= monthlyData[3] %>, <%= monthlyData[4] %>, <%= monthlyData[5] %>, <%= monthlyData[6] %>, <%= monthlyData[7] %>, <%= monthlyData[8] %>, <%= monthlyData[9] %>, <%= monthlyData[10] %>, <%= monthlyData[11] %>];
    const activeUsers = <%= activeUsers %>; const inactiveUsers = <%= totalUsers - activeUsers %>;
    const allUsersData = [<% for (int i = 0; i < allUsers.size(); i++) { Map<String, Object> user = allUsers.get(i); if (i > 0) out.print(","); %> { username: '<%= user.get("username") %>', email: '<%= user.get("email") %>', email_verified: <%= user.get("email_verified") %>, created_at: '<%= user.get("created_at") %>' } <% } %>];
    const allCurrentCropsData = [<% for (int i = 0; i < allCurrentCrops.size(); i++) { Map<String, Object> crop = allCurrentCrops.get(i); if (i > 0) out.print(","); %> { farmer_name: '<%= crop.get("farmer_name") %>', username: '<%= crop.get("username") %>', crop_name: '<%= crop.get("crop_name") %>', farm_area: <%= crop.get("farm_area") %>, contact_number: '<%= crop.get("contact_number") %>', crop_dates: '<%= crop.get("crop_dates") %>', period: <%= crop.get("period") %> } <% } %>];
    const allHistoryCropsData = [<% for (int i = 0; i < allHistoryCrops.size(); i++) { Map<String, Object> crop = allHistoryCrops.get(i); if (i > 0) out.print(","); %> { farmer_name: '<%= crop.get("farmer_name") %>', username: '<%= crop.get("username") %>', crop_name: '<%= crop.get("crop_name") %>', farm_area: <%= crop.get("farm_area") %>, contact_number: '<%= crop.get("contact_number") %>', crop_dates: '<%= crop.get("crop_dates") %>', period: <%= crop.get("period") %> } <% } %>];
    const summaryData = { totalUsers: <%= totalUsers %>, totalCurrentCrops: <%= totalCurrentCrops %>, totalHistoryCrops: <%= totalHistoryCrops %>, totalFarmArea: <%= totalFarmArea %>, verifiedUsers: <%= verifiedUsers %> };

    let charts = {};

    document.addEventListener('DOMContentLoaded', function() {
        initializeCharts();
    });

    function initializeCharts() {
        const cropCtx = document.getElementById('cropDistributionChart').getContext('2d');
        charts.crop = new Chart(cropCtx, { type: 'doughnut', data: { labels: cropLabels, datasets: [{ data: cropData, backgroundColor: ['#2e7d32', '#ff9800', '#2196f3', '#9c27b0', '#f44336', '#009688', '#795548'] }] }, options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { position: 'bottom', labels: { font: { size: window.innerWidth < 768 ? 10 : 12 } } } } } });
        const areaCtx = document.getElementById('topCropsChart').getContext('2d');
        charts.area = new Chart(areaCtx, { type: 'bar', data: { labels: cropAreaLabels, datasets: [{ label: 'Area (acres)', data: cropAreaValues, backgroundColor: '#2e7d32', borderRadius: 5 }] }, options: { responsive: true, maintainAspectRatio: true, scales: { y: { beginAtZero: true, title: { display: true, text: 'Area (acres)' } } } } });
        const trendCtx = document.getElementById('monthlyTrendChart').getContext('2d');
        charts.trend = new Chart(trendCtx, { type: 'line', data: { labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], datasets: [{ label: 'Crops Added', data: monthlyData, borderColor: '#ff9800', backgroundColor: 'rgba(255, 152, 0, 0.1)', tension: 0.4, fill: true }] }, options: { responsive: true, maintainAspectRatio: true } });
        const activityCtx = document.getElementById('userActivityChart').getContext('2d');
        charts.activity = new Chart(activityCtx, { type: 'pie', data: { labels: ['Active Users (with crops)', 'Inactive Users'], datasets: [{ data: [activeUsers, inactiveUsers], backgroundColor: ['#2e7d32', '#e0e0e0'] }] }, options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { position: 'bottom', labels: { font: { size: window.innerWidth < 768 ? 10 : 12 } } } } } });
    }

    function switchTable(table) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.getElementById(`tab${table.charAt(0).toUpperCase() + table.slice(1)}`).classList.add('active');
        document.getElementById('usersTable').style.display = table === 'users' ? 'block' : 'none';
        document.getElementById('currentTable').style.display = table === 'current' ? 'block' : 'none';
        document.getElementById('historyTable').style.display = table === 'history' ? 'block' : 'none';
    }

    function downloadAllData() { showLoading(); generatePDF({ users: allUsersData, currentCrops: allCurrentCropsData, historyCrops: allHistoryCropsData, summary: summaryData }, 'All_Users_Report'); hideLoading(); showAlert('success', 'Download Started', 'Complete system report is being generated'); }
    function downloadSelectedUser() { const select = document.getElementById('userSelect'); const username = select.value; if (username === 'all') { showAlert('error', 'Selection Required', 'Please select a specific user from the dropdown'); return; } showLoading(); const userInfo = allUsersData.find(u => u.username === username); const userCurrentCrops = allCurrentCropsData.filter(c => c.username === username); const userHistoryCrops = allHistoryCropsData.filter(c => c.username === username); const userTotalArea = userCurrentCrops.reduce((sum, crop) => sum + crop.farm_area, 0); const userData = { userInfo: userInfo, currentCrops: userCurrentCrops, historyCrops: userHistoryCrops, summary: { totalUsers: 1, totalCurrentCrops: userCurrentCrops.length, totalHistoryCrops: userHistoryCrops.length, totalFarmArea: userTotalArea, verifiedUsers: userInfo && userInfo.email_verified ? 1 : 0 } }; if (userCurrentCrops.length === 0 && userHistoryCrops.length === 0) { hideLoading(); showAlert('warning', 'No Data', 'Selected user has no crop records'); return; } generatePDF(userData, username + '_Report'); hideLoading(); showAlert('success', 'Download Started', 'Report for ' + username + ' is being generated'); }
    function generatePDF(data, title) { const { jsPDF } = window.jspdf; const doc = new jsPDF(); doc.setFontSize(20); doc.setTextColor(46, 125, 50); doc.text('AgroInsights Farm Report', 20, 20); doc.setFontSize(14); doc.setTextColor(100, 100, 100); doc.text(title.includes('All_Users') ? 'Complete System Report - All Users' : 'User Report: ' + title.replace('_Report', ''), 20, 30); doc.setFontSize(10); doc.text(`Generated on: ${new Date().toLocaleString()}`, 20, 37); let yPos = 45; if (data.summary) { doc.setFontSize(12); doc.setTextColor(0, 0, 0); doc.text('Summary Statistics', 20, yPos); yPos += 7; let summaryData = []; if (title.includes('All_Users')) { summaryData = [['Total Users', data.summary.totalUsers], ['Verified Users', data.summary.verifiedUsers || 0], ['Current Crops', data.summary.totalCurrentCrops], ['History Crops', data.summary.totalHistoryCrops], ['Total Area', (data.summary.totalFarmArea || 0).toFixed(1) + ' acres']]; } else { summaryData = [['Username', data.userInfo?.username || ''], ['Email', data.userInfo?.email || ''], ['Status', data.userInfo?.email_verified ? 'Verified' : 'Unverified'], ['Registered On', data.userInfo?.created_at || ''], ['Current Crops', data.summary.totalCurrentCrops], ['History Crops', data.summary.totalHistoryCrops], ['Total Area', (data.summary.totalFarmArea || 0).toFixed(1) + ' acres']]; } doc.autoTable({ startY: yPos, head: [['Metric', 'Value']], body: summaryData, theme: 'striped', headStyles: { fillColor: [46, 125, 50] } }); yPos = doc.lastAutoTable.finalY + 10; } if (title.includes('All_Users') && data.users && data.users.length > 0) { doc.setFontSize(12); doc.text('Registered Users', 20, yPos); yPos += 5; doc.autoTable({ startY: yPos, head: [['Username', 'Email', 'Verified', 'Registered On']], body: data.users.map(u => [u.username || '', u.email || '', u.email_verified ? 'Yes' : 'No', u.created_at || '']), theme: 'striped', headStyles: { fillColor: [46, 125, 50] } }); yPos = doc.lastAutoTable.finalY + 10; } if (data.currentCrops && data.currentCrops.length > 0) { doc.setFontSize(12); doc.text('Current Crops', 20, yPos); yPos += 5; doc.autoTable({ startY: yPos, head: [['Farmer', 'Crop', 'Area', 'Contact', 'Date', 'Period']], body: data.currentCrops.map(c => [c.farmer_name || '', c.crop_name || '', (c.farm_area || 0).toFixed(1) + ' acres', c.contact_number || '', c.crop_dates || '', (c.period || 0) + ' months']), theme: 'striped', headStyles: { fillColor: [46, 125, 50] } }); yPos = doc.lastAutoTable.finalY + 10; } if (data.historyCrops && data.historyCrops.length > 0) { doc.setFontSize(12); doc.text('Historical Crops', 20, yPos); yPos += 5; doc.autoTable({ startY: yPos, head: [['Farmer', 'Crop', 'Area', 'Contact', 'Date', 'Period']], body: data.historyCrops.map(c => [c.farmer_name || '', c.crop_name || '', (c.farm_area || 0).toFixed(1) + ' acres', c.contact_number || '', c.crop_dates || '', (c.period || 0) + ' months']), theme: 'striped', headStyles: { fillColor: [255, 152, 0] } }); } doc.save(title + '_' + new Date().toISOString().split('T')[0] + '.pdf'); }
    function exportCurrentViewPDF() { const { jsPDF } = window.jspdf; const doc = new jsPDF(); doc.setFontSize(20); doc.setTextColor(46, 125, 50); doc.text('AgroInsights - Current View Report', 20, 20); doc.setFontSize(10); doc.text(`Generated on: ${new Date().toLocaleString()}`, 20, 30); let headers = []; let body = []; if (document.getElementById('usersTable').style.display !== 'none') { headers = [['Username', 'Email', 'Status', 'Registered On', 'Crops Count']]; body = allUsersData.map(user => { const cropCount = allCurrentCropsData.filter(c => c.username === user.username).length; return [user.username || '', user.email || '', user.email_verified ? 'Verified' : 'Pending', user.created_at || '', cropCount.toString()]; }); } else if (document.getElementById('currentTable').style.display !== 'none') { headers = [['Farmer', 'Username', 'Crop', 'Area (acres)', 'Contact', 'Planted On', 'Period (months)']]; body = allCurrentCropsData.map(crop => [crop.farmer_name || '', crop.username || '', crop.crop_name || '', (crop.farm_area || 0).toFixed(1), crop.contact_number || '', crop.crop_dates || '', (crop.period || 0).toString()]); } else { headers = [['Farmer', 'Username', 'Crop', 'Area (acres)', 'Contact', 'Planted On', 'Period (months)', 'Status']]; body = allHistoryCropsData.map(crop => [crop.farmer_name || '', crop.username || '', crop.crop_name || '', (crop.farm_area || 0).toFixed(1), crop.contact_number || '', crop.crop_dates || '', (crop.period || 0).toString(), 'Completed']); } if (body.length > 0) { doc.autoTable({ startY: 40, head: headers, body: body, theme: 'striped', headStyles: { fillColor: [46, 125, 50] } }); } else { doc.text('No data available', 20, 40); } doc.save('current_view_' + new Date().toISOString().split('T')[0] + '.pdf'); showAlert('success', 'Export Complete', 'PDF has been downloaded'); }
    function exportCurrentViewExcel() { let data = []; let sheetName = ''; if (document.getElementById('usersTable').style.display !== 'none') { sheetName = 'Users'; data = allUsersData.map(user => { const cropCount = allCurrentCropsData.filter(c => c.username === user.username).length; return { 'Username': user.username || '', 'Email': user.email || '', 'Status': user.email_verified ? 'Verified' : 'Pending', 'Registered On': user.created_at || '', 'Crops Count': cropCount }; }); } else if (document.getElementById('currentTable').style.display !== 'none') { sheetName = 'Current Crops'; data = allCurrentCropsData.map(crop => ({ 'Farmer Name': crop.farmer_name || '', 'Username': crop.username || '', 'Crop': crop.crop_name || '', 'Area (acres)': (crop.farm_area || 0).toFixed(1), 'Contact': crop.contact_number || '', 'Planted On': crop.crop_dates || '', 'Period (months)': crop.period || 0 })); } else { sheetName = 'History Crops'; data = allHistoryCropsData.map(crop => ({ 'Farmer Name': crop.farmer_name || '', 'Username': crop.username || '', 'Crop': crop.crop_name || '', 'Area (acres)': (crop.farm_area || 0).toFixed(1), 'Contact': crop.contact_number || '', 'Planted On': crop.crop_dates || '', 'Period (months)': crop.period || 0, 'Status': 'Completed' })); } if (data.length > 0) { const wb = XLSX.utils.book_new(); const ws = XLSX.utils.json_to_sheet(data); XLSX.utils.book_append_sheet(wb, ws, sheetName); XLSX.writeFile(wb, sheetName + '_' + new Date().toISOString().split('T')[0] + '.xlsx'); showAlert('success', 'Export Complete', 'Excel file has been downloaded'); } else { showAlert('error', 'Export Failed', 'No data available to export'); } }
    function showLoading() { document.getElementById('loadingSpinner').style.display = 'block'; }
    function hideLoading() { document.getElementById('loadingSpinner').style.display = 'none'; }
    function showAlert(type, title, message) { const container = document.getElementById('alertContainer'); const alertDiv = document.createElement('div'); alertDiv.className = `alert alert-${type}`; alertDiv.innerHTML = `<i class='bx ${type === 'success' ? 'bx-check-circle' : 'bx-error-circle'}'></i><div class="alert-content"><div class="alert-title">${title}</div><div class="alert-message">${message}</div></div><i class='bx bx-x close-alert' onclick="this.parentElement.remove()"></i>`; container.appendChild(alertDiv); setTimeout(() => { if (alertDiv.parentElement) alertDiv.remove(); }, 5000); }
    window.print = function() { const printWindow = window.open('', '_blank'); let tableHTML = ''; if (document.getElementById('usersTable').style.display !== 'none') { tableHTML = generateTableHTML('Users', ['Username', 'Email', 'Status', 'Registered On', 'Crops Count'], allUsersData.map(user => { const cropCount = allCurrentCropsData.filter(c => c.username === user.username).length; return [user.username || '', user.email || '', user.email_verified ? 'Verified' : 'Pending', user.created_at || '', cropCount.toString()]; })); } else if (document.getElementById('currentTable').style.display !== 'none') { tableHTML = generateTableHTML('Current Crops', ['Farmer Name', 'Username', 'Crop', 'Area (acres)', 'Contact', 'Planted On', 'Period (months)'], allCurrentCropsData.map(crop => [crop.farmer_name || '', crop.username || '', crop.crop_name || '', (crop.farm_area || 0).toFixed(1), crop.contact_number || '', crop.crop_dates || '', (crop.period || 0).toString()])); } else { tableHTML = generateTableHTML('History Crops', ['Farmer Name', 'Username', 'Crop', 'Area (acres)', 'Contact', 'Planted On', 'Period (months)', 'Status'], allHistoryCropsData.map(crop => [crop.farmer_name || '', crop.username || '', crop.crop_name || '', (crop.farm_area || 0).toFixed(1), crop.contact_number || '', crop.crop_dates || '', (crop.period || 0).toString(), 'Completed'])); } printWindow.document.write(`<html><head><title>AgroInsights Report - ${new Date().toLocaleDateString()}</title><style>body{font-family:Arial,sans-serif;padding:20px;}h1{color:#2e7d32;text-align:center;}h2{color:#1b5e20;margin-top:20px;}table{width:100%;border-collapse:collapse;margin-top:20px;}th{background:#2e7d32;color:white;padding:10px;text-align:left;}td{padding:8px;border-bottom:1px solid #ddd;}.date{text-align:right;color:#666;margin-bottom:20px;}.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin:20px 0;}.stat-card{background:#f8fafc;padding:10px;border-radius:5px;text-align:center;}.stat-value{font-size:20px;font-weight:bold;color:#2e7d32;}.stat-label{color:#666;}</style></head><body><h1>AgroInsights Farm Report</h1><div class="date">Generated on: ${new Date().toLocaleString()}</div><div class="stats"><div class="stat-card"><div class="stat-value">${summaryData.totalUsers}</div><div class="stat-label">Total Users</div></div><div class="stat-card"><div class="stat-value">${summaryData.totalCurrentCrops}</div><div class="stat-label">Current Crops</div></div><div class="stat-card"><div class="stat-value">${summaryData.totalHistoryCrops}</div><div class="stat-label">History Crops</div></div><div class="stat-card"><div class="stat-value">${summaryData.totalFarmArea.toFixed(1)}</div><div class="stat-label">Total Area (acres)</div></div></div>${tableHTML}</body></html>`); printWindow.document.close(); printWindow.focus(); printWindow.print(); printWindow.close(); };
    function generateTableHTML(title, headers, rows) { if (rows.length === 0) return `<h2>${title}</h2><p>No data available</p>`; let html = `<h2>${title}</h2><table><thead><tr>`; headers.forEach(header => html += `<th>${header}</th>`); html += `</tr></thead><tbody>`; rows.forEach(row => { html += '<tr>'; row.forEach(cell => html += `<td>${cell}</td>`); html += '</tr>'; }); html += `</tbody></table>`; return html; }
    document.addEventListener('keydown', function(e) { if (e.ctrlKey && e.key === 'p') { e.preventDefault(); window.print(); } if (e.ctrlKey && e.key === 'e') { e.preventDefault(); exportCurrentViewExcel(); } if (e.ctrlKey && e.key === 'd') { e.preventDefault(); exportCurrentViewPDF(); } });
</script>
</body>
</html>