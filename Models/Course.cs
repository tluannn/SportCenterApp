using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("course")]
    public class Course
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("name")]
        [MaxLength(150)]
        public string Name { get; set; } = string.Empty;

        [Column("description")]
        public string? Description { get; set; }

        [Column("learning_outcome")]
        public string? LearningOutcome { get; set; }

        [Column("level")]
        [MaxLength(30)]
        public string? Level { get; set; }

        [Column("status")]
        [MaxLength(30)]
        public string Status { get; set; } = "ACTIVE";

        [Column("sport_id")]
        public int SportId { get; set; }

        [Column("target_age_min")]
        public int? TargetAgeMin { get; set; }

        [Column("target_age_max")]
        public int? TargetAgeMax { get; set; }

        [Column("age_policy")]
        [MaxLength(50)]
        public string? AgePolicy { get; set; }

        // Navigation
        [ForeignKey("SportId")]
        public virtual Sport? Sport { get; set; }

        public virtual ICollection<CourseOffering> Offerings { get; set; } = new List<CourseOffering>();
    }
}
