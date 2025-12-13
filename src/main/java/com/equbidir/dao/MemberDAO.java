package com.equbidir.dao;

import com.equbidir.model.Member;
import com.equbidir.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    private static final String SELECT_ALL = "SELECT id, name, phone_number, email, address FROM members ORDER BY name";

    public List<Member> findAll() throws SQLException {
        List<Member> members = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Member member = new Member(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("phone_number"),
                    rs.getString("email"),
                    rs.getString("address")
                );
                members.add(member);
            }
        }
        return members;
    }

    public Member findById(int id) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT id, name, phone_number, email, address FROM members WHERE id = ?")) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Member(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("phone_number"),
                        rs.getString("email"),
                        rs.getString("address")
                    );
                }
            }
        }
        return null;
    }
}

