package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/MoveToHistory")
public class MoveToHistory extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String role = (String) session.getAttribute("role");
        String username = (String) session.getAttribute("username");

        int cropId = Integer.parseInt(request.getParameter("cropId"));

        Connection con = null;
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FarmManagement",
                    "root",
                    "0004"
            );

            con.setAutoCommit(false); // 🔁 TRANSACTION

            /* ================= COPY TO HISTORY ================= */
            String insertSql;

            if ("admin".equals(role)) {
                // ADMIN → MOVE ANY USER CROP
                insertSql =
                        "INSERT INTO history_crop (username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) " +
                                "SELECT username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                "FROM add_crop WHERE id=?";
            } else {
                // USER → MOVE OWN CROP ONLY
                insertSql =
                        "INSERT INTO history_crop (username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) " +
                                "SELECT username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                "FROM add_crop WHERE id=? AND username=?";
            }

            PreparedStatement psInsert = con.prepareStatement(insertSql);
            psInsert.setInt(1, cropId);

            if (!"admin".equals(role)) {
                psInsert.setString(2, username);
            }

            int inserted = psInsert.executeUpdate();

            if (inserted == 0) {
                con.rollback();
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.write("NOT_ALLOWED");
                return;
            }

            /* ================= DELETE FROM CURRENT ================= */
            String deleteSql;

            if ("admin".equals(role)) {
                deleteSql = "DELETE FROM add_crop WHERE id=?";
            } else {
                deleteSql = "DELETE FROM add_crop WHERE id=? AND username=?";
            }

            PreparedStatement psDelete = con.prepareStatement(deleteSql);
            psDelete.setInt(1, cropId);

            if (!"admin".equals(role)) {
                psDelete.setString(2, username);
            }

            int deleted = psDelete.executeUpdate();

            if (deleted == 0) {
                con.rollback();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("DELETE_FAILED");
                return;
            }

            con.commit();
            response.setStatus(HttpServletResponse.SC_OK);
            out.write("SUCCESS");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("ERROR: " + e.getMessage());
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception ignored) {}
        }
    }
}