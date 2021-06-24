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
        }

        public UserType UserType { get; }
    }
}
