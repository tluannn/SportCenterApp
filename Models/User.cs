using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("users")]
    public class User
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("name")]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [Column("email")]
        [MaxLength(150)]
        public string Email { get; set; } = string.Empty;

        [Column("password_hash")]
        [MaxLength(255)]
        public string PasswordHash { get; set; } = string.Empty;

        [Column("phone")]
        [MaxLength(20)]
        public string? Phone { get; set; }

        [Column("role")]
        [MaxLength(30)]
        public string Role { get; set; } = string.Empty; // ADMIN, COACH, MEMBER, RECEPTIONIST

        [Column("status")]
        [MaxLength(30)]
        public string Status { get; set; } = "ACTIVE";

        [Column("gender")]
        [MaxLength(1)]
        public string? Gender { get; set; }

        [Column("date_of_birth")]
        public DateTime? DateOfBirth { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation
        public virtual Coach? CoachProfile { get; set; }
        public virtual ICollection<CourseRegistration> Registrations { get; set; } = new List<CourseRegistration>();
    }
}
