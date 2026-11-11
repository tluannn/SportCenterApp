using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("course_registration")]
    public class CourseRegistration
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("member_id")]
        public int MemberId { get; set; }

        [Column("class_id")]
        public int ClassId { get; set; }

        [Column("status")]
        [MaxLength(20)]
        public string Status { get; set; } = "PENDING"; // PENDING, CONFIRMED, CANCELLED, EXPIRED

        [Column("registered_at")]
        public DateTime RegisteredAt { get; set; } = DateTime.Now;

        [Column("cancelled_at")]
        public DateTime? CancelledAt { get; set; }

        [Column("original_price")]
        public decimal OriginalPrice { get; set; }

        [Column("membership_discount")]
        public decimal MembershipDiscount { get; set; } = 0;

        [Column("final_price")]
        public decimal FinalPrice { get; set; }

        [Column("payment_deadline")]
        public DateTime? PaymentDeadline { get; set; }

        // Navigation
        [ForeignKey("MemberId")]
        public virtual User? Member { get; set; }

        [ForeignKey("ClassId")]
        public virtual ClassEntity? Class { get; set; }
    }
}
