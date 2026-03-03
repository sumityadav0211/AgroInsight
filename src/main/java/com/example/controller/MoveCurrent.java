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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FarmManagement",
                    "root",
                    "0004"
            );

            con.setAutoCommit(false);

            // INSERT BACK TO CURRENT
            PreparedStatement insert = con.prepareStatement(
                    "INSERT INTO add_crop (username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) " +
                            "SELECT username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                            "FROM history_crop WHERE id=?"
            );
            insert.setInt(1, cropId);
            insert.executeUpdate();

            // DELETE FROM HISTORY
            PreparedStatement delete = con.prepareStatement(
                    "DELETE FROM history_crop WHERE id=?"
            );
            delete.setInt(1, cropId);
            delete.executeUpdate();

            con.commit();
            con.close();

            response.sendRedirect("viewCrops.jsp?type=history");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
