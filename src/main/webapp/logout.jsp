<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logging Out | AgroInsights</title>
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
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .logout-container {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 3rem;
            box-shadow: var(--shadow);
            text-align: center;
            max-width: 500px;
            width: 100%;
            border: 1px solid var(--border-color);
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logout-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--danger-color), #c82333);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 2.5rem;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.4);
            }
            70% {
                box-shadow: 0 0 0 20px rgba(220, 53, 69, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(220, 53, 69, 0);
            }
        }

        .logout-container h1 {
            color: var(--text-dark);
            margin-bottom: 1rem;
            font-size: 2rem;
        }

        .logout-container p {
            color: var(--text-light);
            margin-bottom: 2rem;
            line-height: 1.6;
            font-size: 1.1rem;
        }

        .progress-container {
            height: 6px;
            background: var(--border-color);
            border-radius: 3px;
            margin: 2rem 0;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--danger-color), #c82333);
            width: 0%;
            border-radius: 3px;
            animation: progress 3s linear forwards;
        }

        @keyframes progress {
            from { width: 0%; }
            to { width: 100%; }
        }

        .redirect-info {
            background: var(--light-bg);
            padding: 1.5rem;
            border-radius: 12px;
            margin-top: 2rem;
            border-left: 4px solid var(--primary-color);
        }

        .redirect-info h3 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }

        .redirect-info p {
            color: var(--text-light);
            margin: 0;
            font-size: 0.95rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
            padding: 1rem;
            border-radius: 12px;
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

        .btn-login {
            background: var(--primary-color);
            color: white;
        }

        .btn-login:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-home {
            background: var(--light-bg);
            color: var(--text-dark);
            border: 2px solid var(--border-color);
        }

        .btn-home:hover {
            background: var(--border-color);
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .logout-container {
                padding: 2rem 1.5rem;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<%
    // Get user info before destroying session
    String username = (String) session.getAttribute("username");

    // Destroy session
    session.invalidate();
%>

<div class="logout-container">
    <div class="logout-icon">
        <i class='bx bx-log-out'></i>
    </div>

    <h1>Goodbye, <%= username != null ? username : "User" %>!</h1>
    <p>You have been successfully logged out from AgroInsights. Thank you for using our platform.</p>

    <div class="progress-container">
        <div class="progress-bar"></div>
    </div>

    <div class="redirect-info">
        <h3><i class='bx bx-info-circle'></i> Redirecting to Home</h3>
        <p>You will be automatically redirected to the home page in a few seconds.</p>
    </div>

    <div class="action-buttons">
        <a href="index.jsp" class="btn btn-home">
            <i class='bx bx-home'></i> Go to Home
        </a>
        <a href="register.jsp" class="btn btn-login">
            <i class='bx bx-log-in'></i> Login Again
        </a>
    </div>
</div>

<script>
    // Redirect after 5 seconds
    setTimeout(() => {
        window.location.href = 'index.jsp';
    }, 5000);

    // Update countdown
    let seconds = 5;
    const countdown = setInterval(() => {
        seconds--;
        const redirectInfo = document.querySelector('.redirect-info p');
        if (redirectInfo && seconds > 0) {
            redirectInfo.textContent = `You will be automatically redirected to the home page in ${seconds} seconds.`;
        }
        if (seconds === 0) {
            clearInterval(countdown);
        }
    }, 1000);
</script>
</body>
</html>
