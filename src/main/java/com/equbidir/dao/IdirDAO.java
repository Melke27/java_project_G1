package com.equbidir.dao;

import com.equbidir.model.IdirGroup;
<<<<<<< HEAD
import com.equbidir.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IdirDAO {

    public List<IdirGroup> getAllGroups() throws SQLException {
        List<IdirGroup> groups = new ArrayList<>();
        String sql = "SELECT idir_id, idir_name, monthly_payment FROM idir_groups ORDER BY idir_id DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                groups.add(new IdirGroup(
                        rs.getInt("idir_id"),
                        rs.getString("idir_name"),
                        rs.getDouble("monthly_payment")
                ));
            }
        }
        return groups;
    }

    public void createGroup(IdirGroup g) throws SQLException {
        String sql = "INSERT INTO idir_groups(idir_name, monthly_payment) VALUES(?,?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, g.getIdirName());
            ps.setDouble(2, g.getMonthlyPayment());
            ps.executeUpdate();
        }
    }

    public void deleteGroup(int idirId) throws SQLException {
        String sql = "DELETE FROM idir_groups WHERE idir_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idirId);
            ps.executeUpdate();
        }
    }

    public void addMemberToIdir(int memberId, int idirId) throws SQLException {
        String sql = "INSERT INTO idir_members(member_id, idir_id, payment_status) VALUES(?,?, 'unpaid')";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ps.setInt(2, idirId);
            ps.executeUpdate();
        }
    }

    public List<String[]> getIdirMembers(int idirId) throws SQLException {
        // returns rows: member_id, full_name, phone, payment_status
        List<String[]> rows = new ArrayList<>();
        String sql = "SELECT m.member_id, m.full_name, m.phone, im.payment_status " +
                "FROM idir_members im JOIN members m ON im.member_id=m.member_id " +
                "WHERE im.idir_id=? ORDER BY m.full_name ASC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idirId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new String[]{
                            String.valueOf(rs.getInt("member_id")),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("payment_status")
                    });
                }
            }
        }
        return rows;
    }

    public void approvePayment(int idirId, int memberId) throws SQLException {
        String sql = "UPDATE idir_members SET payment_status='paid' WHERE idir_id=? AND member_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idirId);
            ps.setInt(2, memberId);
            ps.executeUpdate();
        }
=======

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Simple in-memory DAO for managing Idir groups, payments, and expenses.
 * Replace with JDBC/ORM when a real database is available.
 */
public class IdirDAO {
    private static final Map<Integer, IdirGroup> GROUPS = new ConcurrentHashMap<>();
    private static final AtomicInteger ID_GENERATOR = new AtomicInteger(1);

    public List<IdirGroup> findAll() {
        return new ArrayList<>(GROUPS.values());
    }

    public Optional<IdirGroup> findById(int id) {
        return Optional.ofNullable(GROUPS.get(id));
    }

    public IdirGroup create(String name, double monthlyContribution) {
        int id = ID_GENERATOR.getAndIncrement();
        IdirGroup group = new IdirGroup(id, name, monthlyContribution);
        GROUPS.put(id, group);
        return group;
    }

    public boolean update(int id, String name, double monthlyContribution) {
        IdirGroup group = GROUPS.get(id);
        if (group == null) {
            return false;
        }
        group.setName(name);
        group.setMonthlyContribution(monthlyContribution);
        return true;
    }

    public boolean delete(int id) {
        return GROUPS.remove(id) != null;
    }

    public boolean recordPayment(int groupId, String member, double amount, LocalDate paidDate) {
        IdirGroup group = GROUPS.get(groupId);
        if (group == null) {
            return false;
        }
        group.addPayment(new IdirGroup.Payment(member, amount, paidDate));
        return true;
    }

    public boolean recordExpense(int groupId, String description, double amount, LocalDate spentDate) {
        IdirGroup group = GROUPS.get(groupId);
        if (group == null) {
            return false;
        }
        group.addExpense(new IdirGroup.Expense(description, amount, spentDate));
        return true;
>>>>>>> 02b51aac394f9d81545be5c42cde5eaebbec63e2
    }
}
