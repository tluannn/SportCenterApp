using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("feedback")]
    public class Feedback
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("class_id")]
        public int ClassId { get; set; }

        [Column("member_id")]
        public int MemberId { get; set; }

        [Column("rating")]
        public int Rating { get; set; } // 1 to 5

        [Column("comment")]
        [MaxLength(1000)]
        public string? Comment { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation
        [ForeignKey("ClassId")]
        public virtual ClassEntity? Class { get; set; }

        [ForeignKey("MemberId")]
        public virtual User? Member { get; set; }
    }
}
