using Microsoft.EntityFrameworkCore;
using SportCenterApp.Models;

namespace SportCenterApp.Data
{
    public class SportCenterDbContext : DbContext
    {
        public static string DefaultConnectionString { get; set; } =
            "Server=localhost;Database=SportCenterDB;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True;";

        public SportCenterDbContext()
        {
        }

        public SportCenterDbContext(DbContextOptions<SportCenterDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Coach> Coaches { get; set; } = null!;
        public DbSet<Sport> Sports { get; set; } = null!;
        public DbSet<Course> Courses { get; set; } = null!;
        public DbSet<CourseOffering> CourseOfferings { get; set; } = null!;
        public DbSet<ClassEntity> Classes { get; set; } = null!;
        public DbSet<ClassSession> ClassSessions { get; set; } = null!;
        public DbSet<CourseRegistration> CourseRegistrations { get; set; } = null!;
        public DbSet<Payment> Payments { get; set; } = null!;
        public DbSet<Attendance> Attendances { get; set; } = null!;
        public DbSet<Feedback> Feedbacks { get; set; } = null!;
        public DbSet<Facility> Facilities { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(DefaultConnectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Coach - User (1 - 1)
            modelBuilder.Entity<Coach>()
                .HasOne(c => c.User)
                .WithOne(u => u.CoachProfile)
                .HasForeignKey<Coach>(c => c.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            // Class - Coach
            modelBuilder.Entity<ClassEntity>()
                .HasOne(c => c.Coach)
                .WithMany(ch => ch.Classes)
                .HasForeignKey(c => c.CoachId)
                .OnDelete(DeleteBehavior.Restrict);

            // Class - CourseOffering
            modelBuilder.Entity<ClassEntity>()
                .HasOne(c => c.CourseOffering)
                .WithMany(co => co.Classes)
                .HasForeignKey(c => c.CourseOfferingId)
                .OnDelete(DeleteBehavior.Restrict);

            // CourseOffering - Course
            modelBuilder.Entity<CourseOffering>()
                .HasOne(co => co.Course)
                .WithMany(c => c.Offerings)
                .HasForeignKey(co => co.CourseId)
                .OnDelete(DeleteBehavior.Restrict);

            // Course - Sport
            modelBuilder.Entity<Course>()
                .HasOne(c => c.Sport)
                .WithMany(s => s.Courses)
                .HasForeignKey(c => c.SportId)
                .OnDelete(DeleteBehavior.Restrict);

            // ClassSession - Class
            modelBuilder.Entity<ClassSession>()
                .HasOne(cs => cs.Class)
                .WithMany(c => c.Sessions)
                .HasForeignKey(cs => cs.ClassId)
                .OnDelete(DeleteBehavior.Cascade);

            // CourseRegistration - Class & Member
            modelBuilder.Entity<CourseRegistration>()
                .HasOne(cr => cr.Class)
                .WithMany(c => c.Registrations)
                .HasForeignKey(cr => cr.ClassId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<CourseRegistration>()
                .HasOne(cr => cr.Member)
                .WithMany(u => u.Registrations)
                .HasForeignKey(cr => cr.MemberId)
                .OnDelete(DeleteBehavior.Restrict);

            // Payment - Member
            modelBuilder.Entity<Payment>()
                .HasOne(p => p.Member)
                .WithMany()
                .HasForeignKey(p => p.MemberId)
                .OnDelete(DeleteBehavior.Restrict);

            // Attendance - Session, Member, MarkedBy
            modelBuilder.Entity<Attendance>()
                .HasOne(a => a.Session)
                .WithMany(cs => cs.Attendances)
                .HasForeignKey(a => a.ClassSessionId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Attendance>()
                .HasOne(a => a.Member)
                .WithMany()
                .HasForeignKey(a => a.MemberId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Attendance>()
                .HasOne(a => a.MarkedByUser)
                .WithMany()
                .HasForeignKey(a => a.MarkedBy)
                .OnDelete(DeleteBehavior.Restrict);

            // Feedback - Class & Member
            modelBuilder.Entity<Feedback>()
                .HasOne(f => f.Class)
                .WithMany(c => c.Feedbacks)
                .HasForeignKey(f => f.ClassId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Feedback>()
                .HasOne(f => f.Member)
                .WithMany()
                .HasForeignKey(f => f.MemberId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
