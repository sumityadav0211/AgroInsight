package com.example.controller;

import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;

@WebServlet("/Register")
public class register extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("user_password");

        Map<String, Object> jsonResponse = new HashMap<>();

        Connection con = null;
        PreparedStatement checkUsernamePs = null;
        PreparedStatement checkEmailPs = null;
        PreparedStatement insertPs = null;
        ResultSet rsUsername = null;
        ResultSet rsEmail = null;

        try {
            // ✅ Use Neon PostgreSQL connection
            con = DBConnection.getConnection();

            /* CHECK IF USERNAME EXISTS */
            checkUsernamePs = con.prepareStatement(
                    "SELECT id FROM farmdata WHERE username = ?"
            );
            checkUsernamePs.setString(1, username);
            rsUsername = checkUsernamePs.executeQuery();

            boolean usernameExists = rsUsername.next();

            /* CHECK IF EMAIL EXISTS */
            checkEmailPs = con.prepareStatement(
                    "SELECT id FROM farmdata WHERE email = ?"
            );
            checkEmailPs.setString(1, email);
            rsEmail = checkEmailPs.executeQuery();

            boolean emailExists = rsEmail.next();

            if (usernameExists && emailExists) {

                jsonResponse.put("success", false);
                jsonResponse.put("error", "both_exist");
                jsonResponse.put("message", "Username and email already exist. Please use different credentials.");
                jsonResponse.put("field", "both");

            } else if (usernameExists) {

                jsonResponse.put("success", false);
                jsonResponse.put("error", "username_exists");
                jsonResponse.put("message", "This username is already taken. Please choose a different username.");
                jsonResponse.put("field", "username");

            } else if (emailExists) {

                jsonResponse.put("success", false);
                jsonResponse.put("error", "email_exists");
                jsonResponse.put("message", "This email is already registered. Please use a different email or login.");
                jsonResponse.put("field", "email");

            } else {

                /* INSERT NEW USER */
                insertPs = con.prepareStatement(
                        "INSERT INTO farmdata (username, email, user_password, email_verified, created_at) " +
                                "VALUES (?, ?, ?, false, NOW())"
                );

                insertPs.setString(1, username);
                insertPs.setString(2, email);
                insertPs.setString(3, password);

                insertPs.executeUpdate();

                jsonResponse.put("success", true);
                jsonResponse.put("message", "Registration successful! Please login with your credentials.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("error", "server_error");
            jsonResponse.put("message", "An error occurred during registration. Please try again.");
        } finally {
            try { if (rsUsername != null) rsUsername.close(); } catch (Exception ignored) {}
            try { if (rsEmail != null) rsEmail.close(); } catch (Exception ignored) {}
            try { if (checkUsernamePs != null) checkUsernamePs.close(); } catch (Exception ignored) {}
            try { if (checkEmailPs != null) checkEmailPs.close(); } catch (Exception ignored) {}
            try { if (insertPs != null) insertPs.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}