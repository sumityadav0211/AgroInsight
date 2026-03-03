<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    String cropId = request.getParameter("id");

    if (cropId == null) {
        response.sendRedirect("currentCrop.jsp");
        return;
    }

    // Variables
    String farmerName = "";
    String farmArea = "";
    String cropName = "";
    String contactNumber = "";
    java.sql.Date plantingDate = null;
    int period = 0;
    int id = 0;

    // Weather data
    Random rand = new Random();
    int temperature = 22 + rand.nextInt(12);
    int humidity = 45 + rand.nextInt(45);
    int windSpeed = 3 + rand.nextInt(15);
    int rainfall = rand.nextInt(8);
    int uvIndex = 3 + rand.nextInt(7);

    String[] weatherConditions = {"Sunny", "Partly Cloudy", "Cloudy", "Light Rain", "Clear Sky"};
    String[] weatherIcons = {"☀️", "⛅", "☁️", "🌧️", "🌤️"};
    int weatherIndex = rand.nextInt(weatherConditions.length);

    String[] growthStages = {"Seedling", "Vegetative", "Flowering", "Fruiting", "Harvest Ready"};
    String[] stageColors = {"#ff9800", "#4caf50", "#2196f3", "#9c27b0", "#f44336"};

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/FarmManagement",
                "root",
                "0004"
        );

        PreparedStatement ps = con.prepareStatement("SELECT * FROM add_crop WHERE id = ?");
        ps.setInt(1, Integer.parseInt(cropId));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            id = rs.getInt("id");
            farmerName = rs.getString("farmer_name");
            farmArea = rs.getString("farm_area");
            cropName = rs.getString("crop_name");
            contactNumber = rs.getString("contact_number");
            plantingDate = rs.getDate("crop_dates");
            period = rs.getInt("period");
        } else {
            response.sendRedirect("currentCrop.jsp");
            return;
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Calculate growth
    java.util.Date currentDate = new java.util.Date();
    long diff = currentDate.getTime() - plantingDate.getTime();
    long daysPassed = diff / (1000 * 60 * 60 * 24);
    int progress = Math.min(Math.round((float) daysPassed / (period * 30) * 100), 100);

    Calendar cal = Calendar.getInstance();
    cal.setTime(plantingDate);
    cal.add(Calendar.MONTH, period);
    java.util.Date harvestDate = cal.getTime();

    long daysRemaining = (harvestDate.getTime() - currentDate.getTime()) / (1000 * 60 * 60 * 24);

    int stageIndex = 0;
    if (progress < 20) stageIndex = 0;
    else if (progress < 40) stageIndex = 1;
    else if (progress < 60) stageIndex = 2;
    else if (progress < 80) stageIndex = 3;
    else stageIndex = 4;

    // Crop icons mapping
    Map<String, String> cropIcons = new HashMap<>();
    cropIcons.put("Wheat", "🌾");
    cropIcons.put("Rice", "🌾");
    cropIcons.put("Cotton", "🌿");
    cropIcons.put("Soybean", "🌱");
    cropIcons.put("Turmeric", "🌿");
    cropIcons.put("Sugarcane", "🌾");
    cropIcons.put("Maize", "🌽");
    cropIcons.put("Groundnut", "🥜");

    String cropIcon = cropIcons.getOrDefault(cropName, "🌱");

    // ===== CLEAN CROP FACTS WITHOUT EMOJIS IN TEXT =====
    Map<String, String[]> cropFacts = new HashMap<>();
    cropFacts.put("Wheat", new String[]{
            "India is the 2nd largest producer of wheat",
            "Growing season: Rabi (winter)",
            "Ideal temperature: 20-25°C"
    });
    cropFacts.put("Rice", new String[]{
            "India is the 2nd largest producer of rice",
            "Growing season: Kharif (monsoon)",
            "Requires plenty of water"
    });
    cropFacts.put("Cotton", new String[]{
            "India is the largest producer of cotton",
            "Known as 'White Gold'",
            "Growing period: 6-8 months"
    });
    cropFacts.put("Soybean", new String[]{
            "India's major oilseed crop",
            "Rich in protein (40%)",
            "Growing season: Kharif"
    });
    cropFacts.put("Turmeric", new String[]{
            "India produces 80% of world's turmeric",
            "Known for medicinal properties",
            "Growing period: 7-9 months"
    });
    cropFacts.put("Sugarcane", new String[]{
            "India is the 2nd largest producer",
            "Requires tropical climate",
            "Growing period: 10-12 months"
    });
    cropFacts.put("Maize", new String[]{
            "Also known as corn",
            "Used for food and feed",
            "Growing seasons: Kharif & Rabi"
    });
    cropFacts.put("Groundnut", new String[]{
            "India is the 2nd largest producer",
            "Also known as peanut",
            "Rich in oil (45-50%)"
    });

    String[] facts = cropFacts.getOrDefault(cropName, new String[]{
            "Important food crop",
            "Grown widely in India",
            "Supports local farmers"
    });
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= cropName %> Details | AgroInsights</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea10, #764ba210);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem;
        }

        /* Header/Navbar */
        .navbar {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .logo h1 {
            color: #2e7d32;
            font-size: 1.5rem;
        }

        .logo p {
            color: #666;
            font-size: 0.8rem;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            color: #333;
            text-decoration: none;
            font-weight: 500;
        }

        .nav-links a:hover {
            color: #2e7d32;
        }

        /* Back button */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #2e7d32;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 1.5rem;
            padding: 0.5rem 1rem;
            background: white;
            border-radius: 50px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }

        .back-btn:hover {
            transform: translateX(-5px);
            box-shadow: 0 5px 15px rgba(46,125,50,0.2);
        }

        /* Crop Header */
        .crop-header {
            background: linear-gradient(135deg, #2e7d32, #1b5e20);
            color: white;
            padding: 2.5rem;
            border-radius: 20px 20px 0 0;
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .crop-emoji {
            font-size: 6rem;
            line-height: 1;
            background: rgba(255,255,255,0.15);
            width: 120px;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            backdrop-filter: blur(5px);
            border: 3px solid rgba(255,255,255,0.3);
        }

        .crop-info h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }

        .crop-info p {
            font-size: 1.1rem;
            opacity: 0.9;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Details Grid */
        .details-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            background: white;
            padding: 2rem;
            border-radius: 0 0 20px 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }

        .detail-card {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: #f8fafc;
            border-radius: 12px;
            transition: all 0.3s;
            border: 1px solid #e2e8f0;
        }

        .detail-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-color: #2e7d32;
        }

        .detail-icon {
            width: 45px;
            height: 45px;
            border-radius: 10px;
            background: #2e7d3220;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2e7d32;
            font-size: 1.3rem;
        }

        .detail-label {
            color: #64748b;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .detail-value {
            color: #1e293b;
            font-weight: 600;
            font-size: 1rem;
        }

        /* ===== BEAUTIFUL FACTS SECTION WITH FONT AWESOME ===== */
        .facts-section {
            background: white;
            padding: 1.5rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }

        .facts-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            color: #1e293b;
            font-size: 1.1rem;
            font-weight: 600;
            padding-bottom: 0.8rem;
            border-bottom: 2px solid #f0f0f0;
        }

        .facts-title i {
            color: #2e7d32;
            font-size: 1.2rem;
        }

        .facts-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
        }

        .fact-card {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            padding: 1.2rem;
            border-radius: 14px;
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s ease;
            border: 1px solid #e2e8f0;
        }

        .fact-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(46,125,50,0.1);
            border-color: #2e7d32;
        }

        .fact-icon {
            width: 45px;
            height: 45px;
            background: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2e7d32;
            font-size: 1.3rem;
            box-shadow: 0 3px 8px rgba(0,0,0,0.05);
        }

        .fact-text {
            color: #1e293b;
            font-size: 0.95rem;
            font-weight: 500;
            line-height: 1.4;
            flex: 1;
        }

        /* Split View */
        .split-view {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .progress-card, .stage-card {
            background: white;
            padding: 1.5rem;
            border-radius: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }

        .progress-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            color: #1e293b;
            font-size: 1.1rem;
        }

        .timeline {
            display: flex;
            justify-content: space-between;
            margin: 2rem 0;
            position: relative;
        }

        .timeline::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            width: 100%;
            height: 2px;
            background: #e2e8f0;
            z-index: 1;
        }

        .stage {
            position: relative;
            z-index: 2;
            text-align: center;
            flex: 1;
        }

        .stage-dot {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 2px solid #e2e8f0;
            margin: 0 auto 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            transition: all 0.3s;
        }

        .stage.active .stage-dot {
            background: #2e7d32;
            border-color: #2e7d32;
            color: white;
            transform: scale(1.1);
            box-shadow: 0 0 20px rgba(46,125,50,0.3);
        }

        .stage.active .stage-name {
            color: #2e7d32;
            font-weight: 600;
        }

        .stage-name {
            font-size: 0.8rem;
            color: #64748b;
        }

        .progress-bar {
            height: 8px;
            background: #e2e8f0;
            border-radius: 4px;
            overflow: hidden;
            margin: 0.5rem 0;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #2e7d32, #4caf50);
            width: <%= progress %>%;
            border-radius: 4px;
        }

        /* Stage Card */
        .stage-emoji {
            font-size: 4rem;
            text-align: center;
            padding: 1rem;
            background: #f8fafc;
            border-radius: 12px;
            margin-bottom: 1rem;
        }

        .stage-badge {
            display: inline-block;
            padding: 0.3rem 1rem;
            background: <%= stageColors[stageIndex] %>;
            color: white;
            border-radius: 50px;
            font-weight: 500;
            margin-bottom: 1rem;
            font-size: 0.85rem;
        }

        /* Weather Card */
        .weather-card {
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: white;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .weather-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }

        .weather-main {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .weather-emoji {
            font-size: 3.5rem;
        }

        .weather-temp {
            font-size: 2.5rem;
            font-weight: 700;
        }

        .weather-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
        }

        .weather-stat {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: rgba(255,255,255,0.1);
            border-radius: 12px;
            backdrop-filter: blur(5px);
            transition: all 0.3s;
        }

        .weather-stat:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }

        .weather-stat i {
            font-size: 1.8rem;
        }

        /* Recommendations */
        .recommendations {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border: 1px solid #e2e8f0;
        }

        .rec-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            transition: all 0.3s;
        }

        .rec-item:hover {
            background: #f8fafc;
        }

        .rec-item:last-child {
            border-bottom: none;
        }

        .rec-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #2e7d3220;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2e7d32;
        }

        .print-btn {
            width: 100%;
            padding: 1rem;
            background: #ff9800;
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 1rem;
        }

        .print-btn:hover {
            background: #f57c00;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,152,0,0.3);
        }

        @media (max-width: 768px) {
            .details-grid,
            .facts-grid,
            .split-view,
            .weather-grid {
                grid-template-columns: 1fr;
            }

            .crop-header {
                flex-direction: column;
                text-align: center;
                padding: 1.5rem;
            }

            .crop-info h1 {
                font-size: 2rem;
            }

            .weather-header {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<!-- Navbar -->
<jsp:include page="navbar.jsp" />
<div class="container">
    <!-- Back Button -->
    <a href="currentCrop.jsp" class="back-btn">
        <i class="fas fa-arrow-left"></i> Back to Current Crops
    </a>

    <!-- Crop Header -->
    <div class="crop-header">
        <div class="crop-emoji">
            <%= cropIcon %>
        </div>
        <div class="crop-info">
            <h1><%= cropName %></h1>
            <p><i class="fas fa-user"></i> <%= farmerName %></p>
        </div>
    </div>

    <!-- Details Grid -->
    <div class="details-grid">
        <div class="detail-card">
            <div class="detail-icon"><i class="fas fa-ruler-combined"></i></div>
            <div>
                <div class="detail-label">Farm Area</div>
                <div class="detail-value"><%= farmArea %> acres</div>
            </div>
        </div>
        <div class="detail-card">
            <div class="detail-icon"><i class="fas fa-phone"></i></div>
            <div>
                <div class="detail-label">Contact</div>
                <div class="detail-value"><%= contactNumber %></div>
            </div>
        </div>
        <div class="detail-card">
            <div class="detail-icon"><i class="fas fa-calendar-alt"></i></div>
            <div>
                <div class="detail-label">Planted</div>
                <div class="detail-value"><%= plantingDate %></div>
            </div>
        </div>
        <div class="detail-card">
            <div class="detail-icon"><i class="fas fa-calendar-check"></i></div>
            <div>
                <div class="detail-label">Harvest</div>
                <div class="detail-value"><%= harvestDate %></div>
            </div>
        </div>
        <div class="detail-card">
            <div class="detail-icon"><i class="fas fa-hourglass-half"></i></div>
            <div>
                <div class="detail-label">Days Left</div>
                <div class="detail-value"><%= daysRemaining %> days</div>
            </div>
        </div>
        <div class="detail-card">
            <div class="detail-icon"><i class="fas fa-seedling"></i></div>
            <div>
                <div class="detail-label">Stage</div>
                <div class="detail-value" style="color: <%= stageColors[stageIndex] %>">
                    <%= growthStages[stageIndex] %>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== BEAUTIFUL FACTS SECTION WITH FONT AWESOME ICONS ===== -->
    <div class="facts-section">
        <div class="facts-title">
            <i class="fas fa-info-circle"></i>
            About <%= cropName %> in India
        </div>
        <div class="facts-grid">
            <div class="fact-card">
                <div class="fact-icon">
                    <i class="fas fa-trophy"></i>
                </div>
                <div class="fact-text"><%= facts[0] %></div>
            </div>
            <div class="fact-card">
                <div class="fact-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div class="fact-text"><%= facts[1] %></div>
            </div>
            <div class="fact-card">
                <div class="fact-icon">
                    <i class="fas fa-thermometer-half"></i>
                </div>
                <div class="fact-text"><%= facts[2] %></div>
            </div>
        </div>
    </div>

    <!-- Split View -->
    <div class="split-view">
        <div class="progress-card">
            <h3 class="progress-title">
                <i class="fas fa-chart-line" style="color: #2e7d32;"></i> Growth Progress
            </h3>
            <div class="timeline">
                <% for(int i = 0; i < growthStages.length; i++) { %>
                <div class="stage <%= (i == stageIndex) ? "active" : "" %>">
                    <div class="stage-dot">
                        <%= i == 0 ? "🌱" : (i == 1 ? "🌿" : (i == 2 ? "🌸" : (i == 3 ? "🍎" : "🌾"))) %>
                    </div>
                    <div class="stage-name"><%= growthStages[i] %></div>
                </div>
                <% } %>
            </div>
            <div style="margin-top: 2rem;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                    <span style="color: #64748b;">Overall Progress</span>
                    <span style="color: #2e7d32; font-weight: 700;"><%= progress %>%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill"></div>
                </div>
            </div>
        </div>

        <div class="stage-card">
            <div class="stage-emoji">
                <%= stageIndex == 0 ? "🌱" : (stageIndex == 1 ? "🌿" : (stageIndex == 2 ? "🌸" : (stageIndex == 3 ? "🍎" : "🌾"))) %>
            </div>
            <span class="stage-badge">Current: <%= growthStages[stageIndex] %></span>
            <h3 style="margin: 1rem 0; font-size: 1.2rem;"><%= growthStages[stageIndex] %> Stage of <%= cropName %></h3>
            <p style="color: #64748b; line-height: 1.6;">
                <% if(stageIndex == 0) { %>
                Young plants are establishing root systems and first leaves. This critical period requires careful attention to moisture and protection from pests.
                <% } else if(stageIndex == 1) { %>
                Rapid growth phase where plants develop strong stems and abundant leaves, preparing for reproduction.
                <% } else if(stageIndex == 2) { %>
                Plants are now producing flowers. This stage is essential for pollination and determines future yield.
                <% } else if(stageIndex == 3) { %>
                Fruits are forming and maturing. This stage requires maximum nutrients and consistent water.
                <% } else { %>
                Crops have reached maturity and are ready for harvest. Monitor closely for optimal timing.
                <% } %>
            </p>
        </div>
    </div>

    <!-- Weather Card -->
    <div class="weather-card">
        <div class="weather-header">
            <div class="weather-main">
                <div class="weather-emoji"><%= weatherIcons[weatherIndex] %></div>
                <div>
                    <div class="weather-temp"><%= temperature %>°C</div>
                    <div style="opacity: 0.9;"><%= weatherConditions[weatherIndex] %></div>
                </div>
            </div>
            <div style="background: rgba(255,255,255,0.15); padding: 0.5rem 1.2rem; border-radius: 50px;">
                <i class="fas fa-map-marker-alt"></i> Farm Location
            </div>
        </div>
        <div class="weather-grid">
            <div class="weather-stat">
                <i class="fas fa-tint"></i>
                <div>
                    <div style="font-size: 1.2rem; font-weight: 600;"><%= humidity %>%</div>
                    <div style="font-size: 0.75rem; opacity: 0.8;">Humidity</div>
                </div>
            </div>
            <div class="weather-stat">
                <i class="fas fa-wind"></i>
                <div>
                    <div style="font-size: 1.2rem; font-weight: 600;"><%= windSpeed %> km/h</div>
                    <div style="font-size: 0.75rem; opacity: 0.8;">Wind</div>
                </div>
            </div>
            <div class="weather-stat">
                <i class="fas fa-cloud-rain"></i>
                <div>
                    <div style="font-size: 1.2rem; font-weight: 600;"><%= rainfall %> mm</div>
                    <div style="font-size: 0.75rem; opacity: 0.8;">Rain</div>
                </div>
            </div>
            <div class="weather-stat">
                <i class="fas fa-sun"></i>
                <div>
                    <div style="font-size: 1.2rem; font-weight: 600;"><%= uvIndex %></div>
                    <div style="font-size: 0.75rem; opacity: 0.8;">UV Index</div>
                </div>
            </div>
            <div class="weather-stat">
                <i class="fas fa-cloud"></i>
                <div>
                    <div style="font-size: 1.2rem; font-weight: 600;"><%= weatherConditions[weatherIndex] %></div>
                    <div style="font-size: 0.75rem; opacity: 0.8;">Condition</div>
                </div>
            </div>
            <div class="weather-stat">
                <i class="fas fa-calendar"></i>
                <div>
                    <div style="font-size: 1.2rem; font-weight: 600;"><%= new java.text.SimpleDateFormat("dd MMM").format(new java.util.Date()) %></div>
                    <div style="font-size: 0.75rem; opacity: 0.8;">Today</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recommendations -->
    <div class="recommendations">
        <h3 style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
            <i class="fas fa-lightbulb" style="color: #ff9800;"></i> Recommendations
        </h3>
        <div class="rec-item">
            <div class="rec-icon"><i class="fas fa-water"></i></div>
            <div>
                <h4 style="margin-bottom: 0.3rem;">Water Management</h4>
                <p style="color: #64748b;">Maintain consistent soil moisture for <%= cropName %>. Water deeply but less frequently.</p>
            </div>
        </div>
        <div class="rec-item">
            <div class="rec-icon"><i class="fas fa-flask"></i></div>
            <div>
                <h4 style="margin-bottom: 0.3rem;">Fertilization</h4>
                <p style="color: #64748b;">Apply appropriate fertilizers based on growth stage and soil requirements.</p>
            </div>
        </div>
        <div class="rec-item">
            <div class="rec-icon"><i class="fas fa-bug"></i></div>
            <div>
                <h4 style="margin-bottom: 0.3rem;">Pest Management</h4>
                <p style="color: #64748b;">Monitor regularly for pests and diseases. Take preventive measures early.</p>
            </div>
        </div>
    </div>

    <!-- Print Button -->
    <button class="print-btn" onclick="window.print()">
        <i class="fas fa-print"></i> Print Crop Details
    </button>
</div>
</body>
</html>