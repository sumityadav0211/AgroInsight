<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.controller.DBConnection" %>

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
    <title>User Management | AgroInsights</title>
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
            --warning-color: #ffc107;
            --info-color: #17a2b8;
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
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 2.5rem;
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .admin-badge {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .search-box {
            flex: 1;
            min-width: 300px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1rem;
            background: var(--light-bg);
            transition: var(--transition);
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.1);
        }

        .search-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
        }

        .filters {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 0.8rem 1.5rem;
            background: var(--light-bg);
            border: 2px solid var(--border-color);
            border-radius: 12px;
            color: var(--text-dark);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-btn.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .filter-btn:hover:not(.active) {
            background: var(--border-color);
        }

        .users-table-container {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        thead {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
        }

        th {
            padding: 1.2rem 1.5rem;
            color: white;
            font-weight: 600;
            text-align: left;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tbody tr {
            transition: var(--transition);
            border-bottom: 1px solid var(--border-color);
        }

        tbody tr:hover {
            background: var(--light-bg);
        }

        td {
            padding: 1.2rem 1.5rem;
            color: var(--text-dark);
        }

        .user-cell {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: 600;
            color: var(--text-dark);
        }

        .user-id {
            font-size: 0.85rem;
            color: var(--text-light);
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 0.6rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: var(--transition);
            border: none;
            cursor: pointer;
        }

        .btn-view {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .btn-view:hover {
            background: rgba(46, 125, 50, 0.2);
        }

        .btn-edit {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .btn-edit:hover {
            background: rgba(255, 152, 0, 0.2);
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        .btn-delete:hover {
            background: rgba(220, 53, 69, 0.2);
        }

        .status-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .status-active {
            background: rgba(46, 125, 50, 0.1);
            color: var(--primary-color);
        }

        .status-inactive {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        .status-pending {
            background: rgba(255, 152, 0, 0.1);
            color: var(--secondary-color);
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
            padding: 1.5rem;
        }

        .page-btn {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            color: var(--text-dark);
            text-decoration: none;
            transition: var(--transition);
        }

        .page-btn.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .page-btn:hover:not(.active) {
            background: var(--border-color);
        }

        .no-results {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .no-results i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border-color);
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .controls {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                min-width: 100%;
            }

            th, td {
                padding: 0.8rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-action {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp" />

<div class="container">
    <div class="header">
        <h1><i class='bx bxs-group'></i> User Management</h1>
        <p>Manage all registered users, view details, and perform administrative actions</p>
        <div class="admin-badge">
            <i class='bx bxs-shield'></i> Administrator Privileges Active
        </div>
    </div>

    <div class="controls">
        <div class="search-box">
            <i class='bx bx-search'></i>
            <input type="text" id="searchInput" placeholder="Search users by name, email, or ID...">
        </div>

        <div class="filters">
            <button class="filter-btn active" onclick="filterUsers('all')" id="filterAll">
                <i class='bx bx-user'></i> All Users
            </button>
            <button class="filter-btn" onclick="filterUsers('active')" id="filterActive">
                <i class='bx bx-check-circle'></i> Active
            </button>
            <button class="filter-btn" onclick="filterUsers('pending')" id="filterPending">
                <i class='bx bx-time'></i> Pending
            </button>
            <button class="filter-btn" onclick="addNewUser()" id="addNew">
                <i class='bx bx-plus-circle'></i> Add New
            </button>
        </div>
    </div>

    <div class="users-table-container">
        <table>
            <thead>
            <tr>
                <th>User Profile</th>
                <th>Contact Info</th>
                <th>Account Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="userTableBody">
            <%
                try {
                    // Use connection from controller package
                    Connection con = DBConnection.getConnection();

                    // Get users with their email_verified status (PostgreSQL)
                    PreparedStatement ps = con.prepareStatement(
                            "SELECT id, username, email, email_verified, created_at FROM farmdata ORDER BY id DESC"
                    );
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        String username = rs.getString("username");
                        String email = rs.getString("email");
                        int userId = rs.getInt("id");
                        boolean emailVerified = rs.getBoolean("email_verified");
                        String initial = username.substring(0,1).toUpperCase();

                        // Determine status class and icon
                        String statusClass = emailVerified ? "status-active" : "status-pending";
                        String statusIcon = emailVerified ? "bx-check-circle" : "bx-time";
                        String statusText = emailVerified ? "Active" : "Pending";
            %>
            <tr class="user-row" data-status="<%= emailVerified ? "active" : "pending" %>">
                <td>
                    <div class="user-cell">
                        <div class="user-avatar">
                            <%= initial %>
                        </div>
                        <div class="user-info">
                            <div class="user-name"><%= username %></div>
                            <div class="user-id">ID: <%= userId %></div>
                        </div>
                    </div>
                </td>
                <td>
                    <div style="color: var(--text-dark); font-weight: 500;"><%= email %></div>
                    <div style="color: var(--text-light); font-size: 0.9rem;">Registered User</div>
                </td>
                <td>
                    <span class="status-badge <%= statusClass %>">
                        <i class='bx <%= statusIcon %>'></i> <%= statusText %>
                    </span>
                </td>
                <td>
                    <div class="action-buttons">
                        <a href="addcrop.jsp?username=<%= username %>" class="btn-action btn-view">
                            <i class='bx bx-plus-circle'></i> Add Crop
                        </a>
                        <a href="viewCrops.jsp?adminView=true&username=<%= username %>" class="btn-action btn-view">
                            <i class='bx bx-search-alt'></i> View Crops
                        </a>
                        <a href="editUser.jsp?userId=<%= userId %>" class="btn-action btn-edit">
                            <i class='bx bx-edit-alt'></i> Edit
                        </a>
                        <button class="btn-action btn-delete" onclick="deleteUser(<%= userId %>, '<%= username %>')">
                            <i class='bx bx-trash'></i> Delete
                        </button>
                    </div>
                </td>
            </tr>
            <%
                    }
                    rs.close();
                    ps.close();
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='4' style='color: var(--danger-color); padding: 2rem; text-align: center;'>Error loading users: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>
        <div id="noResults" class="no-results" style="display: none;">
            <i class='bx bx-search-alt'></i>
            <h3>No users found</h3>
            <p>Try adjusting your search or filter criteria</p>
        </div>
    </div>

    <div class="pagination">
        <a href="#" class="page-btn"><i class='bx bx-chevron-left'></i></a>
        <a href="#" class="page-btn active">1</a>
        <a href="#" class="page-btn">2</a>
        <a href="#" class="page-btn">3</a>
        <span style="color: var(--text-light);">...</span>
        <a href="#" class="page-btn">10</a>
        <a href="#" class="page-btn"><i class='bx bx-chevron-right'></i></a>
    </div>
</div>

<script>
    // Store all rows for filtering
    let allRows = [];

    document.addEventListener('DOMContentLoaded', function() {
        // Store all rows on page load
        allRows = Array.from(document.querySelectorAll('.user-row'));
        updateNoResults();
    });

    // Search functionality
    document.getElementById('searchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const currentFilter = document.querySelector('.filter-btn.active')?.id || 'filterAll';

        filterAndSearch(currentFilter, searchTerm);
    });

    // Filter users by status
    function filterUsers(filterType) {
        // Update active button
        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));

        if (filterType === 'all') {
            document.getElementById('filterAll').classList.add('active');
        } else if (filterType === 'active') {
            document.getElementById('filterActive').classList.add('active');
        } else if (filterType === 'pending') {
            document.getElementById('filterPending').classList.add('active');
        }

        // Apply current search and filter
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        filterAndSearch(filterType, searchTerm);
    }

    // Combined filter and search function
    function filterAndSearch(filterType, searchTerm) {
        let visibleCount = 0;

        allRows.forEach(row => {
            const rowText = row.textContent.toLowerCase();
            const rowStatus = row.dataset.status;

            // Check status filter
            let statusMatch = true;
            if (filterType === 'active') {
                statusMatch = rowStatus === 'active';
            } else if (filterType === 'pending') {
                statusMatch = rowStatus === 'pending';
            }

            // Check search term
            const searchMatch = searchTerm === '' || rowText.includes(searchTerm);

            // Show/hide row
            if (statusMatch && searchMatch) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Show/hide no results message
        updateNoResults(visibleCount);
    }

    // Update no results message
    function updateNoResults(visibleCount = null) {
        const noResultsDiv = document.getElementById('noResults');
        const visibleRows = visibleCount !== null ? visibleCount :
            Array.from(document.querySelectorAll('.user-row')).filter(row => row.style.display !== 'none').length;

        if (visibleRows === 0) {
            noResultsDiv.style.display = 'block';
        } else {
            noResultsDiv.style.display = 'none';
        }
    }

    // Add new user function
    function addNewUser() {
        window.location.href = 'addNewUser.jsp?admin=true';
    }

    // Delete user function with confirmation
    function deleteUser(userId, username) {
        if (confirm(`Are you sure you want to delete user "${username}"? This action cannot be undone.`)) {
            // Show loading state
            showLoading();

            // Send delete request
            fetch('DeleteUserServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'userId=' + userId
            })
                .then(response => {
                    if (response.ok) {
                        showAlert('success', 'User Deleted', `User "${username}" has been deleted successfully`);
                        // Remove row from DOM
                        const rowToDelete = Array.from(document.querySelectorAll('.user-row')).find(row =>
                            row.textContent.includes(username)
                        );
                        if (rowToDelete) {
                            rowToDelete.remove();
                            // Update allRows array
                            allRows = Array.from(document.querySelectorAll('.user-row'));
                            updateNoResults();
                        }
                    } else {
                        showAlert('error', 'Delete Failed', 'Unable to delete user. Please try again.');
                    }
                    hideLoading();
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('error', 'Error', 'Network error. Please try again.');
                    hideLoading();
                });
        }
    }

    // Show loading spinner
    function showLoading() {
        const spinner = document.createElement('div');
        spinner.className = 'spinner';
        spinner.id = 'loadingSpinner';
        spinner.innerHTML = '<div class="spinner-inner"></div>';
        document.body.appendChild(spinner);
    }

    // Hide loading spinner
    function hideLoading() {
        const spinner = document.getElementById('loadingSpinner');
        if (spinner) {
            spinner.remove();
        }
    }

    // Show alert message
    function showAlert(type, title, message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type}`;

        alertDiv.innerHTML = `
            <i class='bx ${type === 'success' ? 'bx-check-circle' : 'bx-error-circle'}'></i>
            <div class="alert-content">
                <div class="alert-title">${title}</div>
                <div class="alert-message">${message}</div>
            </div>
            <i class='bx bx-x close-alert' onclick="this.parentElement.remove()"></i>
        `;

        document.body.appendChild(alertDiv);

        setTimeout(() => {
            if (alertDiv.parentElement) {
                alertDiv.remove();
            }
        }, 5000);
    }

    // Add keyboard shortcut for search (Ctrl + F)
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey && e.key === 'f') {
            e.preventDefault();
            document.getElementById('searchInput').focus();
        }
    });

    // Add CSS for spinner and alerts dynamically
    const style = document.createElement('style');
    style.textContent = `
        .spinner {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .spinner-inner {
            width: 50px;
            height: 50px;
            border: 5px solid var(--border-color);
            border-top-color: var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .alert {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 1.5rem;
            border-radius: var(--radius-sm);
            background: white;
            box-shadow: var(--shadow-hover);
            display: flex;
            align-items: center;
            gap: 1rem;
            z-index: 1000;
            animation: slideIn 0.3s ease;
            max-width: 400px;
        }

        .alert-success {
            border-left: 4px solid var(--primary-color);
        }

        .alert-error {
            border-left: 4px solid var(--danger-color);
        }

        .alert i {
            font-size: 1.2rem;
        }

        .alert-success i {
            color: var(--primary-color);
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
    `;
    document.head.appendChild(style);
</script>
</body>
</html>