<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>

    <style>
        body {
            background: #f4f6f8;
            font-family: Arial, sans-serif;
        }

        .form-container {
            width: 420px;
            margin: 60px auto;
            background: #ffffff;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0 8px 22px rgba(0,0,0,0.15);
        }

        .form-container h2 {
            text-align: center;
            color: #1b5e20;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #333;
        }

        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        input:focus {
            outline: none;
            border-color: #1b5e20;
            box-shadow: 0 0 4px rgba(27,94,32,0.3);
        }

        button {
            width: 100%;
            padding: 12px;
            background: #1565c0;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s ease;
        }

        button:hover {
            background: #0d47a1;
            transform: scale(1.02);
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<div class="form-container">
    <h2>Edit User</h2>

    <form action="UpdateUser" method="post">
        <input type="hidden" name="userId"
               value="<%= request.getParameter("userId") %>">

        <label>New Username</label>
        <input type="text" name="username" required>

        <label>New Email</label>
        <input type="email" name="email" required>

        <button type="submit">Update User</button>
    </form>
</div>

</body>
</html>
