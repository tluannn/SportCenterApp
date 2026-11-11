using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using Microsoft.EntityFrameworkCore;
using SportCenterApp.Data;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Manager
{
    public partial class ManagerDashboardView : UserControl
    {
        private readonly ClassService _classService = new ClassService();
        private readonly FeedbackService _feedbackService = new FeedbackService();
        private List<ClassDisplayItem> _allClasses = new List<ClassDisplayItem>();

        public ManagerDashboardView()
        {
            InitializeComponent();
            Loaded += async (s, e) => await LoadDataAsync();
        }

        public async Task LoadDataAsync()
        {
            try
            {
                _allClasses = await _classService.GetAllClassesAsync();
                ApplyFilter();

                // Compute KPI
                using var db = new SportCenterDbContext();
                int totalClasses = _allClasses.Count;
                int totalCoaches = await db.Coaches.CountAsync(c => c.Status == "ACTIVE");
                int totalEnrolled = _allClasses.Sum(c => c.EnrolledCount);
                decimal totalRevenue = await db.Payments
                    .Where(p => p.Status == "SUCCESS" && p.Purpose == "COURSE_REGISTRATION")
                    .SumAsync(p => (decimal?)p.Amount) ?? 0;

                TxtTotalClasses.Text = totalClasses.ToString();
                TxtTotalCoaches.Text = totalCoaches.ToString();
                TxtTotalEnrolled.Text = totalEnrolled.ToString();
                TxtTotalRevenue.Text = $"{totalRevenue:N0} đ";

                BtnCreateClass.Visibility = AuthService.Instance.IsAdmin ? Visibility.Visible : Visibility.Collapsed;

                // Load feedbacks
                var feedbacks = await _feedbackService.GetAllFeedbacksAsync();
                IcFeedbacks.ItemsSource = feedbacks;
                TxtNoFeedback.Visibility = feedbacks.Count == 0 ? Visibility.Visible : Visibility.Collapsed;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải dữ liệu Quản lý: " + ex.Message, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ApplyFilter()
        {
            if (DgClasses == null || _allClasses == null) return;

            string query = TxtSearch?.Text?.Trim().ToLower() ?? string.Empty;
            if (string.IsNullOrEmpty(query))
            {
                DgClasses.ItemsSource = _allClasses;
            }
            else
            {
                DgClasses.ItemsSource = _allClasses.Where(c =>
                    c.ClassName.ToLower().Contains(query) ||
                    c.CoachName.ToLower().Contains(query) ||
                    c.SportName.ToLower().Contains(query) ||
                    c.CourseName.ToLower().Contains(query)
                ).ToList();
            }
        }

        private void OnSearchTextChanged(object sender, TextChangedEventArgs e)
        {
            if (TxtSearchPlaceholder != null)
            {
                TxtSearchPlaceholder.Visibility = string.IsNullOrEmpty(TxtSearch.Text) ? Visibility.Visible : Visibility.Collapsed;
            }
            ApplyFilter();
        }

        private async void OnRefreshClick(object sender, RoutedEventArgs e)
        {
            await LoadDataAsync();
        }

        private async void OnCreateClassClick(object sender, RoutedEventArgs e)
        {
            if (!AuthService.Instance.IsAdmin)
            {
                MessageBox.Show("Chỉ có tài khoản Quản trị viên (ADMIN) mới có quyền tạo khóa học & mở lớp học!", "Từ chối quyền truy cập", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var dialog = new CreateClassDialog
            {
                Owner = Window.GetWindow(this)
            };

            if (dialog.ShowDialog() == true && dialog.IsCreated)
            {
                await LoadDataAsync();
            }
        }
    }
}
