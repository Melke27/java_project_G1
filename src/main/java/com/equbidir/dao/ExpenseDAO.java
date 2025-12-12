package com.equbidir.dao;

import com.equbidir.model.Expense;
import com.equbidir.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ExpenseDAO {

    private static final String INSERT_EXPENSE = "INSERT INTO expenses (amount, expense_date, description, category) VALUES (?, ?, ?, ?)";
    private static final String SELECT_ALL = "SELECT id, amount, expense_date, description, category FROM expenses ORDER BY expense_date DESC, id DESC";
    private static final String SUM_EXPENSES = "SELECT COALESCE(SUM(amount), 0) AS total FROM expenses";
    private static final String SUM_BY_CATEGORY = "SELECT category, COALESCE(SUM(amount),0) AS total FROM expenses GROUP BY category";
    private static final String GET_BALANCE = "SELECT balance FROM idir_fund LIMIT 1";
    private static final String UPDATE_BALANCE = "UPDATE idir_fund SET balance = balance - ?";
    private static final String SUM_BY_MONTH = "SELECT DATE_FORMAT(expense_date, '%Y-%m') AS month_key, COALESCE(SUM(amount),0) AS total FROM expenses GROUP BY month_key ORDER BY month_key DESC";

    public void addExpense(Expense expense) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement insertStmt = conn.prepareStatement(INSERT_EXPENSE, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement updateFund = conn.prepareStatement(UPDATE_BALANCE)) {

                insertStmt.setBigDecimal(1, expense.getAmount());
                insertStmt.setDate(2, Date.valueOf(expense.getDate()));
                insertStmt.setString(3, expense.getDescription());
                insertStmt.setString(4, expense.getCategory());
                insertStmt.executeUpdate();

                updateFund.setBigDecimal(1, expense.getAmount());
                updateFund.executeUpdate();

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public List<Expense> findAll() throws SQLException {
        List<Expense> expenses = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Expense expense = new Expense(
                        rs.getInt("id"),
                        rs.getBigDecimal("amount"),
                        rs.getDate("expense_date").toLocalDate(),
                        rs.getString("description"),
                        rs.getString("category")
                );
                expenses.add(expense);
            }
        }
        return expenses;
    }

    public BigDecimal getTotalExpenses() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SUM_EXPENSES);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }

    public Map<String, BigDecimal> getCategoryTotals() throws SQLException {
        Map<String, BigDecimal> totals = new LinkedHashMap<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SUM_BY_CATEGORY);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                totals.put(rs.getString("category"), rs.getBigDecimal("total"));
            }
        }
        return totals;
    }

    public Map<String, BigDecimal> getMonthlyTotals() throws SQLException {
        Map<String, BigDecimal> totals = new LinkedHashMap<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SUM_BY_MONTH);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                totals.put(rs.getString("month_key"), rs.getBigDecimal("total"));
            }
        }
        return totals;
    }

    public BigDecimal getFundBalance() throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_BALANCE);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("balance");
            }
        }
        return BigDecimal.ZERO;
    }
}

