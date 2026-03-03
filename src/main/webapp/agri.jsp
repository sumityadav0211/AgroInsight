<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agriculture Insights | AgroInsights</title>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #2e7d32;
            --primary-dark: #1b5e20;
            --primary-light: #4caf50;
            --secondary-color: #ff9800;
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
            background: var(--light-bg);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .hero-section {
            background: linear-gradient(rgba(46, 125, 50, 0.9), rgba(27, 94, 32, 0.9));
            color: white;
            padding: 6rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path fill="white" fill-opacity="0.05" d="M50,0 C22.4,0 0,22.4 0,50 C0,77.6 22.4,100 50,100 C77.6,100 100,77.6 100,50 C100,22.4 77.6,0 50,0 Z M50,90 C27.9,90 10,72.1 10,50 C10,27.9 27.9,10 50,10 C72.1,10 90,27.9 90,50 C90,72.1 72.1,90 50,90 Z"/></svg>');
            background-size: 200px;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }

        .hero-content h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .hero-content p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .content-section {
            padding: 5rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-header h2 {
            font-size: 2.5rem;
            color: var(--primary-dark);
            margin-bottom: 1rem;
        }

        .section-header p {
            color: var(--text-light);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .info-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 4rem;
        }

        .info-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }

        .info-card h3 {
            color: var(--primary-dark);
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }

        .info-card p {
            color: var(--text-light);
            line-height: 1.6;
        }

        /* Soil Information Section */
        .soil-info-section {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 5rem 2rem;
            margin: 4rem 0;
        }

        .soil-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .soil-type-card {
            background: white;
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary-color);
        }

        .soil-type-card h3 {
            color: var(--primary-dark);
            margin-bottom: 1rem;
            font-size: 1.3rem;
        }

        .soil-property {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px dashed var(--border-color);
        }

        .soil-property span:last-child {
            font-weight: 600;
            color: var(--primary-dark);
        }

        /* Crop Information Section */
        .crops-section {
            padding: 5rem 2rem;
        }

        .crops-tabs {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 3rem;
            flex-wrap: wrap;
        }

        .crop-tab {
            padding: 0.8rem 2rem;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 50px;
            cursor: pointer;
            font-weight: 500;
            transition: var(--transition);
            min-width: 120px;
            text-align: center;
        }

        .crop-tab.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .crop-tab:hover:not(.active) {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .crop-details {
            display: none;
            background: white;
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .crop-details.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .crop-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--border-color);
            flex-wrap: wrap;
            gap: 1rem;
        }

        .crop-header h3 {
            font-size: 1.8rem;
            color: var(--primary-dark);
        }

        .crop-lifecycle {
            background: var(--primary-light);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .crop-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .crop-info-item {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 12px;
            border-left: 4px solid var(--secondary-color);
        }

        .crop-info-item h4 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }

        .crop-info-item p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .crop-stages {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border-color);
        }

        .stage-timeline {
            display: flex;
            justify-content: space-between;
            margin-top: 1.5rem;
            position: relative;
            overflow-x: auto;
            padding-bottom: 1rem;
        }

        .stage-timeline::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--border-color);
            z-index: 1;
        }

        .stage {
            text-align: center;
            position: relative;
            z-index: 2;
            background: white;
            padding: 0 1rem;
            min-width: 120px;
        }

        .stage-dot {
            width: 40px;
            height: 40px;
            background: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin: 0 auto 0.5rem;
            font-size: 0.9rem;
        }

        .stage-name {
            font-weight: 500;
            color: var(--text-dark);
            font-size: 0.9rem;
            margin-bottom: 0.3rem;
        }

        .stage-duration {
            font-size: 0.8rem;
            color: var(--text-light);
        }

        /* Calculator Section */
        .calculator-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5rem 2rem;
            margin: 4rem 0;
        }

        .calculator-container {
            max-width: 600px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 2rem;
            border-radius: var(--radius);
        }

        .calculator-input {
            width: 100%;
            padding: 1rem;
            margin-bottom: 1rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.9);
        }

        .calculator-input:focus {
            outline: 2px solid var(--primary-color);
        }

        .calculator-result {
            background: rgba(255, 255, 255, 0.2);
            padding: 1.5rem;
            border-radius: 8px;
            margin-top: 1rem;
            display: none;
        }

        .calculator-result.active {
            display: block;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Weather Widget */
        .weather-widget {
            background: white;
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            margin: 2rem 0;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .weather-icon {
            font-size: 3rem;
            color: var(--secondary-color);
        }

        .weather-info {
            flex: 1;
            min-width: 200px;
        }

        .weather-info h4 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .weather-info p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.3rem;
        }

        /* AI Section */
        .ai-section {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            color: white;
            padding: 5rem 2rem;
            margin: 4rem 0;
            text-align: center;
        }

        .ai-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .ai-content h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .ai-content p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .btn-ai {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            padding: 1rem 2.5rem;
            background: white;
            color: var(--primary-color);
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .btn-ai:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        /* Soil Health Section */
        .soil-health-section {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            padding: 4rem 2rem;
            border-radius: var(--radius);
            margin: 3rem 0;
        }

        .soil-content {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }

        .soil-content h2 {
            color: var(--primary-dark);
            font-size: 2.2rem;
            margin-bottom: 1rem;
        }

        .soil-content p {
            color: var(--text-dark);
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2.5rem;
            }

            .section-header h2 {
                font-size: 2rem;
            }

            .crops-tabs {
                gap: 0.5rem;
            }

            .crop-tab {
                padding: 0.6rem 1.2rem;
                font-size: 0.9rem;
                min-width: 100px;
            }

            .crop-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .stage-timeline {
                flex-wrap: nowrap;
                overflow-x: auto;
            }

            .stage {
                min-width: 100px;
            }

            .weather-widget {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-content">
        <h1>We are in a new era of agriculture</h1>
        <p>Transforming farming with technology, data, and sustainable practices for a better tomorrow</p>
    </div>
</section>

<!-- Soil Information Section -->
<section class="soil-info-section">
    <div class="section-header">
        <h2>Soil Types & Properties</h2>
        <p>Understanding different soil types and their characteristics for optimal crop cultivation</p>
    </div>

    <div class="soil-grid">
        <div class="soil-type-card">
            <h3>Loamy Soil</h3>
            <div class="soil-property">
                <span>Texture</span>
                <span>Medium</span>
            </div>
            <div class="soil-property">
                <span>Drainage</span>
                <span>Good</span>
            </div>
            <div class="soil-property">
                <span>pH Range</span>
                <span>6.0-7.0</span>
            </div>
            <div class="soil-property">
                <span>Best For</span>
                <span>Most Crops</span>
            </div>
            <div class="soil-property">
                <span>Water Retention</span>
                <span>Medium-High</span>
            </div>
        </div>

        <div class="soil-type-card">
            <h3>Clay Soil</h3>
            <div class="soil-property">
                <span>Texture</span>
                <span>Fine</span>
            </div>
            <div class="soil-property">
                <span>Drainage</span>
                <span>Poor</span>
            </div>
            <div class="soil-property">
                <span>pH Range</span>
                <span>5.5-6.5</span>
            </div>
            <div class="soil-property">
                <span>Best For</span>
                <span>Rice, Wheat</span>
            </div>
            <div class="soil-property">
                <span>Water Retention</span>
                <span>High</span>
            </div>
        </div>

        <div class="soil-type-card">
            <h3>Sandy Soil</h3>
            <div class="soil-property">
                <span>Texture</span>
                <span>Coarse</span>
            </div>
            <div class="soil-property">
                <span>Drainage</span>
                <span>Excellent</span>
            </div>
            <div class="soil-property">
                <span>pH Range</span>
                <span>6.5-7.5</span>
            </div>
            <div class="soil-property">
                <span>Best For</span>
                <span>Root Vegetables</span>
            </div>
            <div class="soil-property">
                <span>Water Retention</span>
                <span>Low</span>
            </div>
        </div>
    </div>
</section>

<!-- Crop Information Section -->
<section class="crops-section">
    <div class="section-header">
        <h2>Crop Cultivation Guide</h2>
        <p>Detailed information about popular crops including lifecycle, soil requirements, and cultivation practices</p>
    </div>

    <div class="crops-tabs">
        <div class="crop-tab active" data-crop="wheat">Wheat</div>
        <div class="crop-tab" data-crop="rice">Rice</div>
        <div class="crop-tab" data-crop="corn">Corn</div>
        <div class="crop-tab" data-crop="soybean">Soybean</div>
        <div class="crop-tab" data-crop="cotton">Cotton</div>
    </div>

    <!-- Wheat Crop Details -->
    <div class="crop-details active" id="wheat">
        <div class="crop-header">
            <h3>Wheat Cultivation Guide</h3>
            <div class="crop-lifecycle">Life Cycle: 120-150 days</div>
        </div>

        <div class="crop-grid">
            <div class="crop-info-item">
                <h4>Best Soil Type</h4>
                <p>Clay loam with good drainage</p>
            </div>
            <div class="crop-info-item">
                <h4>Ideal pH Range</h4>
                <p>6.0 - 7.5</p>
            </div>
            <div class="crop-info-item">
                <h4>Temperature Range</h4>
                <p>15°C - 25°C</p>
            </div>
            <div class="crop-info-item">
                <h4>Water Requirement</h4>
                <p>450-650 mm per season</p>
            </div>
            <div class="crop-info-item">
                <h4>Sowing Season</h4>
                <p>October-November (Winter)</p>
            </div>
            <div class="crop-info-item">
                <h4>Harvest Time</h4>
                <p>March-April</p>
            </div>
        </div>

        <div class="crop-stages">
            <h4>Growth Stages & Timeline</h4>
            <div class="stage-timeline">
                <div class="stage">
                    <div class="stage-dot">1</div>
                    <div class="stage-name">Germination</div>
                    <div class="stage-duration">7-10 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">2</div>
                    <div class="stage-name">Tillering</div>
                    <div class="stage-duration">30-45 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">3</div>
                    <div class="stage-name">Stem Extension</div>
                    <div class="stage-duration">25-35 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">4</div>
                    <div class="stage-name">Grain Fill</div>
                    <div class="stage-duration">30-40 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">5</div>
                    <div class="stage-name">Maturity</div>
                    <div class="stage-duration">15-20 days</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Rice Crop Details -->
    <div class="crop-details" id="rice">
        <div class="crop-header">
            <h3>Rice Cultivation Guide</h3>
            <div class="crop-lifecycle">Life Cycle: 90-150 days</div>
        </div>

        <div class="crop-grid">
            <div class="crop-info-item">
                <h4>Best Soil Type</h4>
                <p>Clay loam with water retention</p>
            </div>
            <div class="crop-info-item">
                <h4>Ideal pH Range</h4>
                <p>5.5 - 6.5</p>
            </div>
            <div class="crop-info-item">
                <h4>Temperature Range</h4>
                <p>20°C - 35°C</p>
            </div>
            <div class="crop-info-item">
                <h4>Water Requirement</h4>
                <p>1000-2000 mm per season</p>
            </div>
            <div class="crop-info-item">
                <h4>Sowing Season</h4>
                <p>June-July (Kharif)</p>
            </div>
            <div class="crop-info-item">
                <h4>Harvest Time</h4>
                <p>October-November</p>
            </div>
        </div>

        <div class="crop-stages">
            <h4>Growth Stages & Timeline</h4>
            <div class="stage-timeline">
                <div class="stage">
                    <div class="stage-dot">1</div>
                    <div class="stage-name">Nursery</div>
                    <div class="stage-duration">25-30 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">2</div>
                    <div class="stage-name">Transplanting</div>
                    <div class="stage-duration">Immediate</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">3</div>
                    <div class="stage-name">Vegetative</div>
                    <div class="stage-duration">30-40 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">4</div>
                    <div class="stage-name">Reproductive</div>
                    <div class="stage-duration">30 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">5</div>
                    <div class="stage-name">Ripening</div>
                    <div class="stage-duration">25-30 days</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Corn Crop Details -->
    <div class="crop-details" id="corn">
        <div class="crop-header">
            <h3>Corn (Maize) Cultivation Guide</h3>
            <div class="crop-lifecycle">Life Cycle: 70-120 days</div>
        </div>

        <div class="crop-grid">
            <div class="crop-info-item">
                <h4>Best Soil Type</h4>
                <p>Well-drained loamy soil</p>
            </div>
            <div class="crop-info-item">
                <h4>Ideal pH Range</h4>
                <p>5.8 - 7.0</p>
            </div>
            <div class="crop-info-item">
                <h4>Temperature Range</h4>
                <p>18°C - 30°C</p>
            </div>
            <div class="crop-info-item">
                <h4>Water Requirement</h4>
                <p>500-800 mm per season</p>
            </div>
            <div class="crop-info-item">
                <h4>Sowing Season</h4>
                <p>June-July (Kharif)</p>
            </div>
            <div class="crop-info-item">
                <h4>Harvest Time</h4>
                <p>September-October</p>
            </div>
        </div>

        <div class="crop-stages">
            <h4>Growth Stages & Timeline</h4>
            <div class="stage-timeline">
                <div class="stage">
                    <div class="stage-dot">1</div>
                    <div class="stage-name">Germination</div>
                    <div class="stage-duration">7-10 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">2</div>
                    <div class="stage-name">Seedling</div>
                    <div class="stage-duration">15-20 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">3</div>
                    <div class="stage-name">Vegetative</div>
                    <div class="stage-duration">35-45 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">4</div>
                    <div class="stage-name">Tasseling</div>
                    <div class="stage-duration">10-15 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">5</div>
                    <div class="stage-name">Maturity</div>
                    <div class="stage-duration">30-35 days</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Soybean Crop Details -->
    <div class="crop-details" id="soybean">
        <div class="crop-header">
            <h3>Soybean Cultivation Guide</h3>
            <div class="crop-lifecycle">Life Cycle: 80-120 days</div>
        </div>

        <div class="crop-grid">
            <div class="crop-info-item">
                <h4>Best Soil Type</h4>
                <p>Well-drained fertile soil</p>
            </div>
            <div class="crop-info-item">
                <h4>Ideal pH Range</h4>
                <p>6.0 - 7.5</p>
            </div>
            <div class="crop-info-item">
                <h4>Temperature Range</h4>
                <p>20°C - 30°C</p>
            </div>
            <div class="crop-info-item">
                <h4>Water Requirement</h4>
                <p>450-700 mm per season</p>
            </div>
            <div class="crop-info-item">
                <h4>Sowing Season</h4>
                <p>June-July (Kharif)</p>
            </div>
            <div class="crop-info-item">
                <h4>Harvest Time</h4>
                <p>September-October</p>
            </div>
        </div>

        <div class="crop-stages">
            <h4>Growth Stages & Timeline</h4>
            <div class="stage-timeline">
                <div class="stage">
                    <div class="stage-dot">1</div>
                    <div class="stage-name">Germination</div>
                    <div class="stage-duration">5-7 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">2</div>
                    <div class="stage-name">Vegetative</div>
                    <div class="stage-duration">25-35 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">3</div>
                    <div class="stage-name">Flowering</div>
                    <div class="stage-duration">20-30 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">4</div>
                    <div class="stage-name">Pod Development</div>
                    <div class="stage-duration">20-25 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">5</div>
                    <div class="stage-name">Maturity</div>
                    <div class="stage-duration">10-15 days</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cotton Crop Details -->
    <div class="crop-details" id="cotton">
        <div class="crop-header">
            <h3>Cotton Cultivation Guide</h3>
            <div class="crop-lifecycle">Life Cycle: 150-180 days</div>
        </div>

        <div class="crop-grid">
            <div class="crop-info-item">
                <h4>Best Soil Type</h4>
                <p>Black cotton soil</p>
            </div>
            <div class="crop-info-item">
                <h4>Ideal pH Range</h4>
                <p>5.5 - 8.0</p>
            </div>
            <div class="crop-info-item">
                <h4>Temperature Range</h4>
                <p>21°C - 35°C</p>
            </div>
            <div class="crop-info-item">
                <h4>Water Requirement</h4>
                <p>600-1200 mm per season</p>
            </div>
            <div class="crop-info-item">
                <h4>Sowing Season</h4>
                <p>April-June</p>
            </div>
            <div class="crop-info-item">
                <h4>Harvest Time</h4>
                <p>September-December</p>
            </div>
        </div>

        <div class="crop-stages">
            <h4>Growth Stages & Timeline</h4>
            <div class="stage-timeline">
                <div class="stage">
                    <div class="stage-dot">1</div>
                    <div class="stage-name">Germination</div>
                    <div class="stage-duration">7-10 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">2</div>
                    <div class="stage-name">Seedling</div>
                    <div class="stage-duration">30-40 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">3</div>
                    <div class="stage-name">Square Formation</div>
                    <div class="stage-duration">30-35 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">4</div>
                    <div class="stage-name">Flowering</div>
                    <div class="stage-duration">50-60 days</div>
                </div>
                <div class="stage">
                    <div class="stage-dot">5</div>
                    <div class="stage-name">Boll Development</div>
                    <div class="stage-duration">50-70 days</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Calculator Section -->
<section class="calculator-section">
    <div class="calculator-container">
        <h3>Crop Yield Calculator</h3>
        <p>Estimate your potential yield based on field parameters</p>

        <div class="calculator-inputs">
            <input type="number" class="calculator-input" id="fieldArea" placeholder="Field Area (acres)">
            <input type="number" class="calculator-input" id="seedRate" placeholder="Seed Rate (kg/acre)">
            <input type="number" class="calculator-input" id="expectedYield" placeholder="Expected Yield (kg/acre)">

            <select class="calculator-input" id="cropType">
                <option value="">Select Crop Type</option>
                <option value="wheat">Wheat</option>
                <option value="rice">Rice</option>
                <option value="corn">Corn</option>
                <option value="soybean">Soybean</option>
                <option value="cotton">Cotton</option>
            </select>

            <button class="btn-ai" onclick="calculateYield()" style="width: 100%; margin-top: 1rem;">
                Calculate Yield <i class='bx bx-calculator'></i>
            </button>
        </div>

        <div class="calculator-result" id="yieldResult">
            <h4>Estimated Results</h4>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem; margin-top: 1rem;">
                <div style="background: rgba(255,255,255,0.1); padding: 1rem; border-radius: 8px;">
                    <div style="font-size: 0.9rem; opacity: 0.8;">Total Seed Required</div>
                    <div style="font-size: 1.5rem; font-weight: bold;" id="seedRequired">0 kg</div>
                </div>
                <div style="background: rgba(255,255,255,0.1); padding: 1rem; border-radius: 8px;">
                    <div style="font-size: 0.9rem; opacity: 0.8;">Expected Production</div>
                    <div style="font-size: 1.5rem; font-weight: bold;" id="totalYield">0 kg</div>
                </div>
                <div style="background: rgba(255,255,255,0.1); padding: 1rem; border-radius: 8px; grid-column: span 2;">
                    <div style="font-size: 0.9rem; opacity: 0.8;">Harvest Time</div>
                    <div style="font-size: 1.2rem; font-weight: bold;" id="harvestTime">0 days</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Weather Widget -->
<section class="content-section">
    <div class="weather-widget">
        <div class="weather-icon">
            <i class='bx bx-sun'></i>
        </div>
        <div class="weather-info">
            <h4>Current Agricultural Weather</h4>
            <p>Temperature: <span id="temp">25°C</span> | Humidity: <span id="humidity">65%</span></p>
            <p>Rainfall: <span id="rainfall">10mm</span> | Soil Moisture: <span id="moisture">Optimal</span></p>
            <p id="weatherAlert">Ideal conditions for wheat sowing</p>
        </div>
        <button class="btn-ai" onclick="updateWeather()">
            Refresh <i class='bx bx-refresh'></i>
        </button>
    </div>
</section>

<!-- Introduction Section -->
<section class="content-section">
    <div class="section-header">
        <h2>Modern Agricultural Challenges</h2>
        <p>Addressing the complex issues facing today's farmers with innovative solutions</p>
    </div>

    <div class="info-cards">
        <div class="info-card">
            <h3>The Challenges</h3>
            <p>Farmers around the world are dealing with enormous challenges. From needing to boost yields to dealing with ever-evolving pressures from pests and disease. All while protecting the environment and improving soil quality.</p>
        </div>

        <div class="info-card">
            <h3>Our Role</h3>
            <p>With our extensive research and development infrastructure, global scale and cutting-edge science, we provide the tools that farmers need to keep feeding the world, now and into the future.</p>
        </div>

        <div class="info-card">
            <h3>Innovation & Collaboration</h3>
            <p>These challenges mean that collaboration and innovation are essential tools to help develop a sustainable, productive, and regenerative global food system.</p>
        </div>
    </div>
</section>

<!-- Soil Health Section -->
<section class="soil-health-section">
    <div class="soil-content">
        <h2>What is Soil Health?</h2>
        <p>As the foundation of food and life on this planet, soil is something we all care about. Healthy soil supports crop growth, stores water, filters pollutants, and sustains biodiversity. Now we need to learn how to care better for our soil.</p>
        <a href="#" class="btn-ai">
            Learn About Soil Health <i class='bx bx-right-arrow-alt'></i>
        </a>
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
            <a href="index.jsp">Home</a>
            <a href="agri.jsp">Agriculture</a>
            <a href="currentCrop.jsp">Current crop</a>
            <a href="historyCrop.jsp">History crop</a>
            <a href="contact.jsp">Contact</a>
        </div>
        <div class="footer-column">
            <h3>Contact Us</h3>
            <p>Email: infoagriculture1020@gmail.com</p>
            <p>Phone: 9495960205</p>
            <p>Location: Sawarde kolhapur, Maharashtra, India</p>
        </div>
        <div class="footer-column">
            <h3>Follow Us</h3>
            <div class="social-icons">
                <a href="#"><i class='bx bxl-facebook'></i></a>
                <a href="#"><i class='bx bxl-twitter'></i></a>
                <a href="#"><i class='bx bxl-instagram'></i></a>
                <a href="#"><i class='bx bxl-linkedin'></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        &copy; 2025 AgroInsights Inc. | All Rights Reserved
    </div>
</footer>

<script>
    // Crop Tabs Functionality
    document.addEventListener('DOMContentLoaded', function() {
        const tabs = document.querySelectorAll('.crop-tab');
        const contents = document.querySelectorAll('.crop-details');

        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                // Remove active class from all tabs and contents
                tabs.forEach(t => t.classList.remove('active'));
                contents.forEach(c => c.classList.remove('active'));

                // Add active class to clicked tab
                tab.classList.add('active');

                // Show corresponding content
                const cropType = tab.getAttribute('data-crop');
                document.getElementById(cropType).classList.add('active');
            });
        });

        // Initialize calculator
        initializeCalculator();

        // Initialize weather
        updateWeather();
    });

    // Crop Yield Calculator
    function initializeCalculator() {
        const cropLifecycles = {
            wheat: 135,
            rice: 120,
            corn: 110,
            soybean: 105,
            cotton: 165
        };

        window.calculateYield = function() {
            const area = parseFloat(document.getElementById('fieldArea').value) || 0;
            const seedRate = parseFloat(document.getElementById('seedRate').value) || 0;
            const expectedYield = parseFloat(document.getElementById('expectedYield').value) || 0;
            const cropType = document.getElementById('cropType').value;

            if (area > 0 && seedRate > 0 && expectedYield > 0 && cropType) {
                const totalSeed = area * seedRate;
                const totalYield = area * expectedYield;
                const harvestDays = cropLifecycles[cropType] || 120;

                document.getElementById('seedRequired').textContent = totalSeed.toFixed(2) + ' kg';
                document.getElementById('totalYield').textContent = totalYield.toFixed(2) + ' kg';
                document.getElementById('harvestTime').textContent = harvestDays + ' days';

                document.getElementById('yieldResult').classList.add('active');
            } else {
                alert('Please fill all fields correctly');
            }
        };
    }

    // Weather Update Function
    function updateWeather() {
        const weatherConditions = [
            { temp: [22, 25], humidity: [60, 65], icon: 'bx-sun', alert: 'Ideal conditions for wheat sowing' },
            { temp: [26, 30], humidity: [70, 75], icon: 'bx-cloud', alert: 'Good for rice cultivation' },
            { temp: [18, 22], humidity: [55, 60], icon: 'bx-wind', alert: 'Cool weather - protect seedlings' },
            { temp: [30, 35], humidity: [75, 80], icon: 'bx-cloud-light-rain', alert: 'Monitor for pest infestation' }
        ];

        const randomCondition = weatherConditions[Math.floor(Math.random() * weatherConditions.length)];
        const temp = Math.floor(Math.random() * (randomCondition.temp[1] - randomCondition.temp[0])) + randomCondition.temp[0];
        const humidity = Math.floor(Math.random() * (randomCondition.humidity[1] - randomCondition.humidity[0])) + randomCondition.humidity[0];
        const rainfall = Math.floor(Math.random() * 20);

        document.querySelector('.weather-icon i').className = `bx ${randomCondition.icon}`;
        document.getElementById('temp').textContent = temp + '°C';
        document.getElementById('humidity').textContent = humidity + '%';
        document.getElementById('rainfall').textContent = rainfall + 'mm';
        document.getElementById('moisture').textContent = humidity > 70 ? 'High' : (humidity < 50 ? 'Low' : 'Optimal');
        document.getElementById('weatherAlert').textContent = randomCondition.alert;
    }
</script>

<style>
    .footer {
        background: var(--dark-bg);
        color: white;
        padding: 3rem 2rem 1rem;
    }

    .footer-container {
        max-width: 1200px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 2rem;
    }

    .footer-column h3 {
        color: white;
        margin-bottom: 1.5rem;
        font-size: 1.2rem;
    }

    .footer-column p {
        color: #94a3b8;
        line-height: 1.6;
        margin-bottom: 1rem;
    }

    .footer-column a {
        display: block;
        color: #94a3b8;
        text-decoration: none;
        margin-bottom: 0.8rem;
        transition: var(--transition);
    }

    .footer-column a:hover {
        color: white;
        transform: translateX(5px);
    }

    .social-icons {
        display: flex;
        gap: 1rem;
    }

    .social-icons a {
        width: 40px;
        height: 40px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
        transition: var(--transition);
    }

    .social-icons a:hover {
        background: var(--primary-color);
        transform: translateY(-3px);
    }

    .footer-bottom {
        text-align: center;
        margin-top: 3rem;
        padding-top: 1.5rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        color: #94a3b8;
        font-size: 0.9rem;
    }
</style>
</body>
</html>