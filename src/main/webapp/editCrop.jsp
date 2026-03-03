<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%
    if (session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String cropId = (String) request.getAttribute("cropId");
    String farmerName = (String) request.getAttribute("farmerName");
    String farmArea = (String) request.getAttribute("farmArea");
    String cropName = (String) request.getAttribute("cropName");
    String contactNumber = (String) request.getAttribute("contactNumber");
    String cropDate = (String) request.getAttribute("cropDate");
    String period = (String) request.getAttribute("period");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Crop | AgroInsights</title>
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
            max-width: 800px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .back-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.8rem 1.5rem;
            background: var(--light-bg);
            color: var(--text-dark);
            text-decoration: none;
            border-radius: var(--radius);
            font-weight: 500;
            transition: var(--transition);
            border: 1px solid var(--border-color);
        }

        .back-btn:hover {
            background: var(--border-color);
            transform: translateY(-2px);
        }

        .page-title {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-title h1 {
            font-size: 2.2rem;
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }

        .page-title p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .edit-form {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2rem;
            border: 1px solid var(--border-color);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
            font-weight: 500;
            font-size: 0.95rem;
        }

        .form-group input {
            width: 100%;
            padding: 0.9rem 1rem;
            border: 1px solid var(--border-color);
            border-radius: var(--radius);
            font-size: 1rem;
            transition: var(--transition);
            background: var(--light-bg);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.1);
        }

        .form-group input.error {
            border-color: var(--danger-color);
        }

        .error-message {
            color: var(--danger-color);
            font-size: 0.85rem;
            margin-top: 0.3rem;
            display: none;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
            padding: 1rem;
            border-radius: var(--radius);
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: var(--transition);
            border: none;
            cursor: pointer;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(46, 125, 50, 0.3);
        }

        .btn-cancel {
            background: var(--light-bg);
            color: var(--text-dark);
            border: 1px solid var(--border-color);
        }

        .btn-cancel:hover {
            background: var(--border-color);
            transform: translateY(-2px);
        }

        .success-message {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
            padding: 1rem;
            border-radius: var(--radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid rgba(46, 125, 50, 0.2);
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .header {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }

            .form-actions {
                flex-direction: column;
            }

            .page-title h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="header">
        <a href="currentCrop.jsp" class="back-btn">
            <i class='bx bx-arrow-back'></i>
            Back to Current Crops
        </a>
        <div class="user-info">
            <span style="color: var(--text-light);">Logged in as: </span>
            <strong><%= session.getAttribute("username") %> (Admin)</strong>
        </div>
    </div>

    <div class="page-title">
        <h1><i class='bx bx-edit'></i> Edit Crop</h1>
        <p>Update crop information for better tracking and management</p>
    </div>

    <% if (cropId == null || cropId.isEmpty()) { %>
    <div class="success-message">
        <i class='bx bx-error-circle'></i>
        Error: No crop ID specified. Please select a crop to edit.
    </div>
    <% } %>

    <form action="EditCrop" method="post" class="edit-form" id="cropForm">
        <input type="hidden" name="cropId" value="<%= cropId %>">

        <div class="form-group">
            <label for="farmerName"><i class='bx bxs-user'></i> Farmer Name</label>
            <input type="text" id="farmerName" name="farmerName"
                   value="<%= farmerName %>"
                   placeholder="Enter farmer's full name" required>
            <div class="error-message" id="farmerNameError"></div>
        </div>

        <div class="form-group">
            <label for="farmArea"><i class='bx bxs-area'></i> Farm Area (acres)</label>
            <input type="number" id="farmArea" name="farmArea"
                   value="<%= farmArea %>"
                   placeholder="Enter farm area in acres"
                   step="0.01" min="0.01" required>
            <div class="error-message" id="farmAreaError"></div>
        </div>

        <div class="form-group">
            <label for="cropName"><i class='bx bxs-leaf'></i> Crop Name</label>
            <input type="text" id="cropName" name="cropName"
                   value="<%= cropName %>"
                   placeholder="Enter crop name" required>
            <div class="error-message" id="cropNameError"></div>
        </div>

        <div class="form-group">
            <label for="contactNumber"><i class='bx bxs-phone'></i> Contact Number</label>
            <input type="tel" id="contactNumber" name="contactNumber"
                   value="<%= contactNumber %>"
                   placeholder="Enter 10-digit contact number" required>
            <div class="error-message" id="contactNumberError"></div>
        </div>

        <div class="form-group">
            <label for="date"><i class='bx bxs-calendar'></i> Crop Date</label>
            <input type="date" id="date" name="date"
                   value="<%= cropDate %>" required>
            <div class="error-message" id="dateError"></div>
        </div>

        <div class="form-group">
            <label for="period"><i class='bx bxs-time'></i> Growth Period (months)</label>
            <input type="number" id="period" name="period"
                   value="<%= period %>"
                   placeholder="Enter growth period in months"
                   min="1" max="36" required>
            <div class="error-message" id="periodError"></div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-submit">
                <i class='bx bx-save'></i> Update Crop
            </button>
            <a href="currentCrop.jsp" class="btn btn-cancel">
                <i class='bx bx-x'></i> Cancel
            </a>
        </div>
    </form>
</div>

<script>
    // Form validation
    document.getElementById('cropForm').addEventListener('submit', function(e) {
        let isValid = true;

        // Clear previous errors
        document.querySelectorAll('.error-message').forEach(el => {
            el.style.display = 'none';
        });
        document.querySelectorAll('input').forEach(el => {
            el.classList.remove('error');
        });

        // Validate farmer name
        const farmerName = document.getElementById('farmerName').value.trim();
        if (farmerName.length < 2) {
            showError('farmerName', 'Farmer name must be at least 2 characters');
            isValid = false;
        }

        // Validate farm area
        const farmArea = document.getElementById('farmArea').value;
        if (farmArea <= 0) {
            showError('farmArea', 'Farm area must be greater than 0');
            isValid = false;
        }

        // Validate crop name
        const cropName = document.getElementById('cropName').value.trim();
        if (cropName.length < 2) {
            showError('cropName', 'Crop name must be at least 2 characters');
            isValid = false;
        }

        // Validate contact number
        const contactNumber = document.getElementById('contactNumber').value.trim();
        const phoneRegex = /^[0-9]{10}$/;
        if (!phoneRegex.test(contactNumber)) {
            showError('contactNumber', 'Please enter a valid 10-digit phone number');
            isValid = false;
        }

        // Validate date
        const date = document.getElementById('date').value;
        if (!date) {
            showError('date', 'Please select a date');
            isValid = false;
        }

        // Validate period
        const period = document.getElementById('period').value;
        if (period < 1 || period > 36) {
            showError('period', 'Growth period must be between 1 and 36 months');
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    function showError(fieldId, message) {
        const field = document.getElementById(fieldId);
        const errorElement = document.getElementById(fieldId + 'Error');

        field.classList.add('error');
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }

    // Real-time validation
    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('input', function() {
            this.classList.remove('error');
            const errorElement = document.getElementById(this.id + 'Error');
            if (errorElement) {
                errorElement.style.display = 'none';
            }
        });
    });

    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('date').setAttribute('max', today);
</script>
</body>
</html>