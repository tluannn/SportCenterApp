using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SportCenterApp.Data;
using SportCenterApp.Models;

namespace SportCenterApp.Services
{
    public class ClassDisplayItem
    {
        public int Id { get; set; }
        public string ClassName { get; set; } = string.Empty;
        public int Capacity { get; set; }
        public int EnrolledCount { get; set; }
        public int RemainingSlots => Math.Max(0, Capacity - EnrolledCount);
        public bool IsFull => RemainingSlots <= 0;
        public string SlotDisplay
        {
            get => $"{EnrolledCount} / {Capacity} học viên";
            set { }
        }

        public int CoachId { get; set; }
        public string CoachName { get; set; } = string.Empty;
        public string CoachEmail { get; set; } = string.Empty;
        public string CoachBio { get; set; } = string.Empty;

        public int CourseOfferingId { get; set; }
        public string OfferingName { get; set; } = string.Empty;
        public string CourseName { get; set; } = string.Empty;
        public string SportName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string PriceFormatted
        {
            get => $"{Price:N0} VNĐ";
            set { }
        }

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string DateRangeDisplay
        {
            get => $"{StartDate:dd/MM/yyyy} - {EndDate:dd/MM/yyyy}";
            set { }
        }

        public int TotalSessions { get; set; }
        public string Status { get; set; } = "ACTIVE";
        public double AverageRating { get; set; }
        public int FeedbackCount { get; set; }
        public string RatingDisplay
        {
            get => FeedbackCount > 0 ? $"⭐ {AverageRating:0.0} ({FeedbackCount})" : "Chưa có đánh giá";
            set { }
        }
    }

    public class CoachSelectOption
    {
        public int CoachId { get; set; }
        public int UserId { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Bio { get; set; } = string.Empty;
        public string DisplayText => $"{FullName} ({Email})";
    }

    public class OfferingSelectOption
    {
        public int OfferingId { get; set; }
        public string OfferingName { get; set; } = string.Empty;
        public string CourseName { get; set; } = string.Empty;
        public string SportName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int PlannedSessions { get; set; }
        public string DisplayText => $"{CourseName} - {OfferingName} ({Price:N0} đ | {PlannedSessions} buổi)";
    }

    public class ClassService
    {
        public async Task<List<ClassDisplayItem>> GetAllClassesAsync()
        {
            using var db = new SportCenterDbContext();
            var classes = await db.Classes
                .Include(c => c.Coach)
                    .ThenInclude(ch => ch!.User)
                .Include(c => c.CourseOffering)
                    .ThenInclude(co => co!.Course)
                        .ThenInclude(crs => crs!.Sport)
                .Include(c => c.Registrations)
                .Include(c => c.Sessions)
                .Include(c => c.Feedbacks)
                .OrderByDescending(c => c.Id)
                .ToListAsync();

            return classes.Select(c =>
            {
                var enrolled = c.Registrations.Count(r => r.Status == "CONFIRMED" || r.Status == "PENDING");
                var avgRating = c.Feedbacks.Any() ? c.Feedbacks.Average(f => f.Rating) : 0;

                return new ClassDisplayItem
                {
                    Id = c.Id,
                    ClassName = c.Name,
                    Capacity = c.Capacity,
                    EnrolledCount = enrolled,
                    CoachId = c.CoachId,
                    CoachName = c.Coach?.User?.Name ?? "Chưa gán",
                    CoachEmail = c.Coach?.User?.Email ?? string.Empty,
                    CoachBio = c.Coach?.Bio ?? string.Empty,
                    CourseOfferingId = c.CourseOfferingId,
                    OfferingName = c.CourseOffering?.Name ?? string.Empty,
                    CourseName = c.CourseOffering?.Course?.Name ?? string.Empty,
                    SportName = c.CourseOffering?.Course?.Sport?.Name ?? "Thể thao",
                    Price = c.CourseOffering?.Price ?? 0,
                    StartDate = c.CourseOffering?.StartDate ?? DateTime.Today,
                    EndDate = c.CourseOffering?.EndDate ?? DateTime.Today.AddMonths(1),
                    TotalSessions = c.Sessions.Count > 0 ? c.Sessions.Count : (c.CourseOffering?.PlannedSessions ?? 0),
                    Status = c.Status,
                    AverageRating = avgRating,
                    FeedbackCount = c.Feedbacks.Count
                };
            }).ToList();
        }

