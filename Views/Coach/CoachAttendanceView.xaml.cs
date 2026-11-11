using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Coach
{
    public partial class CoachAttendanceView : UserControl
    {
        private readonly AttendanceService _attendanceService = new AttendanceService();
        private List<StudentAttendanceItem> _currentItems = new List<StudentAttendanceItem>();

        public CoachAttendanceView()
        {
            InitializeComponent();
            Loaded += async (s, e) => await LoadSessionsAsync();
        }

        public async Task LoadSessionsAsync()
        {
            var currentUser = AuthService.Instance.CurrentUser;
            if (currentUser == null) return;

            try
            {
                var sessions = await _attendanceService.GetSessionsForUserAsync(currentUser);
                CmbSessions.ItemsSource = sessions;

                if (sessions.Count > 0)
                {
                    CmbSessions.SelectedIndex = 0;
                }
                else
                {
                    TxtSessionDetails.Text = "Không có buổi học nào được giao hoặc chưa tạo lịch.";
                    TxtAttendanceStats.Text = "Vui lòng liên hệ Quản lý để kiểm tra lịch lớp.";
                    DgAttendance.ItemsSource = null;
                    TxtNoStudents.Visibility = Visibility.Visible;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải lịch buổi học: " + ex.Message, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async void OnSessionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (CmbSessions.SelectedItem is SessionSelectOption option)
            {
                TxtSessionDetails.Text = $"Lớp: {option.ClassName} | Thời gian: {option.StartTime:dd/MM/yyyy HH:mm} - {option.EndTime:HH:mm} ({option.Status})";
                await LoadStudentsAsync(option.SessionId);
            }
        }

        private async Task LoadStudentsAsync(int sessionId)
        {
            try
            {
                _currentItems = await _attendanceService.GetAttendanceSheetAsync(sessionId);
                DgAttendance.ItemsSource = _currentItems;

                int total = _currentItems.Count;
                int present = _currentItems.Count(i => i.Status == "PRESENT");
                TxtAttendanceStats.Text = $"Sĩ số lớp: {total} học viên | Đã đánh dấu có mặt: {present}/{total}";
                TxtNoStudents.Visibility = total == 0 ? Visibility.Visible : Visibility.Collapsed;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải danh sách học viên: " + ex.Message, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void OnMarkAllPresentClick(object sender, RoutedEventArgs e)
        {
            if (_currentItems == null || _currentItems.Count == 0) return;

            foreach (var item in _currentItems)
            {
                item.Status = "PRESENT";
            }

            DgAttendance.Items.Refresh();
            TxtAttendanceStats.Text = $"Sĩ số lớp: {_currentItems.Count} học viên | Đã đánh dấu có mặt: {_currentItems.Count}/{_currentItems.Count}";
        }

        private async void OnSaveAttendanceClick(object sender, RoutedEventArgs e)
        {
            if (CmbSessions.SelectedValue == null)
            {
                MessageBox.Show("Vui lòng chọn một buổi học.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            int sessionId = (int)CmbSessions.SelectedValue;
            var currentUser = AuthService.Instance.CurrentUser;
            if (currentUser == null) return;

            if (_currentItems == null || _currentItems.Count == 0)
            {
                MessageBox.Show("Không có học viên nào trong lớp này để lưu điểm danh.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                BtnSaveAttendance.IsEnabled = false;

                var (success, msg) = await _attendanceService.SaveAttendanceAsync(sessionId, currentUser.Id, _currentItems);
                if (success)
                {
                    MessageBox.Show(msg, "Điểm Danh Thành Công", MessageBoxButton.OK, MessageBoxImage.Information);
                    await LoadStudentsAsync(sessionId);
                }
                else
                {
                    MessageBox.Show(msg, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi lưu điểm danh: " + ex.Message, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            finally
            {
                BtnSaveAttendance.IsEnabled = true;
            }
        }

        private async void OnRefreshClick(object sender, RoutedEventArgs e)
        {
            await LoadSessionsAsync();
        }
    }
}
