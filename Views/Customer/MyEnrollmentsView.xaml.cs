using System;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Customer
{
    public partial class MyEnrollmentsView : UserControl
    {
        private readonly RegistrationService _regService = new RegistrationService();

        public MyEnrollmentsView()
        {
            InitializeComponent();
            Loaded += async (s, e) => await LoadDataAsync();
        }

        public async Task LoadDataAsync()
        {
            var currentUser = AuthService.Instance.CurrentUser;
            if (currentUser == null) return;

            try
            {
                var list = await _regService.GetMemberEnrollmentsAsync(currentUser.Id);
                DgEnrollments.ItemsSource = list;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải danh sách khóa học của bạn: " + ex.Message, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async void OnRefreshClick(object sender, RoutedEventArgs e)
        {
            await LoadDataAsync();
        }

        private async void OnOpenFeedbackClick(object sender, RoutedEventArgs e)
        {
            if (sender is Button btn && btn.Tag is EnrollmentDisplayItem item)
            {
                var dialog = new FeedbackDialog(item.ClassId, item.ClassName, item.FeedbackRating, item.FeedbackComment)
                {
                    Owner = Window.GetWindow(this)
                };

                if (dialog.ShowDialog() == true && dialog.IsSubmitted)
                {
                    await LoadDataAsync();
                }
            }
        }
    }
}
