<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit User | AgroInsights</title>
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
            max-width: 600px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        @media (max-width: 768px) {
            .container {
                margin: 1rem auto;
            }
        }

        .header {
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-light);
            text-decoration: none;
            transition: var(--transition);
            padding: 0.5rem 1rem;
            background: var(--light-bg);
            border-radius: 50px;
            font-size: clamp(0.8rem, 2.5vw, 0.9rem);
        }

        .back-link:hover {
            color: var(--primary-color);
            background: var(--border-color);
        }

        .header h1 {
            font-size: clamp(1.3rem, 5vw, 2rem);
            color: var(--primary-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .form-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
        }

        @media (max-width: 480px) {
            .form-card {
                padding: 1.5rem;
            }
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
            font-weight: 500;
            font-size: clamp(0.85rem, 2.5vw, 0.95rem);
        }

        .form-group label i {
            color: var(--primary-color);
            margin-right: 0.5rem;
        }

        .form-group input {
            width: 100%;
            padding: 0.9rem 1rem;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: clamp(0.85rem, 2.5vw, 1rem);
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
            font-size: 0.8rem;
            margin-top: 0.3rem;
            display: none;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        @media (max-width: 480px) {
            .form-actions {
                flex-direction: column;
                gap: 0.8rem;
            }
        }

        .btn {
            flex: 1;
            padding: 0.9rem;
            border: none;
            border-radius: 12px;
            font-size: clamp(0.85rem, 2.5vw, 1rem);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(46, 125, 50, 0.3);
        }

        .btn-secondary {
            background: var(--light-bg);
            color: var(--text-dark);
            border: 2px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: var(--border-color);
            transform: translateY(-2px);
        }

        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            animation: slideIn 0.3s ease;
        }

        .alert-success {
            background: rgba(46, 125, 50, 0.1);
            border-left: 4px solid var(--primary-color);
            color: var(--primary-color);
        }

        .alert-error {
            background: rgba(220, 53, 69, 0.1);
            border-left: 4px solid var(--danger-color);
            color: var(--danger-color);
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="header">
        <a href="adminUser.jsp" class="back-link">
            <i class='bx bx-arrow-back'></i> Back to Users
        </a>
        <h1><i class='bx bx-edit-alt'></i> Edit User</h1>
    </div>

    <div class="form-card">
        <form action="UpdateUser" method="post" id="editUserForm">
            <input type="hidden" name="userId" value="<%= request.getParameter("userId") %>">

            <div class="form-group">
                <label><i class='bx bxs-user'></i> New Username</label>
                <input type="text" name="username" id="username" required placeholder="Enter username" minlength="3">
                <div class="error-message" id="usernameError">Username must be at least 3 characters</div>
            </div>

            <div class="form-group">
                <label><i class='bx bxs-envelope'></i> New Email</label>
                <input type="email" name="email" id="email" required placeholder="Enter email address">
                <div class="error-message" id="emailError">Please enter a valid email address</div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class='bx bx-save'></i> Update User
                </button>
                <a href="adminUser.jsp" class="btn btn-secondary">
                    <i class='bx bx-x'></i> Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('editUserForm').addEventListener('submit', function(e) {
        let isValid = true;

        document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input').forEach(el => el.classList.remove('error'));

        const username = document.getElementById('username').value.trim();
        if (username.length < 3) {
            showFieldError('username', 'Username must be at least 3 characters');
            isValid = false;
        }

        const email = document.getElementById('email').value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            showFieldError('email', 'Please enter a valid email address');
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    function showFieldError(fieldId, message) {
        const field = document.getElementById(fieldId);
        const errorElement = document.getElementById(fieldId + 'Error');
        field.classList.add('error');
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }

    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('input', function() {
            this.classList.remove('error');
            const errorElement = document.getElementById(this.id + 'Error');
            if (errorElement) errorElement.style.display = 'none';
        });
    });
</script>
</body>
</html>