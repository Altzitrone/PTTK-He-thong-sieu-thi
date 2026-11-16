package dao;

import model.DeliveryStaff6;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeliveryStaffDAO {
    /** Danh sách người giao đang rảnh tại thời điểm mở biểu mẫu. */
    public List<DeliveryStaff6> getAvailableStaff() throws SQLException {
        String sql = """
                SELECT d.id, m.fullName, m.phoneNumber, s.workShift, d.workStatus
                FROM tblDeliveryStaff6 d
                JOIN tblStaff6 s ON s.id = d.id
                JOIN tblMember6 m ON m.id = s.id
                WHERE d.workStatus = ?
                ORDER BY m.fullName, d.id
                """;
        List<DeliveryStaff6> staff = new ArrayList<>();
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, DeliveryStaff6.AVAILABLE);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    staff.add(new DeliveryStaff6(rows.getInt("id"), rows.getString("fullName"),
                            rows.getString("phoneNumber"), rows.getString("workShift"), rows.getString("workStatus")));
                }
            }
        }
        return staff;
    }

    /** Đổi trạng thái nếu người giao vẫn rảnh, trên kết nối giao dịch của thao tác xuất. */
    boolean assignIfAvailable(Connection connection, int deliveryStaffId) throws SQLException {
        String sql = "UPDATE tblDeliveryStaff6 SET workStatus = ? WHERE id = ? AND workStatus = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, DeliveryStaff6.BUSY);
            statement.setInt(2, deliveryStaffId);
            statement.setString(3, DeliveryStaff6.AVAILABLE);
            return statement.executeUpdate() == 1;
        }
    }
}
