
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String targetUser = request.getParameter("username");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Current Crop | AgroInsights</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
            padding: 2rem 1rem;
        }

        .container {
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

        .form-wrapper {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            gap: 3rem;
            flex-wrap: wrap;
        }

        .form-container {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2.5rem;
            width: 100%;
            max-width: 500px;
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .form-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(46, 125, 50, 0.1);
        }

        .form-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .form-header i {
            font-size: 2rem;
            color: var(--primary-color);
            background: rgba(46, 125, 50, 0.1);
            padding: 1rem;
            border-radius: 12px;
        }

        .form-header h2 {
            font-size: 1.8rem;
            color: var(--text-dark);
            font-weight: 600;
        }

        <% if (targetUser != null) { %>
        .target-user-badge {
            background: linear-gradient(135deg, var(--secondary-color), #ffb74d);
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.2);
        }
        <% } %>

        .input-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .input-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
            font-weight: 500;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .input-group label i {
            color: var(--primary-color);
        }

        .input-group input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1rem;
            transition: var(--transition);
            background: var(--light-bg);
        }

        .input-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.1);
            background: white;
        }

        .input-group::before {
            font-family: 'boxicons';
            position: absolute;
            left: 1rem;
            top: 2.8rem;
            color: var(--text-light);
            font-size: 1.2rem;
        }

        .input-group:nth-child(1)::before { content: "\eee4"; } /* farmer */
        .input-group:nth-child(2)::before { content: "\ebbd"; } /* area */
        .input-group:nth-child(3)::before { content: "\ee8a"; } /* crop */
        .input-group:nth-child(4)::before { content: "\ef75"; } /* phone */
        .input-group:nth-child(5)::before { content: "\eb23"; } /* date */
        .input-group:nth-child(6)::before { content: "\ebc4"; } /* period */

        .btn-submit {
            width: 100%;
            padding: 1.2rem;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
            margin-top: 1.5rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(46, 125, 50, 0.3);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: var(--radius);
            padding: 2rem;
            max-width: 400px;
            box-shadow: var(--shadow);
        }

        .info-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card ul {
            list-style: none;
            margin-top: 1.5rem;
        }

        .info-card li {
            margin-bottom: 1rem;
            display: flex;
            align-items: flex-start;
            gap: 0.8rem;
        }

        .info-card i {
            color: #a78bfa;
            font-size: 1.2rem;
            margin-top: 0.2rem;
        }

        @media (max-width: 768px) {
            .form-wrapper {
                flex-direction: column;
            }

            .form-container {
                padding: 1.5rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="page-header">
        <h1>🌾 Add Current Crop</h1>
        <p>Record new crop information with detailed specifications</p>
    </div>

    <div class="form-wrapper">
        <div class="form-container">
            <% if (targetUser != null) { %>
            <div class="target-user-badge">
                <i class='bx bxs-user-check'></i>
                Adding crop for: <%= targetUser %>
            </div>
            <input type="hidden" name="targetUser" value="<%= targetUser %>">
            <% } %>

            <div class="form-header">
                <i class='bx bxs-leaf'></i>
                <h2>Crop Details</h2>
            </div>

            <form action="AddCurrentCrop" method="post">
                <% if (targetUser != null) { %>
                <input type="hidden" name="targetUser" value="<%= targetUser %>">
                <% } %>

                <div class="input-group">
                    <label><i class='bx bxs-user'></i> Farmer Name</label>
                    <input type="text" name="farmerName" required placeholder="Enter farmer's full name">
                </div>

                <div class="input-group">
                    <label><i class='bx bxs-area'></i> Farm Area (acres)</label>
                    <input type="text" name="farmArea" required placeholder="e.g., 10.5">
                </div>

                <div class="input-group">
                    <label><i class='bx bxs-tree'></i> Crop Name</label>
                    <input type="text" name="cropName" required placeholder="e.g., Wheat, Rice, Corn">
                </div>

                <div class="input-group">
                    <label><i class='bx bxs-phone'></i> Contact Number</label>
                    <input type="text" name="contactNumber" required placeholder="+91 00000 00000">
                </div>

                <div class="input-group">
                    <label><i class='bx bxs-calendar'></i> Planting Date</label>
                    <input type="date" name="date" required>
                </div>

                <div class="input-group">
                    <label><i class='bx bxs-time'></i> Growth Period (Months)</label>
                    <input type="number" name="period" required placeholder="e.g., 6" min="1">
                </div>

                <button type="submit" class="btn-submit">
                    <i class='bx bx-save'></i> Save Crop Details
                </button>
            </form>
        </div>

        <div class="info-card">
            <h3><i class='bx bxs-info-circle'></i> Important Notes</h3>
            <p>Ensure all information is accurate for better crop management and analysis.</p>
            <ul>
                <li><i class='bx bxs-check-circle'></i> <span>Double-check farmer contact details</span></li>
                <li><i class='bx bxs-check-circle'></i> <span>Verify land area measurements</span></li>
                <li><i class='bx bxs-check-circle'></i> <span>Include crop variety if known</span></li>
                <li><i class='bx bxs-check-circle'></i> <span>Update after each season</span></li>
            </ul>
        </div>
    </div>
</div>

<script>
    // Get today's date
    const today = new Date();

    // Calculate date 15 days ago
    const fifteenDaysAgo = new Date();
    fifteenDaysAgo.setDate(today.getDate() - 15);

    // Format dates to YYYY-MM-DD for input min/max
    const formatDate = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    };

    // Set min date to 15 days ago and max date to today (prevents future dates)
    const dateInput = document.querySelector('input[type="date"]');
    dateInput.min = formatDate(fifteenDaysAgo);
    dateInput.max = formatDate(today);

    // Optional: Set default value to today
    dateInput.value = formatDate(today);

    // Additional validation to ensure no future dates can be manually entered
    dateInput.addEventListener('change', function() {
        const selectedDate = new Date(this.value);
        if (selectedDate > today) {
            alert('Cannot select future dates. Please select today or a past date.');
            this.value = formatDate(today);
        }
    });
</script>
</body>
</html>
