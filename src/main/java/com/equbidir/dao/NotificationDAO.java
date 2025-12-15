package com.equbidir.dao;

import com.equbidir.model.Notification;
import com.equbidir.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public void createNotification(String title, String message, int createdByMemberId) throws SQLException {
        String sql = "INSERT INTO notifications (title, message, created_by) VALUES (?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, message);
            ps.setInt(3, createdByMemberId);
            ps.executeUpdate();
        }
    }

    public List<Notification> getLatestNotifications(int limit) throws SQLException {
        List<Notification> out = new ArrayList<>();

        String sql = "SELECT n.notification_id, n.title, n.message, n.created_at, m.full_name AS created_by_name " +
                "FROM notifications n " +
                "JOIN members m ON n.created_by = m.member_id " +
                "ORDER BY n.created_at DESC " +
                "LIMIT ?";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new Notification(
                            rs.getInt("notification_id"),
                            rs.getString("title"),
                            rs.getString("message"),
                            rs.getTimestamp("created_at"),
                            rs.getString("created_by_name")
                    ));
                }
            }
        }

        return out;
    }
}
