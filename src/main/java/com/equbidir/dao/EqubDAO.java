package com.equbidir.dao;

import com.equbidir.model.EqubGroup;
import com.equbidir.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class EqubDAO {

    public List<EqubGroup> getAllGroups() throws SQLException {
        List<EqubGroup> groups = new ArrayList<>();
        String sql = "SELECT equb_id, equb_name, amount, frequency FROM equb_groups ORDER BY equb_id DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                groups.add(new EqubGroup(
                        rs.getInt("equb_id"),
                        rs.getString("equb_name"),
                        rs.getDouble("amount"),
                        rs.getString("frequency")
                ));
            }
        }
        return groups;
    }

    public void createGroup(EqubGroup g) throws SQLException {
        String sql = "INSERT INTO equb_groups(equb_name, amount, frequency) VALUES(?,?,?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, g.getEqubName());
            ps.setDouble(2, g.getAmount());
            ps.setString(3, g.getFrequency());
            ps.executeUpdate();
        }
    }

    public void deleteGroup(int equbId) throws SQLException {
        String sql = "DELETE FROM equb_groups WHERE equb_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, equbId);
            ps.executeUpdate();
        }
    }

    public void addMemberToEqub(int memberId, int equbId) throws SQLException {
        String sql = "INSERT INTO equb_members(member_id, equb_id, payment_status) VALUES(?,?, 'unpaid')";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ps.setInt(2, equbId);
            ps.executeUpdate();
        }
    }

    // NEW: Check if member is already in this Equb group
    public boolean isMemberInEqub(int memberId, int equbId) throws SQLException {
        String sql = "SELECT 1 FROM equb_members WHERE member_id = ? AND equb_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ps.setInt(2, equbId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // true if exists
            }
        }
    }

    public List<String[]> getEqubMembers(int equbId) throws SQLException {
        // returns rows: member_id, full_name, phone, payment_status, rotation_position
        List<String[]> rows = new ArrayList<>();
        String sql = "SELECT m.member_id, m.full_name, m.phone, em.payment_status, em.rotation_position " +
                "FROM equb_members em JOIN members m ON em.member_id=m.member_id " +
                "WHERE em.equb_id=? ORDER BY em.rotation_position IS NULL, em.rotation_position ASC, m.full_name ASC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, equbId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new String[]{
                            String.valueOf(rs.getInt("member_id")),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("payment_status"),
                            rs.getObject("rotation_position") == null ? "" : String.valueOf(rs.getInt("rotation_position"))
                    });
                }
            }
        }
        return rows;
    }

    public void approvePayment(int equbId, int memberId) throws SQLException {
        approvePayment(equbId, memberId, null);
    }

    public void approvePayment(int equbId, int memberId, Integer approvedBy) throws SQLException {
        String upd = "UPDATE equb_members SET payment_status='paid' WHERE equb_id=? AND member_id=? AND payment_status<>'paid'";

        try (Connection con = DatabaseConnection.getConnection()) {
            int updated;
            try (PreparedStatement ps = con.prepareStatement(upd)) {
                ps.setInt(1, equbId);
                ps.setInt(2, memberId);
                updated = ps.executeUpdate();
            }

            // Only create a history record if status actually changed.
            if (updated > 0) {
                String ins = "INSERT INTO equb_payments (equb_id, member_id, amount, approved_by) " +
                        "SELECT eg.equb_id, ?, eg.amount, ? FROM equb_groups eg WHERE eg.equb_id = ?";
                try (PreparedStatement ps2 = con.prepareStatement(ins)) {
                    ps2.setInt(1, memberId);
                    if (approvedBy == null) {
                        ps2.setNull(2, Types.INTEGER);
                    } else {
                        ps2.setInt(2, approvedBy);
                    }
                    ps2.setInt(3, equbId);
                    ps2.executeUpdate();
                }
            }
        }
    }

    /**
     * Generates rotation positions 1..N. If random=true, order is shuffled.
     */
    public void generateRotation(int equbId, boolean random) throws SQLException {
        List<Integer> memberIds = new ArrayList<>();
        String q = "SELECT member_id FROM equb_members WHERE equb_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(q)) {
            ps.setInt(1, equbId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) memberIds.add(rs.getInt("member_id"));
            }
        }

        if (random) Collections.shuffle(memberIds);

        String upd = "UPDATE equb_members SET rotation_position=? WHERE equb_id=? AND member_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(upd)) {
            for (int i = 0; i < memberIds.size(); i++) {
                ps.setInt(1, i + 1);
                ps.setInt(2, equbId);
                ps.setInt(3, memberIds.get(i));
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
}