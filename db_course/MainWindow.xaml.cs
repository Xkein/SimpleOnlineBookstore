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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace db_course
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        protected override void OnActivated(EventArgs e)
        {
            base.OnActivated(e);

            if (General.User is null)
            {
                Login login = new Login();
                login.Closed += Login_Closed;
                login.ShowDialog();
            }
        }

        private void Login_Closed(object sender, EventArgs e)
        {
            if(General.User is null)
            {
                this.Close();
                return;
            }

            switch (General.User.GetUserType())
            {
                case UserType.StoreManager:
                    StoreManager storeManager = new StoreManager();
                    storeManager.Show();
                    this.Close();
                    break;
                case UserType.NormalUser:
                    NormalUser normalUser = new NormalUser();
                    normalUser.Show();
                    this.Close();
                    break;
                case UserType.Manager:
                    Manager manager = new Manager();
                    manager.ShowDialog();
                    General.User.CloseAndClearPool();
                    General.User = null;
                    break;
                default:
                    MessageBox.Show("未知用户！");
                    break;
            }
        }
    }
}
