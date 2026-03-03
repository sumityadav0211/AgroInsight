<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New User | AgroInsights</title>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Previous styles remain the same */
        :root {
            --primary-color: #2e7d32;
            --primary-dark: #1b5e20;
            --primary-light: #4caf50;
            --secondary-color: #ff9800;
            --danger-color: #dc3545;
            --success-color: #28a745;
            --admin-color: #9c27b0;
            --dark-bg: #0f172a;
            --light-bg: #f8fafc;
            --card-bg: #ffffff;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --border-color: #e2e8f0;
            --shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 15px 40px rgba(0, 0, 0, 0.15);
            --radius: 16px;
            --radius-sm: 12px;
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
            padding-bottom: 2rem;
        }

        .container {
            max-width: 600px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 2rem;
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .header p {
            color: var(--text-light);
            font-size: 1rem;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-light);
            text-decoration: none;
            margin-bottom: 1rem;
            transition: var(--transition);
        }

        .back-link:hover {
            color: var(--primary-color);
        }

        .form-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 2rem;
            box-shadow: var(--shadow);
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

        .form-group label i {
            color: var(--primary-color);
            margin-right: 0.5rem;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.9rem 1rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 1rem;
            transition: var(--transition);
            background: var(--light-bg);
        }

        .form-group input:focus,
        .form-group select:focus {
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

        .password-strength {
            margin-top: 0.5rem;
            height: 5px;
            background: var(--border-color);
            border-radius: 3px;
            overflow: hidden;
        }

        .strength-bar {
            height: 100%;
            width: 0%;
            transition: var(--transition);
        }

        .strength-weak {
            background: var(--danger-color);
            width: 33%;
        }

        .strength-medium {
            background: var(--secondary-color);
            width: 66%;
        }

        .strength-strong {
            background: var(--success-color);
            width: 100%;
        }

        .strength-text {
            font-size: 0.8rem;
            margin-top: 0.3rem;
            text-align: right;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin-right: 0.5rem;
        }

        .checkbox-group label {
            display: inline;
            margin: 0;
            cursor: pointer;
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-top: 0.5rem;
        }

        .role-badge-farmer {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
            border: 1px solid rgba(46, 125, 50, 0.2);
        }

        .role-badge-admin {
            background: rgba(156, 39, 176, 0.1);
            color: var(--admin-color);
            border: 1px solid rgba(156, 39, 176, 0.2);
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
            padding: 1rem;
            border: none;
            border-radius: var(--radius-sm);
            font-size: 1rem;
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

        .btn-primary.admin-mode {
            background: linear-gradient(135deg, var(--admin-color), #7b1fa2);
        }

        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(46, 125, 50, 0.3);
        }

        .btn-primary.admin-mode:hover:not(:disabled) {
            box-shadow: 0 10px 20px rgba(156, 39, 176, 0.3);
        }

        .btn-primary:disabled {
            opacity: 0.7;
            cursor: not-allowed;
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

        .message-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            max-width: 400px;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: var(--radius-sm);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideIn 0.3s ease;
            box-shadow: var(--shadow-hover);
            background: white;
        }

        .alert-success {
            border-left: 4px solid var(--success-color);
        }

        .alert-success i {
            color: var(--success-color);
        }

        .alert-error {
            border-left: 4px solid var(--danger-color);
        }

        .alert-error i {
            color: var(--danger-color);
        }

        .alert-content {
            flex: 1;
        }

        .alert-title {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.2rem;
        }

        .alert-message {
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .close-alert {
            color: var(--text-light);
            cursor: pointer;
            transition: var(--transition);
            font-size: 1.2rem;
        }

        .close-alert:hover {
            color: var(--text-dark);
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
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .container {
                margin: 1rem auto;
            }

            .form-card {
                padding: 1.5rem;
            }

            .form-actions {
                flex-direction: column;
            }

            .message-container {
                left: 20px;
                right: 20px;
                max-width: none;
            }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <a href="adminUser.jsp" class="back-link">
        <i class='bx bx-arrow-back'></i> Back to User Management
    </a>

    <div class="header">
        <h1><i class='bx bx-user-plus'></i> Add New User</h1>
        <p>Create a new account in the system</p>
    </div>

    <div class="message-container" id="messageContainer"></div>

    <div class="form-card">
        <form action="AdminAddUserServlet" method="post" id="addUserForm" target="hiddenFrame" onsubmit="return handleFormSubmit()">
            <div class="form-group">
                <label><i class='bx bxs-user'></i> Username *</label>
                <input type="text" name="username" id="username" required
                       placeholder="Enter username" minlength="3" maxlength="50">
                <div class="error-message" id="usernameError">Username must be at least 3 characters</div>
            </div>

            <div class="form-group">
                <label><i class='bx bxs-envelope'></i> Email Address *</label>
                <input type="email" name="email" id="email" required
                       placeholder="Enter email address">
                <div class="error-message" id="emailError">Please enter a valid email address</div>
            </div>

            <div class="form-group">
                <label><i class='bx bxs-lock-alt'></i> Password *</label>
                <input type="password" name="password" id="password" required
                       placeholder="Enter password" minlength="6" onkeyup="checkPasswordStrength()">
                <div class="password-strength">
                    <div class="strength-bar" id="strengthBar"></div>
                </div>
                <div class="strength-text" id="strengthText"></div>
                <div class="error-message" id="passwordError">Password must be at least 6 characters</div>
            </div>

            <div class="form-group">
                <label><i class='bx bxs-lock-alt'></i> Confirm Password *</label>
                <input type="password" name="confirmPassword" id="confirmPassword" required
                       placeholder="Confirm password" onkeyup="checkPasswordMatch()">
                <div class="error-message" id="confirmError">Passwords do not match</div>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" name="emailVerified" id="emailVerified" value="true" checked>
                <label for="emailVerified">
                    <i class='bx bx-check-circle' style="color: var(--primary-color);"></i>
                    Mark as verified (skip email verification)
                </label>
            </div>

            <div class="form-group">
                <label><i class='bx bxs-user-badge'></i> User Role</label>
                <select name="role" id="roleSelect" onchange="updateButtonText()">
                    <option value="user" selected>Farmer</option>
                    <option value="admin">Administrator</option>
                </select>
                <div id="rolePreview">
                    <span class="role-badge role-badge-farmer" id="roleBadge">
                        <i class='bx bx-user'></i> Farmer Account
                    </span>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class='bx bx-save' id="submitIcon"></i>
                    <span id="submitText">Create Farmer</span>
                </button>
                <a href="adminUser.jsp" class="btn btn-secondary">
                    <i class='bx bx-x'></i> Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<!-- Hidden iframe to handle form submission without page refresh -->
<iframe name="hiddenFrame" style="display: none;"></iframe>

<script>
    function updateButtonText() {
        const roleSelect = document.getElementById('roleSelect');
        const submitBtn = document.getElementById('submitBtn');
        const submitText = document.getElementById('submitText');
        const submitIcon = document.getElementById('submitIcon');
        const roleBadge = document.getElementById('roleBadge');

        if (roleSelect.value === 'admin') {
            submitText.textContent = 'Create Administrator';
            submitIcon.className = 'bx bx-shield-quarter';
            submitBtn.classList.add('admin-mode');

            roleBadge.innerHTML = '<i class="bx bx-shield"></i> Administrator Account';
            roleBadge.className = 'role-badge role-badge-admin';
        } else {
            submitText.textContent = 'Create Farmer';
            submitIcon.className = 'bx bx-save';
            submitBtn.classList.remove('admin-mode');

            roleBadge.innerHTML = '<i class="bx bx-user"></i> Farmer Account';
            roleBadge.className = 'role-badge role-badge-farmer';
        }
    }

    function handleFormSubmit() {
        if (!validateForm()) {
            return false;
        }

        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('submitText');
        const btnIcon = document.getElementById('submitIcon');

        btnIcon.className = 'bx bx-loader-alt bx-spin';
        btnText.textContent = ' Creating...';
        submitBtn.disabled = true;

        return true;
    }

    function showSuccessMessage(username, role) {
        hideLoading();

        const messageContainer = document.getElementById('messageContainer');
        const messageDiv = document.createElement('div');
        messageDiv.className = 'alert alert-success';

        const roleText = (role === 'admin') ? 'Administrator' : 'Farmer';

        messageDiv.innerHTML =
            '<i class="bx bx-check-circle"></i>' +
            '<div class="alert-content">' +
            '<div class="alert-title">Success!</div>' +
            '<div class="alert-message">' + roleText + ' "' + username + '" has been created successfully.</div>' +
            '</div>' +
            '<i class="bx bx-x close-alert" onclick="this.parentElement.remove()"></i>';

        messageContainer.appendChild(messageDiv);

        document.getElementById('addUserForm').reset();
        document.getElementById('roleSelect').value = 'user';
        updateButtonText();

        document.getElementById('strengthBar').className = 'strength-bar';
        document.getElementById('strengthBar').style.width = '0%';
        document.getElementById('strengthText').textContent = '';

        setTimeout(() => {
            if (messageDiv.parentElement) {
                messageDiv.remove();
            }
        }, 5000);
    }

    function showErrorMessage(errorMessage) {
        hideLoading();

        const messageContainer = document.getElementById('messageContainer');
        const messageDiv = document.createElement('div');
        messageDiv.className = 'alert alert-error';

        messageDiv.innerHTML =
            '<i class="bx bx-error-circle"></i>' +
            '<div class="alert-content">' +
            '<div class="alert-title">Error!</div>' +
            '<div class="alert-message">' + errorMessage + '</div>' +
            '</div>' +
            '<i class="bx bx-x close-alert" onclick="this.parentElement.remove()"></i>';

        messageContainer.appendChild(messageDiv);

        setTimeout(() => {
            if (messageDiv.parentElement) {
                messageDiv.remove();
            }
        }, 5000);
    }

    function hideLoading() {
        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('submitText');
        const btnIcon = document.getElementById('submitIcon');
        const roleSelect = document.getElementById('roleSelect');

        if (roleSelect.value === 'admin') {
            btnIcon.className = 'bx bx-shield-quarter';
            btnText.textContent = 'Create Administrator';
        } else {
            btnIcon.className = 'bx bx-save';
            btnText.textContent = 'Create Farmer';
        }

        submitBtn.disabled = false;
    }

    function validateForm() {
        let isValid = true;

        document.querySelectorAll('.error-message').forEach(el => {
            el.style.display = 'none';
        });
        document.querySelectorAll('input').forEach(el => {
            el.classList.remove('error');
        });

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

        const password = document.getElementById('password').value;
        if (password.length < 6) {
            showFieldError('password', 'Password must be at least 6 characters');
            isValid = false;
        }

        const confirmPassword = document.getElementById('confirmPassword').value;
        if (password !== confirmPassword) {
            showFieldError('confirm', 'Passwords do not match');
            isValid = false;
        }

        return isValid;
    }

    function showFieldError(fieldId, message) {
        const field = document.getElementById(fieldId);
        const errorElement = document.getElementById(fieldId + 'Error');

        field.classList.add('error');
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }

    function checkPasswordStrength() {
        const password = document.getElementById('password').value;
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');

        strengthBar.className = 'strength-bar';

        if (password.length === 0) {
            strengthBar.style.width = '0%';
            strengthText.textContent = '';
            return;
        }

        let strength = 0;

        if (password.length >= 8) strength += 1;
        if (password.length >= 12) strength += 1;
        if (/[a-z]/.test(password)) strength += 1;
        if (/[A-Z]/.test(password)) strength += 1;
        if (/[0-9]/.test(password)) strength += 1;
        if (/[^a-zA-Z0-9]/.test(password)) strength += 1;

        if (strength <= 2) {
            strengthBar.classList.add('strength-weak');
            strengthText.textContent = 'Weak password';
            strengthText.style.color = 'var(--danger-color)';
        } else if (strength <= 4) {
            strengthBar.classList.add('strength-medium');
            strengthText.textContent = 'Medium password';
            strengthText.style.color = 'var(--secondary-color)';
        } else {
            strengthBar.classList.add('strength-strong');
            strengthText.textContent = 'Strong password';
            strengthText.style.color = 'var(--success-color)';
        }
    }

    function checkPasswordMatch() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const confirmError = document.getElementById('confirmError');

        if (confirmPassword.length > 0 && password !== confirmPassword) {
            confirmError.style.display = 'block';
            document.getElementById('confirmPassword').classList.add('error');
        } else {
            confirmError.style.display = 'none';
            document.getElementById('confirmPassword').classList.remove('error');
        }
    }

    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('input', function() {
            this.classList.remove('error');
            const errorElement = document.getElementById(this.id + 'Error');
            if (errorElement) {
                errorElement.style.display = 'none';
            }
        });
    });

    window.onload = function() {
        updateButtonText();
    };
</script>
</body>
</html>