using System;
using System.Windows;
using SportCenterApp.Services;

namespace SportCenterApp.Views
{
    public partial class LoginWindow : Window
    {
        public LoginWindow()
        {
            InitializeComponent();
            TxtPassword.Password = "123456";
        }

        private async void OnQuickManagerClick(object sender, RoutedEventArgs e)
        {
            TxtEmail.Text = "demo.admin@sportcenter.test";
            TxtPassword.Password = "123456";
            await PerformQuickLogin("ADMIN");
        }

        private async void OnQuickCoachClick(object sender, RoutedEventArgs e)
        {
            TxtEmail.Text = "demo.coach1@sportcenter.test";
            TxtPassword.Password = "123456";
            await PerformQuickLogin("COACH");
        }

        private async void OnQuickCustomerClick(object sender, RoutedEventArgs e)
        {
            TxtEmail.Text = "demo.member1@sportcenter.test";
            TxtPassword.Password = "123456";
            await PerformQuickLogin("CUSTOMER");
        }

        private async System.Threading.Tasks.Task PerformQuickLogin(string role)
        {
            try
            {
                BtnLogin.IsEnabled = false;
                BorderError.Visibility = Visibility.Collapsed;
                await AuthService.Instance.SwitchToDemoAccountAsync(role);

                if (AuthService.Instance.IsLoggedIn)
                {
                    OpenMainWindow();
                }
                else
                {
                    ShowError($"Không thể kích hoạt tài khoản {role}. Vui lòng kiểm tra kết nối CSDL.");
                }
            }
            catch (Exception ex)
            {
                ShowError("Lỗi kết nối cơ sở dữ liệu: " + ex.Message);
            }
            finally
            {
                BtnLogin.IsEnabled = true;
            }
        }

        private async void OnLoginClick(object sender, RoutedEventArgs e)
        {
            string email = TxtEmail.Text.Trim();
            string password = TxtPassword.Password;

            if (string.IsNullOrEmpty(email))
            {
                ShowError("Vui lòng nhập Email.");
                return;
            }

            try
            {
                BtnLogin.IsEnabled = false;
                BorderError.Visibility = Visibility.Collapsed;

                var result = await AuthService.Instance.LoginAsync(email, password);
                if (result.Success)
                {
                    OpenMainWindow();
                }
                else
                {
                    ShowError(result.Message);
                }
            }
            catch (Exception ex)
            {
                ShowError("Lỗi đăng nhập: " + ex.Message);
            }
            finally
            {
                BtnLogin.IsEnabled = true;
            }
        }

        private void OpenMainWindow()
        {
            var mainWin = new MainWindow();
            mainWin.Show();
            this.Close();
        }

        private void ShowError(string msg)
        {
            TxtError.Text = msg;
            BorderError.Visibility = Visibility.Visible;
        }
    }
}
