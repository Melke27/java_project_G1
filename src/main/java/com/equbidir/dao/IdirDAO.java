package com.equbidir.dao;

import com.equbidir.model.IdirGroup;
import com.equbidir.util.DatabaseConnection;

import java.math.BigDecimal;
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

    public boolean isMemberInIdir(int memberId, int idirId) throws SQLException {
        String sql = "SELECT 1 FROM idir_members WHERE member_id = ? AND idir_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ps.setInt(2, idirId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // FIXED: Now returns actual total fund balance from paid contributions
    public BigDecimal getTotalFundBalance() throws SQLException {
        String sql = """
            SELECT COALESCE(SUM(ig.monthly_payment), 0)
            FROM idir_members im
            JOIN idir_groups ig ON im.idir_id = ig.idir_id
            WHERE im.payment_status = 'paid'
            """;
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
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
        List<String[]> rows = new ArrayList<>();
        String sql = "SELECT m.member_id, m.full_name, m.phone, im.payment_status " +
                "FROM idir_members im JOIN members m ON im.member_id = m.member_id " +
                "WHERE im.idir_id = ? ORDER BY m.full_name ASC";
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
        approvePayment(idirId, memberId, null);
    }

    public void approvePayment(int idirId, int memberId, Integer approvedBy) throws SQLException {
        String upd = "UPDATE idir_members SET payment_status='paid' WHERE idir_id=? AND member_id=? AND payment_status<>'paid'";

        try (Connection con = DatabaseConnection.getConnection()) {
            int updated;
            try (PreparedStatement ps = con.prepareStatement(upd)) {
                ps.setInt(1, idirId);
                ps.setInt(2, memberId);
                updated = ps.executeUpdate();
            }

            if (updated > 0) {
                String ins = "INSERT INTO idir_payments (idir_id, member_id, amount, approved_by) " +
                        "SELECT ig.idir_id, ?, ig.monthly_payment, ? FROM idir_groups ig WHERE ig.idir_id = ?";
                try (PreparedStatement ps2 = con.prepareStatement(ins)) {
                    ps2.setInt(1, memberId);
                    if (approvedBy == null) {
                        ps2.setNull(2, Types.INTEGER);
                    } else {
                        ps2.setInt(2, approvedBy);
                    }
                    ps2.setInt(3, idirId);
                    ps2.executeUpdate();
                }
            }
        }
    }
}