        public async Task<List<Sport>> GetActiveSportsAsync()
        {
            using var db = new SportCenterDbContext();
            return await db.Sports
                .Where(s => s.Status == "ACTIVE")
                .OrderBy(s => s.Name)
                .ToListAsync();
        }

        public async Task<List<CoachSelectOption>> GetCoachOptionsAsync()
        {
            using var db = new SportCenterDbContext();
            var coaches = await db.Coaches
                .Include(c => c.User)
                .Where(c => c.Status == "ACTIVE")
                .ToListAsync();

            return coaches.Select(c => new CoachSelectOption
            {
                CoachId = c.Id,
                UserId = c.UserId,
                FullName = c.User?.Name ?? $"HLV #{c.Id}",
                Email = c.User?.Email ?? string.Empty,
                Bio = c.Bio ?? string.Empty
            }).ToList();
        }

        public async Task<List<OfferingSelectOption>> GetOfferingOptionsAsync()
        {
            using var db = new SportCenterDbContext();
            var offerings = await db.CourseOfferings
                .Include(co => co.Course)
                    .ThenInclude(c => c!.Sport)
                .OrderByDescending(co => co.Id)
                .ToListAsync();

            return offerings.Select(co => new OfferingSelectOption
            {
                OfferingId = co.Id,
                OfferingName = co.Name,
                CourseName = co.Course?.Name ?? "Khóa học",
                SportName = co.Course?.Sport?.Name ?? "Thể thao",
                Price = co.Price,
                StartDate = co.StartDate,
                EndDate = co.EndDate,
                PlannedSessions = co.PlannedSessions
            }).ToList();
        }

        public async Task<(bool Success, string Message, int NewClassId)> CreateClassAsync(
            string className,
            int capacity,
            int coachId,
            int courseOfferingId,
            string status = "ACTIVE")
        {
            if (string.IsNullOrWhiteSpace(className))
                return (false, "Tên lớp học không được để trống.", 0);

            if (capacity <= 0)
                return (false, "Sức chứa lớp học phải lớn hơn 0.", 0);

            if (coachId <= 0)
                return (false, "Vui lòng chọn Huấn luyện viên cho lớp.", 0);

            if (courseOfferingId <= 0)
                return (false, "Vui lòng chọn Gói khóa học cho lớp.", 0);

            using var db = new SportCenterDbContext();

            var coachExists = await db.Coaches.AnyAsync(c => c.Id == coachId);
            if (!coachExists) return (false, "Huấn luyện viên không tồn tại.", 0);

            var offering = await db.CourseOfferings.FindAsync(courseOfferingId);
            if (offering == null) return (false, "Gói khóa học không tồn tại.", 0);

            var newClass = new ClassEntity
            {
                Name = className.Trim(),
                Capacity = capacity,
                CoachId = coachId,
                CourseOfferingId = courseOfferingId,
                Status = status
            };

            db.Classes.Add(newClass);
            await db.SaveChangesAsync();

            // Automatically generate sessions for this new class so Coach can take attendance immediately!
            var sessionCount = offering.PlannedSessions > 0 ? offering.PlannedSessions : 8;
            var sessionDuration = offering.SessionDuration > 0 ? offering.SessionDuration : 60;
            var startDate = offering.StartDate > DateTime.Today ? offering.StartDate : DateTime.Today.AddDays(1);

            DateTime currentSessionDate = startDate.Date.AddHours(9); // Default 09:00 AM
            for (int i = 0; i < sessionCount; i++)
            {
                db.ClassSessions.Add(new ClassSession
                {
                    ClassId = newClass.Id,
                    FacilityId = 1,
                    StartTime = currentSessionDate,
                    EndTime = currentSessionDate.AddMinutes(sessionDuration),
                    Status = "SCHEDULED"
                });

                // Alternate every 3-4 days (e.g. Tuesday / Friday or every 3 days)
                currentSessionDate = currentSessionDate.AddDays(i % 2 == 0 ? 3 : 4);
            }

            await db.SaveChangesAsync();

            return (true, $"Tạo lớp '{newClass.Name}' và gán Huấn luyện viên thành công! Đã lên lịch {sessionCount} buổi học.", newClass.Id);
        }

