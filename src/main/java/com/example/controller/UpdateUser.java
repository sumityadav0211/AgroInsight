package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateUser")
public class UpdateUser extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔐 ADMIN CHECK
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        String newUsername = request.getParameter("username");
        String newEmail = request.getParameter("email");

        Connection con = null;
        PreparedStatement psGet = null;
        PreparedStatement psUser = null;
        PreparedStatement psAddCrop = null;
        PreparedStatement psHistory = null;
        ResultSet rs = null;

        try {
            // ✅ Use PostgreSQL connection
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            /* ================= GET OLD USERNAME ================= */
            String oldUsername;

            psGet = con.prepareStatement(
                    "SELECT username FROM farmdata WHERE id=?"
            );
            psGet.setInt(1, userId);
            rs = psGet.executeQuery();

            if (rs.next()) {
                oldUsername = rs.getString("username");
            } else {
                throw new SQLException("User not found");
            }

            /* ================= UPDATE farmdata ================= */
            psUser = con.prepareStatement(
                    "UPDATE farmdata SET username=?, email=? WHERE id=?"
            );
            psUser.setString(1, newUsername);
            psUser.setString(2, newEmail);
            psUser.setInt(3, userId);
            psUser.executeUpdate();

            /* ================= UPDATE add_crop ================= */
            psAddCrop = con.prepareStatement(
                    "UPDATE add_crop SET username=? WHERE username=?"
            );
            psAddCrop.setString(1, newUsername);
            psAddCrop.setString(2, oldUsername);
            psAddCrop.executeUpdate();

            /* ================= UPDATE history_crop ================= */
            psHistory = con.prepareStatement(
                    "UPDATE history_crop SET username=? WHERE username=?"
            );
            psHistory.setString(1, newUsername);
            psHistory.setString(2, oldUsername);
            psHistory.executeUpdate();

            con.commit(); // ✅ SUCCESS

            response.sendRedirect("adminUser.jsp?updated=true");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (SQLException ignored) {}

            e.printStackTrace();
            response.sendRedirect("adminUser.jsp?error=true");

        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (psGet != null) psGet.close(); } catch (Exception ignored) {}
            try { if (psUser != null) psUser.close(); } catch (Exception ignored) {}
            try { if (psAddCrop != null) psAddCrop.close(); } catch (Exception ignored) {}
            try { if (psHistory != null) psHistory.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}