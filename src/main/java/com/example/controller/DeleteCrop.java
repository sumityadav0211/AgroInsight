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
        PreparedStatement psCurrent = null;
        PreparedStatement psHistory = null;

        try {
            // ✅ Use Neon PostgreSQL connection
            con = DBConnection.getConnection();

            con.setAutoCommit(false); // 🔁 START TRANSACTION

            /* ========= DELETE FROM CURRENT CROPS ========= */
            psCurrent = con.prepareStatement(
                    "DELETE FROM add_crop WHERE id=?"
            );
            psCurrent.setInt(1, cropId);
            psCurrent.executeUpdate();

            /* ========= DELETE FROM HISTORY CROPS ========= */
            psHistory = con.prepareStatement(
                    "DELETE FROM history_crop WHERE id=?"
            );
            psHistory.setInt(1, cropId);
            psHistory.executeUpdate();

            con.commit(); // ✅ COMMIT TRANSACTION

            response.sendRedirect("viewCrops.jsp?type=current");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            throw new ServletException(e);
        } finally {
            try { if (psCurrent != null) psCurrent.close(); } catch (Exception ignored) {}
            try { if (psHistory != null) psHistory.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}