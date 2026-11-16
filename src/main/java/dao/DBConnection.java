package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Singleton giữ cấu hình JDBC. Mỗi thao tác lấy một kết nối riêng. */
public final class DBConnection {
    private static final DBConnection INSTANCE = new DBConnection();

    private DBConnection() {
    }

    public static DBConnection getInstance() {
        return INSTANCE;
    }

    public Connection getConnection() throws SQLException {
        String url = System.getenv().getOrDefault("SUPERMARKET_DB_URL", "jdbc:mysql://localhost:3306/supermarket6");
        String user = System.getenv().getOrDefault("SUPERMARKET_DB_USER", "supermarket_app");
        String password = System.getenv().getOrDefault("SUPERMARKET_DB_PASSWORD", "");
        try {
            // Tomcat có thể khởi tạo DriverManager trước khi nạp JDBC driver trong WAR.
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy MySQL Connector/J.", e);
        }
        return DriverManager.getConnection(url, user, password);
    }
}
