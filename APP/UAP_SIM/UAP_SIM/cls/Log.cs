using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;


namespace UAP_SIM
{
    class Log
    {
        public static void writelog(string value)
        {
            //this.value = value;
            string logname = "gdkhlog" + DateTime.Now.ToString("yyyyMMdd") + ".txt";
            string logfile = System.Environment.CurrentDirectory + "\\LOG\\" + logname;
            StreamWriter sw;
            if (File.Exists(logfile) == true)
            {
                sw = File.AppendText(logfile);
            }
            else
            {
                if (Directory.Exists(System.Environment.CurrentDirectory + "\\LOG") == false)//如果不存在就创建文件夹
{
                    Directory.CreateDirectory(System.Environment.CurrentDirectory + "\\LOG");
                }
                sw = File.CreateText(logfile);
            }
            try
            {
                sw.WriteLine(DateTime.Now + "： " + "{0}", value);
                sw.WriteLine("------------------------------");
                sw.Close();
            }
            catch (Exception ex)
            {
                sw.WriteLine("日志写入失败，" + ex.Message);
            }
        }
    }
}
