-- Khởi tạo MySQL 8.x và dữ liệu demo. Có thể chạy lại mà không đặt lại dữ liệu.
CREATE DATABASE IF NOT EXISTS supermarket6 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE supermarket6;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS tblMember6 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(80) NOT NULL UNIQUE,
    passwordHash VARCHAR(200) NOT NULL,
    fullName VARCHAR(150) NOT NULL,
    phoneNumber VARCHAR(24),
    role VARCHAR(24) NOT NULL,
    CHECK (role IN ('CUSTOMER', 'WAREHOUSE', 'DELIVERY'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblCustomer6 (
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES tblMember6(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblStaff6 (
    id INT PRIMARY KEY,
    workShift VARCHAR(50),
    FOREIGN KEY (id) REFERENCES tblMember6(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblWarehouseStaff6 (
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES tblStaff6(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblDeliveryStaff6 (
    id INT PRIMARY KEY,
    workStatus VARCHAR(24) NOT NULL,
    CHECK (workStatus IN ('Đang rảnh', 'Đang giao')),
    FOREIGN KEY (id) REFERENCES tblStaff6(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblItem6 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    itemName VARCHAR(160) NOT NULL,
    price DECIMAL(15,2) NOT NULL CHECK (price >= 0),
    stockQuantity INT NOT NULL CHECK (stockQuantity >= 0),
    description TEXT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblOnlineOrder6 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    orderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    totalAmount DECIMAL(15,2) NOT NULL CHECK (totalAmount >= 0),
    status VARCHAR(24) NOT NULL DEFAULT 'Chưa xuất',
    deliveryAddress VARCHAR(255) NOT NULL,
    customerId INT NOT NULL,
    warehouseStaffId INT,
    CONSTRAINT chk_online_order_delivery_status CHECK (
        status = 'Chưa xuất'
        OR (status IN ('Đã xuất', 'Đã giao') AND warehouseStaffId IS NOT NULL)
    ),
    FOREIGN KEY (customerId) REFERENCES tblCustomer6(id),
    FOREIGN KEY (warehouseStaffId) REFERENCES tblWarehouseStaff6(id),
    INDEX idx_order_status_date (status, orderDate, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblOrderDetail6 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    onlineOrderId INT NOT NULL,
    itemId INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unitPrice DECIMAL(15,2) NOT NULL CHECK (unitPrice >= 0),
    FOREIGN KEY (onlineOrderId) REFERENCES tblOnlineOrder6(id),
    FOREIGN KEY (itemId) REFERENCES tblItem6(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblInvoice6 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    printDate DATETIME,
    paymentDetail VARCHAR(255) NOT NULL,
    onlineOrderId INT NOT NULL UNIQUE,
    deliveryStaffId INT NOT NULL,
    FOREIGN KEY (onlineOrderId) REFERENCES tblOnlineOrder6(id),
    FOREIGN KEY (deliveryStaffId) REFERENCES tblDeliveryStaff6(id)
) ENGINE=InnoDB;

-- Mật khẩu mẫu cho khách hàng và nhân viên kho: Demo1234!
INSERT INTO tblMember6 (id, username, passwordHash, fullName, phoneNumber, role) VALUES
    (1, 'khachhang', '9ff8830d234fdfded64c300b846910d8:61897c7b5d5c336c7cfd717675b24a00f84c1c15e8373ba0db6c0205c5fc8045', 'Nguyễn Văn An', '0900000001', 'CUSTOMER'),
    (2, 'nhanvienkho', '3077d648682deaa1851541899fc9e19b:b6a60ac520d2430d56784d66b59f93d5dee0ce4fd9175feac40212c939f340e1', 'Phạm Văn Dũng', '0900000002', 'WAREHOUSE'),
    (3, 'giaohang1', '69918bf56ca16019075151f633a7cd7e:8f8e727a9a5dfa2107fc60599aa9d4b20d14ef298f80bddd7175da4fae0dfd1d', 'Lê Văn Anh', '0900000003', 'DELIVERY'),
    (4, 'giaohang2', '48e849718a76d4d6bda83f0af65e78d3:5e9bc68ebb9b4466b63d392a54d46a3249c618ab04eac845075fa5f4dc742621', 'Trần Thị Bình', '0900000004', 'DELIVERY')
ON DUPLICATE KEY UPDATE id = tblMember6.id;

INSERT INTO tblCustomer6 (id) VALUES (1) ON DUPLICATE KEY UPDATE id = tblCustomer6.id;
INSERT INTO tblStaff6 (id, workShift) VALUES (2, 'Ca sáng'), (3, 'Ca sáng'), (4, 'Ca chiều')
ON DUPLICATE KEY UPDATE id = tblStaff6.id;
INSERT INTO tblWarehouseStaff6 (id) VALUES (2) ON DUPLICATE KEY UPDATE id = tblWarehouseStaff6.id;
INSERT INTO tblDeliveryStaff6 (id, workStatus) VALUES (3, 'Đang rảnh'), (4, 'Đang rảnh')
ON DUPLICATE KEY UPDATE id = tblDeliveryStaff6.id;

INSERT INTO tblItem6 (id, itemName, price, stockQuantity, description) VALUES
    (1, 'Sữa tươi tiệt trùng 1L', 32000, 50, 'Sữa tươi tiệt trùng, hộp 1 lít.'),
    (2, 'Gạo thơm ST25 5kg', 175000, 75, 'Gạo thơm đóng túi 5 kg.'),
    (3, 'Nước khoáng 500ml', 5000, 120, 'Nước khoáng đóng chai 500 ml.'),
    (4, 'Sữa chua có đường', 8000, 65, 'Sữa chua có đường, hộp 100 g.')
ON DUPLICATE KEY UPDATE id = tblItem6.id;

INSERT INTO tblOnlineOrder6 (id, totalAmount, deliveryAddress, customerId) VALUES
    (1, 382000, '96 Nguyễn Trãi, Hà Nội', 1),
    (2, 25000, '10 Trần Phú, Hà Nội', 1)
ON DUPLICATE KEY UPDATE id = tblOnlineOrder6.id;

INSERT INTO tblOrderDetail6 (id, onlineOrderId, itemId, quantity, unitPrice) VALUES
    (1, 1, 1, 1, 32000), (2, 1, 2, 2, 175000), (3, 2, 3, 5, 5000)
ON DUPLICATE KEY UPDATE id = tblOrderDetail6.id;
