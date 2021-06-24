using Core;
using Oracle.ManagedDataAccess.Client;
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
    /// Interaction logic for ManageActivities.xaml
    /// </summary>
    public partial class ManageActivities : Window
    {
        public ManageActivities()
        {
            InitializeComponent();

            User user = General.User;
            try
            {
                user.Connect();
                DataSet ds = user.ExecuteQuery($"select * from RG.活动 where 店铺ID = '{user.ID}'");
                DataTable dt = ds.Tables["ds"];
                lvOrders.ItemsSource = dt.DefaultView;
                dt.RowChanging += Dt_RowChanging;
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

        protected override void OnActivated(EventArgs e)
        {
            base.OnActivated(e);
        }

        private void Dt_RowChanging(object sender, DataRowChangeEventArgs e)
        {
            if (e.Action == DataRowAction.Change)
            {
                User user = General.User;
                try
                {
                    user.Connect();
                    var row = e.Row;

                    user.ExecuteNonQuery(
                        $"update RG.活动 set " +
                        $"活动时间=:活动时间," +
                        $"活动描述='{row[3]}'," +
                        $"优惠形式='{row[4]}'," +
                        $"折扣=:折扣" +
                        $" where ID = '{row[0]}'",
                        new OracleParameter(":活动时间", OracleDbType.Date) { Value = row[2] },
                        new OracleParameter(":折扣", OracleDbType.Single) { Value = row[5] });

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

        private void Update_Click(object sender, RoutedEventArgs e)
        {
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
                    user.ExecuteNonQuery($"delete from RG.活动 where ID='{item}'");
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

        private void New_Click(object sender, RoutedEventArgs e)
        {
            User user = General.User;
            try
            {
                user.Connect();
                user.ExecuteNonQuery($"insert into RG.活动(ID, 店铺ID) values('{tbID.Text}', '{user.ID}')");
                DataSet ds = user.ExecuteQuery($"select * from RG.活动 where ID='{tbID.Text}' and 店铺ID='{user.ID}'");
                DataRowView newItem = ds.Tables["ds"].DefaultView[0];

                DataView dv = lvOrders.ItemsSource as DataView;
                dv.Table.ImportRow(newItem.Row);
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
