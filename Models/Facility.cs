using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("facility")]
    public class Facility
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("name")]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [Column("type")]
        [MaxLength(50)]
        public string? Type { get; set; }

        [Column("status")]
        [MaxLength(30)]
        public string Status { get; set; } = "ACTIVE";

        [Column("sport_id")]
        public int? SportId { get; set; }

        [Column("image_url")]
        public string? ImageUrl { get; set; }
    }
}
