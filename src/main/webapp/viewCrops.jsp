
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        }

        .container {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 2.5rem;
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .page-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        <% if ("admin".equals(role) && selectedUser != null) { %>
        .user-badge {
            background: linear-gradient(135deg, var(--secondary-color), #ffb74d);
            color: white;
            padding: 1rem 2rem;
            border-radius: var(--radius);
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            margin: 1rem auto;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.2);
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
        }

        .tab {
            flex: 1;
            padding: 1rem 1.5rem;
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
        }

        .tab.active {
            background: var(--primary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(46, 125, 50, 0.2);
        }

        .tab:hover:not(.active) {
            background: var(--light-bg);
        }

        .table-container {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        thead {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
        }

        th {
            padding: 1.2rem 1.5rem;
            color: white;
            font-weight: 600;
            text-align: left;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tbody tr {
            transition: var(--transition);
            border-bottom: 1px solid var(--border-color);
        }

        tbody tr:hover {
            background: var(--light-bg);
            transform: translateY(-2px);
        }

        td {
            padding: 1.2rem 1.5rem;
            color: var(--text-dark);
            vertical-align: middle;
        }

        .crop-status {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 500;
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
            padding: 0.6rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: var(--transition);
            border: none;
            cursor: pointer;
        }

        .btn-edit {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .btn-edit:hover {
            background: rgba(46, 125, 50, 0.2);
            transform: translateY(-2px);
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        .btn-delete:hover {
            background: rgba(220, 53, 69, 0.2);
            transform: translateY(-2px);
        }

        .btn-move {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .btn-move:hover {
            background: rgba(255, 152, 0, 0.2);
            transform: translateY(-2px);
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border-color);
        }

        .crop-details {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .crop-name {
            font-weight: 600;
            color: var(--text-dark);
        }

        .crop-meta {
            font-size: 0.85rem;
            color: var(--text-light);
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .summary-card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
        }

        .summary-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
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
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.3rem;
        }

        .summary-label {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .tabs-container {
                flex-direction: column;
            }

            th, td {
                padding: 0.8rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-action {
                width: 100%;
                justify-content: center;
            }
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
            <div class="summary-icon">
                <i class='bx bx-leaf'></i>
            </div>
            <div class="summary-number" id="totalCrops">0</div>
            <div class="summary-label">Total Crops</div>
        </div>
        <div class="summary-card">
            <div class="summary-icon">
                <i class='bx bx-area'></i>
            </div>
            <div class="summary-number" id="totalArea">0</div>
            <div class="summary-label">Total Area (acres)</div>
        </div>
        <div class="summary-card">
            <div class="summary-icon">
                <i class='bx bx-calendar'></i>
            </div>
            <div class="summary-number" id="avgPeriod">0</div>
            <div class="summary-label">Avg Period (months)</div>
        </div>
    </div>

    <div class="tabs-container">
        <button class="tab <%= "current".equals(type) ? "active" : "" %>"
                onclick="window.location.href='viewCrops.jsp?type=current<%= (selectedUser != null ? "&username=" + selectedUser : "") %>'">
            <i class='bx bx-leaf'></i>
            Current Crops
        </button>
        <button class="tab <%= "history".equals(type) ? "active" : "" %>"
                onclick="window.location.href='viewCrops.jsp?type=history<%= (selectedUser != null ? "&username=" + selectedUser : "") %>'">
            <i class='bx bx-history'></i>
            Crop History
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

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/FarmManagement",
                            "root",
                            "0004"
                    );

                    String sql;
                    PreparedStatement ps;

                    if ("history".equals(type)) {
                        if ("admin".equals(role)) {
                            if (selectedUser != null) {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                        "FROM history_crop WHERE username=?";
                                ps = con.prepareStatement(sql);
                                ps.setString(1, selectedUser);
                            } else {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                        "FROM history_crop";
                                ps = con.prepareStatement(sql);
                            }
                        } else {
                            sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                    "FROM history_crop WHERE username=?";
                            ps = con.prepareStatement(sql);
                            ps.setString(1, sessionUser);
                        }
                    } else {
                        if ("admin".equals(role)) {
                            if (selectedUser != null) {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                        "FROM add_crop WHERE username=?";
                                ps = con.prepareStatement(sql);
                                ps.setString(1, selectedUser);
                            } else {
                                sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                        "FROM add_crop";
                                ps = con.prepareStatement(sql);
                            }
                        } else {
                            sql = "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                    "FROM add_crop WHERE username=?";
                            ps = con.prepareStatement(sql);
                            ps.setString(1, sessionUser);
                        }
                    }

                    ResultSet rs = ps.executeQuery();

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
                        <% if ("admin".equals(role) && selectedUser != null) { %>
                        <form action="EditCrop" method="get" style="display: inline;">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <input type="hidden" name="username" value="<%= selectedUser %>">
                            <button type="submit" class="btn-action btn-edit">
                                <i class='bx bx-edit'></i> Edit
                            </button>
                        </form>
                        <% } %>

                        <% if ("admin".equals(role)) { %>
                        <form action="DeleteCrop" method="post" style="display: inline;">
                            <input type="hidden" name="cropId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-action btn-delete">
                                <i class='bx bx-trash'></i> Delete
                            </button>
                        </form>
                        <% } %>

                        <% if ("current".equals(type)) { %>
                        <form action="MoveToHistory" method="post" style="display: inline;">
                            <input type="hidden" name="cropId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-action btn-move">
                                <i class='bx bx-history'></i> Move
                            </button>
                        </form>
                        <% } else if ("admin".equals(role)) { %>
                        <form action="MoveCurrent" method="post" style="display: inline;">
                            <input type="hidden" name="cropId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-action btn-move">
                                <i class='bx bx-transfer'></i> Restore
                            </button>
                        </form>
                        <% } %>
                        <% } %>
                    </div>
                </td>
            </tr>
            <%
                }

                if (!hasData) {
            %>
            <tr>
                <td colspan="5">
                    <div class="no-data">
                        <i class='bx bx-leaf'></i>
                        <h3>No crop data found</h3>
                        <p><%= "current".equals(type) ? "Add your first crop to get started" : "No historical records available" %></p>
                        <% if ("current".equals(type)) { %>
                        <a href="addcrop.jsp" class="btn-action btn-edit" style="margin-top: 1rem; display: inline-flex;">
                            <i class='bx bx-plus'></i> Add New Crop
                        </a>
                        <% } %>
                    </div>
                </td>
            </tr>
            <%
                    }

                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' style='color: var(--danger-color); padding: 2rem; text-align: center;'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script>
    // Update summary cards with animation
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

    // Update stats
    setTimeout(() => {
        animateValue(document.getElementById('totalCrops'), 0, <%= totalCrops %>, 1000);
        animateValue(document.getElementById('totalArea'), 0, Math.round(<%= totalArea %>), 1000);
        animateValue(document.getElementById('avgPeriod'), 0, <%= totalCrops > 0 ? Math.round(totalPeriod/totalCrops) : 0 %>, 1000);
    }, 500);
</script>
</body>
</html>
