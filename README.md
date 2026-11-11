# 🏋️ SportCenter - WPF Course Booking & Management Application

Ứng dụng WPF chuyên nghiệp cho **Trung tâm Thể thao Sport Center** viết bằng **C# .NET 8 / WPF**, kết nối trực tiếp cơ sở dữ liệu SQL Server `SportCenterDB`, kiến trúc phân tầng (Layered Architecture: Models, Data/EF Core, Services, Views/Dialogs) và tuân thủ tiêu chuẩn thiết kế hiện đại (Impeccable Craft Floor & UI/UX Pro Max).

---

## 📌 Các Tính Năng Đã Hoàn Thiện Theo Yêu Cầu

### 1. Phân quyền 3 vai trò (Manager, Coach, Customer)
- **👔 Quản lý (Manager / Admin):**
  - Xem Dashboard tổng quan với các thẻ KPI: Tổng số lớp, Tổng HLV, Lượt đăng ký, Doanh thu thực tế.
  - **Tạo lớp học mới & Gán Huấn luyện viên (Coach):** Chọn gói khóa học (Course Offering), nhập sức chứa, chỉ định HLV phụ trách, tự động sinh lịch học các buổi (`class_session`) để HLV có thể điểm danh ngay.
  - Tìm kiếm, lọc danh sách lớp học và theo dõi toàn bộ Feedback của học viên gửi về trung tâm.
- **🏃 Khách hàng / Học viên (Customer / Member):**
  - **Khám phá & Đặt khóa học (Course Catalog):** Duyệt các lớp học thể thao theo từng bộ môn (Cầu lông, Bóng rổ, Bơi lội, Yoga...), xem thông tin chi tiết HLV, lịch học, số chỗ còn trống.
  - **Đăng ký lớp & Thanh toán cơ bản (Registration & Payment):** Chọn phương thức thanh toán (*Thanh toán Online*, *Quét mã QR chuyển khoản*, hoặc *Tiền mặt tại quầy*), nhận biên lai thanh toán và mã giao dịch (`TXN-...`).
  - **Quản lý lớp đã đăng ký:** Xem lịch sử đăng ký, hóa đơn đã thanh toán.
  - **Gửi đánh giá (Feedback):** Đánh giá số sao (⭐ 1-5 sao) và để lại nhận xét về chất lượng khóa học, HLV.
- **🥋 Huấn luyện viên (Coach):**
  - **Điểm danh học viên (Attendance):** Chọn buổi học phụ trách, hiển thị danh sách học viên đã đăng ký, hỗ trợ điểm danh nhanh *"Tất cả Có mặt"* hoặc tùy chỉnh từng học viên (*Có mặt, Vắng mặt, Đi muộn, Có phép*) kèm ghi chú buổi học.
  - **Xem phản hồi (Coach Feedback):** Đọc các đánh giá sao và lời nhận xét của học viên dành riêng cho các lớp mình giảng dạy.

---

## 🗄️ Cấu Hình Cơ Sở Dữ Liệu SQL Server

