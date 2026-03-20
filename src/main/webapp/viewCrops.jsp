<%@ page import="com.example.controller.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = (String) session.getAttribute("role");
    String selectedUser = request.getParameter("username");
    String sessionUser = (String) session.getAttribute("username");

    String type = request.getParameter("type");
    if (type == null) {
        type = "current";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Crop Management | AgroInsights</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
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

        .container {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: clamp(1.5rem, 5vw, 2.5rem);
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .page-header p {
            color: var(--text-light);
            font-size: clamp(0.85rem, 3vw, 1.1rem);
        }

        <% if ("admin".equals(role) && selectedUser != null) { %>
        .user-badge {
            background: linear-gradient(135deg, var(--secondary-color), #ffb74d);
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: var(--radius);
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            margin: 1rem auto;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.2);
            font-size: clamp(0.8rem, 2.5vw, 0.95rem);
            flex-wrap: wrap;
            justify-content: center;
        }
        <% } %>

        .tabs-container {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            background: var(--card-bg);
            padding: 0.5rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            max-width: 400px;
            margin: 2rem auto;
            flex-wrap: wrap;
        }

        .tab {
            flex: 1;
            padding: 0.8rem 1.2rem;
            background: transparent;
            border: none;
            border-radius: 12px;
            color: var(--text-dark);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: clamp(0.75rem, 2.5vw, 0.9rem);
            white-space: nowrap;
        }

        @media (max-width: 480px) {
            .tab {
                padding: 0.6rem 0.8rem;
            }
            .tab span {
                display: none;
            }
        }

        .tab.active {
            background: var(--primary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(46, 125, 50, 0.2);
        }

        .table-container {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow-x: auto;
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            min-width: 700px;
        }

        thead {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
        }

        th {
            padding: 1rem 1.2rem;
            color: white;
            font-weight: 600;
            text-align: left;
            font-size: clamp(0.7rem, 2.5vw, 0.85rem);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        @media (max-width: 768px) {
            th, td {
                padding: 0.8rem;
            }
        }

        tbody tr {
            transition: var(--transition);
            border-bottom: 1px solid var(--border-color);
        }

        tbody tr:hover {
            background: var(--light-bg);
        }

        td {
            padding: 1rem 1.2rem;
            color: var(--text-dark);
            vertical-align: middle;
            font-size: clamp(0.75rem, 2.5vw, 0.85rem);
        }

        .crop-status {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.4rem 0.8rem;
            border-radius: 50px;
            font-size: clamp(0.7rem, 2.5vw, 0.8rem);
            font-weight: 500;
            white-space: nowrap;
        }

        .status-current {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .status-history {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 0.5rem 0.8rem;
            border-radius: 8px;
            font-size: clamp(0.7rem, 2.5vw, 0.8rem);
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            background: transparent;
        }

        @media (max-width: 600px) {
            .btn-action span {
                display: none;
            }
            .btn-action {
                padding: 0.5rem;
            }
        }

        .btn-edit {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .btn-edit:hover {
            background: rgba(46, 125, 50, 0.2);
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        .btn-delete:hover {
            background: rgba(220, 53, 69, 0.2);
        }

        .btn-move {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .btn-move:hover {
            background: rgba(255, 152, 0, 0.2);
        }

        .no-data {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--text-light);
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border-color);
        }

        .no-data h3 {
            font-size: clamp(1.1rem, 4vw, 1.3rem);
            margin-bottom: 0.5rem;
        }

        .crop-details {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .crop-name {
            font-weight: 600;
            color: var(--text-dark);
            font-size: clamp(0.85rem, 2.5vw, 0.95rem);
        }

        .crop-meta {
            font-size: 0.7rem;
            color: var(--text-light);
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 600px) {
            .summary-cards {
                gap: 1rem;
            }
        }

        .summary-card {
            background: var(--card-bg);
            padding: 1.2rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
        }

        .summary-icon {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.8rem;
            font-size: 1.3rem;
        }

        @media (max-width: 480px) {
            .summary-icon {
                width: 35px;
                height: 35px;
                font-size: 1rem;
            }
        }

        .summary-card:nth-child(1) .summary-icon {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .summary-card:nth-child(2) .summary-icon {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .summary-card:nth-child(3) .summary-icon {
            background: rgba(156, 39, 176, 0.1);
            color: #9c27b0;
        }

        .summary-number {
            font-size: clamp(1.3rem, 5vw, 2rem);
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.2rem;
        }

        .summary-label {
            color: var(--text-light);
            font-size: clamp(0.7rem, 2.5vw, 0.85rem);
        }

        /* Alert Styles */
        .alert {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            background: white;
            box-shadow: var(--shadow);
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

        .spinner {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .spinner-inner {
            width: 40px;
            height: 40px;
            border: 4px solid var(--border-color);
            border-top-color: var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="page-header">
        <h1><i class='bx bxs-leaf'></i> Crop Management</h1>
        <p>Track and manage all your agricultural activities in one place</p>

        <% if ("admin".equals(role) && selectedUser != null) { %>
        <div class="user-badge">
            <i class='bx bxs-user-check'></i>
            Viewing crops for: <strong><%= selectedUser %></strong>
        </div>
        <% } %>
    </div>

    <div class="summary-cards">
        <div class="summary-card">
            <div class="summary-icon"><i class='bx bx-leaf'></i></div>
            <div class="summary-number" id="totalCrops">0</div>
            <div class="summary-label">Total Crops</div>
        </div>
        <div class="summary-card">
            <div class="summary-icon"><i class='bx bx-area'></i></div>
            <div class="summary-number" id="totalArea">0</div>
            <div class="summary-label">Total Area (acres)</div>
        </div>
        <div class="summary-card">
            <div class="summary-icon"><i class='bx bx-calendar'></i></div>
            <div class="summary-number" id="avgPeriod">0</div>
            <div class="summary-label">Avg Period (months)</div>
        </div>
    </div>

    <div class="tabs-container">
        <button class="tab <%= "current".equals(type) ? "active" : "" %>"
                onclick="window.location.href='viewCrops.jsp?type=current<%= (selectedUser != null ? "&username=" + selectedUser : "") %>'">
            <i class='bx bx-leaf'></i>
            <span>Current Crops</span>
        </button>
        <button class="tab <%= "history".equals(type) ? "active" : "" %>"
                onclick="window.location.href='viewCrops.jsp?type=history<%= (selectedUser != null ? "&username=" + selectedUser : "") %>'">
            <i class='bx bx-history'></i>
            <span>Crop History</span>
        </button>
    </div>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Crop Details</th>
                <th>Farm Information</th>
                <th>Timeline</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                boolean hasData = false;
                int totalCrops = 0;
                double totalArea = 0;
                int totalPeriod = 0;

                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.getConnection();
                    String sql;

                    if ("history".equals(type)) {
                        if ("admin".equals(role)) {
                            if (selectedUser != null && !selectedUser.isEmpty()) {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period FROM history_crop WHERE username=?";
                                ps = con.prepareStatement(sql);
                                ps.setString(1, selectedUser);
                            } else {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period FROM history_crop";
                                ps = con.prepareStatement(sql);
                            }
                        } else {
                            sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period FROM history_crop WHERE username=?";
                            ps = con.prepareStatement(sql);
                            ps.setString(1, sessionUser);
                        }
                    } else {
                        if ("admin".equals(role)) {
                            if (selectedUser != null && !selectedUser.isEmpty()) {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period FROM add_crop WHERE username=?";
                                ps = con.prepareStatement(sql);
                                ps.setString(1, selectedUser);
                            } else {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period FROM add_crop";
                                ps = con.prepareStatement(sql);
                            }
                        } else {
                            sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period FROM add_crop WHERE username=?";
                            ps = con.prepareStatement(sql);
                            ps.setString(1, sessionUser);
                        }
                    }

                    rs = ps.executeQuery();

                    while (rs.next()) {
                        hasData = true;
                        totalCrops++;
                        totalArea += Double.parseDouble(rs.getString("farm_area"));
                        totalPeriod += rs.getInt("period");
            %>
            <tr>
                <td>
                    <div class="crop-details">
                        <div class="crop-name"><%= rs.getString("crop_name") %></div>
                        <div class="crop-meta">Farmer: <%= rs.getString("farmer_name") %></div>
                    </div>
                </td>
                <td>
                    <div class="crop-details">
                        <div style="font-weight: 500;"><%= rs.getString("farm_area") %> acres</div>
                        <div class="crop-meta">Contact: <%= rs.getString("contact_number") %></div>
                    </div>
                </td>
                <td>
                    <div class="crop-details">
                        <div style="font-weight: 500;"><%= rs.getDate("crop_dates") %></div>
                        <div class="crop-meta"><%= rs.getString("period") %> months</div>
                    </div>
                </td>
                <td>
                    <span class="crop-status <%= "current".equals(type) ? "status-current" : "status-history" %>">
                        <i class='bx <%= "current".equals(type) ? "bx-check-circle" : "bx-history" %>'></i>
                        <%= "current".equals(type) ? "Active" : "Completed" %>
                    </span>
                </td>
                <td>
                    <div class="action-buttons">
                        <% if ("current".equals(type) || ("history".equals(type) && "admin".equals(role))) { %>
                        <% if ("admin".equals(role)) { %>
                        <form action="EditCrop" method="get" style="display: inline;">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <% if (selectedUser != null && !selectedUser.isEmpty()) { %>
                            <input type="hidden" name="username" value="<%= selectedUser %>">
                            <% } %>
                            <button type="submit" class="btn-action btn-edit">
                                <i class='bx bx-edit'></i>
                                <span>Edit</span>
                            </button>
                        </form>

                        <form action="DeleteCrop" method="post" style="display: inline;">
                            <input type="hidden" name="cropId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-action btn-delete" onclick="return confirm('Are you sure you want to delete this crop?');">
                                <i class='bx bx-trash'></i>
                                <span>Delete</span>
                            </button>
                        </form>
                        <% } %>

                        <% if ("current".equals(type)) { %>
                        <form action="MoveToHistory" method="post" style="display: inline;">
                            <input type="hidden" name="cropId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-action btn-move" onclick="return confirm('Are you sure you want to mark this crop as completed?');">
                                <i class='bx bx-history'></i>
                                <span>Move</span>
                            </button>
                        </form>
                        <% } else if ("admin".equals(role)) { %>
                        <form action="MoveCurrent" method="post" style="display: inline;">
                            <input type="hidden" name="cropId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-action btn-move" onclick="return confirm('Are you sure you want to restore this crop?');">
                                <i class='bx bx-transfer'></i>
                                <span>Restore</span>
                            </button>
                        </form>
                        <% } %>
                        <% } %>
                    </div>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' style='color: var(--danger-color); padding: 2rem; text-align: center;'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (con != null) con.close(); } catch (Exception e) {}
                }
            %>
            </tbody>
        </table>

        <% if (!hasData) { %>
        <div class="no-data">
            <i class='bx bx-leaf'></i>
            <h3>No crop data found</h3>
            <p><%= "current".equals(type) ? "Add your first crop to get started" : "No historical records available" %></p>
            <% if ("current".equals(type)) { %>
            <a href="addcrop.jsp" class="btn-action btn-edit" style="margin-top: 1rem; display: inline-flex; padding: 0.8rem 1.5rem;">
                <i class='bx bx-plus'></i> Add New Crop
            </a>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

<script>
    function animateValue(element, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            const value = Math.floor(progress * (end - start) + start);
            element.textContent = value;
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    setTimeout(() => {
        animateValue(document.getElementById('totalCrops'), 0, <%= totalCrops %>, 1000);
        animateValue(document.getElementById('totalArea'), 0, Math.round(<%= totalArea %>), 1000);
        animateValue(document.getElementById('avgPeriod'), 0, <%= totalCrops > 0 ? Math.round(totalPeriod/totalCrops) : 0 %>, 1000);
    }, 500);
</script>
</body>
</html>