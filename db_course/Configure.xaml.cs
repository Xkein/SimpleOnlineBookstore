using Core;
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
    /// Interaction logic for Configure.xaml
    /// </summary>
    public partial class Configure : Window
    {
        public Configure()
        {
            InitializeComponent();
            DataContext = this;

            UserType = General.User.GetUserType();
            cnvStoreConfig.Visibility = UserType == UserType.StoreManager ? Visibility.Visible : Visibility.Collapsed;
        }

        public UserType UserType { get; }

        private void Save_Click(object sender, RoutedEventArgs e)
        {
            User user = General.User;
            try
            {
                user.Connect();

                user.ExecuteNonQuery(
                    $"update RG.店铺 set " +
                    $"所在地址='{tbAddress.Text}'," +
                    $"店铺描述='{tbDesc.Text}'" +
                    $" where ID = '{user.ID}'");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                user.Close();
            }
        }
    }
}
