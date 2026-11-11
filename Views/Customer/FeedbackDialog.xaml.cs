using System;
using System.Windows;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Customer
{
    public partial class FeedbackDialog : Window
    {
        private readonly int _classId;
        private readonly string _className;
        private readonly FeedbackService _feedbackService = new FeedbackService();
        public bool IsSubmitted { get; private set; } = false;

        public FeedbackDialog(int classId, string className, int? currentRating = null, string? currentComment = null)
        {
            InitializeComponent();
            _classId = classId;
            _className = className;
            TxtClassSubtitle.Text = $"Lớp học: {className}";

            if (currentRating.HasValue)
            {
                switch (currentRating.Value)
                {
                    case 1: RbStar1.IsChecked = true; break;
                    case 2: RbStar2.IsChecked = true; break;
                    case 3: RbStar3.IsChecked = true; break;
                    case 4: RbStar4.IsChecked = true; break;
                    case 5: RbStar5.IsChecked = true; break;
                }
            }

            if (!string.IsNullOrEmpty(currentComment))
            {
                TxtComment.Text = currentComment;
            }
        }

        private async void OnSubmitClick(object sender, RoutedEventArgs e)
        {
            var currentUser = AuthService.Instance.CurrentUser;
            if (currentUser == null)
            {
                ShowError("Vui lòng đăng nhập để gửi đánh giá.");
                return;
            }

            int rating = 5;
            if (RbStar1.IsChecked == true) rating = 1;
            else if (RbStar2.IsChecked == true) rating = 2;
            else if (RbStar3.IsChecked == true) rating = 3;
            else if (RbStar4.IsChecked == true) rating = 4;
            else if (RbStar5.IsChecked == true) rating = 5;

            string comment = TxtComment.Text.Trim();
            if (string.IsNullOrEmpty(comment))
            {
                ShowError("Vui lòng viết vài dòng nhận xét hoặc cảm nhận của bạn.");
                return;
            }

            try
            {
                BtnSubmit.IsEnabled = false;
                TxtError.Visibility = Visibility.Collapsed;

                var (success, msg) = await _feedbackService.SubmitFeedbackAsync(currentUser.Id, _classId, rating, comment);
                if (success)
                {
                    MessageBox.Show(msg, "Hoàn tất", MessageBoxButton.OK, MessageBoxImage.Information);
                    IsSubmitted = true;
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
                ShowError("Lỗi gửi phản hồi: " + ex.Message);
            }
            finally
            {
                BtnSubmit.IsEnabled = true;
            }
        }

        private void OnCancelClick(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        private void ShowError(string msg)
        {
            TxtError.Text = msg;
            TxtError.Visibility = Visibility.Visible;
        }
    }
}