Toàn bộ cấu trúc bảng và dữ liệu mẫu (admin, coach, member, môn học, lớp học) đã được đóng gói sẵn trong file script:
👉 **[`Database/SportCenterDB.sql`](file:///C:/Users/Admin/PRN211/Database/SportCenterDB.sql)**

### Hướng dẫn import Database (Dành cho thành viên nhóm):
1. Mở **SQL Server Management Studio (SSMS)** hoặc **Azure Data Studio**.
2. Kết nối tới SQL Server của máy bạn.
3. Mở file `Database/SportCenterDB.sql` và nhấn **Execute (F5)** để tự động tạo cơ sở dữ liệu `SportCenterDB` kèm toàn bộ dữ liệu mẫu.
4. Kiểm tra chuỗi kết nối tại [`Data/SportCenterDbContext.cs`](file:///C:/Users/Admin/PRN211/Data/SportCenterDbContext.cs):
   - Mặc định: `Server=localhost;Database=SportCenterDB;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True;`
   - *Lưu ý:* Nếu bạn sử dụng SQL Server Express, hãy đổi `localhost` thành `.\SQLEXPRESS` hoặc `localhost\SQLEXPRESS`. Nếu dùng tài khoản `sa`, hãy thêm `User Id=sa;Password=your_password;`.

---

## 🔑 Tài Khoản Thử Nghiệm Nhanh (Demo Accounts)

Hệ thống tích hợp sẵn nút bấm **"ĐĂNG NHẬP NHANH (DEMO ACCOUNTS)"** trên màn hình đăng nhập và menu chuyển vai trò nhanh trong màn hình chính:

| Vai trò | Email Demo | Mật khẩu Demo |
| :--- | :--- | :--- |
| **👔 Quản lý (Manager)** | `demo.admin@sportcenter.test` | `123456` hoặc `admin` |
| **🥋 HLV (Coach)** | `demo.coach1@sportcenter.test` | `123456` |
| **🏃 Học viên (Customer)** | `demo.member1@sportcenter.test` | `123456` |

---

## 🚀 Hướng Dẫn Chạy Ứng Dụng

Mở PowerShell / Terminal tại thư mục gốc của dự án:

```powershell
# 1. Restore các package cần thiết
dotnet restore

# 2. Build ứng dụng
dotnet build

# 3. Khởi chạy ứng dụng WPF
dotnet run
```

---

## 📂 Cấu Trúc Dự Án (Project Structure)

```
SportCenterApp/
├── Models/                     # Entity models ánh xạ bảng SQL SportCenterDB
│   ├── User.cs                 # Bảng users (Admin, Coach, Member)
│   ├── Coach.cs                # Bảng coach (Profile HLV, bio)
│   ├── Sport.cs                # Bảng sport (Môn thể thao)
│   ├── Course.cs               # Bảng course (Khóa học)
│   ├── CourseOffering.cs       # Bảng course_offering (Gói mở lớp, giá, lịch)
│   ├── ClassEntity.cs          # Bảng class (Lớp học, gán coach)
│   ├── ClassSession.cs         # Bảng class_session (Buổi học, thời gian)
│   ├── CourseRegistration.cs   # Bảng course_registration (Đăng ký học viên)
│   ├── Payment.cs              # Bảng payment (Hóa đơn, thanh toán)
│   ├── Attendance.cs           # Bảng attendance (Điểm danh buổi học)
│   └── Feedback.cs             # Bảng feedback (Đánh giá học viên)
├── Data/
│   └── SportCenterDbContext.cs # Entity Framework Core DbContext kết nối SQL Server
├── Services/                   # Tầng xử lý nghiệp vụ & logic
│   ├── AuthService.cs          # Đăng nhập, session, chuyển đổi vai trò
│   ├── ClassService.cs         # Tạo lớp học, gán HLV, sinh lịch học
│   ├── RegistrationService.cs  # Đăng ký khóa học, thanh toán, xuất biên lai
│   ├── AttendanceService.cs    # Lấy danh sách điểm danh, lưu chuyên cần
│   └── FeedbackService.cs      # Gửi & xem đánh giá sao, nhận xét
├── Views/                      # Giao diện người dùng XAML
│   ├── LoginWindow.xaml        # Màn hình đăng nhập & chọn vai trò nhanh
│   ├── MainWindow.xaml         # Khung điều hướng chính với thanh Sidebar & Header
│   ├── Manager/
│   │   ├── ManagerDashboardView.xaml   # Báo cáo KPI, danh sách lớp, feedbacks
│   │   └── CreateClassDialog.xaml      # Hộp thoại tạo lớp & chỉ định HLV
│   ├── Customer/
│   │   ├── CourseCatalogView.xaml      # Danh mục khóa học & nút đăng ký
│   │   ├── RegistrationPaymentDialog.xaml # Hộp thoại thanh toán & QR Code
│   │   ├── MyEnrollmentsView.xaml      # Khóa học đã đăng ký & nút viết feedback
│   │   └── FeedbackDialog.xaml         # Hộp thoại chấm điểm sao & nhận xét
│   └── Coach/
│       ├── CoachAttendanceView.xaml    # Giao diện điểm danh buổi học
│       └── CoachFeedbackView.xaml      # Giao diện xem đánh giá của học viên
├── App.xaml                    # Design tokens, màu sắc hiện đại, styles
└── SportCenterApp.csproj       # .NET 8 WPF Project
```
