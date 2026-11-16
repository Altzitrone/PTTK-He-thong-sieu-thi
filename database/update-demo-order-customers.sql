USE supermarket6;
SET NAMES utf8mb4;

START TRANSACTION;

INSERT INTO tblMember6 (username, passwordHash, fullName, role)
SELECT CONCAT('mau_khach_don_', demo.orderId), CONCAT(HEX(RANDOM_BYTES(16)), ':', HEX(RANDOM_BYTES(32))),
       demo.fullName, 'CUSTOMER'
FROM (VALUES
    ROW(3, 'Trần Minh Khôi'),
    ROW(4, 'Lê Thị Thu Hà'),
    ROW(5, 'Phạm Gia Huy'),
    ROW(6, 'Vũ Ngọc Mai'),
    ROW(7, 'Đỗ Hoàng Nam'),
    ROW(8, 'Bùi Thanh Thảo'),
    ROW(9, 'Hoàng Đức Anh'),
    ROW(10, 'Đặng Minh Châu'),
    ROW(11, 'Phan Quang Hưng'),
    ROW(12, 'Võ Khánh Linh')
) AS demo(orderId, fullName)
JOIN tblOnlineOrder6 AS orders ON orders.id = demo.orderId
WHERE NOT EXISTS (
    SELECT 1 FROM tblMember6 AS m WHERE m.username = CONCAT('mau_khach_don_', demo.orderId)
);

INSERT INTO tblCustomer6 (id)
SELECT m.id
FROM tblOnlineOrder6 AS orders
JOIN tblMember6 AS m ON m.username = CONCAT('mau_khach_don_', orders.id)
WHERE orders.id BETWEEN 3 AND 12
  AND NOT EXISTS (SELECT 1 FROM tblCustomer6 AS customer WHERE customer.id = m.id);

UPDATE tblOnlineOrder6 AS orders
JOIN tblMember6 AS customer ON customer.username = CONCAT('mau_khach_don_', orders.id)
JOIN tblMember6 AS original ON original.id = orders.customerId AND original.username = 'khachhang'
SET orders.customerId = customer.id
WHERE orders.id BETWEEN 3 AND 12;

COMMIT;

SELECT orders.id AS order_id, customer.fullName AS customer_name
FROM tblOnlineOrder6 AS orders
JOIN tblMember6 AS customer ON customer.id = orders.customerId
WHERE orders.id BETWEEN 3 AND 12
ORDER BY orders.id;
