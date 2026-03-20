package com.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;

import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/login")
public class login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Map<String, Object> jsonResponse = new HashMap<>();

        Connection con = null;
        PreparedStatement psAdmin = null;
        PreparedStatement psUser = null;
        ResultSet rsAdmin = null;
        ResultSet rsUser = null;

        try {
            // ✅ Use Neon PostgreSQL connection
            con = DBConnection.getConnection();

            HttpSession session = request.getSession();

            /* ========= CHECK ADMIN ========= */
            psAdmin = con.prepareStatement(
                    "SELECT username, email FROM admin WHERE username=? AND user_password=?"
            );
            psAdmin.setString(1, username);
            psAdmin.setString(2, password);

            rsAdmin = psAdmin.executeQuery();

            if (rsAdmin.next()) {
                session.setAttribute("username", rsAdmin.getString("username"));
                session.setAttribute("userEmail", rsAdmin.getString("email"));
                session.setAttribute("role", "admin");

                jsonResponse.put("success", true);
                jsonResponse.put("role", "admin");
                jsonResponse.put("redirect", "index.jsp");

                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }

            /* ========= CHECK NORMAL USER ========= */
            // ⚠️ Make sure table name is lowercase in Neon: farmdata
            psUser = con.prepareStatement(
                    "SELECT username, email FROM farmdata WHERE username=? AND user_password=?"
            );
            psUser.setString(1, username);
            psUser.setString(2, password);

            rsUser = psUser.executeQuery();

            if (rsUser.next()) {
                session.setAttribute("username", rsUser.getString("username"));
                session.setAttribute("userEmail", rsUser.getString("email"));
                session.setAttribute("role", "user");

                jsonResponse.put("success", true);
                jsonResponse.put("role", "user");
                jsonResponse.put("redirect", "index.jsp");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("error", "invalid");
                jsonResponse.put("message", "Invalid username or password. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("error", "server_error");
            jsonResponse.put("message", "An error occurred. Please try again.");
        } finally {
            try { if (rsAdmin != null) rsAdmin.close(); } catch (Exception ignored) {}
            try { if (rsUser != null) rsUser.close(); } catch (Exception ignored) {}
            try { if (psAdmin != null) psAdmin.close(); } catch (Exception ignored) {}
            try { if (psUser != null) psUser.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}