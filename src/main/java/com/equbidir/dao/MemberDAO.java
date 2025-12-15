package com.equbidir.dao;

import com.equbidir.model.Member;
import com.equbidir.model.EqubMemberInfo;
import com.equbidir.model.EqubMembership;
import com.equbidir.model.IdirMembership;
import com.equbidir.model.ContributionRecord;
import com.equbidir.util.DatabaseConnection;
import com.equbidir.util.SecurityUtil;
import com.equbidir.model.IdirMemberInfo;
import com.equbidir.model.Contribution;

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

    public List<Member> getAdmins() throws SQLException {
        List<Member> admins = new ArrayList<>();
        String sql = "SELECT member_id, full_name, phone, address, role FROM members WHERE LOWER(role)='admin' ORDER BY full_name ASC";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                admins.add(new Member(
                        rs.getInt("member_id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("role")
                ));
            }
        }

        return admins;
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

    public Member getMemberById(int memberId) throws SQLException {
        String sql = "SELECT member_id, full_name, phone, address, role FROM members WHERE member_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
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

    public int countRegularMembers(String search) throws SQLException {
        boolean hasSearch = search != null && !search.trim().isEmpty();
        String base = "SELECT COUNT(*) FROM members WHERE (role IS NULL OR LOWER(role) <> 'admin')";
        String sql = hasSearch ? base + " AND (LOWER(full_name) LIKE ? OR LOWER(phone) LIKE ?)" : base;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (hasSearch) {
                String s = "%" + search.trim().toLowerCase() + "%";
                ps.setString(1, s);
                ps.setString(2, s);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<Member> getRegularMembers(String search, int offset, int limit) throws SQLException {
        List<Member> members = new ArrayList<>();

        boolean hasSearch = search != null && !search.trim().isEmpty();
        String base = "SELECT member_id, full_name, phone, address, role FROM members WHERE (role IS NULL OR LOWER(role) <> 'admin')";
        String orderLimit = " ORDER BY full_name ASC LIMIT ? OFFSET ?";
        String sql = hasSearch
                ? base + " AND (LOWER(full_name) LIKE ? OR LOWER(phone) LIKE ?)" + orderLimit
                : base + orderLimit;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = 1;
            if (hasSearch) {
                String s = "%" + search.trim().toLowerCase() + "%";
                ps.setString(idx++, s);
                ps.setString(idx++, s);
            }
            ps.setInt(idx++, limit);
            ps.setInt(idx, offset);

            try (ResultSet rs = ps.executeQuery()) {
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
        }
        return members;
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

    public List<EqubMembership> getEqubMemberships(int memberId) throws SQLException {
        List<EqubMembership> out = new ArrayList<>();

        String sql = "SELECT eg.equb_id, eg.equb_name, eg.amount, eg.frequency, em.payment_status, em.rotation_position " +
                "FROM equb_members em JOIN equb_groups eg ON em.equb_id = eg.equb_id " +
                "WHERE em.member_id = ? " +
                "ORDER BY eg.equb_name ASC";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Integer rotationPos = rs.getObject("rotation_position") != null
                            ? rs.getInt("rotation_position")
                            : null;

                    out.add(new EqubMembership(
                            rs.getInt("equb_id"),
                            rs.getString("equb_name"),
                            rs.getDouble("amount"),
                            rs.getString("frequency"),
                            rs.getString("payment_status"),
                            rotationPos
                    ));
                }
            }
        }

        return out;
    }

    public List<IdirMembership> getIdirMemberships(int memberId) throws SQLException {
        List<IdirMembership> out = new ArrayList<>();

        String sql = "SELECT ig.idir_id, ig.idir_name, ig.monthly_payment, im.payment_status " +
                "FROM idir_members im JOIN idir_groups ig ON im.idir_id = ig.idir_id " +
                "WHERE im.member_id = ? " +
                "ORDER BY ig.idir_name ASC";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new IdirMembership(
                            rs.getInt("idir_id"),
                            rs.getString("idir_name"),
                            rs.getDouble("monthly_payment"),
                            rs.getString("payment_status")
                    ));
                }
            }
        }

        return out;
    }

    public List<ContributionRecord> getContributionHistory(int memberId, int limit) throws SQLException {
        List<ContributionRecord> out = new ArrayList<>();

        String sql = "SELECT * FROM (" +
                "  SELECT 'equb' AS type, eg.equb_name AS group_name, ep.amount AS amount, ep.created_at AS paid_at " +
                "  FROM equb_payments ep JOIN equb_groups eg ON ep.equb_id = eg.equb_id " +
                "  WHERE ep.member_id = ? " +
                "  UNION ALL " +
                "  SELECT 'idir' AS type, ig.idir_name AS group_name, ip.amount AS amount, ip.created_at AS paid_at " +
                "  FROM idir_payments ip JOIN idir_groups ig ON ip.idir_id = ig.idir_id " +
                "  WHERE ip.member_id = ? " +
                ") t ORDER BY t.paid_at DESC LIMIT ?";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            ps.setInt(2, memberId);
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(new ContributionRecord(
                            rs.getString("type"),
                            rs.getString("group_name"),
                            rs.getDouble("amount"),
                            rs.getTimestamp("paid_at")
                    ));
                }
            }
        }

        return out;
    }

    /**
     * Backwards-compatible helper: returns details for the first Equb the member belongs to.
     */
    public EqubMemberInfo getMemberEqubInfo(int memberId) throws SQLException {
        List<EqubMembership> memberships = getEqubMemberships(memberId);
        if (memberships.isEmpty()) {
            return null;
        }
        return getMemberEqubInfo(memberId, memberships.get(0).getEqubId());
    }

    public EqubMemberInfo getMemberEqubInfo(int memberId, int equbId) throws SQLException {
        String sql = """
            SELECT
                eg.equb_id,
                eg.equb_name,
                eg.amount,
                eg.frequency,
                em.rotation_position,
                em.payment_status,
                (SELECT COUNT(*) FROM equb_members em2 WHERE em2.equb_id = eg.equb_id) AS total_members
            FROM equb_members em
            JOIN equb_groups eg ON em.equb_id = eg.equb_id
            WHERE em.member_id = ? AND eg.equb_id = ?
            """;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            ps.setInt(2, equbId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Integer rotationPos = rs.getObject("rotation_position") != null
                            ? rs.getInt("rotation_position")
                            : null;

                    return new EqubMemberInfo(
                            rs.getInt("equb_id"),
                            rs.getString("equb_name"),
                            rs.getDouble("amount"),
                            rs.getString("frequency"),
                            rotationPos,
                            rs.getString("payment_status"),
                            rs.getInt("total_members")
                    );
                }
            }
        }
        return null;
    }

    public IdirMemberInfo getMemberIdirInfo(int memberId) throws SQLException {
        String sql = """
            SELECT 
                ig.idir_id,
                ig.idir_name,
                ig.monthly_payment,
                im.payment_status,
                (COUNT(CASE WHEN im2.payment_status = 'paid' THEN 1 END) * ig.monthly_payment) AS fund_balance,
                (SELECT COUNT(*) FROM idir_members im2 WHERE im2.idir_id = ig.idir_id) AS total_members
            FROM idir_members im
            JOIN idir_groups ig ON im.idir_id = ig.idir_id
            LEFT JOIN idir_members im2 ON im2.idir_id = ig.idir_id
            WHERE im.member_id = ?
            GROUP BY ig.idir_id, ig.idir_name, ig.monthly_payment, im.payment_status
            """;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new IdirMemberInfo(
                            rs.getInt("idir_id"),
                            rs.getString("idir_name"),
                            rs.getDouble("monthly_payment"),
                            rs.getString("payment_status"),
                            rs.getDouble("fund_balance"),
                            rs.getInt("total_members")
                    );
                }
            }
        }
        return null;
    }

    public List<Contribution> getMemberContributionHistory(int memberId) throws SQLException {
        List<Contribution> contributions = new ArrayList<>();
        String sql = """
            SELECT 'Equb' AS type, eg.equb_name AS group_name, eg.amount, em.payment_status AS status
            FROM equb_members em
            JOIN equb_groups eg ON em.equb_id = eg.equb_id
            WHERE em.member_id = ?
            
            UNION ALL
            
            SELECT 'Idir' AS type, ig.idir_name AS group_name, ig.monthly_payment, im.payment_status AS status
            FROM idir_members im
            JOIN idir_groups ig ON im.idir_id = ig.idir_id
            WHERE im.member_id = ?
            ORDER BY group_name
            """;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            ps.setInt(2, memberId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    contributions.add(new Contribution(
                            null,
                            rs.getString("group_name"),
                            rs.getString("type"),
                            rs.getDouble("amount"),
                            rs.getString("status")
                    ));
                }
            }
        }
        return contributions;
    }
}
