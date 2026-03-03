package com.example.controller;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:postgresql://ep-soft-lab-a1gfk0rz-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require";

    private static final String USER = "neondb_owner";
    private static final String PASSWORD = "npg_LMNa6rxqAn7s"; // Reset this

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

