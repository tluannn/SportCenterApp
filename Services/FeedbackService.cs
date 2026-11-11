using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SportCenterApp.Data;
using SportCenterApp.Models;

namespace SportCenterApp.Services
{
    public class FeedbackDisplayItem
    {
        public int Id { get; set; }
        public int ClassId { get; set; }
        public string ClassName { get; set; } = string.Empty;
        public string CourseName { get; set; } = string.Empty;
        public string SportName { get; set; } = string.Empty;
        public string CoachName { get; set; } = string.Empty;

        public int MemberId { get; set; }
        public string MemberName { get; set; } = string.Empty;
        public string MemberEmail { get; set; } = string.Empty;

        public int Rating { get; set; }
        public string RatingStars => new string('⭐', Math.Clamp(Rating, 1, 5));
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedAtFormatted => CreatedAt.ToString("dd/MM/yyyy HH:mm");
    }

    public class FeedbackService
    {
        public async Task<(bool Success, string Message)> SubmitFeedbackAsync(
            int memberId,
            int classId,
            int rating,
            string? comment)
        {
            if (memberId <= 0 || classId <= 0)
                return (false, "Thông tin gửi đánh giá không hợp lệ.");

            if (rating < 1 || rating > 5)
                return (false, "Điểm đánh giá phải từ 1 đến 5 sao.");

            using var db = new SportCenterDbContext();

            // Verify registration
            var isEnrolled = await db.CourseRegistrations
                .AnyAsync(r => r.MemberId == memberId && r.ClassId == classId && r.Status == "CONFIRMED");

            if (!isEnrolled)
            {
                return (false, "Bạn chỉ có thể đánh giá lớp học mà bạn đã tham gia.");
            }

            var existingFeedback = await db.Feedbacks
                .FirstOrDefaultAsync(f => f.MemberId == memberId && f.ClassId == classId);

            if (existingFeedback != null)
            {
                // Update existing feedback
                existingFeedback.Rating = rating;
                existingFeedback.Comment = comment?.Trim();
                existingFeedback.CreatedAt = DateTime.Now;
                await db.SaveChangesAsync();
                return (true, "Đã cập nhật đánh giá thành công!");
            }
            else
            {
                var feedback = new Feedback
                {
                    MemberId = memberId,
                    ClassId = classId,
                    Rating = rating,
                    Comment = comment?.Trim(),
                    CreatedAt = DateTime.Now
                };

                db.Feedbacks.Add(feedback);
                await db.SaveChangesAsync();
                return (true, "Cảm ơn bạn! Đã gửi đánh giá thành công.");
            }
        }

        public async Task<List<FeedbackDisplayItem>> GetFeedbacksForClassAsync(int classId)
        {
            using var db = new SportCenterDbContext();

            var list = await db.Feedbacks
                .Include(f => f.Member)
                .Include(f => f.Class)
                    .ThenInclude(c => c!.Coach)
                        .ThenInclude(ch => ch!.User)
                .Include(f => f.Class)
                    .ThenInclude(c => c!.CourseOffering)
                        .ThenInclude(co => co!.Course)
                            .ThenInclude(crs => crs!.Sport)
                .Where(f => f.ClassId == classId)
                .OrderByDescending(f => f.CreatedAt)
                .ToListAsync();

            return list.Select(f => MapToDisplay(f)).ToList();
        }

        public async Task<List<FeedbackDisplayItem>> GetFeedbacksForCoachAsync(int coachUserId)
        {
            using var db = new SportCenterDbContext();

            var coach = await db.Coaches.FirstOrDefaultAsync(c => c.UserId == coachUserId);
            if (coach == null) return new List<FeedbackDisplayItem>();

            var list = await db.Feedbacks
                .Include(f => f.Member)
                .Include(f => f.Class)
                    .ThenInclude(c => c!.Coach)
                        .ThenInclude(ch => ch!.User)
                .Include(f => f.Class)
                    .ThenInclude(c => c!.CourseOffering)
                        .ThenInclude(co => co!.Course)
                            .ThenInclude(crs => crs!.Sport)
                .Where(f => f.Class != null && f.Class.CoachId == coach.Id)
                .OrderByDescending(f => f.CreatedAt)
                .ToListAsync();

            return list.Select(f => MapToDisplay(f)).ToList();
        }

        public async Task<List<FeedbackDisplayItem>> GetAllFeedbacksAsync()
        {
            using var db = new SportCenterDbContext();

            var list = await db.Feedbacks
                .Include(f => f.Member)
                .Include(f => f.Class)
                    .ThenInclude(c => c!.Coach)
                        .ThenInclude(ch => ch!.User)
                .Include(f => f.Class)
                    .ThenInclude(c => c!.CourseOffering)
                        .ThenInclude(co => co!.Course)
                            .ThenInclude(crs => crs!.Sport)
                .OrderByDescending(f => f.CreatedAt)
                .ToListAsync();

            return list.Select(f => MapToDisplay(f)).ToList();
        }

        private static FeedbackDisplayItem MapToDisplay(Feedback f)
        {
            return new FeedbackDisplayItem
            {
                Id = f.Id,
                ClassId = f.ClassId,
                ClassName = f.Class?.Name ?? "Lớp học",
                CourseName = f.Class?.CourseOffering?.Course?.Name ?? "Khóa học",
                SportName = f.Class?.CourseOffering?.Course?.Sport?.Name ?? "Thể thao",
                CoachName = f.Class?.Coach?.User?.Name ?? "HLV",
                MemberId = f.MemberId,
                MemberName = f.Member?.Name ?? "Học viên",
                MemberEmail = f.Member?.Email ?? string.Empty,
                Rating = f.Rating,
                Comment = f.Comment,
                CreatedAt = f.CreatedAt
            };
        }
    }
}
