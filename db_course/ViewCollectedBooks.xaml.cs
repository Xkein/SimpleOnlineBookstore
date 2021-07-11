using Core;
using System;
using System.Collections.Generic;
using System.Data;
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
    /// Interaction logic for ViewCollectedBooks.xaml
    /// </summary>
    public partial class ViewCollectedBooks : Window
    {
        public ViewCollectedBooks()
        {
            InitializeComponent();

            User user = General.User;
            try
            {
                user.Connect();
                DataSet ds = user.ExecuteQuery($"select * from RG.收藏 where 用户ID = '{user.ID}'");
                DataTable dt = ds.Tables["ds"];
                lvOrders.ItemsSource = dt.DefaultView;
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

        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            User user = General.User;
            try
            {
                var item = lvOrders.SelectedItem as DataRowView;
                if (item != null)
                {
                    user.Connect();
                    user.ExecuteNonQuery($"delete from RG.收藏 where 用户ID='{item[0]}'");
                    DataView dv = lvOrders.ItemsSource as DataView;
                    dv.Table.Rows.Remove(item.Row);
                }
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
