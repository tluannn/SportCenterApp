using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("attendance")]
    public class Attendance
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("class_session_id")]
        public int ClassSessionId { get; set; }

        [Column("member_id")]
        public int MemberId { get; set; }

        [Column("status")]
        [MaxLength(30)]
        public string Status { get; set; } = "PRESENT"; // PRESENT, ABSENT, LATE, EXCUSED

        [Column("marked_by")]
        public int MarkedBy { get; set; }

        [Column("marked_at")]
        public DateTime MarkedAt { get; set; } = DateTime.Now;

        [Column("note")]
        [MaxLength(500)]
        public string? Note { get; set; }

        // Navigation
        [ForeignKey("ClassSessionId")]
        public virtual ClassSession? Session { get; set; }

        [ForeignKey("MemberId")]
        public virtual User? Member { get; set; }

        [ForeignKey("MarkedBy")]
        public virtual User? MarkedByUser { get; set; }
    }
}
