# PRODUCT.md - Sport Center Pro Management & Course Booking

## 1. Product Identity & Purpose
- **Tên sản phẩm:** Sport Center Pro Management System (WPF Application)
- **Mục tiêu:** Cung cấp hệ thống quản lý trung tâm thể thao toàn diện và đặt khóa học thể thao trực quan, ổn định, hỗ trợ 3 phân hệ người dùng cốt lõi (Manager, Coach, Customer).
- **Nền tảng công nghệ:** .NET 8 (WPF Desktop Application), C# 12, Entity Framework Core 8, Microsoft SQL Server (`SportCenterDB`).

## 2. Target Users & Surface Modes

### A. Quản lý (Manager / Admin / Receptionist) - Surface Mode: `Operate`
- **Nhu cầu:** Quét thông tin nhanh, kiểm soát số lượng học viên, doanh thu, phân bổ nguồn lực.
- **Tính năng chính:**
  - KPI Dashboard: Theo dõi sĩ số, tổng lớp, huấn luyện viên, doanh thu.
  - Tạo lớp học mới, liên kết gói khóa học (Course Offering), nhập sức chứa, gán Huấn luyện viên phụ trách (Coach).
  - Tự động sinh lịch học các buổi (`class_session`) để phục vụ điểm danh.
  - Giám sát toàn bộ đánh giá (Feedback) của học viên toàn hệ thống.

### B. Huấn luyện viên (Coach) - Surface Mode: `Operate`
- **Nhu cầu:** Thao tác điểm danh nhanh chóng, chính xác trước/trong buổi học, đọc phản hồi học viên để nâng cao nghiệp vụ.
- **Tính năng chính:**
  - Xem danh sách lớp và lịch các buổi học được phân công phụ trách.
  - Điểm danh học viên (`attendance`): Đánh dấu nhanh *Tất cả có mặt*, hoặc chọn từng học viên (*Có mặt, Vắng mặt, Đi muộn, Có phép*), kèm ghi chú từng người.
  - Đọc các đánh giá sao và nhận xét của học viên dành cho lớp của mình.

### C. Khách hàng / Học viên (Customer / Member) - Surface Mode: `Persuade` & `Operate`
- **Nhu cầu:** Duyệt tìm lớp học thể thao theo sở thích, đăng ký nhanh gọn, thanh toán minh bạch, theo dõi lịch sử và phản hồi.
- **Tính năng chính:**
  - Khám phá danh mục khóa học (Course Catalog) theo môn thể thao, xem trình độ, số buổi, HLV phụ trách, chỗ trống.
  - Đăng ký & Thanh toán: Chọn phương thức (Trực tuyến, QR Code chuyển khoản ngân hàng mô phỏng, hoặc Tiền mặt tại quầy), nhận mã giao dịch `TXN-...`.
  - Quản lý khóa học của tôi: Xem tình trạng hóa đơn và buổi học.
  - Gửi đánh giá (Feedback): Chấm 1-5 sao và để lại nhận xét.

## 3. Constraints & Quality Standards (Craft Floor)
- **Cơ sở dữ liệu:** Tương thích 100% với schema `SportCenterDB` (SQL Server).
- **Mã nguồn:** Kiến trúc 3-layer phân tách rõ ràng (`Models`, `Data`, `Services`, `Views/Dialogs`).
- **Khả năng sử dụng:** Hỗ trợ phím tắt, `Cursor="Hand"` cho mọi phần tử click, phản hồi trạng thái rõ ràng, chuyển vai trò tức thì cho mục đích demo/chấm điểm.
