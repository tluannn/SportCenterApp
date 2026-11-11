using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("coach")]
    public class Coach
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("user_id")]
        public int UserId { get; set; }

        [Column("bio")]
        public string? Bio { get; set; }

        [Column("image_url")]
        public string? ImageUrl { get; set; }

        [Column("status")]
        [MaxLength(30)]
        public string Status { get; set; } = "ACTIVE";

        // Navigation
        [ForeignKey("UserId")]
        public virtual User? User { get; set; }

        public virtual ICollection<ClassEntity> Classes { get; set; } = new List<ClassEntity>();
    }
}
