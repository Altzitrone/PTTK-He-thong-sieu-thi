# Hệ thống quản lý siêu thị trực tuyến

Dự án Java MVC triển khai hai mô-đun của Đề 09.

- Khách hàng đăng nhập, tìm mặt hàng theo tên và xem chi tiết.
- Nhân viên kho đăng nhập, lọc đơn, chọn người giao, xác nhận xuất, mở hóa đơn và in lại.

Bán tại quầy thuộc sơ đồ tổng thể của báo cáo. Dữ liệu đơn hàng đầu vào của mô-đun kho được cấp bằng script mẫu.

## Môi trường

- JDK 21 và Maven 3.
- Apache Tomcat 9 dùng Servlet API `javax.servlet`.
- MySQL 8.4 với schema UTF-8. Maven đóng gói JDBC Connector/J và JSTL trong WAR.
- Giao diện nạp Bootstrap 5 từ CDN. Nút xác nhận và nút in dùng JavaScript nội bộ.

## Khởi tạo cơ sở dữ liệu

1. Chạy [database/init.sql](database/init.sql) trong MySQL Workbench bằng tài khoản có quyền tạo schema. Chọn cơ sở dữ liệu `supermarket6`. Script giữ nguyên dữ liệu demo đã được cập nhật nếu chạy lại.
2. Tạo hoặc chọn một tài khoản MySQL riêng để ứng dụng sử dụng. Ví dụ với tài khoản cục bộ, thay mật khẩu mẫu trước khi chạy:

   ```sql
   CREATE USER 'supermarket_app'@'localhost' IDENTIFIED BY 'replace-with-a-local-password';
   GRANT SELECT, INSERT, UPDATE ON supermarket6.* TO 'supermarket_app'@'localhost';
   ```

3. Đặt các biến môi trường cho tiến trình Tomcat. Ví dụ trong PowerShell:

   ```powershell
   $env:SUPERMARKET_DB_URL = 'jdbc:mysql://localhost:3306/supermarket6'
   $env:SUPERMARKET_DB_USER = 'supermarket_app'
   $env:SUPERMARKET_DB_PASSWORD = 'your-local-password'
   ```

   Nếu dùng cấu hình chạy Tomcat của IDE, đặt các biến trong mục **Environment variables** của cấu hình. URL và tên người dùng có giá trị mặc định như trên.

## Build và triển khai

```powershell
mvn package
```

- **IntelliJ IDEA** — Mở `pom.xml` dưới dạng dự án Maven, chọn JDK 21 và triển khai artifact WAR lên Tomcat 9 nếu IDE có hỗ trợ. Cũng có thể chép `target/PTTKWeb.war` vào thư mục `webapps` của Tomcat.
- **Eclipse** — Import **Existing Maven Projects**, chọn JDK 21 và thêm Tomcat 9 trong tab **Servers**. Thêm ứng dụng vào server hoặc triển khai WAR trực tiếp.
- Mở `http://localhost:8080/PTTKWeb/login` nếu triển khai WAR theo tên mặc định.

| Vai trò | Tên đăng nhập | Mật khẩu demo |
|---|---|---|
| Khách hàng | `khachhang` | `Demo1234!` |
| Nhân viên kho | `nhanvienkho` | `Demo1234!` |

## Cấu trúc và cách kiểm tra

- `src/main/java/model` — Các JavaBean, gồm thực thể đơn, dòng hàng, khách hàng, nhân viên và hóa đơn.
- `src/main/java/dao` — JDBC và giao dịch xuất hàng. `DBConnection` là singleton cấu hình. Mỗi yêu cầu JDBC sử dụng kết nối riêng và tự đóng sau khi hoàn tất.
- `src/main/java/controller` — Servlet, xác thực phiên, phân quyền và kiểm tra dữ liệu biểu mẫu.
- `src/main/webapp/WEB-INF/view` — JSP/JSTL chia theo `member`, `customer` và `warehouseStaff`.

1. Đăng nhập bằng tài khoản khách hàng, tìm **Sữa** và bấm **Xem**. Dùng nút quay lại để trở về đúng từ khóa vừa nhập.
2. Đăng xuất và đăng nhập bằng tài khoản kho. Chọn đơn ở trạng thái **Chưa xuất**, chọn người giao, sau đó bấm **Cập nhật trạng thái**.
3. Bấm **In hóa đơn** để mở bản in. Bấm **In** để gọi hộp thoại in của trình duyệt. Lọc **Đã xuất** để mở lại đơn và in cùng mã hóa đơn.
4. Kiểm tra từ hai phiên kho cùng chọn một người giao. Lần xác nhận lưu trước sẽ chuyển người giao sang **Đang giao**. Lần sau báo dữ liệu đã thay đổi nếu người đó vẫn bận.

### Quy tắc lưu và in

Cập nhật trạng thái đơn, ghi nhận nhân viên kho, chuyển người giao sang **Đang giao** và tạo hóa đơn diễn ra trong cùng một giao dịch. CSDL giữ một hóa đơn cho mỗi đơn bằng khóa duy nhất trên `onlineOrderId`. `InvoiceServlet` gọi `createInvoice(Invoice6)` để chuẩn bị hóa đơn đã lưu và ghi thời điểm tạo bản in đầu tiên. Việc bấm in hoặc in lại dùng hộp thoại in của trình duyệt.

Mô-đun kho đọc tồn kho và đơn đã được tạo sẵn. Số lượng tồn được giả định đã được xử lý ở khâu đặt hàng. Việc chuyển người giao về **Đang rảnh** thuộc nghiệp vụ kết thúc giao hàng, ngoài hai mô-đun chi tiết.
