using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SportCenterApp.Data;
using SportCenterApp.Models;

namespace SportCenterApp.Services
{
    public class SessionSelectOption
    {
        public int SessionId { get; set; }
        public int ClassId { get; set; }
        public string ClassName { get; set; } = string.Empty;
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string Status { get; set; } = string.Empty;
        public string DisplayText => $"{ClassName} | {StartTime:dd/MM/yyyy HH:mm} - {EndTime:HH:mm} ({Status})";
    }

    public class StudentAttendanceItem : System.ComponentModel.INotifyPropertyChanged
    {
        public event System.ComponentModel.PropertyChangedEventHandler? PropertyChanged;
        protected void OnPropertyChanged(string propName) =>
            PropertyChanged?.Invoke(this, new System.ComponentModel.PropertyChangedEventArgs(propName));

        public int MemberId { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;

        public int? AttendanceId { get; set; }

        private string _status = "PRESENT";
        public string Status
        {
            get => _status;
            set
            {
                if (_status != value)
                {
                    _status = value;
                    OnPropertyChanged(nameof(Status));
                    OnPropertyChanged(nameof(StatusBackground));
                    OnPropertyChanged(nameof(StatusBorder));
                    OnPropertyChanged(nameof(StatusForeground));
                    OnPropertyChanged(nameof(StatusDisplayText));
                    OnPropertyChanged(nameof(IsPresent));
                    OnPropertyChanged(nameof(IsAbsent));
                    OnPropertyChanged(nameof(IsLate));
                    OnPropertyChanged(nameof(IsExcused));
                }
            }
        }

        public string StatusBackground => Status switch
        {
            "ABSENT" => "#FEE2E2",
            "LATE" => "#FEF3C7",
            "EXCUSED" => "#E0E7FF",
            _ => "#DCFCE7" // PRESENT
        };

        public string StatusBorder => Status switch
        {
            "ABSENT" => "#EF4444",
            "LATE" => "#F59E0B",
            "EXCUSED" => "#6366F1",
            _ => "#16A34A" // PRESENT
        };

        public string StatusForeground => Status switch
        {
            "ABSENT" => "#B91C1C",
            "LATE" => "#B45309",
            "EXCUSED" => "#3730A3",
            _ => "#15803D" // PRESENT
        };

        public string StatusDisplayText => Status switch
        {
            "ABSENT" => "❌ Vắng mặt (Absent)",
            "LATE" => "⏰ Đi muộn (Late)",
            "EXCUSED" => "📝 Có phép (Excused)",
            _ => "✅ Có mặt (Present)"
        };

        private string? _note;
        public string? Note
        {
            get => _note;
            set
            {
                if (_note != value)
                {
                    _note = value;
                    OnPropertyChanged(nameof(Note));
                }
            }
        }

        private DateTime? _markedAt;
        public DateTime? MarkedAt
        {
            get => _markedAt;
            set
            {
                if (_markedAt != value)
                {
                    _markedAt = value;
                    OnPropertyChanged(nameof(MarkedAt));
                    OnPropertyChanged(nameof(LastMarkedDisplay));
                    OnPropertyChanged(nameof(HasBeenMarked));
                }
            }
        }

        private string _markedByName = string.Empty;
        public string MarkedByName
        {
            get => _markedByName;
            set
            {
                if (_markedByName != value)
                {
                    _markedByName = value;
                    OnPropertyChanged(nameof(MarkedByName));
                    OnPropertyChanged(nameof(LastMarkedDisplay));
                    OnPropertyChanged(nameof(HasBeenMarked));
                }
            }
        }

        public string LastMarkedDisplay
        {
            get
            {
                if (string.IsNullOrWhiteSpace(MarkedByName) && !MarkedAt.HasValue)
                {
                    return "Chưa điểm danh";
                }
                string by = !string.IsNullOrWhiteSpace(MarkedByName) ? $"Bởi: {MarkedByName}" : "Đã điểm danh";
                string at = MarkedAt.HasValue ? MarkedAt.Value.ToString("dd/MM/yyyy HH:mm") : string.Empty;
                return string.IsNullOrEmpty(at) ? by : $"{by}\n{at}";
            }
        }

        public bool HasBeenMarked => !string.IsNullOrWhiteSpace(MarkedByName) || MarkedAt.HasValue;

        // UI Helpers
        public bool IsPresent => Status == "PRESENT";
        public bool IsAbsent => Status == "ABSENT";
        public bool IsLate => Status == "LATE";
        public bool IsExcused => Status == "EXCUSED";
    }

