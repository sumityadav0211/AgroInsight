package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/EditCrop")
public class EditCrop extends HttpServlet {

    // ================= LOAD EDIT PAGE =================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String cropId = request.getParameter("id");

        if (cropId == null || cropId.isEmpty()) {
            response.sendRedirect("currentCrop.jsp?error=noid");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // ✅ Use PostgreSQL connection
            con = DBConnection.getConnection();

            ps = con.prepareStatement(
                    "SELECT * FROM add_crop WHERE id=?"
            );
            ps.setInt(1, Integer.parseInt(cropId));

            rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("cropId", rs.getInt("id") + "");
                request.setAttribute("farmerName", rs.getString("farmer_name"));
                request.setAttribute("farmArea", rs.getString("farm_area"));
                request.setAttribute("cropName", rs.getString("crop_name"));
                request.setAttribute("contactNumber", rs.getString("contact_number"));
                request.setAttribute("cropDate", rs.getDate("crop_dates"));
                request.setAttribute("period", rs.getString("period"));

                request.getRequestDispatcher("editCrop.jsp").forward(request, response);
            } else {
                response.sendRedirect("currentCrop.jsp?error=notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("currentCrop.jsp?error=load");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }

    // ================= UPDATE CROP =================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String cropId = request.getParameter("cropId");
        String farmerName = request.getParameter("farmerName");
        String farmArea = request.getParameter("farmArea");
        String cropName = request.getParameter("cropName");
        String contactNumber = request.getParameter("contactNumber");
        String date = request.getParameter("date");
        String period = request.getParameter("period");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // ✅ Use PostgreSQL connection
            con = DBConnection.getConnection();

            ps = con.prepareStatement(
                    "UPDATE add_crop SET farmer_name=?, farm_area=?, crop_name=?, contact_number=?, crop_dates=?, period=? WHERE id=?"
            );

            ps.setString(1, farmerName);
            ps.setString(2, farmArea);
            ps.setString(3, cropName);
            ps.setString(4, contactNumber);

            // ✅ Convert String date to SQL Date
            ps.setDate(5, Date.valueOf(date));

            ps.setString(6, period);
            ps.setInt(7, Integer.parseInt(cropId));

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("currentCrop.jsp?success=updated");
            } else {
                response.sendRedirect("currentCrop.jsp?error=notupdated");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("currentCrop.jsp?error=database");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}