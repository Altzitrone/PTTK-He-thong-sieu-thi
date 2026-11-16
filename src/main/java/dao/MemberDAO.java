package dao;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.sql.*;
import java.util.HexFormat;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class MemberDAO {
    private static final HexFormat HEX = HexFormat.of();
    // Dùng phép kiểm tra có chi phí tương đương khi tên đăng nhập không tồn tại.
    private static final String DUMMY_HASH = "00".repeat(16) + ":" + "00".repeat(32);

    public record Account(int id, String fullName, String role) {
    }

    /** Xác thực tài khoản khách hàng hoặc nhân viên kho bằng PBKDF2. */
    public Account authenticate(String username, char[] password) throws SQLException {
        String sql = """
                SELECT m.id, m.fullName, m.role, m.passwordHash
                FROM tblMember6 m
                LEFT JOIN tblCustomer6 c ON c.id = m.id
                LEFT JOIN tblWarehouseStaff6 w ON w.id = m.id
                WHERE m.username = ?
                  AND ((m.role = 'CUSTOMER' AND c.id IS NOT NULL)
                    OR (m.role = 'WAREHOUSE' AND w.id IS NOT NULL))
                """;
        Account account = null;
        String passwordHash = DUMMY_HASH;
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet rows = statement.executeQuery()) {
                if (rows.next()) {
                    account = new Account(rows.getInt("id"), rows.getString("fullName"), rows.getString("role"));
                    passwordHash = rows.getString("passwordHash");
                }
            }
        }
        return matches(password, passwordHash) ? account : null;
    }

    private boolean matches(char[] password, String encoded) throws SQLException {
        String[] parts = encoded.split(":", -1);
        if (parts.length != 2 || parts[0].length() != 32 || parts[1].length() != 64) {
            return false;
        }
        PBEKeySpec spec = null;
        try {
            spec = new PBEKeySpec(password, HEX.parseHex(parts[0]), 600_000, 256);
            byte[] actual = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return MessageDigest.isEqual(actual, HEX.parseHex(parts[1]));
        } catch (IllegalArgumentException e) {
            return false;
        } catch (GeneralSecurityException e) {
            throw new SQLException("Không thể xác thực mật khẩu.", e);
        } finally {
            if (spec != null) {
                spec.clearPassword();
            }
        }
    }
}
