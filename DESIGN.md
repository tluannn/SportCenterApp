# DESIGN.md - Design Tokens & Visual Architecture

> Được thiết lập theo quy chuẩn kết hợp **UI UX Pro Max** (Sports/Fitness domain palette & typography) và **Impeccable** (Chế độ bề mặt `Operate`/`Persuade`, chuẩn Craft Floor, loại bỏ AI Slop).

---

## 1. Color System (Dark Slate & Athletic Energy)

Hệ màu tối chuyên sâu cho ứng dụng quản lý thể thao cao cấp, độ tương phản cao đạt chuẩn WCAG AA (> 4.5:1), chống mỏi mắt:

| Token | Hex Code | Ứng dụng trong giao diện WPF |
| :--- | :--- | :--- |
| `BgDark` | `#0F172A` | Nền canvas ứng dụng (Slate 900) |
| `SurfaceCard` | `#1E293B` | Nền các thẻ Card, Sidebar, Container chính (Slate 800) |
| `SurfaceElevated` | `#283548` | Nền Textbox, Input, ComboBox, hàng xen kẽ DataGrid |
| `BorderSubtle` | `#334155` | Đường viền các card, bảng phân cách, nhẹ nhàng, sắc nét |
| `Primary` | `#2563EB` | Nút hành động chính, viền khi focus (Royal Blue năng động) |
| `PrimaryHover` | `#1D4ED8` | Trạng thái rê chuột nút chính |
| `TealAccent` | `#0D9488` | Điểm nhấn thương hiệu, thẻ môn thể thao, tiêu đề phụ |
| `Success` | `#10B981` | Đăng ký thành công, thanh toán hoàn tất, có mặt (Emerald) |
| `Warning` | `#F59E0B` | Đánh giá sao, cảnh báo, đi muộn (Amber) |
| `Danger` | `#EF4444` | Vắng mặt, hết chỗ, thông báo lỗi (Coral Red) |
| `TextPrimary` | `#F8FAFC` | Chữ chính, tiêu đề (Trắng Slate độ tương phản cao) |
| `TextSecondary` | `#94A3B8` | Chữ phụ, nhãn hỗ trợ, mô tả (Slate 400) |

---

## 2. Typography & Hierarchy

- **Font Family:** `Segoe UI, Aptos, system-ui, sans-serif`
- **Tỉ lệ phân cấp:**
  - **Hero / Title:** 20 - 24pt, `FontWeight="Bold"`
  - **Section Heading:** 15 - 18pt, `FontWeight="SemiBold"`
  - **Card / Table Title:** 13 - 14pt, `FontWeight="Bold"`
  - **Body / Content:** 12 - 13pt, `FontWeight="Normal"`
  - **Caption / Badge / Overline:** 10 - 11pt, `FontWeight="SemiBold"`, chữ in hoa nhẹ

---

## 3. Radii & Spacing Scale

- **Border Radius:**
  - Nút bấm (Button): `CornerRadius="7"`
  - Ô nhập liệu (Input / TextBox / ComboBox): `CornerRadius="6"`
  - Thẻ chứa (Card / Panel): `CornerRadius="8"` đến `CornerRadius="10"`
  - Huy hiệu (Pill Badge): `CornerRadius="12"`
- **Padding & Grid Rhythm:**
  - Card padding: `18px - 24px`
  - Table row height: `42px`
  - Input height: `36px - 38px`

---

## 4. Impeccable Craft Floor & Anti-AI Slop Checklist

1. **Tuyệt đối không dùng AI Slop:** Không lồng 3 lớp card vô nghĩa, không dùng hiệu ứng gradient mờ nhạt gây khó nhìn.
2. **Không dùng Emoji thay icon hệ thống:** Mọi nút bấm, tiêu đề đều có nhãn chữ rõ ràng (Clean Typography & Semantics).
3. **Affordance & Cursor:** 100% phần tử tương tác (`Button`, `ComboBox`, `RadioButton`) đều được thiết lập `Cursor="Hand"`.
4. **Phản hồi trạng thái (Feedback loop):**
   - Mọi nút bấm đều có hiệu ứng Hover & Pressed.
   - Thao tác thành công hoặc lỗi đều có thông báo dialog hoặc thông báo inline rõ ràng.
   - Có trạng thái rỗng (Empty state) cho bảng dữ liệu khi chưa có học viên hoặc chưa có buổi học.
