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
    /// Interaction logic for ManageOrders.xaml
    /// </summary>
    public partial class ManageOrders : Window
    {
        public ManageOrders()
        {
            InitializeComponent();

            User user = General.User;
            try
            {
                user.Connect();
                DataSet ds = user.ExecuteQuery($"select * from RG.订单 where 用户ID = '{user.ID}'");
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
    }
}
