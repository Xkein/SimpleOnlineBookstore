using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using Oracle.ManagedDataAccess;
using Oracle.ManagedDataAccess.Types;
using Oracle.ManagedDataAccess.Client;


namespace Core
{
    public enum UserType
    {
        Unknown, StoreManager, NormalUser, Manager
    }
    public class User
    {
        public User(string id, string password)
        {
            string dataSource = "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=COURSE)))";
            string connectionStr = string.Format(
                "DATA SOURCE={2};" +
                "USER ID={0};" +
                "password={1}", id, password, dataSource);
            Connection = new OracleConnection(connectionStr);
            ID = id.ToUpper();
        }

        public OracleConnection Connection { get; private set; }
        public string ID { get; }
        public string Name
        {
            get
            {
                switch (GetUserType())
                {
                    case UserType.StoreManager:
                        return "店铺管理员" + ID;
                    case UserType.NormalUser:
                        return "用户" + ID;
                    case UserType.Manager:
                        return "管理员" + ID;
                    default:
                        return ID;
                }
            }
        }

        public UserType GetUserType()
        {
            try
            {
                Connect();
                if (ExecuteScalar($"select * from RG.用户 where ID = '{ID}'") != null)
                {
                    return UserType.NormalUser;
                }
                if (ExecuteScalar($"select * from RG.店铺 where ID = '{ID}'") != null)
                {
                    return UserType.StoreManager;
                }
                return UserType.Manager;
            }
            catch (Exception)
            {
                return UserType.Unknown;
            }
            finally
            {
                Close();
            }
        }

        public bool Connect()
        {
            Connection.Open();
            return Connection.State != ConnectionState.Closed;
        }

        public bool Close()
        {
            if(Connection.State != ConnectionState.Closed)
            {
                Connection.Close();
            }
            return Connection.State == ConnectionState.Closed;
        }

        public bool CloseAndClearPool()
        {
            bool ret = Close();
            OracleConnection.ClearPool(Connection);
            return ret;
        }

        public OracleCommand CreateCommand(string cmdText, OracleParameter[] cmdParms = null, CommandType cmdType = CommandType.Text, OracleTransaction trans = null)
        {
            OracleCommand cmd = Connection.CreateCommand();
            cmd.CommandText = cmdText;
            if(cmdParms != null && cmdParms.Length > 0)
            {
                cmd.Parameters.AddRange(cmdParms);
            }
            cmd.Transaction = trans;
            cmd.CommandType = cmdType;
            return cmd;
        }

        public int ExecuteNonQuery(string sqlCmd, params OracleParameter[] cmdParms)
        {
            OracleCommand cmd = CreateCommand(sqlCmd, cmdParms);
            return cmd.ExecuteNonQuery();
        }

        public OracleDataReader ExecuteReader(string sqlCmd, params OracleParameter[] cmdParms)
        {
            OracleCommand cmd = CreateCommand(sqlCmd, cmdParms);
            OracleDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            cmd.Parameters.Clear();
            return reader;
        }

        public object ExecuteScalar(string sqlCmd, params OracleParameter[] cmdParms)
        {
            OracleCommand cmd = CreateCommand(sqlCmd, cmdParms);
            object obj = cmd.ExecuteScalar();
            cmd.Parameters.Clear();
            return Object.Equals(obj, System.DBNull.Value) ? null : obj;
        }

        public DataSet ExecuteQuery(string sqlCmd, params OracleParameter[] cmdParms)
        {
            OracleCommand cmd = CreateCommand(sqlCmd, cmdParms);
            using (OracleDataAdapter adapter = new OracleDataAdapter(cmd))
            {
                DataSet ds = new DataSet();
                adapter.Fill(ds, "ds");
                cmd.Parameters.Clear();
                return ds;
            }
        }

        public DataSet ExecuteProcedure(string procName, params OracleParameter[] cmdParms)
        {
            OracleCommand cmd = CreateCommand(procName, cmdParms, CommandType.StoredProcedure);
            using (OracleDataAdapter adapter = new OracleDataAdapter(cmd))
            {
                DataSet ds = new DataSet();
                adapter.SelectCommand = cmd;
                adapter.Fill(ds, "ds");
                return ds;
            }
        }
    }
}
