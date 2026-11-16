USE supermarket6;
SET NAMES utf8mb4;
START TRANSACTION;

INSERT INTO tblItem6 (itemName, price, stockQuantity, description)
SELECT catalog.itemName, catalog.price, 0, catalog.description
FROM (VALUES
    ROW('Mì tôm Hảo Hảo Tôm Chua Cay (gói 75g)', 4500, 'Nhãn hàng: Acecook. Đơn vị: Gói.'),
    ROW('Mì khoai tây Omachi Xốt Bò Hầm (gói 80g)', 8500, 'Nhãn hàng: Masan. Đơn vị: Gói.'),
    ROW('Phở bò ăn liền Cung Đình (gói 68g)', 9000, 'Nhãn hàng: Micoem. Đơn vị: Gói.'),
    ROW('Miến Phú Hương sườn heo (gói 58g)', 10500, 'Nhãn hàng: Acecook. Đơn vị: Gói.'),
    ROW('Gạo ST25 thượng hạng (túi 5kg)', 185000, 'Nhãn hàng: A An. Đơn vị: Túi.'),
    ROW('Dầu ăn thực vật Tường An Cooking Oil (1L)', 48000, 'Nhãn hàng: Tường An. Đơn vị: Chai.'),
    ROW('Dầu đậu nành Simply nguyên chất (1L)', 56000, 'Nhãn hàng: Calofic. Đơn vị: Chai.'),
    ROW('Nước mắm Nam Ngư Đệ Nhị (chai 900ml)', 28000, 'Nhãn hàng: Masan. Đơn vị: Chai.'),
    ROW('Nước tương Tam Thái Tử Nhất Ca (chai 500ml)', 14000, 'Nhãn hàng: Masan. Đơn vị: Chai.'),
    ROW('Tương ớt Chin-su (chai 250g)', 15000, 'Nhãn hàng: Masan. Đơn vị: Chai.'),
    ROW('Hạt nêm Knorr thịt thăn xương ống (gói 400g)', 36000, 'Nhãn hàng: Unilever. Đơn vị: Gói.'),
    ROW('Đường tinh luyện Biên Hòa (túi 1kg)', 29000, 'Nhãn hàng: TTC AgriS. Đơn vị: Túi.'),
    ROW('Sữa tươi tiệt trùng có đường (lốc 4 hộp x 180ml)', 32000, 'Nhãn hàng: Vinamilk. Đơn vị: Lốc.'),
    ROW('Sữa tươi tiệt trùng ít đường TH true MILK (lốc 4x180ml)', 36000, 'Nhãn hàng: TH. Đơn vị: Lốc.'),
    ROW('Sữa đặc có đường Ông Thọ đỏ (lon 380g)', 25000, 'Nhãn hàng: Vinamilk. Đơn vị: Lon.'),
    ROW('Sữa đậu nành Fami nguyên chất (lốc 6 hộp x 200ml)', 27000, 'Nhãn hàng: Vinasoy. Đơn vị: Lốc.'),
    ROW('Nước giải khát Coca-Cola (lon 320ml)', 10000, 'Nhãn hàng: Coca-Cola. Đơn vị: Lon.'),
    ROW('Nước giải khát Pepsi (chai 1.5L)', 21000, 'Nhãn hàng: Suntory PepsiCo. Đơn vị: Chai.'),
    ROW('Trà xanh Không Độ vị chanh (chai 455ml)', 10000, 'Nhãn hàng: Tân Hiệp Phát. Đơn vị: Chai.'),
    ROW('Nước tăng lực Red Bull (lon 250ml)', 13000, 'Nhãn hàng: TCP. Đơn vị: Lon.'),
    ROW('Nước tăng lực Sting dâu (chai 330ml)', 11000, 'Nhãn hàng: Suntory PepsiCo. Đơn vị: Chai.'),
    ROW('Nước khoáng thiên nhiên La Vie (chai 500ml)', 5000, 'Nhãn hàng: Nestlé. Đơn vị: Chai.'),
    ROW('Cà phê hòa tan G7 3in1 (hộp 18 gói)', 54000, 'Nhãn hàng: Trung Nguyên. Đơn vị: Hộp.'),
    ROW('Bia Tiger Crystal (lon 330ml)', 18000, 'Nhãn hàng: Heineken. Đơn vị: Lon.'),
    ROW('Bánh Choco-Pie Orion (hộp 12 cái)', 55000, 'Nhãn hàng: Orion. Đơn vị: Hộp.'),
    ROW('Bánh quy bơ Danisa (hộp thiếc 454g)', 135000, 'Nhãn hàng: Mayora. Đơn vị: Hộp.'),
    ROW('Bánh quy kem Oreo Vani (gói 119.6g)', 16000, 'Nhãn hàng: Mondelēz. Đơn vị: Gói.'),
    ROW('Bánh gạo One One vị ngọt dịu (gói 150g)', 22000, 'Nhãn hàng: One One. Đơn vị: Gói.'),
    ROW('Snack khoai tây O''Star vị tảo biển (gói 56g)', 12000, 'Nhãn hàng: Orion. Đơn vị: Gói.'),
    ROW('Snack bí đỏ Poca (gói 45g)', 7000, 'Nhãn hàng: PepsiCo. Đơn vị: Gói.'),
    ROW('Kẹo dẻo Alpenliebe hương dâu kem (gói 98g)', 15000, 'Nhãn hàng: Perfetti Van Melle. Đơn vị: Gói.'),
    ROW('Kẹo cao su Doublemint bạc hà (hũ 58.4g)', 28000, 'Nhãn hàng: Mars Wrigley. Đơn vị: Hũ.'),
    ROW('Socola KitKat trà xanh (gói 8 thanh)', 45000, 'Nhãn hàng: Nestlé. Đơn vị: Gói.'),
    ROW('Xúc xích tiệt trùng Vissan heo (gói 5 cây x 35g)', 21000, 'Nhãn hàng: Vissan. Đơn vị: Gói.'),
    ROW('Dầu gội Clear Bạc Hà mát lạnh (chai 630g)', 165000, 'Nhãn hàng: Unilever. Đơn vị: Chai.'),
    ROW('Dầu gội Pantene ngăn rụng tóc (chai 650g)', 158000, 'Nhãn hàng: P&G. Đơn vị: Chai.'),
    ROW('Sữa tắm Lifebuoy bảo vệ vượt trội (chai 800g)', 145000, 'Nhãn hàng: Unilever. Đơn vị: Chai.'),
    ROW('Sữa tắm Dove dưỡng ẩm chuyên sâu (chai 500g)', 125000, 'Nhãn hàng: Unilever. Đơn vị: Chai.'),
    ROW('Kem đánh răng P/S Trà Xanh (tuýp 180g)', 34000, 'Nhãn hàng: Unilever. Đơn vị: Tuýp.'),
    ROW('Kem đánh răng Colgate MaxFresh (tuýp 175g)', 36000, 'Nhãn hàng: Colgate-Palmolive. Đơn vị: Tuýp.'),
    ROW('Bàn chải đánh răng Colgate lông mềm', 22000, 'Nhãn hàng: Colgate-Palmolive. Đơn vị: Cái.'),
    ROW('Sữa rửa mặt Hazeline Nghệ Hoa Cúc (tuýp 100g)', 49000, 'Nhãn hàng: Unilever. Đơn vị: Tuýp.'),
    ROW('Khăn giấy ướt Mamamy không mùi (gói 100 tờ)', 35000, 'Nhãn hàng: DHTI. Đơn vị: Gói.'),
    ROW('Khăn giấy ăn Pulppy (gói 100 tờ)', 18000, 'Nhãn hàng: New Toyo. Đơn vị: Gói.'),
    ROW('Nước giặt OMO Matic cửa trước (túi 3.6kg)', 195000, 'Nhãn hàng: Unilever. Đơn vị: Túi.'),
    ROW('Nước giặt Ariel hương Downy (túi 3.2kg)', 189000, 'Nhãn hàng: P&G. Đơn vị: Túi.'),
    ROW('Nước xả vải Comfort đậm đặc hương ban mai (túi 3.2L)', 179000, 'Nhãn hàng: Unilever. Đơn vị: Túi.'),
    ROW('Nước rửa chén Sunlight chanh 100 (can 3.6kg)', 98000, 'Nhãn hàng: Unilever. Đơn vị: Can.'),
    ROW('Nước lau sàn Sunlight tinh dầu thảo mộc (can 3.6kg)', 89000, 'Nhãn hàng: Unilever. Đơn vị: Can.'),
    ROW('Giấy vệ sinh Bless You À La Vie (lốc 10 cuộn)', 68000, 'Nhãn hàng: Saigon Paper. Đơn vị: Lốc.')
) AS catalog(itemName, price, description)
WHERE NOT EXISTS (
    SELECT 1 FROM tblItem6 AS item WHERE item.itemName = catalog.itemName
);
SELECT ROW_COUNT() AS inserted_items;
COMMIT;

