package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/AdminAddUserServlet")
public class AdminAddUser extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String emailVerified = request.getParameter("emailVerified");
        String role = request.getParameter("role");

        System.out.println("Adding user - Username: " + username + ", Email: " + email + ", Role: " + role);

        boolean isEmailVerified = "true".equals(emailVerified);

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FarmManagement?useSSL=false",
                    "root",
                    "0004"
            );

            // Check if username or email already exists in respective table
            if ("admin".equals(role)) {
                // Check admin table
                String checkAdminQuery = "SELECT id FROM admin WHERE username = ? OR email = ?";
                ps = con.prepareStatement(checkAdminQuery);
                ps.setString(1, username);
                ps.setString(2, email);
                rs = ps.executeQuery();

                if (rs.next()) {
                    out.println("<script>window.parent.showErrorMessage('Username or email already exists in admin table!');</script>");
                    return;
                }
                rs.close();
                ps.close();

                // Insert into admin table only
                String insertAdminQuery = "INSERT INTO admin (username, email, user_password) VALUES (?, ?, ?)";
                ps = con.prepareStatement(insertAdminQuery);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);

                int adminRows = ps.executeUpdate();
                System.out.println("Admin insert affected rows: " + adminRows);

                if (adminRows > 0) {
                    out.println("<script>window.parent.showSuccessMessage('" + username + "', 'admin');</script>");
                } else {
                    out.println("<script>window.parent.showErrorMessage('Failed to create administrator. Please try again.');</script>");
                }

            } else {
                // Check FarmData table for farmer
                String checkUserQuery = "SELECT id FROM FarmData WHERE username = ? OR email = ?";
                ps = con.prepareStatement(checkUserQuery);
                ps.setString(1, username);
                ps.setString(2, email);
                rs = ps.executeQuery();

                if (rs.next()) {
                    out.println("<script>window.parent.showErrorMessage('Username or email already exists!');</script>");
                    return;
                }
                rs.close();
                ps.close();

                // Insert into FarmData table only
                String insertUserQuery = "INSERT INTO FarmData (username, email, user_password, email_verified, created_at) VALUES (?, ?, ?, ?, NOW())";
                ps = con.prepareStatement(insertUserQuery);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setBoolean(4, isEmailVerified);

                int userRows = ps.executeUpdate();
                System.out.println("FarmData insert affected rows: " + userRows);

                if (userRows > 0) {
                    out.println("<script>window.parent.showSuccessMessage('" + username + "', 'user');</script>");
                } else {
                    out.println("<script>window.parent.showErrorMessage('Failed to create farmer. Please try again.');</script>");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error: " + e.getMessage());
            out.println("<script>window.parent.showErrorMessage('Database error: " + e.getMessage() + "');</script>");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error: " + e.getMessage());
            out.println("<script>window.parent.showErrorMessage('Error: " + e.getMessage() + "');</script>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}