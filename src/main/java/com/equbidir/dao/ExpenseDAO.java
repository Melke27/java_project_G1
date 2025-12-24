package com.equbidir.dao;

import com.equbidir.model.Expense;
import com.equbidir.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class ExpenseDAO {

    public void addExpense(int idirId, double amount, String description, java.sql.Date expenseDate) throws SQLException {
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

    public BigDecimal getTotalExpenses() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM idir_expenses";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    public Map<String, BigDecimal> getMonthlyExpenseTotals() throws SQLException {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT TO_CHAR(expense_date, 'YYYY-MM') AS month, COALESCE(SUM(amount), 0) " +
                "FROM idir_expenses GROUP BY month ORDER BY month DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("month"), rs.getBigDecimal(2));
            }
        }
        return map;
    }

    public List<Expense> getAllExpenses() throws SQLException {
        List<Expense> list = new ArrayList<>();
        String sql = "SELECT expense_date AS date, 'Idir Expense' AS category, description, amount " +
                "FROM idir_expenses ORDER BY expense_date DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Expense e = new Expense();
                e.setDate(rs.getDate("date"));
                e.setCategory(rs.getString("category"));
                e.setDescription(rs.getString("description"));
                e.setAmount(rs.getBigDecimal("amount"));
                list.add(e);
            }
        }
        return list;
    }

    public int countActiveEqubGroups() throws SQLException {
        String sql = "SELECT COUNT(DISTINCT equb_id) FROM equb_members";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<String[]> listExpensesByIdir(int idirId) throws SQLException {
        List<String[]> rows = new ArrayList<>();
        String sql = "SELECT expense_id, amount, description, expense_date FROM idir_expenses WHERE idir_id=? ORDER BY expense_date DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idirId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new String[]{
                            String.valueOf(rs.getInt("expense_id")),
                            String.format("%,.2f", rs.getDouble("amount")),
                            rs.getString("description"),
                            rs.getDate("expense_date").toString()
                    });
                }
            }
        }
        return rows;
    }
}