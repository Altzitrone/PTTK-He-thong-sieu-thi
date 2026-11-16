package dao;

import model.Invoice6;
import model.OnlineOrder6;

import java.sql.*;

public class InvoiceDAO {
    /** Chuẩn bị chứng từ của đơn đã xuất. In lại giữ nguyên mã và ngày in đầu tiên. */
    public boolean createInvoice(Invoice6 invoice) throws SQLException {
        // ID và người giao lấy từ CSDL. Không tạo chứng từ ngoài giao dịch xác nhận xuất.
        String sql = """
                UPDATE tblInvoice6 i
                JOIN tblOnlineOrder6 o ON o.id = i.onlineOrderId
                SET i.printDate = COALESCE(i.printDate, CURRENT_TIMESTAMP)
                WHERE i.id = ? AND i.onlineOrderId = ? AND i.deliveryStaffId = ? AND o.status IN (?, ?)
                """;
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, invoice.getId());
            statement.setInt(2, invoice.getOnlineOrder().getId());
            statement.setInt(3, invoice.getDeliveryStaff().getId());
            statement.setString(4, OnlineOrder6.EXPORTED);
            statement.setString(5, OnlineOrder6.DELIVERED);
            // Một số cấu hình JDBC trả 0 nếu ngày in đã có và dữ liệu không đổi.
            if (statement.executeUpdate() == 1) {
                return true;
            }
        }
        Invoice6 saved = getByOrderId(invoice.getOnlineOrder());
        return saved != null && saved.getId() == invoice.getId() && saved.getPrintDate() != null;
    }

    /** Chỉ gọi từ giao dịch xác nhận xuất để bảo đảm tính nhất quán với đơn và người giao. */
    void createInvoice(Connection connection, Invoice6 invoice) throws SQLException {
        String sql = "INSERT INTO tblInvoice6 (paymentDetail, onlineOrderId, deliveryStaffId) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, invoice.getPaymentDetail());
            statement.setInt(2, invoice.getOnlineOrder().getId());
            statement.setInt(3, invoice.getDeliveryStaff().getId());
            statement.executeUpdate();
        }
    }

    /** Đọc hóa đơn đã lưu và gắn với đơn cùng các dòng hàng dùng để trình bày. */
    public Invoice6 getByOrderId(OnlineOrder6 order) throws SQLException {
        String sql = "SELECT id, printDate, paymentDetail FROM tblInvoice6 WHERE onlineOrderId = ?";
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, order.getId());
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) {
                    return null;
                }
                Timestamp printed = rows.getTimestamp("printDate");
                return new Invoice6(rows.getInt("id"), printed == null ? null : printed.toLocalDateTime(),
                        rows.getString("paymentDetail"), order, order.getDeliveryStaff());
            }
        }
    }
}
