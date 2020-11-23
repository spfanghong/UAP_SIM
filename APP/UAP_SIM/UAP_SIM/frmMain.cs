using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Reflection;
using Oracle.ManagedDataAccess.Client;

namespace UAP_SIM
{
    public partial class frmMain : Form
    {
        DBHelper DBH = new DBHelper();
        Dictionary<string,string> SrvInfo = new Dictionary<string,string>();
        int intstartLin = 1;
        public frmMain()
        {
            InitializeComponent();
        }
        
        private void btnUAPPath_Click(object sender, EventArgs e)
        {
            this.folderBrowserDialog1.SelectedPath = "C:\\";
            if (this.folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                this.txtUAPPath.Text = this.folderBrowserDialog1.SelectedPath;
            }
        }

        private void btnUAPBusiFilePath_Click(object sender, EventArgs e)
        {
            this.folderBrowserDialog1.SelectedPath = "C:\\";
            if (this.folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                this.txtFilePath.Text = this.folderBrowserDialog1.SelectedPath;
            }
        }

        private void frmMain_Load(object sender, EventArgs e)
        {
            this.Text ="UAP_SIM " + Assembly.GetExecutingAssembly().GetName().Version.ToString();
            GetOrSetConfig(1);
        }

        /// <summary>
        /// 提取参数填写或保存界面参数
        /// </summary>
        /// <param name="GetOrSet">1 提取，2保存</param>
        private void GetOrSetConfig(long GetOrSet)
        {
            INIHelper INI = new INIHelper(System.Environment.CurrentDirectory + "\\Config.INI");
            
            switch (GetOrSet)
            {
                case 1:
                    this.txtIP.Text = INI.GetValueByName("OracelIP", "127.0.0.1");
                    this.txtOracleSSID.Text = INI.GetValueByName("OracleSSID", "ORACL");
                    this.txtUAPPwd.Text = INI.GetValueByName("OraclePassword", "UAP_SIM");
                    this.txtUAPPath.Text = INI.GetValueByName("CcNetAgentPath", @"C:\CcNetAgent\data\CcNetAgent");
                    this.txtFilePath.Text = INI.GetValueByName("CcNetAgentFilePath", @"C:\CcNetAgent\data\CcNetAgent\File");
                    this.txtRTime.Text = INI.GetValueByName("RefreshTime", "500");
                    break;
                case 2:
                    INI.SetValueByName("OracelIP", this.txtIP.Text);
                    INI.SetValueByName("OracleSSID", this.txtOracleSSID.Text);
                    INI.SetValueByName("OraclePassword", this.txtUAPPwd.Text);
                    INI.SetValueByName("CcNetAgentPath", this.txtUAPPath.Text);
                    INI.SetValueByName("CcNetAgentFilePath", this.txtFilePath.Text);
                    INI.SetValueByName("RefreshTime", this.txtRTime.Text);
                    INI.SaveINI();
                    break;

            }
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            try
            {
                if (DBHConnect() == -1)
                {
                    timer1.Enabled = false;
                    Log.writelog("链接数据库错误!");
                    MessageBox.Show("链接数据库错误!");
                }
                else
                {
                    DataTable DTSrv = DBH.UAPGetSRVInfo();
                    if (DTSrv.Rows.Count > 0 )
                    {
                        SrvInfo.Clear();
                        for (int i= 0 ; i < DTSrv.Rows.Count; i++)
                        {
                            SrvInfo.Add((string)DTSrv.Rows[i][0], (string)DTSrv.Rows[i][0]);
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                timer1.Enabled = false;
                Log.writelog("链接数据库发生错误：" + ex.Message + "\r\n");
                MessageBox.Show("链接数据库发生错误：" + ex.Message + "\r\n");

            }

            //保存界面设置
            if (timer1.Enabled)
            {
                this.btnStart.Text = "开始";
                timer1.Stop();
                timer1.Enabled = false;
            }
            else
            {
                this.btnStart.Text = "停止";
                GetOrSetConfig(2);
                timer1.Enabled = true;
                timer1.Interval = System.Convert.ToInt32(this.txtRTime.Text.Trim());
                timer1.Start();
            }
        }

        private long DBHConnect()
        {
            DBH.CnString = "Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=" + this.txtIP.Text + ")(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=" + this.txtOracleSSID.Text + ")));Persist Security Info=True;User ID=UAP_SIM;Password=" + this.txtUAPPwd.Text + ";";

            return DBH.ConnectOracleDB();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            string debugMsg = "";
            //oracle数据库连接
            try
            {
                if (DBHConnect() == -1)
                {
                    timer1.Enabled = false;
                    Log.writelog("链接数据库错误!");
                    MessageBox.Show("链接数据库错误!");
                    
                };
            }
            catch (Exception ex)
            {
                timer1.Enabled = false;
                Log.writelog("链接数据库发生错误：" + ex.Message + "\r\n");
                MessageBox.Show("链接数据库发生错误：" + ex.Message + "\r\n");

            }

            try
            {
                
                //REQ文件初始化
                debugMsg = "初始化REQ对象" + this.txtUAPPath.Text + @"REQ.dbf";
                QuickDBF DBFReq = new QuickDBF(this.txtUAPPath.Text + @"REQ.dbf");
                //REP文件初始化
                debugMsg = "初始化REP对象" + this.txtUAPPath.Text + @"REP.dbf";
                QuickDBF DBFRep = new QuickDBF(this.txtUAPPath.Text + @"REP.dbf");

                //准备条件，检索待处理业务
                Dictionary<string, string> dictConditions = new Dictionary<string, string>(); //检索条件
                List<Dictionary<string, string>> RetDatas = new List<Dictionary<string, string>>(); //检索返回

                //检索未处理的业务，等效"SELECT * FROM REQ where CLBZ<>'1' and SBRQ='" + sbrq + "'";
                dictConditions.Add("CLBZ", "z");
                dictConditions.Add("SBRQ", DateTime.Now.ToString("yyyyMMdd"));

                DBFReq.FiltData(dictConditions, ref RetDatas, intstartLin);
                //如果有待处理的数据
                if (RetDatas.Count > 0)
                {
                    for (int i = 0; i < RetDatas.Count; i++)
                    {
                        intstartLin =  int.Parse(RetDatas[i]["ROWID"]) +1 ;
                        if (SrvInfo.ContainsKey(RetDatas[i]["FWM"] + "_" + RetDatas[i]["FWLX"]))
                        {
                        debugMsg = "获取服务" + RetDatas[i]["FWM"] + "_" + RetDatas[i]["FWLX"];
                        List<Dictionary<string, string>> ZWJRetDatas = new List<Dictionary<string, string>>(); //子文件检索返回
                        debugMsg = "初始子文件对象" + this.txtFilePath.Text + @"\" + RetDatas[i]["ZWJM"];
                        QuickDBF DBFReqDetail = new QuickDBF(this.txtFilePath.Text + @"\" + RetDatas[i]["ZWJM"]);
                        dictConditions.Clear();
                        
                        DBFReqDetail.FiltData(dictConditions, ref ZWJRetDatas);//得到子文件数据
                            for (int j = 0; j < ZWJRetDatas.Count(); j++)
                            {   //调用存储过程产生回报结果
                                DataTable DTRet = DBH.UAPCommand(RetDatas[i]["FWM"] + "_" + RetDatas[i]["FWLX"], ZWJRetDatas[j]);
                                //获取回报数据结构
                                DataTable DTStru = DBH.UAPGetIOInfo(RetDatas[i]["FWM"], RetDatas[i]["FWLX"], "1");

                                //回报文件生成,使用返回结果集和数据结构创建文件
                                QuickDBF DBFRePDetail = new QuickDBF(this.txtFilePath.Text + @"\T0" + RetDatas[i]["FWLX"] + RetDatas[i]["SBBH"] + ".DBF", DTStru);
                                DBFRePDetail.CreateData2DBF(DTRet);

                                //回报文件索引记录
                                Dictionary<string, string> RepData = new Dictionary<string, string>();
                                RepData.Add("SBBH", RetDatas[i]["SBBH"]); //申报编号与REQ申报编号一致
                                RepData.Add("WJBZ", "1"); //文件标志，目前都是有主文件没从文件
                                RepData.Add("ZWJM", "T0" + RetDatas[i]["FWLX"] + RetDatas[i]["SBBH"] + ".DBF"); //主文件名就是前面生成的回报文件名
                                RepData.Add("FQSJ", DateTime.Now.ToString("yyyyMMdd")); //回报日期
                                RepData.Add("CLBZ", "0");//应答处理标志（clbz），交易处理方在生成应答记录时，应将该字段设置为‘0’或为空，请求发起方在收到应答记录、提交处理以前将该字段设置为‘1’


                                if (DTRet.Rows.Count > 0)
                                {
                                    //RepData.Add("JGDM", (string)DTRet.Rows[0]["JGDM"]); //结果代码从回报中提取
                                    //20200908 修订，JGDM字段为通讯状态代码 固定返回 0000
                                    RepData.Add("JGDM", "0000");
                                    RepData.Add("CLSM", (string)DTRet.Rows[0]["JGSM"]); //结果代码从回报中提取
                                }
                                else
                                {
                                    RepData.Add("JGDM", "0000");
                                    RepData.Add("CLSM", "零记录回报");
                                }
                                DBFRep.insertDict2DBF(RepData);

                                //更新请求文件索引记录
                                RepData.Clear();
                                RepData.Add("CLBZ", "1"); //将REQ文件处理标志更新为1已回报

                                DBFReq.updateDBF(int.Parse(RetDatas[i]["ROWID"]), RepData);
                            }
                        }
                        else
                        {
                            Log.writelog("发生暂不支持的业务：" + RetDatas[i]["FWM"] + "_" + RetDatas[i]["FWLX"]);

                        }
                    }
                }
            }
            catch(Exception ex)
            {
                timer1.Enabled = false;
                MessageBox.Show("初始REQ/REP发生错误：" + ex.Message + "\r\n");
                Log.writelog("初始REQ/REP发生错误：" + ex.Message + debugMsg);
            }



        }

        private void 关于UAPToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AboutBox frmAbout = new AboutBox();
            frmAbout.ShowDialog();
            frmAbout.Close();
        }
    }
}
