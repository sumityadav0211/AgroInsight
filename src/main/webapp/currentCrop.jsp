<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Current Crops | AgroInsights</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        .container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
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

        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.95rem;
        }

        .crops-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .crop-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: var(--transition);
            border: 1px solid var(--border-color);
        }

        .crop-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .crop-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 1.5rem;
            position: relative;
        }

        .crop-header::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 100%;
            height: 20px;
            background: inherit;
            clip-path: polygon(0 0, 100% 0, 100% 100%, 0 0);
        }

        .crop-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .crop-subtitle {
            font-size: 0.95rem;
            opacity: 0.9;
        }

        .crop-content {
            padding: 1.5rem;
        }

        .crop-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .info-label {
            color: var(--text-light);
            font-size: 0.85rem;
            font-weight: 500;
        }

        .info-value {
            color: var(--text-dark);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .crop-progress {
            margin-bottom: 1.5rem;
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }

        .progress-label {
            color: var(--text-dark);
            font-weight: 500;
        }

        .progress-percentage {
            color: var(--primary-color);
            font-weight: 600;
        }

        .progress-bar {
            height: 8px;
            background: var(--border-color);
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
            border-radius: 4px;
            transition: width 1s ease;
        }

        .crop-actions {
            display: flex;
            gap: 0.8rem;
        }

        .btn-action {
            flex: 1;
            padding: 0.8rem;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
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
        }

        .btn-view {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .btn-view:hover {
            background: rgba(255, 152, 0, 0.2);
        }

        .btn-move {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        .btn-move:hover {
            background: rgba(220, 53, 69, 0.2);
        }

        .no-crops {
            grid-column: 1 / -1;
            text-align: center;
            padding: 4rem 2rem;
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .no-crops i {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 1.5rem;
        }

        .no-crops h3 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }

        .no-crops p {
            color: var(--text-light);
            margin-bottom: 1.5rem;
        }

        .btn-add {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            transition: var(--transition);
        }

        .btn-add:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(46, 125, 50, 0.3);
        }

        .success-message {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--primary-color);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            z-index: 1000;
            animation: slideIn 0.3s ease;
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

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .crops-grid {
                grid-template-columns: 1fr;
            }

            .crop-info {
                grid-template-columns: 1fr;
            }

            .crop-actions {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="page-header">
        <h1><i class='bx bxs-leaf'></i> Current Crops</h1>
        <p>Monitor and manage your active agricultural activities</p>
    </div>

    <div class="stats-bar">
        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-tree'></i>
            </div>
            <div class="stat-value" id="totalCrops">0</div>
            <div class="stat-label">Active Crops</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-area'></i>
            </div>
            <div class="stat-value" id="totalArea">0</div>
            <div class="stat-label">Total Area (acres)</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-calendar'></i>
            </div>
            <div class="stat-value" id="avgPeriod">0</div>
            <div class="stat-label">Average Period</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-bar-chart-alt-2'></i>
            </div>
            <div class="stat-value">96%</div>
            <div class="stat-label">Success Rate</div>
        </div>
    </div>

    <div class="crops-grid">
        <%
            boolean hasData = false;
            int cropCount = 0;
            double areaSum = 0;
            int periodSum = 0;

            try {
                // Use connection pool utility
                Connection con = com.example.util.DBConnection.getConnection();

                // FIX: Always show all crops regardless of user role
                // This query gets ALL crops from the database
                PreparedStatement ps = con.prepareStatement(
                        "SELECT id, farmer_name, farm_area, crop_name, contact_number, crop_dates, period, username FROM add_crop"
                );

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    hasData = true;
                    cropCount++;
                    areaSum += Double.parseDouble(rs.getString("farm_area"));
                    periodSum += rs.getInt("period");

                    int cropId = rs.getInt("id");
                    int period = rs.getInt("period");
                    Date cropDate = rs.getDate("crop_dates");
                    java.util.Date currentDate = new java.util.Date();
                    long diff = currentDate.getTime() - cropDate.getTime();
                    long daysPassed = diff / (1000 * 60 * 60 * 24);
                    int progress = Math.min(Math.round((float) daysPassed / (period * 30) * 100), 100);
        %>
        <div class="crop-card" id="crop-<%= cropId %>">
            <div class="crop-header">
                <div class="crop-title">
                    <i class='bx bxs-leaf'></i>
                    <%= rs.getString("crop_name") %>
                </div>
                <div class="crop-subtitle">
                    <i class='bx bxs-user'></i> <%= rs.getString("farmer_name") %>
                </div>
            </div>

            <div class="crop-content">
                <div class="crop-info">
                    <div class="info-item">
                        <span class="info-label">Farm Area</span>
                        <span class="info-value"><%= rs.getString("farm_area") %> acres</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Contact</span>
                        <span class="info-value"><%= rs.getString("contact_number") %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Planted On</span>
                        <span class="info-value"><%= cropDate %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Growth Period</span>
                        <span class="info-value"><%= period %> months</span>
                    </div>
                </div>

                <div class="crop-progress">
                    <div class="progress-header">
                        <span class="progress-label">Growth Progress</span>
                        <span class="progress-percentage"><%= progress %>%</span>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: <%= progress %>%"></div>
                    </div>
                </div>

                <div class="crop-actions">
                    <%
                        // Only show Edit button to admin
                        if ("admin".equals(role)) {
                    %>
                    <a href="editCrop.jsp?id=<%= cropId %>" class="btn-action btn-edit">
                        <i class='bx bx-edit'></i> Edit
                    </a>
                    <% } %>

                    <a href="cropDetails.jsp?id=<%= cropId %>" class="btn-action btn-view">
                        <i class='bx bx-show'></i> Details
                    </a>

                    <button type="button" class="btn-action btn-move" onclick="moveToHistory(<%= cropId %>)">
                        <i class='bx bx-history'></i> Complete
                    </button>
                </div>
            </div>
        </div>
        <%
            }

            rs.close();
            ps.close();
            con.close();

            if (!hasData) {
        %>
        <div class="no-crops">
            <i class='bx bx-leaf'></i>
            <h3>No Active Crops Found</h3>
            <p>Start by adding your first crop to track agricultural activities</p>
            <a href="addcrop.jsp" class="btn-add">
                <i class='bx bx-plus'></i> Add First Crop
            </a>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println("<div class='no-crops' style='color: var(--danger-color);'>Error loading crops: " + e.getMessage() + "</div>");
            }
        %>
    </div>
</div>

<script>
    // Animate stats
    function animateStats() {
        const cropsElement = document.getElementById('totalCrops');
        const areaElement = document.getElementById('totalArea');
        const periodElement = document.getElementById('avgPeriod');

        animateValue(cropsElement, 0, <%= cropCount %>, 1000);
        animateValue(areaElement, 0, Math.round(<%= areaSum %>), 1000);
        animateValue(periodElement, 0, <%= cropCount > 0 ? Math.round(periodSum/cropCount) : 0 %>, 1000);
    }

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

    // Function to move crop to history using AJAX
    function moveToHistory(cropId) {
        if (!confirm('Are you sure you want to mark this crop as completed and move it to history?')) {
            return;
        }

        // Show loading state
        const button = event.target.closest('.btn-move');
        const originalHTML = button.innerHTML;
        button.innerHTML = '<i class="bx bx-loader bx-spin"></i> Moving...';
        button.disabled = true;

        // Send AJAX request
        fetch('MoveToHistory', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'cropId=' + cropId
        })
            .then(response => {
                if (response.ok) {
                    // Show success message
                    showMessage('Crop successfully moved to history!', 'success');
                    // Remove the crop card from the DOM
                    const cropCard = document.getElementById('crop-' + cropId);
                    if (cropCard) {
                        cropCard.style.opacity = '0';
                        cropCard.style.transform = 'translateY(-20px)';
                        setTimeout(() => {
                            cropCard.remove();
                            updateStats();
                        }, 300);
                    }
                } else {
                    showMessage('Error moving crop to history. Please try again.', 'error');
                    // Reset button
                    button.innerHTML = originalHTML;
                    button.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Network error. Please try again.', 'error');
                button.innerHTML = originalHTML;
                button.disabled = false;
            });
    }

    // Function to update stats after moving a crop
    function updateStats() {
        const totalCropsElement = document.getElementById('totalCrops');
        const areaElement = document.getElementById('totalArea');
        const currentCount = parseInt(totalCropsElement.textContent);
        if (currentCount > 0) {
            totalCropsElement.textContent = currentCount - 1;
            // Animate the decrease
            animateValue(totalCropsElement, currentCount, currentCount - 1, 500);
        }
    }

    // Function to show success/error messages
    function showMessage(message, type) {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'success-message';
        messageDiv.style.background = type === 'success' ? '#2e7d32' : '#dc3545';

        const icon = type === 'success' ? 'bx-check-circle' : 'bx-error-circle';
        messageDiv.innerHTML = `
            <i class='bx ${icon}'></i>
            ${message}
        `;

        document.body.appendChild(messageDiv);

        // Remove message after 3 seconds
        setTimeout(() => {
            messageDiv.style.opacity = '0';
            messageDiv.style.transform = 'translateX(100%)';
            setTimeout(() => {
                document.body.removeChild(messageDiv);
            }, 300);
        }, 3000);
    }

    // Start animations after page load
    setTimeout(animateStats, 500);

    // Animate progress bars
    document.querySelectorAll('.progress-fill').forEach(bar => {
        const width = bar.style.width;
        bar.style.width = '0%';
        setTimeout(() => {
            bar.style.width = width;
        }, 300);
    });
</script>
</body>
</html>