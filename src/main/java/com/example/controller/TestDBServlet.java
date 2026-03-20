package com.example.controller;

import java.sql.Connection;

public class TestDBServlet {

    public static void main(String[] args) {

        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            System.out.println("🎉 Connection Working!");
        } else {
            System.out.println("⚠️ Connection Failed!");
        }

    }
}