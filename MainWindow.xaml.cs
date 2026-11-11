using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Threading;
using SportCenterApp.Services;
using SportCenterApp.Views;
using SportCenterApp.Views.Coach;
using SportCenterApp.Views.Customer;
using SportCenterApp.Views.Manager;

namespace SportCenterApp
{
    public partial class MainWindow : Window
    {
        private ManagerDashboardView? _managerDashboardView;
        private CourseCatalogView? _courseCatalogView;
        private MyEnrollmentsView? _myEnrollmentsView;
        private CoachAttendanceView? _coachAttendanceView;
        private CoachFeedbackView? _coachFeedbackView;
        private DispatcherTimer? _clockTimer;

        public MainWindow()
        {
            InitializeComponent();
            Loaded += OnLoaded;
        }

        private void OnLoaded(object sender, RoutedEventArgs e)
        {
            StartClock();
            RefreshUserSession();
        }

        private void StartClock()
        {
            _clockTimer = new DispatcherTimer
            {
                Interval = TimeSpan.FromSeconds(1)
            };
            _clockTimer.Tick += (s, e) =>
            {
                TxtCurrentTime.Text = DateTime.Now.ToString("HH:mm:ss - dd/MM/yyyy");
            };
            _clockTimer.Start();
            TxtCurrentTime.Text = DateTime.Now.ToString("HH:mm:ss - dd/MM/yyyy");
        }

        public void RefreshUserSession()
        {
            var user = AuthService.Instance.CurrentUser;
            if (user == null)
            {
                // Fallback demo admin
                _ = AuthService.Instance.SwitchToDemoAccountAsync("ADMIN");
                user = AuthService.Instance.CurrentUser;
            }

            if (user == null) return;

            TxtUserName.Text = user.Name;
            TxtUserAvatar.Text = !string.IsNullOrEmpty(user.Name) ? user.Name[0].ToString().ToUpper() : "U";

            string role = user.Role.ToUpper();
            if (role == "ADMIN" || role == "RECEPTIONIST")
            {
                TxtRoleBadge.Text = role == "ADMIN" ? "👑 QUẢN LÝ (ADMIN)" : "💼 TIẾP TÂN (RECEPTIONIST)";
                BorderRoleBadge.Background = new SolidColorBrush(Color.FromRgb(219, 234, 254));
                TxtRoleBadge.Foreground = new SolidColorBrush(Color.FromRgb(29, 78, 216));

                PanelManagerNav.Visibility = Visibility.Visible;
                // Only ADMIN can create courses & classes
                BtnNavCreateClass.Visibility = role == "ADMIN" ? Visibility.Visible : Visibility.Collapsed;
                PanelCustomerNav.Visibility = Visibility.Visible;
                PanelCoachNav.Visibility = Visibility.Visible;

                SelectRoleCombo("ADMIN");
                NavigateToManagerDashboard();
            }
            else if (role == "COACH")
            {
                TxtRoleBadge.Text = "🥋 HUẤN LUYỆN VIÊN (COACH)";
                BorderRoleBadge.Background = new SolidColorBrush(Color.FromRgb(209, 250, 229));
                TxtRoleBadge.Foreground = new SolidColorBrush(Color.FromRgb(4, 120, 87));

                PanelManagerNav.Visibility = Visibility.Collapsed;
                // Coach CANNOT see member / customer tasks
                PanelCustomerNav.Visibility = Visibility.Collapsed;
                PanelCoachNav.Visibility = Visibility.Visible;

                SelectRoleCombo("COACH");
                NavigateToCoachAttendance();
            }
            else // MEMBER / CUSTOMER
            {
                TxtRoleBadge.Text = "🏃 HỌC VIÊN (CUSTOMER)";
                BorderRoleBadge.Background = new SolidColorBrush(Color.FromRgb(254, 243, 199));
                TxtRoleBadge.Foreground = new SolidColorBrush(Color.FromRgb(180, 83, 9));

                PanelManagerNav.Visibility = Visibility.Collapsed;
                PanelCustomerNav.Visibility = Visibility.Visible;
                PanelCoachNav.Visibility = Visibility.Collapsed;

                SelectRoleCombo("CUSTOMER");
                NavigateToCustomerCatalog();
            }
        }

        private void SelectRoleCombo(string roleTag)
        {
            foreach (ComboBoxItem item in CmbSwitchRole.Items)
            {
                if (item.Tag?.ToString() == roleTag)
                {
                    CmbSwitchRole.SelectedItem = item;
                    break;
                }
            }
        }

        private async void OnSwitchRoleChanged(object sender, SelectionChangedEventArgs e)
        {
            if (CmbSwitchRole.SelectedItem is ComboBoxItem item && item.Tag is string tag)
            {
                var curUser = AuthService.Instance.CurrentUser;
                if (curUser != null && curUser.Role.Equals(tag, StringComparison.OrdinalIgnoreCase))
                {
                    return; // Already this role
                }

                await AuthService.Instance.SwitchToDemoAccountAsync(tag);
                RefreshUserSession();
            }
        }

