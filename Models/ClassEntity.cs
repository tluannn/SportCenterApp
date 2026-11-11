using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("class")]
    public class ClassEntity
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("name")]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [Column("capacity")]
        public int Capacity { get; set; } = 15;

        [Column("coach_id")]
        public int CoachId { get; set; }

        [Column("course_offering_id")]
        public int CourseOfferingId { get; set; }

        [Column("status")]
        [MaxLength(30)]
        public string Status { get; set; } = "ACTIVE";

        // Navigation
        [ForeignKey("CoachId")]
        public virtual Coach? Coach { get; set; }

        [ForeignKey("CourseOfferingId")]
        public virtual CourseOffering? CourseOffering { get; set; }

        public virtual ICollection<ClassSession> Sessions { get; set; } = new List<ClassSession>();
        public virtual ICollection<CourseRegistration> Registrations { get; set; } = new List<CourseRegistration>();
        public virtual ICollection<Feedback> Feedbacks { get; set; } = new List<Feedback>();
    }
}
