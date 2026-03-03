package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/ExportReportServlet")
public class downloadData extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String username = (String) session.getAttribute("username");
        String farmerName = (String) session.getAttribute("farmerName");

        if(username == null){
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition",
                "attachment; filename=" + username + "_crop_report.csv");

        PrintWriter out = response.getWriter();

        out.println("FarmerName,Username,Crop,Area,Yield,Revenue");

        try {
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/agriculture_db",
                    "root",
                    "password"
            );

            String sql = "SELECT crop_name, area, yield, revenue FROM crop_data WHERE username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                out.println(
                        farmerName + "," +
                                username + "," +
                                rs.getString("crop_name") + "," +
                                rs.getDouble("area") + "," +
                                rs.getDouble("yield") + "," +
                                rs.getDouble("revenue")
                );
            }

            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            out.println("Error Generating Report");
        }
    }
}