SELECT COUNT(DISTINCT itemName) AS catalog_items_found
FROM tblItem6
WHERE itemName IN ('Mì tôm Hảo Hảo Tôm Chua Cay (gói 75g)', 'Mì khoai tây Omachi Xốt Bò Hầm (gói 80g)', 'Phở bò ăn liền Cung Đình (gói 68g)', 'Miến Phú Hương sườn heo (gói 58g)', 'Gạo ST25 thượng hạng (túi 5kg)', 'Dầu ăn thực vật Tường An Cooking Oil (1L)', 'Dầu đậu nành Simply nguyên chất (1L)', 'Nước mắm Nam Ngư Đệ Nhị (chai 900ml)', 'Nước tương Tam Thái Tử Nhất Ca (chai 500ml)', 'Tương ớt Chin-su (chai 250g)', 'Hạt nêm Knorr thịt thăn xương ống (gói 400g)', 'Đường tinh luyện Biên Hòa (túi 1kg)', 'Sữa tươi tiệt trùng có đường (lốc 4 hộp x 180ml)', 'Sữa tươi tiệt trùng ít đường TH true MILK (lốc 4x180ml)', 'Sữa đặc có đường Ông Thọ đỏ (lon 380g)', 'Sữa đậu nành Fami nguyên chất (lốc 6 hộp x 200ml)', 'Nước giải khát Coca-Cola (lon 320ml)', 'Nước giải khát Pepsi (chai 1.5L)', 'Trà xanh Không Độ vị chanh (chai 455ml)', 'Nước tăng lực Red Bull (lon 250ml)', 'Nước tăng lực Sting dâu (chai 330ml)', 'Nước khoáng thiên nhiên La Vie (chai 500ml)', 'Cà phê hòa tan G7 3in1 (hộp 18 gói)', 'Bia Tiger Crystal (lon 330ml)', 'Bánh Choco-Pie Orion (hộp 12 cái)', 'Bánh quy bơ Danisa (hộp thiếc 454g)', 'Bánh quy kem Oreo Vani (gói 119.6g)', 'Bánh gạo One One vị ngọt dịu (gói 150g)', 'Snack khoai tây O''Star vị tảo biển (gói 56g)', 'Snack bí đỏ Poca (gói 45g)', 'Kẹo dẻo Alpenliebe hương dâu kem (gói 98g)', 'Kẹo cao su Doublemint bạc hà (hũ 58.4g)', 'Socola KitKat trà xanh (gói 8 thanh)', 'Xúc xích tiệt trùng Vissan heo (gói 5 cây x 35g)', 'Dầu gội Clear Bạc Hà mát lạnh (chai 630g)', 'Dầu gội Pantene ngăn rụng tóc (chai 650g)', 'Sữa tắm Lifebuoy bảo vệ vượt trội (chai 800g)', 'Sữa tắm Dove dưỡng ẩm chuyên sâu (chai 500g)', 'Kem đánh răng P/S Trà Xanh (tuýp 180g)', 'Kem đánh răng Colgate MaxFresh (tuýp 175g)', 'Bàn chải đánh răng Colgate lông mềm', 'Sữa rửa mặt Hazeline Nghệ Hoa Cúc (tuýp 100g)', 'Khăn giấy ướt Mamamy không mùi (gói 100 tờ)', 'Khăn giấy ăn Pulppy (gói 100 tờ)', 'Nước giặt OMO Matic cửa trước (túi 3.6kg)', 'Nước giặt Ariel hương Downy (túi 3.2kg)', 'Nước xả vải Comfort đậm đặc hương ban mai (túi 3.2L)', 'Nước rửa chén Sunlight chanh 100 (can 3.6kg)', 'Nước lau sàn Sunlight tinh dầu thảo mộc (can 3.6kg)', 'Giấy vệ sinh Bless You À La Vie (lốc 10 cuộn)');
