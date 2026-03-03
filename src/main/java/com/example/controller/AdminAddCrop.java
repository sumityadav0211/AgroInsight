package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminAddCrop")
public class AdminAddCrop extends HttpServlet {

    private final String URL = "jdbc:mysql://localhost:3306/FarmManagement";
    private final String USER = "root";
    private final String PASS = "0004";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String username = request.getParameter("targetUser"); // ✅ Important

        String farmerName = request.getParameter("farmerName");
        String farmArea = request.getParameter("farmArea");
        String cropName = request.getParameter("cropName");
        String contactNumber = request.getParameter("contactNumber");
        String date = request.getParameter("date");
        String period = request.getParameter("period");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(URL, USER, PASS);

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO add_crop (username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) VALUES (?, ?, ?, ?, ?, ?, ?)"
            );

            ps.setString(1, username);  // ✅ specific user
            ps.setString(2, farmerName);
            ps.setString(3, farmArea);
            ps.setString(4, cropName);
            ps.setString(5, contactNumber);
            ps.setString(6, date);
            ps.setString(7, period);

            ps.executeUpdate();
            con.close();

            response.sendRedirect("viewCrops.jsp?type=current&username=" + username);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminUser.jsp?error=database");
        }
    }
}