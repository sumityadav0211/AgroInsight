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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FarmManagement",
                    "root",
                    "0004"
            );

            con.setAutoCommit(false); // 🔒 START TRANSACTION

            /* ================= GET OLD USERNAME ================= */
            String oldUsername;

            PreparedStatement psGet = con.prepareStatement(
                    "SELECT username FROM FarmData WHERE id=?"
            );
            psGet.setInt(1, userId);
            ResultSet rs = psGet.executeQuery();

            if (rs.next()) {
                oldUsername = rs.getString("username");
            } else {
                throw new SQLException("User not found");
            }

            /* ================= UPDATE FarmData ================= */
            PreparedStatement psUser = con.prepareStatement(
                    "UPDATE FarmData SET username=?, email=? WHERE id=?"
            );
            psUser.setString(1, newUsername);
            psUser.setString(2, newEmail);
            psUser.setInt(3, userId);
            psUser.executeUpdate();

            /* ================= UPDATE add_crop ================= */
            PreparedStatement psAddCrop = con.prepareStatement(
                    "UPDATE add_crop SET username=? WHERE username=?"
            );
            psAddCrop.setString(1, newUsername);
            psAddCrop.setString(2, oldUsername);
            psAddCrop.executeUpdate();

            /* ================= UPDATE history_crop ================= */
            PreparedStatement psHistory = con.prepareStatement(
                    "UPDATE history_crop SET username=? WHERE username=?"
            );
            psHistory.setString(1, newUsername);
            psHistory.setString(2, oldUsername);
            psHistory.executeUpdate();

            con.commit(); // ✅ SUCCESS

            response.sendRedirect("adminUser.jsp?updated=true");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback(); // ❌ ROLLBACK
            } catch (SQLException ignored) {}

            e.printStackTrace();
            response.sendRedirect("adminUser.jsp?error=true");

        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException ignored) {}
        }
    }
}
