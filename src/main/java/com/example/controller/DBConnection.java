package com.example.controller;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:postgresql://ep-soft-lab-a1gfk0rz-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require";

    private static final String USER = "neondb_owner";
    private static final String PASSWORD = "npg_LMNa6rxqAn7s";

    public static Connection getConnection() {

        Connection conn = null;

        try {

            Class.forName("org.postgresql.Driver");

            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("Database Connected Successfully");

        } catch (Exception e) {

            System.out.println("Database Connection Failed");
            e.printStackTrace();

        }

        return conn;
    }
}