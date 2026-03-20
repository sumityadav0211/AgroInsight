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
        PreparedStatement psInsert = null;
        PreparedStatement psDelete = null;

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        try {
            // ✅ Use PostgreSQL connection
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            /* ================= COPY TO HISTORY ================= */
            String insertSql;

            if ("admin".equals(role)) {
                insertSql =
                        "INSERT INTO history_crop (username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) " +
                                "SELECT username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                "FROM add_crop WHERE id=?";
            } else {
                insertSql =
                        "INSERT INTO history_crop (username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period) " +
                                "SELECT username, farmer_name, farm_area, crop_name, contact_number, crop_dates, period " +
                                "FROM add_crop WHERE id=? AND username=?";
            }

            psInsert = con.prepareStatement(insertSql);
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

            psDelete = con.prepareStatement(deleteSql);
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

            con.commit(); // ✅ Commit transaction

            response.setStatus(HttpServletResponse.SC_OK);
            out.write("SUCCESS");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("ERROR");
        } finally {
            try { if (psInsert != null) psInsert.close(); } catch (Exception ignored) {}
            try { if (psDelete != null) psDelete.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}