        #region Navigation Handlers
        private void SetActiveNavButton(Button? activeButton)
        {
            var navButtons = new[]
            {
                BtnNavManagerDashboard,
                BtnNavCreateClass,
                BtnNavCustomerCatalog,
                BtnNavCustomerEnrollments,
                BtnNavCoachAttendance,
                BtnNavCoachFeedback
            };

            var primaryStyle = (Style)FindResource("PrimaryButtonStyle");
            var outlineStyle = (Style)FindResource("OutlineButtonStyle");

            foreach (var btn in navButtons)
            {
                if (btn == null) continue;
                btn.Style = (btn == activeButton) ? primaryStyle : outlineStyle;
            }
        }

        private void RestoreActiveNavFromCurrentView()
        {
            if (MainContentArea.Content is ManagerDashboardView)
                SetActiveNavButton(BtnNavManagerDashboard);
            else if (MainContentArea.Content is CourseCatalogView)
                SetActiveNavButton(BtnNavCustomerCatalog);
            else if (MainContentArea.Content is MyEnrollmentsView)
                SetActiveNavButton(BtnNavCustomerEnrollments);
            else if (MainContentArea.Content is CoachAttendanceView)
                SetActiveNavButton(BtnNavCoachAttendance);
            else if (MainContentArea.Content is CoachFeedbackView)
                SetActiveNavButton(BtnNavCoachFeedback);
            else
                SetActiveNavButton(null);
        }

        private void OnNavManagerDashboardClick(object sender, RoutedEventArgs e) => NavigateToManagerDashboard();
        private void OnNavCustomerCatalogClick(object sender, RoutedEventArgs e)
        {
            if (AuthService.Instance.IsCoach)
            {
                MessageBox.Show("Huấn luyện viên không có quyền truy cập tác vụ của học viên.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            NavigateToCustomerCatalog();
        }

        private void OnNavCustomerEnrollmentsClick(object sender, RoutedEventArgs e)
        {
            if (AuthService.Instance.IsCoach)
            {
                MessageBox.Show("Huấn luyện viên không có quyền truy cập tác vụ của học viên.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            NavigateToCustomerEnrollments();
        }

        private void OnNavCoachAttendanceClick(object sender, RoutedEventArgs e) => NavigateToCoachAttendance();
        private void OnNavCoachFeedbackClick(object sender, RoutedEventArgs e) => NavigateToCoachFeedback();

        private void NavigateToManagerDashboard()
        {
            SetActiveNavButton(BtnNavManagerDashboard);
            _managerDashboardView ??= new ManagerDashboardView();
            MainContentArea.Content = _managerDashboardView;
            TxtActiveViewTitle.Text = "Quản Lý Khóa Học & Báo Cáo Tổng Quan";
            _ = _managerDashboardView.LoadDataAsync();
        }

        private void NavigateToCustomerCatalog()
        {
            SetActiveNavButton(BtnNavCustomerCatalog);
            _courseCatalogView ??= new CourseCatalogView();
            MainContentArea.Content = _courseCatalogView;
            TxtActiveViewTitle.Text = "Khám Phá & Đặt Khóa Học Thể Thao";
            _ = _courseCatalogView.LoadDataAsync();
        }

        private void NavigateToCustomerEnrollments()
        {
            SetActiveNavButton(BtnNavCustomerEnrollments);
            _myEnrollmentsView ??= new MyEnrollmentsView();
            MainContentArea.Content = _myEnrollmentsView;
            TxtActiveViewTitle.Text = "Khóa Học Đã Đăng Ký & Đánh Giá Phản Hồi";
            _ = _myEnrollmentsView.LoadDataAsync();
        }

        private void NavigateToCoachAttendance()
        {
            SetActiveNavButton(BtnNavCoachAttendance);
            _coachAttendanceView ??= new CoachAttendanceView();
            MainContentArea.Content = _coachAttendanceView;
            TxtActiveViewTitle.Text = "Điểm Danh Học Viên Các Lớp Phụ Trách";
            _ = _coachAttendanceView.LoadSessionsAsync();
        }

        private void NavigateToCoachFeedback()
        {
            SetActiveNavButton(BtnNavCoachFeedback);
            _coachFeedbackView ??= new CoachFeedbackView();
            MainContentArea.Content = _coachFeedbackView;
            TxtActiveViewTitle.Text = "Phản Hồi & Đánh Giá Từ Học Viên";
            _ = _coachFeedbackView.LoadFeedbacksAsync();
        }

        private async void OnNavCreateClassClick(object sender, RoutedEventArgs e)
        {
            if (!AuthService.Instance.IsAdmin)
            {
                MessageBox.Show("Chỉ có tài khoản Quản trị viên (ADMIN) mới có quyền tạo khóa học & mở lớp học!", "Từ chối quyền truy cập", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            SetActiveNavButton(BtnNavCreateClass);

            var dialog = new CreateClassDialog
            {
                Owner = this
            };

            if (dialog.ShowDialog() == true && dialog.IsCreated)
            {
                if (MainContentArea.Content is ManagerDashboardView mg)
                {
                    await mg.LoadDataAsync();
                    SetActiveNavButton(BtnNavManagerDashboard);
                }
                else
                {
                    NavigateToManagerDashboard();
                }
            }
            else
            {
                RestoreActiveNavFromCurrentView();
            }
        }

        private void OnLogoutClick(object sender, RoutedEventArgs e)
        {
            _clockTimer?.Stop();
            AuthService.Instance.Logout();

            var loginWin = new LoginWindow();
            loginWin.Show();
            this.Close();
        }
        #endregion
    }
}
