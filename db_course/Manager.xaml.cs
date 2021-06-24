﻿using Core;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.ComponentModel;
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
    /// Interaction logic for Manager.xaml
    /// </summary>
    public partial class Manager : Window, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public Manager()
        {
            InitializeComponent();
            DataContext = this;
            this.Title = General.User.Name;
        }

        private string result;
        public string Result
        {
            get => result;
            set
            {
                result = value;
                OnPropertyChanged(nameof(Result));
            }
        }

        private void Create_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            button.IsEnabled = false;

            User manager = General.User;
            try
            {
                manager.Connect();
                manager.ExecuteNonQuery($"create user {tbUser.Text} identified by {tbPassword.Password}");
                manager.ExecuteNonQuery($"grant resource, connect to {tbUser.Text}");

                manager.ExecuteNonQuery(string.Format("insert into {0}(ID) values('{1}')", (bool)rbUser.IsChecked ? "用户" : "店铺", tbUser.Text));

                User user = new User(tbUser.Text, tbPassword.Password);
                if (user.Connect())
                {
                    user.CloseAndClearPool();
                    Result = "创建成功！";
                }
            }
            catch (OracleException ex)
            {
                Result = ex.Message;
            }
            finally
            {
                manager.Close();
            }

            button.IsEnabled = true;
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            button.IsEnabled = false;
            User manager = General.User;
            try
            {
                manager.Connect();
                manager.ExecuteNonQuery($"drop user {tbUser.Text} cascade");
                manager.ExecuteNonQuery(string.Format("delete from {0} where ID = '{1}'", (bool)rbUser.IsChecked ? "用户" : "店铺", tbUser.Text));
                Result = "删除成功！";
            }
            catch (OracleException ex)
            {
                Result = ex.Message;
                try
                {
                    manager.ExecuteNonQuery(string.Format("delete from {0} where ID = '{1}'", (bool)rbUser.IsChecked ? "用户" : "店铺", tbUser.Text));
                }
                catch (Exception)
                {
                }
            }
            finally
            {
                manager.Close();
            }

            button.IsEnabled = true;
        }

        private void Change_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            button.IsEnabled = false;

            User manager = General.User;
            try
            {
                manager.Connect();
                manager.ExecuteNonQuery($"alter user {tbUser.Text} identified by {tbPassword.Password}");

                User user = new User(tbUser.Text, tbPassword.Password);
                if (user.Connect())
                {
                    user.CloseAndClearPool();
                    Result = "修改成功！";
                }
            }
            catch (OracleException ex)
            {
                Result = ex.Message;
            }
            finally
            {
                manager.Close();
            }

            button.IsEnabled = true;
        }
    }
}
