using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SportCenterApp.Models
{
    [Table("payment")]
    public class Payment
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("member_id")]
        public int MemberId { get; set; }

        [Column("amount")]
        public decimal Amount { get; set; }

        [Column("method")]
        [MaxLength(20)]
        public string Method { get; set; } = "ONLINE"; // ONLINE, COUNTER, QR_TRANSFER

        [Column("purpose")]
        [MaxLength(30)]
        public string Purpose { get; set; } = "COURSE_REGISTRATION";

        [Column("reference_id")]
        public int ReferenceId { get; set; } // Points to CourseRegistration.Id

        [Column("auto_renew")]
        public bool? AutoRenew { get; set; } = false;

        [Column("status")]
        [MaxLength(20)]
        public string Status { get; set; } = "SUCCESS"; // PENDING, SUCCESS, CANCELLED

        [Column("transaction_code")]
        [MaxLength(50)]
        public string TransactionCode { get; set; } = string.Empty;

        [Column("processed_by")]
        public int? ProcessedBy { get; set; }

        [Column("note")]
        [MaxLength(500)]
        public string? Note { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        [Column("paid_at")]
        public DateTime? PaidAt { get; set; }

        [Column("refunded_at")]
        public DateTime? RefundedAt { get; set; }

        [Column("refunded_by")]
        public int? RefundedBy { get; set; }

        // Navigation
        [ForeignKey("MemberId")]
        public virtual User? Member { get; set; }
    }
}
