package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminAddCrop")
public class AdminAddCrop extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String username = request.getParameter("targetUser");

        String farmerName = request.getParameter("farmerName");
        String farmArea = request.getParameter("farmArea");
        String cropName = request.getParameter("cropName");
        String contactNumber = request.getParameter("contactNumber");
        String date = request.getParameter("date");
        String period = request.getParameter("period");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // ✅ Use Neon PostgreSQL connection
            con = DBConnection.getConnection();

            String sql = "INSERT INTO add_crop " +
                    "(username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, farmerName);
            ps.setString(3, farmArea);
            ps.setString(4, cropName);
            ps.setString(5, contactNumber);

            // ✅ Convert String date to SQL Date
            ps.setDate(6, Date.valueOf(date));

            ps.setString(7, period);

            ps.executeUpdate();

            response.sendRedirect("viewCrops.jsp?type=current&username=" + username);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminUser.jsp?error=database");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}