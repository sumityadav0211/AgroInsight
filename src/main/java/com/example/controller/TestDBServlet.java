package com.example.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            out.println("<h2>Database Connected Successfully ✅</h2>");
        } else {
            out.println("<h2>Database Connection Failed ❌</h2>");
        }
    }
}