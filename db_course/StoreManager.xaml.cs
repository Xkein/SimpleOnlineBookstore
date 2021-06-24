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
    /// Interaction logic for StoreManager.xaml
    /// </summary>
    public partial class StoreManager : Window
    {
        public StoreManager()
        {
            InitializeComponent();
            this.Title = General.User.Name;
        }

        private void ManageActivities_Click(object sender, RoutedEventArgs e)
        {
            ManageActivities manageActivities = new ManageActivities();
            manageActivities.Show();
        }

        private void ManageBooks_Click(object sender, RoutedEventArgs e)
        {
            ManageBooks manageBooks = new ManageBooks();
            manageBooks.Show();
        }

        private void Configure_Click(object sender, RoutedEventArgs e)
        {
            Configure configure = new Configure();
            configure.Show();
        }
    }
}
