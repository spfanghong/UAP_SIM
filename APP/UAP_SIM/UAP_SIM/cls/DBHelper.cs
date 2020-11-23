using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace UAP_SIM
{
    class DBHelper
    {
        public string CnString = "";
        public OracleConnection cn = new OracleConnection(); 
        public long ConnectOracleDB()
        {
            //连接断开或者连接字符串发生变化了 
            if (CnString != cn.ConnectionString || cn.State == ConnectionState.Closed)
            {
                try
                {
                    cn.Close();
                    cn.ConnectionString =  CnString;
                    cn.Open();
                }
                catch (Exception ex)
                {
                    Log.writelog("链接数据库发生错误：" + ex.Message + "\r\n");

                    return -1;
                }
            }
            return 0;
        }

        /// <summary>
        /// 执行UAP指令，模拟回报返回
        /// </summary>
        /// <param name="ServiceCode"></param>
        /// <param name="inputPar"></param>
        /// <returns></returns>
        public DataTable UAPCommand (string ServiceCode, Dictionary<string, string> inputPar)
        {

            OracleParameter[] par = new OracleParameter[inputPar.Count + 1 -1 ];//约定，所有的UAP逻辑存储过程第一个参数均为输出参数，名称固定retCursor，且为游标类型 但是数据集最后有一个rowid字段是不需要传递给存储过程的
            par[0] = new OracleParameter("retCursor", OracleDbType.RefCursor, ParameterDirection.Output);
            int i = 0;
            string log = ServiceCode + ":   ";
            foreach (string key in inputPar.Keys)
            {
                //
                if (key != "ROWID")
                {
                    par[i + 1] = new OracleParameter("AC_I_" + key, OracleDbType.NVarchar2, ParameterDirection.Input);
                    par[i + 1].Value = (inputPar[key]);
                    log = log + key + "=" + par[i + 1].Value + "; ";
                    i++;
                }
                
                
            
            }
            Log.writelog(log);
            try
            {
                DataTable re = GetDataTable(cn, ServiceCode, CommandType.StoredProcedure, par);
                return re;
            }
            catch (Exception ex)
            {
                Log.writelog(ServiceCode + "处理错误：" + ex.Message);
                return null;
            }

        }
        /// <summary>
        /// 根据接口类型及编号获取接口输入输出字段信息
        /// </summary>
        /// <param name="ServiceName"></param>
        /// <param name="ServiceType"></param>
        /// <param name="ServiecDirct"></param>
        /// <returns></returns>
        public DataTable UAPGetIOInfo(string ServiceName , string ServiceType , string ServiecDirct = "1")
        {
            string SQL = "select * from UAP_SIM.Cfg_Jkinfo where SVR_NAME =:ServiceName and SVR_TYPE =:ServiceType and SVR_DIRECT =:ServiecDirct order by svr_direct";
            OracleParameter[] PARS = { new OracleParameter(":ServiceName", ServiceName), new OracleParameter(":ServiceType", ServiceType), new OracleParameter(":ServiecDirct", ServiecDirct) };
            DataTable DTRET = ExecuteDataTable(SQL, PARS);
            return DTRET;
        }
        
        /// <summary>
        /// 获取已经实现的存储过程。利用此来确定哪些服务已经实现支持
        /// </summary>
        /// <param name="ServiceType"></param>
        /// <returns></returns>
        public DataTable UAPGetSRVInfo()
        {
            string SQL = "select object_name from user_procedures";
            DataTable DTRET = ExecuteDataTable(SQL);
            return DTRET;
        }

        #region 执行SQL语句,返回受影响行数
        public  int ExecuteNonQuery(string sql, params OracleParameter[] parameters)
        {
                using (OracleCommand cmd = cn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    cmd.Parameters.AddRange(parameters);
                    return cmd.ExecuteNonQuery();
                }
        }
        #endregion
        #region 执行SQL语句,返回DataTable;只用来执行查询结果比较少的情况
        public  DataTable ExecuteDataTable(string sql, params OracleParameter[] parameters)
        {
                using (OracleCommand cmd = cn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    cmd.Parameters.AddRange(parameters);
                    OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                    DataTable datatable = new DataTable();
                    adapter.Fill(datatable);
                    return datatable;
                }
        }
        #endregion

        /// <summary>
        /// 执行存储过程
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="commandType"></param>
        /// <param name="opar"></param>
        /// <returns></returns>
        public DataTable GetDataTable(OracleConnection cn, string sql, CommandType commandType, params OracleParameter[] opar)
        {
            DataTable dt = new DataTable();
            using (OracleDataAdapter dap = new OracleDataAdapter(sql, cn))
            {
                dap.SelectCommand.Parameters.AddRange(opar);
                dap.SelectCommand.CommandType = commandType;
                dap.Fill(dt);
            }
            return dt;
        }
    }
}
