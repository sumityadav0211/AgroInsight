package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteCrop")
public class DeleteCrop extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔐 ADMIN AUTH CHECK
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to delete crops");
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

            con.setAutoCommit(false); // 🔁 TRANSACTION START

            /* ========= DELETE FROM CURRENT CROPS ========= */
            PreparedStatement psCurrent = con.prepareStatement(
                    "DELETE FROM add_crop WHERE id=?"
            );
            psCurrent.setInt(1, cropId);
            psCurrent.executeUpdate();

            /* ========= DELETE FROM HISTORY CROPS ========= */
            PreparedStatement psHistory = con.prepareStatement(
                    "DELETE FROM history_crop WHERE id=?"
            );
            psHistory.setInt(1, cropId);
            psHistory.executeUpdate();

            // Commit even if record exists in only one table
            con.commit();
            con.close();

            // Redirect back
            response.sendRedirect("viewCrops.jsp?type=current");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
