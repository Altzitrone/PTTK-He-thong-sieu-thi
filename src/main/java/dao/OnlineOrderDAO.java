package dao;

import model.Customer6;
import model.DeliveryStaff6;
import model.Invoice6;
import model.Item6;
import model.OnlineOrder6;
import model.OrderDetail6;
import model.Staff6;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OnlineOrderDAO {
    private static final String SELECT_ORDER = """
            SELECT o.id, o.orderDate, o.totalAmount, o.status, o.deliveryAddress,
                   o.customerId, c.fullName AS customerName, c.phoneNumber AS customerPhone,
                   o.warehouseStaffId, w.fullName AS warehouseName,
                   i.deliveryStaffId, m.fullName AS deliveryName, m.phoneNumber AS deliveryPhone,
                   d.workStatus, s.workShift
            FROM tblOnlineOrder6 o
            JOIN tblMember6 c ON c.id = o.customerId
            LEFT JOIN tblMember6 w ON w.id = o.warehouseStaffId
            LEFT JOIN tblInvoice6 i ON i.onlineOrderId = o.id
            LEFT JOIN tblDeliveryStaff6 d ON d.id = i.deliveryStaffId
            LEFT JOIN tblStaff6 s ON s.id = d.id
            LEFT JOIN tblMember6 m ON m.id = d.id
            """;
    private final DeliveryStaffDAO deliveryStaffDAO = new DeliveryStaffDAO();
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    /** Tải phần đầu đơn theo trạng thái. Chi tiết chỉ được tải khi mở từng đơn. */
    public List<OnlineOrder6> getOrdersByStatus(String status) throws SQLException {
        String sql = SELECT_ORDER + (status == null ? "" : " WHERE o.status = ?")
                + " ORDER BY o.orderDate DESC, o.id DESC";
        List<OnlineOrder6> orders = new ArrayList<>();
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            if (status != null) {
                statement.setString(1, status);
            }
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    orders.add(readOrder(rows));
                }
            }
        }
        return orders;
    }

    /** Tải đơn, khách hàng, nhân viên liên quan và từng dòng hàng. */
    public OnlineOrder6 getOrderById(int id) throws SQLException {
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ORDER + " WHERE o.id = ?")) {
            statement.setInt(1, id);
            OnlineOrder6 order;
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) {
                    return null;
                }
                order = readOrder(rows);
            }
            order.setDetails(readDetails(connection, id));
            return order;
        }
    }

    /** Xuất đơn với mã người giao khi đơn đã có sẵn nhân viên kho phụ trách. */
    public boolean updateOrderStatus(int orderId, int staffId, String status) throws SQLException {
        return updateOrderStatus(orderId, staffId, status, null);
    }

    /** Xác nhận xuất với mã nhân viên kho lấy từ phiên đăng nhập. */
    public boolean updateOrderStatus(int orderId, int staffId, String status, Integer warehouseStaffId)
            throws SQLException {
        if (!OnlineOrder6.EXPORTED.equals(status)) {
            throw new IllegalArgumentException("Chỉ hỗ trợ chuyển đơn sang trạng thái Đã xuất.");
        }
        try (Connection connection = DBConnection.getInstance().getConnection()) {
            connection.setAutoCommit(false);
            try {
                if (!markExported(connection, orderId, warehouseStaffId)
                        || !deliveryStaffDAO.assignIfAvailable(connection, staffId)) {
                    connection.rollback();
                    return false;
                }
                // Ba thay đổi cùng commit: trạng thái đơn, phân công, hóa đơn.
                OnlineOrder6 order = new OnlineOrder6();
                order.setId(orderId);
                DeliveryStaff6 courier = new DeliveryStaff6();
                courier.setId(staffId);
                Invoice6 invoice = new Invoice6(0, null, "Chứng từ bàn giao hàng", order, courier);
                invoiceDAO.createInvoice(connection, invoice);
                connection.commit();
                return true;
            } catch (SQLException | RuntimeException failure) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackFailure) {
                    failure.addSuppressed(rollbackFailure);
                }
                throw failure;
            }
        }
    }

    /** Xác nhận bàn giao và trả người giao về trạng thái rảnh nếu đã hết đơn đang giao. */
    public boolean completeDelivery(int orderId) throws SQLException {
        String completeOrder = """
                UPDATE tblOnlineOrder6 SET status = ?
                WHERE id = ? AND status = ?
                  AND EXISTS (SELECT 1 FROM tblInvoice6 WHERE onlineOrderId = ?)
                """;
        String releaseCourier = """
                UPDATE tblDeliveryStaff6 AS staff
                JOIN tblInvoice6 AS invoice ON invoice.deliveryStaffId = staff.id
                SET staff.workStatus = ?
                WHERE invoice.onlineOrderId = ? AND staff.workStatus = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM tblInvoice6 AS activeInvoice
                      JOIN tblOnlineOrder6 AS activeOrder ON activeOrder.id = activeInvoice.onlineOrderId
                      WHERE activeInvoice.deliveryStaffId = staff.id AND activeOrder.status = ?
                  )
                """;
        try (Connection connection = DBConnection.getInstance().getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement complete = connection.prepareStatement(completeOrder);
                 PreparedStatement release = connection.prepareStatement(releaseCourier)) {
                complete.setString(1, OnlineOrder6.DELIVERED);
                complete.setInt(2, orderId);
                complete.setString(3, OnlineOrder6.EXPORTED);
                complete.setInt(4, orderId);
                if (complete.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
                release.setString(1, DeliveryStaff6.AVAILABLE);
                release.setInt(2, orderId);
                release.setString(3, DeliveryStaff6.BUSY);
                release.setString(4, OnlineOrder6.EXPORTED);
                release.executeUpdate();
                connection.commit();
                return true;
            } catch (SQLException failure) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackFailure) {
                    failure.addSuppressed(rollbackFailure);
                }
                throw failure;
            }
        }
    }

    private boolean markExported(Connection connection, int orderId, Integer warehouseStaffId) throws SQLException {
        String sql = """
                UPDATE tblOnlineOrder6
                SET status = ?, warehouseStaffId = COALESCE(?, warehouseStaffId)
                WHERE id = ? AND status = ? AND COALESCE(?, warehouseStaffId) IS NOT NULL
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, OnlineOrder6.EXPORTED);
            statement.setObject(2, warehouseStaffId, Types.INTEGER);
            statement.setInt(3, orderId);
            statement.setString(4, OnlineOrder6.UNEXPORTED);
            statement.setObject(5, warehouseStaffId, Types.INTEGER);
            return statement.executeUpdate() == 1;
        }
    }

    private OnlineOrder6 readOrder(ResultSet row) throws SQLException {
        Customer6 customer = new Customer6(row.getInt("customerId"), row.getString("customerName"),
                row.getString("customerPhone"));
        Integer warehouseId = row.getObject("warehouseStaffId", Integer.class);
        Staff6 warehouseStaff = warehouseId == null ? null
                : new Staff6(warehouseId, row.getString("warehouseName"), null, null);
        Integer deliveryId = row.getObject("deliveryStaffId", Integer.class);
        DeliveryStaff6 courier = deliveryId == null ? null
                : new DeliveryStaff6(deliveryId, row.getString("deliveryName"), row.getString("deliveryPhone"),
                        row.getString("workShift"), row.getString("workStatus"));
        return new OnlineOrder6(row.getInt("id"), row.getTimestamp("orderDate").toLocalDateTime(),
                row.getBigDecimal("totalAmount"), row.getString("status"), row.getString("deliveryAddress"),
                customer, warehouseStaff, courier, List.of());
    }

    private List<OrderDetail6> readDetails(Connection connection, int orderId) throws SQLException {
        String sql = """
                SELECT d.id, d.quantity, d.unitPrice, i.id AS itemId, i.itemName,
                       i.price, i.stockQuantity, i.description
                FROM tblOrderDetail6 d
                JOIN tblItem6 i ON i.id = d.itemId
                WHERE d.onlineOrderId = ?
                ORDER BY d.id
                """;
        List<OrderDetail6> details = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, orderId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    Item6 item = new Item6(rows.getInt("itemId"), rows.getString("itemName"),
                            rows.getBigDecimal("price"), rows.getInt("stockQuantity"), rows.getString("description"));
                    details.add(new OrderDetail6(rows.getInt("id"), item, rows.getInt("quantity"),
                            rows.getBigDecimal("unitPrice")));
                }
            }
        }
        return details;
    }
}