        public async Task<(bool Success, string Message, int NewClassId)> CreateCourseAndClassAsync(
            int sportId,
            string courseName,
            string level,
            string? description,
            decimal price,
            int plannedSessions,
            int sessionDuration,
            DateTime startDate,
            DateTime endDate,
            string className,
            int coachId,
            int capacity,
            string classStatus = "ACTIVE")
        {
            if (sportId <= 0)
                return (false, "Vui lòng chọn môn thể thao cho khóa học.", 0);

            if (string.IsNullOrWhiteSpace(courseName))
                return (false, "Tên khóa học không được để trống.", 0);

            if (price < 0)
                return (false, "Học phí khóa học không hợp lệ.", 0);

            if (plannedSessions <= 0)
                return (false, "Số buổi học dự kiến phải lớn hơn 0.", 0);

            if (endDate < startDate)
                return (false, "Ngày kết thúc khóa học phải sau ngày bắt đầu.", 0);

            if (string.IsNullOrWhiteSpace(className))
                return (false, "Tên lớp học không được để trống.", 0);

            if (coachId <= 0)
                return (false, "Vui lòng chọn Huấn luyện viên cho lớp.", 0);

            if (capacity <= 0)
                return (false, "Sức chứa lớp học phải lớn hơn 0.", 0);

            using var db = new SportCenterDbContext();
            using var transaction = await db.Database.BeginTransactionAsync();

            try
            {
                // 1. Tạo Khóa học (Course)
                var newCourse = new Course
                {
                    SportId = sportId,
                    Name = courseName.Trim(),
                    Level = level,
                    Description = string.IsNullOrWhiteSpace(description) ? null : description.Trim(),
                    Status = "ACTIVE"
                };
                db.Courses.Add(newCourse);
                await db.SaveChangesAsync();

                // 2. Tạo Gói khóa học mở đăng ký (CourseOffering)
                var newOffering = new CourseOffering
                {
                    CourseId = newCourse.Id,
                    Name = $"{courseName.Trim()} ({startDate:dd/MM} - {endDate:dd/MM/yyyy})",
                    Price = price,
                    PlannedSessions = plannedSessions,
                    SessionDuration = sessionDuration > 0 ? sessionDuration : 60,
                    StartDate = startDate,
                    EndDate = endDate,
                    Status = "OPEN"
                };
                db.CourseOfferings.Add(newOffering);
                await db.SaveChangesAsync();

                // 3. Tạo Lớp học (ClassEntity)
                var newClass = new ClassEntity
                {
                    Name = className.Trim(),
                    Capacity = capacity,
                    CoachId = coachId,
                    CourseOfferingId = newOffering.Id,
                    Status = classStatus
                };
                db.Classes.Add(newClass);
                await db.SaveChangesAsync();

                // 4. Sinh lịch các buổi học (ClassSession)
                var facility = await db.Facilities.FirstOrDefaultAsync();
                int? facilityId = facility?.Id ?? 1;

                DateTime currentSessionDate = startDate.Date.AddHours(9); // Mặc định 09:00 AM
                if (currentSessionDate < DateTime.Now)
                {
                    currentSessionDate = DateTime.Today.AddDays(1).AddHours(9);
                }

                for (int i = 0; i < plannedSessions; i++)
                {
                    db.ClassSessions.Add(new ClassSession
                    {
                        ClassId = newClass.Id,
                        FacilityId = facilityId,
                        StartTime = currentSessionDate,
                        EndTime = currentSessionDate.AddMinutes(newOffering.SessionDuration),
                        Status = "SCHEDULED"
                    });

                    // Lặp thứ 3 / thứ 6 hoặc cách 3-4 ngày một buổi
                    currentSessionDate = currentSessionDate.AddDays(i % 2 == 0 ? 3 : 4);
                }

                await db.SaveChangesAsync();
                await transaction.CommitAsync();

                return (true, $"Tạo khóa học '{newCourse.Name}' và mở lớp '{newClass.Name}' thành công! Đã tự động lên lịch {plannedSessions} buổi học.", newClass.Id);
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return (false, "Lỗi khi lưu vào cơ sở dữ liệu: " + ex.Message, 0);
            }
        }
    }
}
