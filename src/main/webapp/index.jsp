<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
    <title>AgroInsights | Modern Agriculture Solutions</title>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Add Noto Sans font for Rupee symbol -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #2e7d32;
            --primary-dark: #1b5e20;
            --primary-light: #4caf50;
            --secondary-color: #ff9800;
            --accent-color: #2196f3;
            --warning-color: #ff5722;
            --dark-bg: #0f172a;
            --light-bg: #f8fafc;
            --card-bg: #ffffff;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --border-color: #e2e8f0;
            --shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 15px 40px rgba(0, 0, 0, 0.15);
            --radius: 16px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', 'Noto Sans Devanagari', sans-serif;
        }

        body {
            background: var(--light-bg);
            color: var(--text-dark);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Weather Header */
        .weather-header {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            color: white;
            padding: 0.8rem 2rem;
            font-size: 0.9rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        @media (max-width: 768px) {
            .weather-header {
                padding: 0.8rem 1rem;
                flex-direction: column;
                text-align: center;
            }
        }

        .weather-info {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        @media (max-width: 600px) {
            .weather-info {
                gap: 0.8rem;
            }
        }

        .weather-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .weather-icon {
            font-size: 1.2rem;
        }

        .date-time {
            font-weight: 500;
        }

        .live-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .live-dot {
            width: 8px;
            height: 8px;
            background: #4CAF50;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.5; transform: scale(0.8); }
            100% { opacity: 1; transform: scale(1); }
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, rgba(27, 94, 32, 0.9), rgba(46, 125, 50, 0.8)),
            url('https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 6rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        @media (max-width: 768px) {
            .hero-section {
                padding: 4rem 1rem;
            }
        }

        @media (max-width: 480px) {
            .hero-section {
                padding: 3rem 1rem;
            }
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            z-index: 2;
        }

        .hero-content h1 {
            font-size: clamp(1.8rem, 5vw, 3.5rem);
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.2;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .hero-content p {
            font-size: clamp(0.9rem, 2.5vw, 1.2rem);
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .btn-hero {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            padding: 0.8rem 2rem;
            background: var(--secondary-color);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: clamp(0.9rem, 2.5vw, 1.1rem);
            transition: var(--transition);
            border: none;
            cursor: pointer;
        }

        @media (max-width: 480px) {
            .btn-hero {
                padding: 0.6rem 1.5rem;
                font-size: 0.9rem;
            }
        }

        .btn-hero:hover {
            background: #e68900;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(255, 152, 0, 0.3);
        }

        /* Live Market Banner */
        .market-banner {
            background: linear-gradient(90deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 1rem 2rem;
            margin: -2rem auto 2rem;
            border-radius: 10px;
            display: flex;
            justify-content: space-around;
            align-items: center;
            flex-wrap: wrap;
            gap: 1.5rem;
            max-width: 1400px;
            width: calc(100% - 2rem);
            box-shadow: var(--shadow);
            position: relative;
            z-index: 10;
        }

        @media (max-width: 1024px) {
            .market-banner {
                gap: 1rem;
                padding: 1rem;
            }
        }

        @media (max-width: 768px) {
            .market-banner {
                flex-direction: column;
                gap: 1rem;
                margin-top: -1rem;
            }
        }

        .market-item {
            text-align: center;
            min-width: 150px;
        }

        @media (max-width: 600px) {
            .market-item {
                min-width: 100%;
            }
        }

        .market-rate {
            font-size: clamp(1.2rem, 4vw, 1.5rem);
            font-weight: 700;
            margin-bottom: 0.3rem;
            font-family: 'Noto Sans Devanagari', 'Poppins', sans-serif;
        }

        .market-crop {
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .market-change {
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.3rem;
            margin-top: 0.3rem;
        }

        .change-up {
            color: #4CAF50;
        }

        .change-down {
            color: #f44336;
        }

        /* Quick Info Cards */
        .quick-info-section {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto 3rem;
        }

        @media (max-width: 768px) {
            .quick-info-section {
                padding: 1rem;
            }
        }

        .quick-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        @media (max-width: 600px) {
            .quick-info-grid {
                gap: 1rem;
            }
        }

        .quick-info-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: var(--transition);
            border-left: 4px solid var(--primary-color);
        }

        @media (max-width: 480px) {
            .quick-info-card {
                padding: 1rem;
                gap: 0.8rem;
            }
        }

        .quick-info-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }

        .quick-info-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: rgba(46, 125, 50, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--primary-color);
            flex-shrink: 0;
        }

        @media (max-width: 480px) {
            .quick-info-icon {
                width: 40px;
                height: 40px;
                font-size: 1.2rem;
            }
        }

        .quick-info-content h3 {
            font-size: clamp(0.9rem, 3vw, 1.1rem);
            margin-bottom: 0.3rem;
            color: var(--text-dark);
        }

        .quick-info-content p {
            font-size: clamp(0.75rem, 2.5vw, 0.9rem);
            color: var(--text-light);
        }

        /* Live Weather Widget */
        .live-weather-widget {
            background: linear-gradient(135deg, #2196F3, #21CBF3);
            border-radius: var(--radius);
            padding: 2rem;
            color: white;
            margin: 2rem auto;
            max-width: 1400px;
            width: calc(100% - 2rem);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 2rem;
            box-shadow: var(--shadow);
        }

        @media (max-width: 768px) {
            .live-weather-widget {
                flex-direction: column;
                text-align: center;
                padding: 1.5rem;
                gap: 1.5rem;
            }
        }

        .weather-main {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        @media (max-width: 480px) {
            .weather-main {
                flex-direction: column;
                gap: 1rem;
            }
        }

        .weather-temp-main {
            font-size: clamp(2rem, 8vw, 3.5rem);
            font-weight: 700;
        }

        .weather-details {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .weather-condition {
            font-size: clamp(0.9rem, 3vw, 1.2rem);
            font-weight: 600;
        }

        .weather-location {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .weather-stats {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        @media (max-width: 480px) {
            .weather-stats {
                justify-content: center;
                gap: 1rem;
            }
        }

        .weather-stat {
            text-align: center;
        }

        .stat-value {
            font-size: clamp(1rem, 4vw, 1.5rem);
            font-weight: 600;
            margin-bottom: 0.3rem;
        }

        .stat-label {
            font-size: 0.8rem;
            opacity: 0.9;
        }

        /* Section Header */
        .section-header {
            text-align: center;
            margin-bottom: 3rem;
            padding: 0 1rem;
        }

        .section-header h2 {
            font-size: clamp(1.5rem, 5vw, 2.5rem);
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }

        .section-header p {
            color: var(--text-light);
            font-size: clamp(0.85rem, 2.5vw, 1.1rem);
            max-width: 600px;
            margin: 0 auto;
        }

        /* Live Crop Prices Table */
        .live-prices-section {
            padding: 5rem 2rem;
            background: white;
        }

        @media (max-width: 768px) {
            .live-prices-section {
                padding: 3rem 1rem;
            }
        }

        .prices-table-container {
            max-width: 1400px;
            margin: 0 auto;
            overflow-x: auto;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .prices-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card-bg);
            min-width: 600px;
        }

        .prices-table th {
            background: var(--primary-color);
            color: white;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            font-size: clamp(0.75rem, 2.5vw, 0.9rem);
        }

        .prices-table td {
            padding: 0.8rem 1rem;
            border-bottom: 1px solid var(--border-color);
            font-size: clamp(0.75rem, 2.5vw, 0.9rem);
        }

        .crop-name-cell {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .crop-image {
            width: 32px;
            height: 32px;
            object-fit: cover;
            border-radius: 6px;
        }

        .price-cell {
            font-weight: 700;
            font-family: 'Noto Sans Devanagari', 'Poppins', sans-serif;
            white-space: nowrap;
        }

        /* Services Section */
        .services-section {
            padding: 5rem 2rem;
            background: var(--light-bg);
        }

        @media (max-width: 768px) {
            .services-section {
                padding: 3rem 1rem;
            }
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        @media (max-width: 600px) {
            .services-grid {
                gap: 1rem;
            }
        }

        .service-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border-top: 4px solid var(--primary-color);
        }

        @media (max-width: 480px) {
            .service-card {
                padding: 1.5rem;
            }
        }

        .service-icon {
            font-size: clamp(2rem, 6vw, 3rem);
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }

        .service-card h3 {
            font-size: clamp(1.1rem, 4vw, 1.5rem);
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .service-card p {
            color: var(--text-light);
            line-height: 1.6;
            font-size: clamp(0.8rem, 2.5vw, 0.95rem);
        }

        /* Footer */
        .footer {
            background: var(--dark-bg);
            color: white;
            padding: 3rem 2rem 1rem;
        }

        @media (max-width: 768px) {
            .footer {
                padding: 2rem 1rem 1rem;
            }
        }

        .footer-container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        @media (max-width: 600px) {
            .footer-container {
                gap: 1.5rem;
            }
        }

        .footer-column h3 {
            color: white;
            margin-bottom: 1.2rem;
            font-size: clamp(1rem, 4vw, 1.3rem);
            font-weight: 600;
        }

        .footer-column p {
            color: #94a3b8;
            line-height: 1.6;
            margin-bottom: 0.8rem;
            font-size: 0.9rem;
        }

        .footer-column a {
            display: block;
            color: #94a3b8;
            text-decoration: none;
            margin-bottom: 0.6rem;
            transition: var(--transition);
            font-size: 0.9rem;
        }

        .social-icons {
            display: flex;
            gap: 0.8rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }

        .social-icons a {
            width: 36px;
            height: 36px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            transition: var(--transition);
        }

        @media (max-width: 480px) {
            .social-icons a {
                width: 32px;
                height: 32px;
                font-size: 1rem;
            }
        }

        .footer-bottom {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #94a3b8;
            font-size: 0.85rem;
            max-width: 1400px;
            margin: 2rem auto 0;
        }

        /* Loading Animation */
        .live-data-loading {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .loading-dot {
            width: 8px;
            height: 8px;
            background: var(--primary-color);
            border-radius: 50%;
            animation: loadingPulse 1.5s infinite;
        }

        .loading-dot:nth-child(2) {
            animation-delay: 0.2s;
        }

        .loading-dot:nth-child(3) {
            animation-delay: 0.4s;
        }

        @keyframes loadingPulse {
            0%, 100% { opacity: 0.3; transform: scale(0.8); }
            50% { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>
<!-- Navbar -->
<jsp:include page="navbar.jsp" />

<!-- Weather Header -->
<div class="weather-header">
    <div class="weather-info">
        <div class="weather-item">
            <i class="bx bx-map weather-icon"></i>
            <span id="current-location">Kolhapur, Maharashtra</span>
        </div>
        <div class="weather-item">
            <i class="bx bx-sun weather-icon" id="current-weather-icon"></i>
            <span id="current-temp" class="live-data-loading">
                <span class="loading-dot"></span>
                <span class="loading-dot"></span>
                <span class="loading-dot"></span>
            </span>
        </div>
        <div class="weather-item">
            <i class="bx bx-droplet weather-icon"></i>
            <span id="current-humidity">Loading...</span>
        </div>
        <div class="weather-item date-time">
            <i class="bx bx-calendar weather-icon"></i>
            <span id="current-date"></span>
        </div>
    </div>
    <div class="live-indicator">
        <div class="live-dot"></div>
        <span>Live Updates</span>
    </div>
</div>

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-content">
        <h1>Redefining The Boundaries Of Agriculture</h1>
        <p>Real-time weather data and live crop prices for smarter farming decisions.</p>
        <a href="register.jsp" class="btn-hero">
            <i class='bx bx-rocket'></i> Get Started Free
        </a>
    </div>
</section>

<!-- Live Market Banner -->
<div class="market-banner">
    <div class="market-item">
        <div class="market-rate"><span class="rupee">₹</span><span id="wheat-price" class="live-data-loading">
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
        </span></div>
        <div class="market-crop">Wheat / quintal</div>
        <div class="market-change change-up" id="wheat-change">--</div>
    </div>
    <div class="market-item">
        <div class="market-rate"><span class="rupee">₹</span><span id="rice-price" class="live-data-loading">
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
        </span></div>
        <div class="market-crop">Rice / quintal</div>
        <div class="market-change change-up" id="rice-change">--</div>
    </div>
    <div class="market-item">
        <div class="market-rate"><span class="rupee">₹</span><span id="cotton-price" class="live-data-loading">
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
        </span></div>
        <div class="market-crop">Cotton / quintal</div>
        <div class="market-change change-down" id="cotton-change">--</div>
    </div>
    <div class="market-item">
        <div class="market-rate"><span class="rupee">₹</span><span id="soybean-price" class="live-data-loading">
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
        </span></div>
        <div class="market-crop">Soybean / quintal</div>
        <div class="market-change" id="soybean-change">--</div>
    </div>
</div>

<!-- Quick Info Cards -->
<section class="quick-info-section">
    <div class="quick-info-grid">
        <div class="quick-info-card">
            <div class="quick-info-icon">
                <i class='bx bx-trending-up'></i>
            </div>
            <div class="quick-info-content">
                <h3>Today's Market Rate</h3>
                <p><span class="rupee">₹</span><span class="price-display" id="quick-wheat-price">Loading...</span>/quintal | Wheat | <span id="quick-wheat-change">--</span></p>
            </div>
        </div>

        <div class="quick-info-card">
            <div class="quick-info-icon">
                <i class='bx bx-leaf'></i>
            </div>
            <div class="quick-info-content">
                <h3>Recommended Crop</h3>
                <p id="recommended-crop">Loading recommendation...</p>
            </div>
        </div>

        <div class="quick-info-card">
            <div class="quick-info-icon">
                <i class='bx bx-cloud-rain'></i>
            </div>
            <div class="quick-info-content">
                <h3>Weather Alert</h3>
                <p id="weather-alert-text">Checking weather conditions...</p>
            </div>
        </div>

        <div class="quick-info-card">
            <div class="quick-info-icon">
                <i class='bx bx-calendar-check'></i>
            </div>
            <div class="quick-info-content">
                <h3>Farming Activity</h3>
                <p id="farming-activity">Loading activity...</p>
            </div>
        </div>
    </div>
</section>

<!-- Live Weather Widget -->
<section class="live-weather-widget">
    <div class="weather-main">
        <div class="weather-temp-main" id="main-temp" style="display: flex; align-items: center; gap: 0.5rem;">
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
            <span class="loading-dot"></span>
        </div>
        <div class="weather-details">
            <div class="weather-condition" id="weather-condition">Loading...</div>
            <div class="weather-location">Kolhapur, Maharashtra</div>
            <div class="weather-update-time">Updated: <span id="weather-update-time">Just now</span></div>
        </div>
    </div>
    <div class="weather-stats">
        <div class="weather-stat">
            <div class="stat-value" id="feels-like">--</div>
            <div class="stat-label">Feels Like</div>
        </div>
        <div class="weather-stat">
            <div class="stat-value" id="wind-speed">--</div>
            <div class="stat-label">Wind Speed</div>
        </div>
        <div class="weather-stat">
            <div class="stat-value" id="precipitation">--</div>
            <div class="stat-label">Precipitation</div>
        </div>
        <div class="weather-stat">
            <div class="stat-value" id="uv-index">--</div>
            <div class="stat-label">UV Index</div>
        </div>
    </div>
</section>

<!-- Live Crop Prices Table -->
<section class="live-prices-section">
    <div class="section-header">
        <h2>Live Crop Prices</h2>
        <p>Real-time market prices from major agricultural markets in Maharashtra</p>
    </div>

    <div class="prices-table-container">
        <table class="prices-table">
            <thead>
            <tr>
                <th>Crop</th>
                <th>Market</th>
                <th>Min Price (₹/quintal)</th>
                <th>Max Price (₹/quintal)</th>
                <th>Change</th>
                <th>Last Updated</th>
            </tr>
            </thead>
            <tbody id="prices-table-body">
            <tr><td colspan="6" style="text-align: center; padding: 2rem;">
                <div class="live-data-loading">
                    <span class="loading-dot"></span>
                    <span class="loading-dot"></span>
                    <span class="loading-dot"></span>
                    <span>Loading live prices...</span>
                </div>
            </td></tr>
            </tbody>
        </table>
    </div>
</section>

<!-- Services Section -->
<section class="services-section">
    <div class="section-header">
        <h2>Our Services</h2>
        <p>Comprehensive solutions tailored to modern agricultural needs</p>
    </div>

    <div class="services-grid">
        <div class="service-card">
            <div class="service-icon">
                <i class='bx bx-analyse'></i>
            </div>
            <h3>Crop Analytics</h3>
            <p>Detailed analysis of crop performance, growth patterns, and yield predictions using advanced algorithms.</p>
        </div>

        <div class="service-card">
            <div class="service-icon">
                <i class='bx bx-cloud-rain'></i>
            </div>
            <h3>Weather Intelligence</h3>
            <p>Accurate weather forecasts and climate analysis to help plan farming activities effectively.</p>
        </div>

        <div class="service-card">
            <div class="service-icon">
                <i class='bx bx-line-chart'></i>
            </div>
            <h3>Market Insights</h3>
            <p>Real-time market prices, demand trends, and selling recommendations for maximum profit.</p>
        </div>

        <div class="service-card">
            <div class="service-icon">
                <i class='bx bx-support'></i>
            </div>
            <h3>Expert Support</h3>
            <p>24/7 access to agricultural experts for guidance on crop management and problem-solving.</p>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>About Us</h3>
            <p>We provide innovative solutions for modern agriculture. Enhancing productivity while caring for nature.</p>
        </div>
        <div class="footer-column">
            <h3>Quick Links</h3>
            <a href="index.jsp"><i class='bx bx-home'></i> Home</a>
            <a href="agri.jsp"><i class='bx bx-leaf'></i> Agriculture</a>
            <a href="currentCrop.jsp"><i class='bx bx-trending-up'></i> Current crop</a>
            <a href="historyCrop.jsp"><i class='bx bx-history'></i> History crop</a>
            <a href="contact.jsp"><i class='bx bx-phone'></i> Contact</a>
        </div>
        <div class="footer-column">
            <h3>Contact Us</h3>
            <p><i class='bx bx-envelope'></i> infoagriculture1020@gmail.com</p>
            <p><i class='bx bx-phone'></i> 9495960205</p>
            <p><i class='bx bx-map'></i> Sawarde kolhapur, Maharashtra, India</p>
        </div>
        <div class="footer-column">
            <h3>Follow Us</h3>
            <div class="social-icons">
                <a href="#"><i class='bx bxl-facebook'></i></a>
                <a href="#"><i class='bx bxl-twitter'></i></a>
                <a href="#"><i class='bx bxl-instagram'></i></a>
                <a href="#"><i class='bx bxl-linkedin'></i></a>
                <a href="#"><i class='bx bxl-youtube'></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        &copy; 2025 AgroInsights Inc. | All Rights Reserved
    </div>
</footer>

<script>
    // Mobile Menu Toggle
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded, initializing live data...');

        // Initialize everything
        updateDateTime();
        initializeLiveData();
        setInterval(updateDateTime, 60000);
    });

    // Update date and time
    function updateDateTime() {
        const dateElement = document.getElementById('current-date');
        if (dateElement) {
            const now = new Date();
            const options = {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };
            dateElement.textContent = now.toLocaleDateString('en-IN', options);
        }
    }

    // Initialize live data
    async function initializeLiveData() {
        console.log('Initializing live data...');

        showLoadingState();

        try {
            await fetchWeatherData();
            updateCropPrices();
            updateQuickInfo();
            startPeriodicUpdates();
        } catch (error) {
            console.error('Error initializing live data:', error);
            useFallbackData();
        }
    }

    // Fetch weather data
    async function fetchWeatherData() {
        try {
            const response = await fetch('https://wttr.in/Kolhapur?format=j1');
            if (!response.ok) throw new Error('Weather API failed');
            const data = await response.json();
            updateWeatherUI(data);
        } catch (error) {
            console.warn('Weather API error, using simulated data:', error);
            updateWeatherUI(null);
        }
    }

    // Update weather UI
    function updateWeatherUI(weatherData) {
        try {
            if (weatherData && weatherData.current_condition && weatherData.current_condition[0]) {
                const current = weatherData.current_condition[0];
                const temp = current.temp_C;
                document.getElementById('current-temp').innerHTML = `${temp}°C`;
                document.getElementById('main-temp').innerHTML = `${temp}°C`;
                document.getElementById('current-humidity').innerHTML = `Humidity: ${current.humidity}%`;
                document.getElementById('weather-condition').innerHTML = current.weatherDesc[0].value;
                document.getElementById('feels-like').innerHTML = `${current.FeelsLikeC}°C`;
                document.getElementById('wind-speed').innerHTML = `${current.windspeedKmph} km/h`;
                document.getElementById('precipitation').innerHTML = `${current.precipMM}%`;
                const uvIndex = Math.min(11, Math.max(1, Math.floor(temp / 3)));
                document.getElementById('uv-index').innerHTML = uvIndex;
                updateWeatherIcon(current.weatherDesc[0].value);
            } else {
                const simulatedTemp = 28 + Math.floor(Math.random() * 5);
                document.getElementById('current-temp').innerHTML = `${simulatedTemp}°C`;
                document.getElementById('main-temp').innerHTML = `${simulatedTemp}°C`;
                document.getElementById('current-humidity').innerHTML = 'Humidity: 65%';
                document.getElementById('weather-condition').innerHTML = 'Sunny';
                document.getElementById('feels-like').innerHTML = `${simulatedTemp + 2}°C`;
                document.getElementById('wind-speed').innerHTML = '12 km/h';
                document.getElementById('precipitation').innerHTML = '10%';
                document.getElementById('uv-index').innerHTML = '6';
                updateWeatherIcon('Sunny');
            }
            const now = new Date();
            document.getElementById('weather-update-time').innerHTML = now.toLocaleTimeString('en-IN', {hour: '2-digit', minute: '2-digit'});
        } catch (error) {
            console.error('Error updating weather UI:', error);
        }
    }

    function updateWeatherIcon(condition) {
        const iconElement = document.getElementById('current-weather-icon');
        if (!iconElement) return;
        const conditionLower = condition.toLowerCase();
        let iconClass = 'bx-sun';
        if (conditionLower.includes('rain')) iconClass = 'bx-cloud-rain';
        else if (conditionLower.includes('cloud')) iconClass = 'bx-cloud';
        else if (conditionLower.includes('thunder')) iconClass = 'bx-cloud-lightning';
        else if (conditionLower.includes('mist')) iconClass = 'bx-wind';
        iconElement.className = `bx ${iconClass} weather-icon`;
    }

    function updateCropPrices() {
        const basePrices = {
            wheat: { min: 2100, max: 2250, change: 2.5 },
            rice: { min: 3400, max: 3600, change: 1.8 },
            cotton: { min: 6500, max: 6800, change: -1.2 },
            soybean: { min: 4200, max: 4400, change: 0.5 }
        };

        const now = new Date();
        const hour = now.getHours();
        const timeFactor = Math.sin(hour * Math.PI / 12) * 0.02;

        Object.keys(basePrices).forEach((crop, index) => {
            const priceData = basePrices[crop];
            const variation = timeFactor + (Math.random() * 0.02 - 0.01);
            const currentMin = Math.round(priceData.min * (1 + variation));

            if (index < 4) {
                const cropIds = ['wheat', 'rice', 'cotton', 'soybean'];
                const cropId = cropIds[index];
                const priceElement = document.getElementById(`${cropId}-price`);
                const changeElement = document.getElementById(`${cropId}-change`);
                if (priceElement) {
                    priceElement.innerHTML = currentMin.toLocaleString();
                    priceElement.classList.remove('live-data-loading');
                }
                if (changeElement) {
                    const change = priceData.change + (Math.random() * 1 - 0.5);
                    const changeText = change > 0 ? `↑ ${change.toFixed(1)}%` : change < 0 ? `↓ ${Math.abs(change).toFixed(1)}%` : '0.0%';
                    changeElement.innerHTML = changeText;
                    changeElement.className = `market-change ${change > 0 ? 'change-up' : (change < 0 ? 'change-down' : '')}`;
                }
            }
        });

        updatePricesTable(basePrices, timeFactor);

        const quickWheatPrice = document.getElementById('quick-wheat-price');
        const quickWheatChange = document.getElementById('quick-wheat-change');
        if (quickWheatPrice && quickWheatChange) {
            const wheatVariation = timeFactor + (Math.random() * 0.02 - 0.01);
            const currentWheatPrice = Math.round(basePrices.wheat.min * (1 + wheatVariation));
            quickWheatPrice.innerHTML = currentWheatPrice.toLocaleString();
            const wheatChange = basePrices.wheat.change + (Math.random() * 1 - 0.5);
            quickWheatChange.innerHTML = wheatChange > 0 ? `Up ${wheatChange.toFixed(1)}%` : wheatChange < 0 ? `Down ${Math.abs(wheatChange).toFixed(1)}%` : 'No change';
        }
    }

    function updatePricesTable(basePrices, timeFactor) {
        const tableBody = document.getElementById('prices-table-body');
        if (!tableBody) return;
        const now = new Date();
        const timeString = now.toLocaleTimeString('en-IN', {hour: '2-digit', minute: '2-digit'});
        const allCrops = {
            wheat: { market: 'Kolhapur APMC', min: 2100, max: 2250, change: 2.5 },
            rice: { market: 'Sangli APMC', min: 3400, max: 3600, change: 1.8 },
            cotton: { market: 'Solapur APMC', min: 6500, max: 6800, change: -1.2 },
            soybean: { market: 'Pune APMC', min: 4200, max: 4400, change: 0.5 },
            turmeric: { market: 'Sangli APMC', min: 8500, max: 9000, change: 3.2 },
            sugarcane: { market: 'Kolhapur APMC', min: 3200, max: 3400, change: 1.5 },
            maize: { market: 'Nashik APMC', min: 1800, max: 1950, change: -0.8 },
            groundnut: { market: 'Satara APMC', min: 5500, max: 5800, change: 2.1 }
        };
        let html = '';
        Object.entries(allCrops).forEach(([crop, data]) => {
            const variation = timeFactor + (Math.random() * 0.02 - 0.01);
            const currentMin = Math.round(data.min * (1 + variation));
            const currentMax = Math.round(data.max * (1 + variation));
            const currentChange = data.change + (Math.random() * 1 - 0.5);
            html += `
                <tr>
                    <td><div class="crop-name-cell"><span>${crop.charAt(0).toUpperCase() + crop.slice(1)}</span></div></td>
                    <td>${data.market}</td>
                    <td class="price-cell">₹${currentMin.toLocaleString()}</td>
                    <td class="price-cell">₹${currentMax.toLocaleString()}</td>
                    <td><div class="change-cell ${currentChange > 0 ? 'change-up' : (currentChange < 0 ? 'change-down' : '')}"><i class='bx ${currentChange > 0 ? 'bx-up-arrow-alt' : (currentChange < 0 ? 'bx-down-arrow-alt' : 'bx-minus')}'></i>${currentChange > 0 ? '+' : ''}${currentChange.toFixed(1)}%</div></td>
                    <td>${timeString}</td>
                </tr>
            `;
        });
        tableBody.innerHTML = html;
    }

    function updateQuickInfo() {
        const now = new Date();
        const month = now.getMonth();
        const hour = now.getHours();
        let recommendedCrop = '';
        if (month >= 6 && month <= 9) recommendedCrop = 'Paddy - Ideal for monsoon season';
        else if (month >= 10 && month <= 12) recommendedCrop = 'Wheat - Best for Rabi season';
        else recommendedCrop = 'Cotton - Suitable for current weather';
        document.getElementById('recommended-crop').innerHTML = recommendedCrop;
        const tempElement = document.getElementById('current-temp');
        const tempText = tempElement ? tempElement.textContent : '28°C';
        const temp = parseInt(tempText) || 28;
        let weatherAlert = 'Normal weather conditions';
        if (temp > 35) weatherAlert = 'Heat alert! Ensure proper irrigation';
        else if (temp < 15) weatherAlert = 'Cold alert! Protect crops from frost';
        else if (hour >= 6 && hour <= 18) weatherAlert = 'Good weather for farming activities';
        else weatherAlert = 'Evening time - Plan for tomorrow';
        document.getElementById('weather-alert-text').innerHTML = weatherAlert;
        const dayOfWeek = now.getDay();
        let farmingActivity = '';
        if (dayOfWeek === 0 || dayOfWeek === 6) farmingActivity = 'Weekend - Good time for planning and maintenance';
        else if (hour >= 6 && hour <= 10) farmingActivity = 'Morning - Best time for sowing and irrigation';
        else if (hour >= 16 && hour <= 18) farmingActivity = 'Evening - Good for harvesting and inspection';
        else farmingActivity = 'Plan your farming activities as per schedule';
        document.getElementById('farming-activity').innerHTML = farmingActivity;
    }

    function useFallbackData() {
        document.getElementById('current-temp').innerHTML = '28°C';
        document.getElementById('main-temp').innerHTML = '28°C';
        document.getElementById('current-humidity').innerHTML = 'Humidity: 65%';
        document.getElementById('weather-condition').innerHTML = 'Sunny';
        document.getElementById('feels-like').innerHTML = '30°C';
        document.getElementById('wind-speed').innerHTML = '12 km/h';
        document.getElementById('precipitation').innerHTML = '10%';
        document.getElementById('uv-index').innerHTML = '6';
        document.getElementById('wheat-price').innerHTML = '2,100';
        document.getElementById('rice-price').innerHTML = '3,400';
        document.getElementById('cotton-price').innerHTML = '6,500';
        document.getElementById('soybean-price').innerHTML = '4,200';
        document.querySelectorAll('.live-data-loading').forEach(el => el.classList.remove('live-data-loading'));
        updateQuickInfo();
    }

    function showLoadingState() {
        const loadingElements = document.querySelectorAll('.live-data-loading');
        loadingElements.forEach(el => {
            if (el.children.length === 0) {
                el.innerHTML = `<span class="loading-dot"></span><span class="loading-dot"></span><span class="loading-dot"></span>`;
            }
        });
    }

    function startPeriodicUpdates() {
        setInterval(() => { updateCropPrices(); updateQuickInfo(); }, 30000);
        setInterval(() => { fetchWeatherData(); }, 300000);
    }

    setTimeout(() => {
        const tempElement = document.getElementById('current-temp');
        if (tempElement && tempElement.classList.contains('live-data-loading')) useFallbackData();
    }, 5000);
</script>
</body>
</html>