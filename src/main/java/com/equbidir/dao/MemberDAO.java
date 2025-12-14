package com.equbidir.dao;

import com.equbidir.model.Member;
import com.equbidir.util.DatabaseConnection;
import com.equbidir.util.SecurityUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    public Member authenticate(String phone, String plainPassword) throws SQLException {
        String sql = "SELECT member_id, full_name, phone, address, password_hash, role FROM members WHERE phone = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");

                    if (SecurityUtil.checkPassword(plainPassword, storedHash)) {
                        return new Member(
                                rs.getInt("member_id"),
                                rs.getString("full_name"),
                                rs.getString("phone"),
                                rs.getString("address"),
                                rs.getString("role")
                        );
                    }
                }
            }
        }
        return null;
    }

    public List<Member> getAllMembers() throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT member_id, full_name, phone, address, role FROM members ORDER BY full_name ASC";

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

    public boolean createMember(Member member, String plainPassword) throws SQLException {
        if (getMemberByPhone(member.getPhone()) != null) {
            return false;
        }

        String hashedPassword = SecurityUtil.hashPassword(plainPassword);

        String sql = "INSERT INTO members (full_name, phone, address, password_hash, role) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, member.getFullName());
            ps.setString(2, member.getPhone());
            ps.setString(3, member.getAddress());
            ps.setString(4, hashedPassword);
            ps.setString(5, member.getRole() != null ? member.getRole() : "member");

            return ps.executeUpdate() > 0;
        }
    }

    public Member getMemberByPhone(String phone) throws SQLException {
        String sql = "SELECT member_id, full_name, phone, address, role FROM members WHERE phone = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Member(
                            rs.getInt("member_id"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("role")
                    );
                }
            }
        }
        return null;
    }

    public boolean updateMember(Member member) throws SQLException {
        String sql = "UPDATE members SET full_name = ?, phone = ?, address = ?, role = ? WHERE member_id = ?";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, member.getFullName());
            ps.setString(2, member.getPhone());
            ps.setString(3, member.getAddress());
            ps.setString(4, member.getRole());
            ps.setInt(5, member.getMemberId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean resetPassword(int memberId, String newPlainPassword) throws SQLException {
        String hashed = SecurityUtil.hashPassword(newPlainPassword);
        String sql = "UPDATE members SET password_hash = ? WHERE member_id = ?";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hashed);
            ps.setInt(2, memberId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteMember(int memberId) throws SQLException {
        String sql = "DELETE FROM members WHERE member_id = ?";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            return ps.executeUpdate() > 0;
        }
    }

    // NEW: Verify current password for change password feature
    public boolean verifyCurrentPassword(int memberId, String plainPassword) throws SQLException {
        String sql = "SELECT password_hash FROM members WHERE member_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    return SecurityUtil.checkPassword(plainPassword, storedHash);
                }
            }
        }
        return false;
    }

    // NEW: Get member with password hash (alternative if needed)
    public String getPasswordHash(int memberId) throws SQLException {
        String sql = "SELECT password_hash FROM members WHERE member_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password_hash");
                }
            }
        }
        return null;
    }
}