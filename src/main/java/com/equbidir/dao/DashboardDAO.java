package com.equbidir.dao;

import com.equbidir.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DashboardDAO {

    private int queryInt(String sql) throws SQLException {
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private double queryDouble(String sql) throws SQLException {
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    public int countMembers() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM members");
    }

    public int countEqubGroups() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM equb_groups");
    }

    public int countIdirGroups() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM idir_groups");
    }

    public int countEqubUnpaidMembers() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM equb_members WHERE payment_status='unpaid'");
    }

    public int countIdirUnpaidMembers() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM idir_members WHERE payment_status='unpaid'");
    }

    public int countIdirExpenses() throws SQLException {
        return queryInt("SELECT COUNT(*) FROM idir_expenses");
    }

    public double totalIdirExpensesAmount() throws SQLException {
        return queryDouble("SELECT COALESCE(SUM(amount), 0) FROM idir_expenses");
    }
}

