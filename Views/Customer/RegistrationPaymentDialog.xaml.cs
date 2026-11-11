using System;
using System.Windows;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Customer
{
    public partial class RegistrationPaymentDialog : Window
    {
        private readonly ClassDisplayItem _classItem;
        private readonly RegistrationService _regService = new RegistrationService();
        public bool IsSuccess { get; private set; } = false;

        public RegistrationPaymentDialog(ClassDisplayItem classItem)
        {
            InitializeComponent();
            _classItem = classItem;
            PopulateData();
        }

        private void PopulateData()
        {
            TxtClassName.Text = _classItem.ClassName;
            TxtSportCourse.Text = $"{_classItem.SportName} • {_classItem.CourseName}";
            TxtCoachName.Text = _classItem.CoachName;
            TxtSchedule.Text = _classItem.DateRangeDisplay;
            TxtOriginalPrice.Text = _classItem.PriceFormatted;
            TxtFinalPrice.Text = _classItem.PriceFormatted;
        }

        private void OnPaymentMethodChanged(object sender, RoutedEventArgs e)
        {
            if (BorderQrBox != null)
            {
                BorderQrBox.Visibility = (RbQr.IsChecked == true) ? Visibility.Visible : Visibility.Collapsed;
            }
        }

        private async void OnConfirmPayClick(object sender, RoutedEventArgs e)
        {
            var currentUser = AuthService.Instance.CurrentUser;
            if (currentUser == null)
            {
                ShowError("Vui lòng đăng nhập lại để thanh toán.");
                return;
            }

            string method = "ONLINE";
            if (RbQr.IsChecked == true) method = "QR_TRANSFER";
            else if (RbCounter.IsChecked == true) method = "COUNTER";

            string note = TxtNote.Text.Trim();

            try
            {
                BtnConfirmPay.IsEnabled = false;
                TxtError.Visibility = Visibility.Collapsed;

                var (success, msg, receipt) = await _regService.RegisterAndPayAsync(currentUser.Id, _classItem.Id, method, note);

                if (success && receipt != null)
                {
                    MessageBox.Show(
                        $"ĐĂNG KÝ VÀ THANH TOÁN THÀNH CÔNG!\n\n" +
                        $"• Khóa học: {receipt.ClassName}\n" +
                        $"• Huấn luyện viên: {receipt.CoachName}\n" +
                        $"• Số tiền: {receipt.Amount:N0} VNĐ\n" +
                        $"• Phương thức: {receipt.Method}\n" +
                        $"• Mã giao dịch: {receipt.TransactionCode}\n" +
                        $"• Thời gian: {receipt.PaidAt:dd/MM/yyyy HH:mm:ss}\n\n" +
                        "Chúc bạn có những buổi tập luyện hiệu quả và năng động tại Sport Center!",
                        "Thanh Toán Hoàn Tất",
                        MessageBoxButton.OK,
                        MessageBoxImage.Information);

                    IsSuccess = true;
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
                ShowError("Lỗi xử lý giao dịch: " + ex.Message);
            }
            finally
            {
                BtnConfirmPay.IsEnabled = true;
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
