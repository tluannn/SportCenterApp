using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SportCenterApp.Data;
using SportCenterApp.Models;

namespace SportCenterApp.Services
{
    public class EnrollmentDisplayItem
    {
        public int RegistrationId { get; set; }
        public int ClassId { get; set; }
        public string ClassName { get; set; } = string.Empty;
        public string CourseName { get; set; } = string.Empty;
        public string SportName { get; set; } = string.Empty;
        public string CoachName { get; set; } = string.Empty;
        public DateTime RegisteredAt { get; set; }
        public string RegisteredAtFormatted
        {
            get => RegisteredAt.ToString("dd/MM/yyyy HH:mm");
            set { }
        }
        public string Status { get; set; } = "CONFIRMED";
        public decimal FinalPrice { get; set; }
        public string FinalPriceFormatted
        {
            get => $"{FinalPrice:N0} VNĐ";
            set { }
        }
        public string PaymentMethod { get; set; } = string.Empty;
        public string TransactionCode { get; set; } = string.Empty;
        public bool HasFeedback { get; set; }
        public int? FeedbackRating { get; set; }
        public string? FeedbackComment { get; set; }
        public string FeedbackStatusText
        {
            get => HasFeedback ? $"Đã đánh giá: ⭐ {FeedbackRating}/5" : "Chưa gửi đánh giá";
            set { }
        }
    }

    public class PaymentReceipt
    {
        public int RegistrationId { get; set; }
        public int PaymentId { get; set; }
        public string ClassName { get; set; } = string.Empty;
        public string CourseName { get; set; } = string.Empty;
        public string CoachName { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public string Method { get; set; } = string.Empty;
        public string TransactionCode { get; set; } = string.Empty;
        public DateTime PaidAt { get; set; }
    }

    public class RegistrationService
    {
        public async Task<(bool Success, string Message, PaymentReceipt? Receipt)> RegisterAndPayAsync(
            int memberId,
            int classId,
            string paymentMethod,
            string? note = null)
        {
            if (memberId <= 0)
                return (false, "Thông tin học viên không hợp lệ.", null);

            using var db = new SportCenterDbContext();

            var member = await db.Users.FindAsync(memberId);
            if (member == null)
                return (false, "Học viên không tồn tại.", null);

            var classEntity = await db.Classes
                .Include(c => c.Coach)
                    .ThenInclude(ch => ch!.User)
                .Include(c => c.CourseOffering)
                    .ThenInclude(co => co!.Course)
                .Include(c => c.Registrations)
                .FirstOrDefaultAsync(c => c.Id == classId);

            if (classEntity == null)
                return (false, "Lớp học không tồn tại.", null);

            if (classEntity.Status != "ACTIVE")
                return (false, "Lớp học hiện tại không mở đăng ký.", null);

            // Check if already registered
            var existingReg = classEntity.Registrations
                .FirstOrDefault(r => r.MemberId == memberId && (r.Status == "CONFIRMED" || r.Status == "PENDING"));

            if (existingReg != null)
                return (false, $"Bạn đã đăng ký lớp học này rồi (Trạng thái: {existingReg.Status}).", null);

            // Check capacity
            int currentEnrolled = classEntity.Registrations.Count(r => r.Status == "CONFIRMED" || r.Status == "PENDING");
            if (currentEnrolled >= classEntity.Capacity)
                return (false, "Lớp học đã đủ sĩ số, không thể đăng ký thêm.", null);

            decimal price = classEntity.CourseOffering?.Price ?? 0;
            decimal discount = 0; // standard base rate
            decimal finalPrice = Math.Max(0, price - discount);

            // Create Registration
            var registration = new CourseRegistration
            {
                MemberId = memberId,
                ClassId = classId,
                Status = "CONFIRMED",
                RegisteredAt = DateTime.Now,
                OriginalPrice = price,
                MembershipDiscount = discount,
                FinalPrice = finalPrice,
                PaymentDeadline = DateTime.Now.AddDays(3)
            };

            db.CourseRegistrations.Add(registration);
            await db.SaveChangesAsync();

            // Create Payment
            string txnCode = $"TXN-{DateTime.Now:yyyyMMddHHmmss}-{new Random().Next(1000, 9999)}";
            var payment = new Payment
            {
                MemberId = memberId,
                Amount = finalPrice,
                Method = string.IsNullOrEmpty(paymentMethod) ? "ONLINE" : paymentMethod,
                Purpose = "COURSE_REGISTRATION",
                ReferenceId = registration.Id,
                AutoRenew = false,
                Status = "SUCCESS",
                TransactionCode = txnCode,
                ProcessedBy = null,
                Note = note ?? $"Thanh toán khóa học '{classEntity.Name}' qua {paymentMethod}",
                CreatedAt = DateTime.Now,
                PaidAt = DateTime.Now
            };

            db.Payments.Add(payment);
            await db.SaveChangesAsync();

            var receipt = new PaymentReceipt
            {
                RegistrationId = registration.Id,
                PaymentId = payment.Id,
                ClassName = classEntity.Name,
                CourseName = classEntity.CourseOffering?.Course?.Name ?? classEntity.Name,
                CoachName = classEntity.Coach?.User?.Name ?? "HLV Phụ trách",
                Amount = finalPrice,
                Method = payment.Method,
                TransactionCode = txnCode,
                PaidAt = DateTime.Now
            };

            return (true, $"Đăng ký và thanh toán thành công lớp '{classEntity.Name}'! Mã giao dịch: {txnCode}", receipt);
        }

        public async Task<List<EnrollmentDisplayItem>> GetMemberEnrollmentsAsync(int memberId)
        {
            using var db = new SportCenterDbContext();

            var registrations = await db.CourseRegistrations
                .Include(r => r.Class)
                    .ThenInclude(c => c!.Coach)
                        .ThenInclude(ch => ch!.User)
                .Include(r => r.Class)
                    .ThenInclude(c => c!.CourseOffering)
                        .ThenInclude(co => co!.Course)
                            .ThenInclude(crs => crs!.Sport)
                .Where(r => r.MemberId == memberId)
                .OrderByDescending(r => r.RegisteredAt)
                .ToListAsync();

            var payments = await db.Payments
                .Where(p => p.MemberId == memberId && p.Purpose == "COURSE_REGISTRATION")
                .ToListAsync();

            var feedbacks = await db.Feedbacks
                .Where(f => f.MemberId == memberId)
                .ToListAsync();

            return registrations.Select(r =>
            {
                var pay = payments.FirstOrDefault(p => p.ReferenceId == r.Id);
                var fb = feedbacks.FirstOrDefault(f => f.ClassId == r.ClassId);

                return new EnrollmentDisplayItem
                {
                    RegistrationId = r.Id,
                    ClassId = r.ClassId,
                    ClassName = r.Class?.Name ?? "Lớp học",
                    CourseName = r.Class?.CourseOffering?.Course?.Name ?? "Khóa học",
                    SportName = r.Class?.CourseOffering?.Course?.Sport?.Name ?? "Thể thao",
                    CoachName = r.Class?.Coach?.User?.Name ?? "HLV",
                    RegisteredAt = r.RegisteredAt,
                    Status = r.Status,
                    FinalPrice = r.FinalPrice,
                    PaymentMethod = pay?.Method ?? "ONLINE",
                    TransactionCode = pay?.TransactionCode ?? "-",
                    HasFeedback = fb != null,
                    FeedbackRating = fb?.Rating,
                    FeedbackComment = fb?.Comment
                };
            }).ToList();
        }
    }
}