    public class AttendanceService
    {
        public async Task<List<SessionSelectOption>> GetSessionsForUserAsync(User user)
        {
            using var db = new SportCenterDbContext();

            IQueryable<ClassSession> query = db.ClassSessions
                .Include(cs => cs.Class)
                    .ThenInclude(c => c!.Coach);

            if (user.Role == "COACH")
            {
                // Find coach ID
                var coach = await db.Coaches.FirstOrDefaultAsync(c => c.UserId == user.Id);
                if (coach != null)
                {
                    query = query.Where(cs => cs.Class != null && cs.Class.CoachId == coach.Id);
                }
            }

            var sessions = await query
                .OrderByDescending(cs => cs.StartTime)
                .ToListAsync();

            return sessions.Select(s => new SessionSelectOption
            {
                SessionId = s.Id,
                ClassId = s.ClassId,
                ClassName = s.Class?.Name ?? $"Lớp #{s.ClassId}",
                StartTime = s.StartTime,
                EndTime = s.EndTime,
                Status = s.Status
            }).ToList();
        }

        public async Task<List<StudentAttendanceItem>> GetAttendanceSheetAsync(int sessionId)
        {
            using var db = new SportCenterDbContext();

            var session = await db.ClassSessions
                .Include(cs => cs.Class)
                    .ThenInclude(c => c!.Registrations)
                        .ThenInclude(r => r.Member)
                .Include(cs => cs.Attendances)
                    .ThenInclude(a => a.MarkedByUser)
                .FirstOrDefaultAsync(cs => cs.Id == sessionId);

            if (session == null || session.Class == null)
                return new List<StudentAttendanceItem>();

            var confirmedRegistrations = session.Class.Registrations
                .Where(r => r.Status == "CONFIRMED")
                .ToList();

            var result = new List<StudentAttendanceItem>();

            foreach (var reg in confirmedRegistrations)
            {
                var member = reg.Member;
                if (member == null) continue;

                var existingAttendance = session.Attendances.FirstOrDefault(a => a.MemberId == member.Id);

                result.Add(new StudentAttendanceItem
                {
                    MemberId = member.Id,
                    FullName = member.Name,
                    Email = member.Email,
                    Phone = member.Phone ?? "-",
                    AttendanceId = existingAttendance?.Id,
                    Status = existingAttendance?.Status ?? "PRESENT",
                    Note = existingAttendance?.Note,
                    MarkedAt = existingAttendance?.MarkedAt,
                    MarkedByName = existingAttendance?.MarkedByUser?.Name ?? string.Empty
                });
            }

            return result;
        }

        public async Task<(bool Success, string Message)> SaveAttendanceAsync(
            int sessionId,
            int markedByUserId,
            List<StudentAttendanceItem> items)
        {
            if (sessionId <= 0 || items == null || items.Count == 0)
                return (false, "Không có dữ liệu điểm danh để lưu.");

            using var db = new SportCenterDbContext();

            var session = await db.ClassSessions
                .Include(cs => cs.Attendances)
                .FirstOrDefaultAsync(cs => cs.Id == sessionId);

            if (session == null)
                return (false, "Buổi học không tồn tại.");

            foreach (var item in items)
            {
                var existing = session.Attendances.FirstOrDefault(a => a.MemberId == item.MemberId);
                if (existing != null)
                {
                    existing.Status = item.Status;
                    existing.Note = item.Note;
                    existing.MarkedBy = markedByUserId;
                    existing.MarkedAt = DateTime.Now;
                }
                else
                {
                    db.Attendances.Add(new Attendance
                    {
                        ClassSessionId = sessionId,
                        MemberId = item.MemberId,
                        Status = item.Status,
                        Note = item.Note,
                        MarkedBy = markedByUserId,
                        MarkedAt = DateTime.Now
                    });
                }
            }

            // Update session status to COMPLETED if not already
            if (session.Status == "SCHEDULED")
            {
                session.Status = "COMPLETED";
            }

            await db.SaveChangesAsync();
            return (true, $"Lưu điểm danh thành công cho {items.Count} học viên!");
        }
    }
}
