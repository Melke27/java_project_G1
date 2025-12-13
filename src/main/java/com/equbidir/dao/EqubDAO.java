package com.equbidir.dao;

import com.equbidir.model.EqubGroup;
import com.equbidir.model.Contribution;
import com.equbidir.model.Rotation;
import com.equbidir.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class EqubDAO {

    // EqubGroup queries
    private static final String INSERT_GROUP = "INSERT INTO equb_groups (name, contribution_amount, frequency, start_date, completed) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_ALL_GROUPS = "SELECT id, name, contribution_amount, frequency, start_date, completed FROM equb_groups ORDER BY start_date DESC, id DESC";
    private static final String SELECT_GROUP_BY_ID = "SELECT id, name, contribution_amount, frequency, start_date, completed FROM equb_groups WHERE id = ?";
    private static final String UPDATE_GROUP = "UPDATE equb_groups SET name = ?, contribution_amount = ?, frequency = ?, start_date = ?, completed = ? WHERE id = ?";
    private static final String MARK_GROUP_COMPLETED = "UPDATE equb_groups SET completed = TRUE WHERE id = ?";
    private static final String COUNT_MEMBERS_IN_GROUP = "SELECT COUNT(DISTINCT member_id) as total FROM equb_members WHERE equb_group_id = ?";

    // Contribution queries
    private static final String INSERT_CONTRIBUTION = "INSERT INTO contributions (equb_group_id, member_id, amount, payment_date) VALUES (?, ?, ?, ?)";
    private static final String SELECT_CONTRIBUTIONS_BY_GROUP = "SELECT c.id, c.equb_group_id, c.member_id, c.amount, c.payment_date, " +
            "m.name as member_name FROM contributions c " +
            "LEFT JOIN members m ON c.member_id = m.id " +
            "WHERE c.equb_group_id = ? ORDER BY c.payment_date DESC, c.id DESC";
    private static final String SELECT_ALL_CONTRIBUTIONS = "SELECT c.id, c.equb_group_id, c.member_id, c.amount, c.payment_date, " +
            "m.name as member_name FROM contributions c " +
            "LEFT JOIN members m ON c.member_id = m.id " +
            "ORDER BY c.payment_date DESC, c.id DESC";

    // Rotation queries
    private static final String INSERT_ROTATION = "INSERT INTO rotations (equb_group_id, member_id, position, rotation_date, completed) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_ROTATIONS_BY_GROUP = "SELECT r.id, r.equb_group_id, r.member_id, r.position, r.rotation_date, r.completed, " +
            "m.name as member_name FROM rotations r " +
            "LEFT JOIN members m ON r.member_id = m.id " +
            "WHERE r.equb_group_id = ? ORDER BY r.position ASC";
    private static final String UPDATE_ROTATION_POSITION = "UPDATE rotations SET position = ? WHERE id = ?";
    private static final String DELETE_ROTATIONS_BY_GROUP = "DELETE FROM rotations WHERE equb_group_id = ?";
    private static final String SELECT_MEMBERS_IN_GROUP = "SELECT DISTINCT member_id FROM equb_members WHERE equb_group_id = ?";

    // Create Equb Group
    public int createGroup(EqubGroup group) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_GROUP, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, group.getName());
            stmt.setBigDecimal(2, group.getContributionAmount());
            stmt.setString(3, group.getFrequency());
            stmt.setDate(4, Date.valueOf(group.getStartDate()));
            stmt.setBoolean(5, group.isCompleted());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        }
    }

    // Get all groups
    public List<EqubGroup> findAllGroups() throws SQLException {
        List<EqubGroup> groups = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_GROUPS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                EqubGroup group = new EqubGroup(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getBigDecimal("contribution_amount"),
                    rs.getString("frequency"),
                    rs.getDate("start_date").toLocalDate(),
                    rs.getBoolean("completed")
                );
                // Get member count
                group.setTotalMembers(getMemberCountForGroup(conn, group.getId()));
                groups.add(group);
            }
        }
        return groups;
    }

    // Get group by ID
    public EqubGroup findGroupById(int id) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_GROUP_BY_ID)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    EqubGroup group = new EqubGroup(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getBigDecimal("contribution_amount"),
                        rs.getString("frequency"),
                        rs.getDate("start_date").toLocalDate(),
                        rs.getBoolean("completed")
                    );
                    group.setTotalMembers(getMemberCountForGroup(conn, group.getId()));
                    return group;
                }
            }
        }
        return null;
    }

    // Update group
    public void updateGroup(EqubGroup group) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_GROUP)) {
            
            stmt.setString(1, group.getName());
            stmt.setBigDecimal(2, group.getContributionAmount());
            stmt.setString(3, group.getFrequency());
            stmt.setDate(4, Date.valueOf(group.getStartDate()));
            stmt.setBoolean(5, group.isCompleted());
            stmt.setInt(6, group.getId());
            
            stmt.executeUpdate();
        }
    }

    // Mark group as completed
    public void markGroupCompleted(int groupId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(MARK_GROUP_COMPLETED)) {
            
            stmt.setInt(1, groupId);
            stmt.executeUpdate();
        }
    }

    // Add contribution
    public void addContribution(Contribution contribution) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_CONTRIBUTION)) {
            
            stmt.setInt(1, contribution.getEqubGroupId());
            stmt.setInt(2, contribution.getMemberId());
            stmt.setBigDecimal(3, contribution.getAmount());
            stmt.setDate(4, Date.valueOf(contribution.getPaymentDate()));
            
            stmt.executeUpdate();
        }
    }

    // Get contributions by group
    public List<Contribution> getContributionsByGroup(int groupId) throws SQLException {
        List<Contribution> contributions = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_CONTRIBUTIONS_BY_GROUP)) {
            
            stmt.setInt(1, groupId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Contribution contribution = new Contribution(
                        rs.getInt("id"),
                        rs.getInt("equb_group_id"),
                        rs.getInt("member_id"),
                        rs.getBigDecimal("amount"),
                        rs.getDate("payment_date").toLocalDate()
                    );
                    contribution.setMemberName(rs.getString("member_name"));
                    contributions.add(contribution);
                }
            }
        }
        return contributions;
    }

    // Get all contributions
    public List<Contribution> findAllContributions() throws SQLException {
        List<Contribution> contributions = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_CONTRIBUTIONS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Contribution contribution = new Contribution(
                    rs.getInt("id"),
                    rs.getInt("equb_group_id"),
                    rs.getInt("member_id"),
                    rs.getBigDecimal("amount"),
                    rs.getDate("payment_date").toLocalDate()
                );
                contribution.setMemberName(rs.getString("member_name"));
                contributions.add(contribution);
            }
        }
        return contributions;
    }

    // Generate rotation schedule automatically
    public void generateRotationSchedule(int groupId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Delete existing rotations for this group
                try (PreparedStatement deleteStmt = conn.prepareStatement(DELETE_ROTATIONS_BY_GROUP)) {
                    deleteStmt.setInt(1, groupId);
                    deleteStmt.executeUpdate();
                }

                // Get all members in the group
                List<Integer> memberIds = getMemberIdsInGroup(conn, groupId);
                if (memberIds.isEmpty()) {
                    conn.commit();
                    return;
                }

                // Get group details to calculate rotation dates
                EqubGroup group = findGroupById(groupId);
                if (group == null) {
                    conn.rollback();
                    return;
                }

                // Generate rotations based on frequency
                LocalDate currentDate = group.getStartDate();
                int position = 1;

                try (PreparedStatement insertStmt = conn.prepareStatement(INSERT_ROTATION)) {
                    for (int memberId : memberIds) {
                        insertStmt.setInt(1, groupId);
                        insertStmt.setInt(2, memberId);
                        insertStmt.setInt(3, position);
                        insertStmt.setDate(4, Date.valueOf(currentDate));
                        insertStmt.setBoolean(5, false);
                        insertStmt.executeUpdate();

                        // Calculate next rotation date based on frequency (increment by 1 period)
                        currentDate = calculateNextRotationDate(currentDate, group.getFrequency());
                        position++;
                    }
                }

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    // Calculate next rotation date based on frequency (increment by 1 period)
    private LocalDate calculateNextRotationDate(LocalDate currentDate, String frequency) {
        switch (frequency.toUpperCase()) {
            case "DAILY":
                return currentDate.plusDays(1);
            case "WEEKLY":
                return currentDate.plusWeeks(1);
            case "MONTHLY":
                return currentDate.plusMonths(1);
            default:
                return currentDate.plusMonths(1);
        }
    }

    // Get rotations by group
    public List<Rotation> getRotationsByGroup(int groupId) throws SQLException {
        List<Rotation> rotations = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ROTATIONS_BY_GROUP)) {
            
            stmt.setInt(1, groupId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Rotation rotation = new Rotation(
                        rs.getInt("id"),
                        rs.getInt("equb_group_id"),
                        rs.getInt("member_id"),
                        rs.getInt("position"),
                        rs.getDate("rotation_date").toLocalDate(),
                        rs.getBoolean("completed")
                    );
                    rotation.setMemberName(rs.getString("member_name"));
                    rotations.add(rotation);
                }
            }
        }
        return rotations;
    }

    // Update rotation position (manual adjustment)
    public void updateRotationPosition(int rotationId, int newPosition) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_ROTATION_POSITION)) {
            
            stmt.setInt(1, newPosition);
            stmt.setInt(2, rotationId);
            stmt.executeUpdate();
        }
    }

    // Get member IDs in a group
    private List<Integer> getMemberIdsInGroup(Connection conn, int groupId) throws SQLException {
        List<Integer> memberIds = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(SELECT_MEMBERS_IN_GROUP)) {
            stmt.setInt(1, groupId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    memberIds.add(rs.getInt("member_id"));
                }
            }
        }
        return memberIds;
    }

    // Get member count for a group
    private int getMemberCountForGroup(Connection conn, int groupId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(COUNT_MEMBERS_IN_GROUP)) {
            stmt.setInt(1, groupId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    // Helper method for getting member count (without connection)
    private int getMemberCountForGroup(int groupId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return getMemberCountForGroup(conn, groupId);
        }
    }

    // Add members to group
    public void addMembersToGroup(int groupId, int[] memberIds) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO equb_members (equb_group_id, member_id) VALUES (?, ?)")) {
            
            for (int memberId : memberIds) {
                stmt.setInt(1, groupId);
                stmt.setInt(2, memberId);
                stmt.executeUpdate();
            }
        }
    }

    // Remove member from group
    public void removeMemberFromGroup(int groupId, int memberId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM equb_members WHERE equb_group_id = ? AND member_id = ?")) {
            
            stmt.setInt(1, groupId);
            stmt.setInt(2, memberId);
            stmt.executeUpdate();
        }
    }
}

