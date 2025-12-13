package com.equbidir.dao;

import com.equbidir.model.Member;
import com.equbidir.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    public Member authenticate(String phone, String passwordHash) throws SQLException {
        String sql = "SELECT member_id, full_name, phone, address, password_hash, role FROM members WHERE phone=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                String storedHash = rs.getString("password_hash");
                if (!storedHash.equals(passwordHash)) return null;

                Member m = new Member();
                m.setMemberId(rs.getInt("member_id"));
                m.setFullName(rs.getString("full_name"));
                m.setPhone(rs.getString("phone"));
                m.setAddress(rs.getString("address"));
                m.setPasswordHash(storedHash);
                m.setRole(rs.getString("role"));
                return m;
            }
        }
    }

    public List<Member> getAllMembers() throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT member_id, full_name, phone, address, role FROM members ORDER BY member_id DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                members.add(new Member(
                        rs.getInt("member_id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("role")
                ));
            }
        }
        return members;
    }

    public void createMember(Member m) throws SQLException {
        String sql = "INSERT INTO members(full_name, phone, address, password_hash, role) VALUES(?,?,?,?,?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, m.getFullName());
            ps.setString(2, m.getPhone());
            ps.setString(3, m.getAddress());
            ps.setString(4, m.getPasswordHash());
            ps.setString(5, m.getRole());
            ps.executeUpdate();
        }
    }

    public void updateMember(Member m) throws SQLException {
        String sql = "UPDATE members SET full_name=?, phone=?, address=?, role=? WHERE member_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, m.getFullName());
            ps.setString(2, m.getPhone());
            ps.setString(3, m.getAddress());
            ps.setString(4, m.getRole());
            ps.setInt(5, m.getMemberId());
            ps.executeUpdate();
        }
    }

    public void resetPassword(int memberId, String newPasswordHash) throws SQLException {
        String sql = "UPDATE members SET password_hash=? WHERE member_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, memberId);
            ps.executeUpdate();
        }
    }

    public void deleteMember(int memberId) throws SQLException {
        String sql = "DELETE FROM members WHERE member_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ps.executeUpdate();
        }
    }
}
