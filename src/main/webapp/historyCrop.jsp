<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.controller.DBConnection" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Crop History | AgroInsights</title>
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

        .timeline {
            position: relative;
            max-width: 1000px;
            margin: 0 auto;
        }

        .timeline::after {
            content: '';
            position: absolute;
            width: 4px;
            background: var(--primary-light);
            top: 0;
            bottom: 0;
            left: 50%;
            margin-left: -2px;
            border-radius: 2px;
        }

        /* Hide timeline line when no data class is added */
        .timeline.no-data::after {
            display: none;
        }

        .timeline-item {
            padding: 10px 40px;
            position: relative;
            width: 50%;
            box-sizing: border-box;
            margin-bottom: 2rem;
        }

        .timeline-item:nth-child(odd) {
            left: 0;
        }

        .timeline-item:nth-child(even) {
            left: 50%;
        }

        .timeline-content {
            padding: 1.5rem;
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
            transition: var(--transition);
            position: relative;
        }

        .timeline-content:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }

        .timeline-item:nth-child(odd) .timeline-content {
            border-left: 4px solid var(--primary-color);
        }

        .timeline-item:nth-child(even) .timeline-content {
            border-right: 4px solid var(--secondary-color);
        }

        .timeline-dot {
            width: 20px;
            height: 20px;
            background: var(--primary-color);
            border: 4px solid white;
            border-radius: 50%;
            position: absolute;
            right: -10px;
            top: 1.5rem;
            z-index: 1;
            box-shadow: 0 0 0 4px var(--primary-light);
        }

        .timeline-item:nth-child(even) .timeline-dot {
            left: -10px;
        }

        .crop-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .crop-title {
            font-size: 1.3rem;
            color: var(--text-dark);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .crop-date {
            color: var(--text-light);
            font-size: 0.9rem;
            background: var(--light-bg);
            padding: 0.3rem 0.8rem;
            border-radius: 50px;
        }

        .crop-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .detail-label {
            color: var(--text-light);
            font-size: 0.85rem;
            font-weight: 500;
        }

        .detail-value {
            color: var(--text-dark);
            font-weight: 600;
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

        .status-completed {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .status-archived {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .stats-summary {
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
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .no-history {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin: 2rem 0;
        }

        .no-history i {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 1.5rem;
        }

        .no-history h3 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }

        .no-history p {
            color: var(--text-light);
            margin-bottom: 1.5rem;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .timeline::after {
                left: 31px;
            }

            .timeline-item {
                width: 100%;
                padding-left: 70px;
                padding-right: 25px;
            }

            .timeline-item:nth-child(even) {
                left: 0;
            }

            .timeline-dot {
                left: 21px !important;
                right: auto;
            }

            .crop-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="page-header">
        <h1><i class='bx bxs-history'></i> Crop History</h1>
        <p>Review your past agricultural activities and harvest records</p>
    </div>

    <div class="stats-summary">
        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-calendar'></i>
            </div>
            <div class="stat-value" id="totalHistory">0</div>
            <div class="stat-label">Historical Records</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-bar-chart-alt-2'></i>
            </div>
            <div class="stat-value" id="successRate">0%</div>
            <div class="stat-label">Success Rate</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-area'></i>
            </div>
            <div class="stat-value" id="totalArea">0</div>
            <div class="stat-label">Total Area Covered</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class='bx bxs-time'></i>
            </div>
            <div class="stat-value" id="avgPeriod">0</div>
            <div class="stat-label">Avg Growth Period</div>
        </div>
    </div>

    <%
        boolean hasData = false;
        int historyCount = 0;
        double areaSum = 0;
        int periodSum = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Use connection pool utility
            con = DBConnection.getConnection();

            ps = con.prepareStatement(
                    "SELECT farmer_name, farm_area, crop_name, contact_number, crop_dates, period FROM history_crop"
            );

            rs = ps.executeQuery();
    %>

    <!-- Timeline container with dynamic no-data class -->
    <div class="timeline">
        <%
            int itemCount = 0;
            while (rs.next()) {
                hasData = true;
                historyCount++;
                areaSum += Double.parseDouble(rs.getString("farm_area"));
                periodSum += rs.getInt("period");
                itemCount++;
        %>
        <div class="timeline-item <%= itemCount % 2 == 0 ? "even" : "odd" %>">
            <div class="timeline-dot"></div>
            <div class="timeline-content">
                <div class="crop-header">
                    <div class="crop-title">
                        <i class='bx bxs-leaf'></i>
                        <%= rs.getString("crop_name") %>
                    </div>
                    <div class="crop-date">
                        <i class='bx bxs-calendar'></i>
                        <%= rs.getDate("crop_dates") %>
                    </div>
                </div>

                <div class="crop-details">
                    <div class="detail-item">
                        <span class="detail-label">Farmer Name</span>
                        <span class="detail-value"><%= rs.getString("farmer_name") %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Farm Area</span>
                        <span class="detail-value"><%= rs.getString("farm_area") %> acres</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Contact</span>
                        <span class="detail-value"><%= rs.getString("contact_number") %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Growth Period</span>
                        <span class="detail-value"><%= rs.getString("period") %> months</span>
                    </div>
                </div>

                <span class="crop-status status-completed">
                    <i class='bx bxs-check-circle'></i> Successfully Completed
                </span>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <%
        } catch (Exception e) {
            out.println("<div class='no-history' style='color: var(--danger-color);'>Error loading history: " + e.getMessage() + "</div>");
        } finally {
            // Close resources
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        if (!hasData) {
    %>
    <div class="no-history">
        <i class='bx bxs-history'></i>
        <h3>No Historical Records Found</h3>
        <p>Complete your first crop to see it appear in the history timeline</p>
    </div>
    <%
        }
    %>
</div>

<script>
    // Update stats with actual values
    document.addEventListener('DOMContentLoaded', function() {
        const historyElement = document.getElementById('totalHistory');
        const areaElement = document.getElementById('totalArea');
        const periodElement = document.getElementById('avgPeriod');
        const rateElement = document.getElementById('successRate');

        const historyCount = <%= historyCount %>;
        const areaSum = <%= areaSum %>;
        const avgPeriod = <%= historyCount > 0 ? Math.round(periodSum/historyCount) : 0 %>;

        // Calculate success rate (you can modify this logic based on your requirements)
        const successRate = historyCount > 0 ? Math.min(100, Math.round((historyCount / (historyCount + 5)) * 100)) : 0;

        // Animate the values
        animateValue(historyElement, 0, historyCount, 1000);
        animateValue(areaElement, 0, Math.round(areaSum), 1000);
        animateValue(periodElement, 0, avgPeriod, 1000);
        animateValue(rateElement, 0, successRate, 1000, true);
    });

    function animateValue(element, start, end, duration, isPercentage = false) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            const value = Math.floor(progress * (end - start) + start);
            element.textContent = isPercentage ? value + '%' : value;
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    // Animate timeline items on scroll
    const timelineItems = document.querySelectorAll('.timeline-content');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.1 });

    timelineItems.forEach(item => {
        item.style.opacity = '0';
        item.style.transform = 'translateY(20px)';
        item.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(item);
    });
</script>
</body>
</html>