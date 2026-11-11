using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("course_offering")]
    public class CourseOffering
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("course_id")]
        public int CourseId { get; set; }

        [Column("name")]
        [MaxLength(150)]
        public string Name { get; set; } = string.Empty;

        [Column("price")]
        public decimal Price { get; set; }

        [Column("start_date")]
        public DateTime StartDate { get; set; }

        [Column("end_date")]
        public DateTime EndDate { get; set; }

        [Column("planned_sessions")]
        public int PlannedSessions { get; set; } = 10;

        [Column("session_duration")]
        public int SessionDuration { get; set; } = 60; // minutes

        [Column("registration_deadline")]
        public DateTime? RegistrationDeadline { get; set; }

        [Column("cancellation_deadline")]
        public DateTime? CancellationDeadline { get; set; }

        [Column("status")]
        [MaxLength(30)]
        public string Status { get; set; } = "OPEN";

        // Navigation
        [ForeignKey("CourseId")]
        public virtual Course? Course { get; set; }

        public virtual ICollection<ClassEntity> Classes { get; set; } = new List<ClassEntity>();
    }
}
