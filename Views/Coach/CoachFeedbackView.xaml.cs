using System;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Coach
{
    public partial class CoachFeedbackView : UserControl
    {
        private readonly FeedbackService _feedbackService = new FeedbackService();

        public CoachFeedbackView()
        {
            InitializeComponent();
            Loaded += async (s, e) => await LoadFeedbacksAsync();
        }

        public async Task LoadFeedbacksAsync()
        {
            var currentUser = AuthService.Instance.CurrentUser;
            if (currentUser == null) return;

            try
            {
                var list = await _feedbackService.GetFeedbacksForCoachAsync(currentUser.Id);
                IcCoachFeedbacks.ItemsSource = list;
                TxtNoFeedback.Visibility = list.Count == 0 ? Visibility.Visible : Visibility.Collapsed;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải đánh giá của học viên: " + ex.Message, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async void OnRefreshClick(object sender, RoutedEventArgs e)
        {
            await LoadFeedbacksAsync();
        }
    }
}
