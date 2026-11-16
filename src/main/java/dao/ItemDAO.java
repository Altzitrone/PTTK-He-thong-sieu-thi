package dao;

import model.Item6;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    private static final String SELECT_ITEM = "SELECT id, itemName, price, stockQuantity, description FROM tblItem6";

    /** Tìm theo chuỗi con nguyên văn, kể cả khi từ khóa chứa ký tự đặc biệt. */
    public List<Item6> searchItemByName(String keyword) throws SQLException {
        String sql = SELECT_ITEM + " WHERE LOCATE(?, itemName) > 0 ORDER BY itemName, id";
        List<Item6> items = new ArrayList<>();
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, keyword);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    items.add(readItem(rows));
                }
            }
        }
        return items;
    }

    /** Trả về mặt hàng theo mã hoặc null nếu mã không tồn tại. */
    public Item6 getItemById(int id) throws SQLException {
        try (Connection connection = DBConnection.getInstance().getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ITEM + " WHERE id = ?")) {
            statement.setInt(1, id);
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? readItem(rows) : null;
            }
        }
    }

    private Item6 readItem(ResultSet row) throws SQLException {
        return new Item6(row.getInt("id"), row.getString("itemName"), row.getBigDecimal("price"),
                row.getInt("stockQuantity"), row.getString("description"));
    }
}
