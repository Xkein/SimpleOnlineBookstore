using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace db_course
{
    /// <summary>
    /// Interaction logic for NormalUser.xaml
    /// </summary>
    public partial class NormalUser : Window
    {
        public NormalUser()
        {
            InitializeComponent();
            this.Title = General.User.Name;
        }

        private void ManageOrders_Click(object sender, RoutedEventArgs e)
        {
            ManageOrders manageOrders = new ManageOrders();
            manageOrders.Show();
        }

        private void ViewHistory_Click(object sender, RoutedEventArgs e)
        {
            ViewHistory viewHistory = new ViewHistory();
            viewHistory.Show();
        }

        private void ViewCollectedBooks_Click(object sender, RoutedEventArgs e)
        {
            ViewCollectedBooks viewCollectedBooks = new ViewCollectedBooks();
            viewCollectedBooks.Show();
        }

        private void Configure_Click(object sender, RoutedEventArgs e)
        {
            Configure configure = new Configure();
            configure.Show();
        }
    }
}
