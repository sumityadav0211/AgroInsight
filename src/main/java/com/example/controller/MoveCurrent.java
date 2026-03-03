package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/MoveCurrent")
public class MoveCurrent extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔐 ADMIN CHECK
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int cropId = Integer.parseInt(request.getParameter("cropId"));

        Connection con = null;
        PreparedStatement insert = null;
        PreparedStatement delete = null;

        try {
            // ✅ Use PostgreSQL connection
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            // INSERT BACK TO CURRENT
            insert = con.prepareStatement(
                    "INSERT INTO add_crop (username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) " +
                            "SELECT username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                            "FROM history_crop WHERE id=?"
            );
            insert.setInt(1, cropId);
            insert.executeUpdate();

            // DELETE FROM HISTORY
            delete = con.prepareStatement(
                    "DELETE FROM history_crop WHERE id=?"
            );
            delete.setInt(1, cropId);
            delete.executeUpdate();

            con.commit(); // Commit transaction

            response.sendRedirect("viewCrops.jsp?type=history");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            throw new ServletException(e);
        } finally {
            try { if (insert != null) insert.close(); } catch (Exception ignored) {}
            try { if (delete != null) delete.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}