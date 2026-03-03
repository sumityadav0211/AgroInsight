package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AddCurrentCrop")
public class UserAddCrops extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String sessionUsername = (String) session.getAttribute("username");

        // 👇 Comes ONLY when admin adds crop for a user
        String targetUser = request.getParameter("targetUser");

        // ✅ Decide final username
        String finalUsername;
        if ("admin".equals(role) && targetUser != null && !targetUser.isEmpty()) {
            finalUsername = targetUser;   // admin adding for user
        } else {
            finalUsername = sessionUsername; // normal user
        }

        String farmerName = request.getParameter("farmerName");
        String farmArea = request.getParameter("farmArea");
        String cropName = request.getParameter("cropName");
        String contactNumber = request.getParameter("contactNumber");
        String date = request.getParameter("date");
        String period = request.getParameter("period");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FarmManagement",
                    "root",
                    "0004"
            );

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO add_crop " +
                            "(farmer_name, farm_area, crop_name, contact_number, crop_dates, period, username) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );

            ps.setString(1, farmerName);
            ps.setString(2, farmArea);
            ps.setString(3, cropName);
            ps.setString(4, contactNumber);
            ps.setString(5, date);
            ps.setString(6, period);
            ps.setString(7, finalUsername);

            ps.executeUpdate();
            con.close();

            // Redirect (same page for admin & user in your original logic)
            response.sendRedirect("addcrop.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
