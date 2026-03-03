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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/FarmManagement",
                    "root",
                    "0004"
            );

            /* CHECK IF USERNAME EXISTS */
            PreparedStatement checkUsernamePs = con.prepareStatement(
                    "SELECT * FROM FarmData WHERE username = ?"
            );
            checkUsernamePs.setString(1, username);
            ResultSet rsUsername = checkUsernamePs.executeQuery();

            /* CHECK IF EMAIL EXISTS */
            PreparedStatement checkEmailPs = con.prepareStatement(
                    "SELECT * FROM FarmData WHERE email = ?"
            );
            checkEmailPs.setString(1, email);
            ResultSet rsEmail = checkEmailPs.executeQuery();

            if (rsUsername.next() && rsEmail.next()) {
                // Both username and email exist
                jsonResponse.put("success", false);
                jsonResponse.put("error", "both_exist");
                jsonResponse.put("message", "Username and email already exist. Please use different credentials.");
                jsonResponse.put("field", "both");
            }
            else if (rsUsername.next()) {
                // Username already exists
                jsonResponse.put("success", false);
                jsonResponse.put("error", "username_exists");
                jsonResponse.put("message", "This username is already taken. Please choose a different username.");
                jsonResponse.put("field", "username");
            }
            else if (rsEmail.next()) {
                // Email already exists
                jsonResponse.put("success", false);
                jsonResponse.put("error", "email_exists");
                jsonResponse.put("message", "This email is already registered. Please use a different email or login.");
                jsonResponse.put("field", "email");
            }
            else {
                // INSERT NEW USER
                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO FarmData (username, email, user_password) VALUES (?, ?, ?)"
                );
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);

                ps.executeUpdate();

                jsonResponse.put("success", true);
                jsonResponse.put("message", "Registration successful! Please login with your credentials.");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("error", "server_error");
            jsonResponse.put("message", "An error occurred during registration. Please try again.");
        }

        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}