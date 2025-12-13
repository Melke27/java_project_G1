package com.equbidir.dao;

import com.equbidir.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExpenseDAO {

    public void addExpense(int idirId, double amount, String description, Date expenseDate) throws SQLException {
        String sql = "INSERT INTO idir_expenses(idir_id, amount, description, expense_date) VALUES(?,?,?,?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idirId);
            ps.setDouble(2, amount);
            ps.setString(3, description);
            ps.setDate(4, expenseDate);
            ps.executeUpdate();
        }
    }

    public List<String[]> listExpensesByIdir(int idirId) throws SQLException {
        // returns: expense_id, amount, description, expense_date
        List<String[]> rows = new ArrayList<>();
        String sql = "SELECT expense_id, amount, description, expense_date FROM idir_expenses WHERE idir_id=? ORDER BY expense_date DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idirId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new String[]{
                            String.valueOf(rs.getInt("expense_id")),
                            String.valueOf(rs.getDouble("amount")),
                            rs.getString("description"),
                            String.valueOf(rs.getDate("expense_date"))
                    });
                }
            }
        }
        return rows;
    }
}
