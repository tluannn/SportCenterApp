using System;
using System.Globalization;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using SportCenterApp.Models;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Manager
{
    public partial class CreateClassDialog : Window
    {
        private readonly ClassService _classService = new ClassService();
        public bool IsCreated { get; private set; } = false;

        private DateTime _parsedStartDate;
        private DateTime _parsedEndDate;
        private decimal _parsedPrice;
        private int _parsedSessions;
        private int _parsedDuration;

        public CreateClassDialog()
        {
            InitializeComponent();
            Loaded += OnLoaded;
        }

        private async void OnLoaded(object sender, RoutedEventArgs e)
        {
            // Permission check: Only ADMIN can create course & class
            if (!AuthService.Instance.IsAdmin)
            {
                MessageBox.Show("Chỉ có tài khoản Quản trị viên (ADMIN) mới có quyền tạo khóa học & mở lớp học!", "Từ chối quyền truy cập", MessageBoxButton.OK, MessageBoxImage.Warning);
                DialogResult = false;
                Close();
                return;
            }

            try
            {
                // Set default dates: 1 week from now -> 5 weeks from now
                TxtStartDate.Text = DateTime.Today.AddDays(7).ToString("dd/MM/yyyy");
                TxtEndDate.Text = DateTime.Today.AddDays(37).ToString("dd/MM/yyyy");

                // Load sports
                var sports = await _classService.GetActiveSportsAsync();
                CmbSports.ItemsSource = sports;
                if (sports.Count > 0)
                {
                    CmbSports.SelectedIndex = 0;
                }

                // Load coaches
                var coaches = await _classService.GetCoachOptionsAsync();
                CmbCoaches.ItemsSource = coaches;
                if (coaches.Count > 0)
                {
                    CmbCoaches.SelectedIndex = 0;
                }
            }
            catch (Exception ex)
            {
                ShowError("Không thể tải danh sách Môn thể thao hoặc HLV: " + ex.Message);
            }
        }

        private void OnSportChanged(object sender, SelectionChangedEventArgs e)
        {
            if (CmbSports.SelectedItem is Sport sport)
            {
                if (string.IsNullOrWhiteSpace(TxtCourseName.Text))
                {
                    TxtCourseName.Text = $"Khóa Học {sport.Name} Cơ Bản {DateTime.Now:MM/yyyy}";
                }
            }
        }

        private void OnGoToStep2Click(object sender, RoutedEventArgs e)
        {
            TxtMessage.Visibility = Visibility.Collapsed;

            // 1. Sport
            if (CmbSports.SelectedValue == null)
            {
                ShowError("Vui lòng chọn Môn thể thao.");
                return;
            }

            // 2. Course Name
            string courseName = TxtCourseName.Text.Trim();
            if (string.IsNullOrEmpty(courseName))
            {
                ShowError("Vui lòng nhập Tên khóa học.");
                return;
            }

            // 3. Price
            if (!decimal.TryParse(TxtPrice.Text.Trim().Replace(",", "").Replace(".", ""), out _parsedPrice) || _parsedPrice < 0)
            {
                ShowError("Học phí phải là số hợp lệ lớn hơn hoặc bằng 0.");
                return;
            }

            // 4. Sessions
            if (!int.TryParse(TxtPlannedSessions.Text.Trim(), out _parsedSessions) || _parsedSessions <= 0)
            {
                ShowError("Số buổi học phải là số nguyên dương.");
                return;
            }

            // 5. Duration
            if (!int.TryParse(TxtSessionDuration.Text.Trim(), out _parsedDuration) || _parsedDuration <= 0)
            {
                ShowError("Thời lượng buổi học phải là số phút lớn hơn 0.");
                return;
            }

            // 6. Dates
            var culture = CultureInfo.InvariantCulture;
            string[] formats = { "dd/MM/yyyy", "d/M/yyyy", "yyyy-MM-dd" };

            if (!DateTime.TryParseExact(TxtStartDate.Text.Trim(), formats, culture, DateTimeStyles.None, out _parsedStartDate))
            {
                ShowError("Ngày khai giảng không đúng định dạng (VD: 15/11/2026).");
                return;
            }

            if (!DateTime.TryParseExact(TxtEndDate.Text.Trim(), formats, culture, DateTimeStyles.None, out _parsedEndDate))
            {
                ShowError("Ngày bế giảng không đúng định dạng (VD: 15/12/2026).");
                return;
            }

            if (_parsedEndDate < _parsedStartDate)
            {
                ShowError("Ngày bế giảng phải sau ngày khai giảng.");
                return;
            }

            // Update Summary Card for Step 2
            var sport = CmbSports.SelectedItem as Sport;
            TxtSummaryCourseTitle.Text = courseName;
            TxtSummaryDetails.Text = $"Môn: {sport?.Name ?? "Thể thao"} • Học phí: {_parsedPrice:N0} đ • {_parsedSessions} buổi ({_parsedDuration}p/buổi)";
            TxtSummaryDates.Text = $"Thời gian: {_parsedStartDate:dd/MM/yyyy} - {_parsedEndDate:dd/MM/yyyy}";

            // Suggest class name if not entered yet
            if (string.IsNullOrWhiteSpace(TxtClassName.Text))
            {
                TxtClassName.Text = $"Lớp {courseName} (Ca Sáng T3-T5)";
            }

            // Switch to Step 2
            PanelStep1.Visibility = Visibility.Collapsed;
            PanelStep2.Visibility = Visibility.Visible;
            FooterStep1.Visibility = Visibility.Collapsed;
            FooterStep2.Visibility = Visibility.Visible;

            // Highlight Step 2 indicator
            IndicatorStep1.Background = Brushes.Transparent;
            IndicatorStep1.BorderBrush = (SolidColorBrush)FindResource("BorderSubtleBrush");
            IndicatorStep1.BorderThickness = new Thickness(1);
            TxtIndicatorStep1.Foreground = (SolidColorBrush)FindResource("TextSecondaryBrush");

            IndicatorStep2.Background = (SolidColorBrush)FindResource("PrimaryBrush");
            IndicatorStep2.BorderThickness = new Thickness(0);
            TxtIndicatorStep2.Foreground = Brushes.White;
        }

        private void OnBackToStep1Click(object sender, RoutedEventArgs e)
        {
            TxtMessage.Visibility = Visibility.Collapsed;

            PanelStep1.Visibility = Visibility.Visible;
            PanelStep2.Visibility = Visibility.Collapsed;
            FooterStep1.Visibility = Visibility.Visible;
            FooterStep2.Visibility = Visibility.Collapsed;

            // Highlight Step 1 indicator
            IndicatorStep1.Background = (SolidColorBrush)FindResource("PrimaryBrush");
            IndicatorStep1.BorderThickness = new Thickness(0);
            TxtIndicatorStep1.Foreground = Brushes.White;

            IndicatorStep2.Background = Brushes.Transparent;
            IndicatorStep2.BorderBrush = (SolidColorBrush)FindResource("BorderSubtleBrush");
            IndicatorStep2.BorderThickness = new Thickness(1);
            TxtIndicatorStep2.Foreground = (SolidColorBrush)FindResource("TextSecondaryBrush");
        }

        private async void OnSaveClick(object sender, RoutedEventArgs e)
        {
            string className = TxtClassName.Text.Trim();
            if (string.IsNullOrEmpty(className))
            {
                ShowError("Vui lòng nhập tên lớp học.");
                return;
            }

            if (CmbCoaches.SelectedValue == null)
            {
                ShowError("Vui lòng chọn một Huấn luyện viên phụ trách.");
                return;
            }

            if (!int.TryParse(TxtCapacity.Text.Trim(), out int capacity) || capacity <= 0)
            {
                ShowError("Sức chứa học viên phải là số nguyên dương.");
                return;
            }

            int sportId = (int)CmbSports.SelectedValue;
            string courseName = TxtCourseName.Text.Trim();
            string level = (CmbLevel.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "Cơ bản";
            string? description = TxtDescription.Text.Trim();
            int coachId = (int)CmbCoaches.SelectedValue;
            string status = (CmbStatus.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "ACTIVE";

            try
            {
                BtnSave.IsEnabled = false;
                TxtMessage.Visibility = Visibility.Collapsed;

                var (success, msg, newId) = await _classService.CreateCourseAndClassAsync(
                    sportId: sportId,
                    courseName: courseName,
                    level: level,
                    description: description,
                    price: _parsedPrice,
                    plannedSessions: _parsedSessions,
                    sessionDuration: _parsedDuration,
                    startDate: _parsedStartDate,
                    endDate: _parsedEndDate,
                    className: className,
                    coachId: coachId,
                    capacity: capacity,
                    classStatus: status
                );

                if (success)
                {
                    MessageBox.Show(msg, "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                    IsCreated = true;
                    DialogResult = true;
                    Close();
                }
                else
                {
                    ShowError(msg);
                }
            }
            catch (Exception ex)
            {
                ShowError("Lỗi hệ thống khi tạo khóa & lớp: " + ex.Message);
            }
            finally
            {
                BtnSave.IsEnabled = true;
            }
        }

        private void ShowError(string msg)
        {
            TxtMessage.Text = "⚠️ " + msg;
            TxtMessage.Visibility = Visibility.Visible;
        }

        private void OnCancelClick(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }
    }
}
