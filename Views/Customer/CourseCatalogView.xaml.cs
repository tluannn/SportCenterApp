using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using Microsoft.EntityFrameworkCore;
using SportCenterApp.Data;
using SportCenterApp.Services;

namespace SportCenterApp.Views.Customer
{
    public partial class CourseCatalogView : UserControl
    {
        private readonly ClassService _classService = new ClassService();
        private List<ClassDisplayItem> _classes = new List<ClassDisplayItem>();

        public CourseCatalogView()
        {
            InitializeComponent();
            Loaded += async (s, e) => await LoadDataAsync();
        }

        public async Task LoadDataAsync()
        {
            try
            {
                _classes = await _classService.GetAllClassesAsync();

                // Populate sports filter
                using var db = new SportCenterDbContext();
                var sports = await db.Sports.Where(s => s.Status == "ACTIVE").ToListAsync();

                CmbSportFilter.Items.Clear();
                CmbSportFilter.Items.Add(new ComboBoxItem { Content = "Tất cả môn thể thao", IsSelected = true });
                foreach (var s in sports)
                {
                    CmbSportFilter.Items.Add(new ComboBoxItem { Content = s.Name });
                }

                ApplyFilter();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải danh mục lớp học: " + ex.Message, "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ApplyFilter()
        {
            if (IcClasses == null || _classes == null) return;

            string query = TxtSearch?.Text?.Trim().ToLower() ?? string.Empty;
            string selectedSport = (CmbSportFilter?.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "Tất cả môn thể thao";

            var filtered = _classes.AsEnumerable();

            if (!string.IsNullOrEmpty(query))
            {
                filtered = filtered.Where(c =>
                    c.ClassName.ToLower().Contains(query) ||
                    c.SportName.ToLower().Contains(query) ||
                    c.CourseName.ToLower().Contains(query) ||
                    c.CoachName.ToLower().Contains(query));
            }

            if (!selectedSport.StartsWith("Tất cả"))
            {
                filtered = filtered.Where(c => c.SportName.Equals(selectedSport, StringComparison.OrdinalIgnoreCase));
            }

            IcClasses.ItemsSource = filtered.ToList();
        }

        private void OnSearchTextChanged(object sender, TextChangedEventArgs e)
        {
            if (TxtSearchPlaceholder != null)
            {
                TxtSearchPlaceholder.Visibility = string.IsNullOrEmpty(TxtSearch.Text) ? Visibility.Visible : Visibility.Collapsed;
            }
            ApplyFilter();
        }

        private void OnSportFilterChanged(object sender, SelectionChangedEventArgs e)
        {
            ApplyFilter();
        }

        private async void OnRefreshClick(object sender, RoutedEventArgs e)
        {
            await LoadDataAsync();
        }

        private async void OnRegisterClassClick(object sender, RoutedEventArgs e)
        {
            if (sender is Button btn && btn.Tag is ClassDisplayItem classItem)
            {
                var dialog = new RegistrationPaymentDialog(classItem)
                {
                    Owner = Window.GetWindow(this)
                };

                if (dialog.ShowDialog() == true && dialog.IsSuccess)
                {
                    await LoadDataAsync();
                }
            }
        }
    }
}
