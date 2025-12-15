package com.equbidir.dao;

import com.equbidir.model.MemberMessage;
import com.equbidir.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MemberMessageDAO {

    public void createMessage(int senderMemberId, String title, String message) throws SQLException {
        String sql = "INSERT INTO member_messages (sender_member_id, title, message) VALUES (?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, senderMemberId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.executeUpdate();
        }
    }

    public List<MemberMessage> getLatestMessages(int limit) throws SQLException {
        List<MemberMessage> out = new ArrayList<>();

        String sql = "SELECT mm.message_id, mm.title, mm.message, mm.created_at, " +
                "m.member_id AS sender_id, m.full_name AS sender_name, m.phone AS sender_phone " +
                "FROM member_messages mm " +
                "JOIN members m ON mm.sender_member_id = m.member_id " +
                "ORDER BY mm.created_at DESC " +
                "LIMIT ?";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new MemberMessage(
                            rs.getInt("message_id"),
                            rs.getString("title"),
                            rs.getString("message"),
                            rs.getTimestamp("created_at"),
                            rs.getInt("sender_id"),
                            rs.getString("sender_name"),
                            rs.getString("sender_phone")
                    ));
                }
            }
        }

        return out;
    }
}
