namespace UAP_SIM
{
    partial class frmMain
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.label1 = new System.Windows.Forms.Label();
            this.txtUAPPath = new System.Windows.Forms.TextBox();
            this.btnUAPPath = new System.Windows.Forms.Button();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.label2 = new System.Windows.Forms.Label();
            this.txtRTime = new System.Windows.Forms.TextBox();
            this.btnStart = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.txtIP = new System.Windows.Forms.TextBox();
            this.txtUAPPwd = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtOracleSSID = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.btnUAPBusiFilePath = new System.Windows.Forms.Button();
            this.txtFilePath = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.文件ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.打开日志ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.帮助ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.关于UAPToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 160);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(185, 12);
            this.label1.TabIndex = 0;
            this.label1.Text = "PROP控制文件(REQ/REP文件）路径";
            // 
            // txtUAPPath
            // 
            this.txtUAPPath.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtUAPPath.Enabled = false;
            this.txtUAPPath.Location = new System.Drawing.Point(13, 175);
            this.txtUAPPath.Name = "txtUAPPath";
            this.txtUAPPath.ReadOnly = true;
            this.txtUAPPath.Size = new System.Drawing.Size(233, 21);
            this.txtUAPPath.TabIndex = 1;
            this.txtUAPPath.Text = "C:\\CcNetAgent\\data\\CcNetAgent";
            // 
            // btnUAPPath
            // 
            this.btnUAPPath.Location = new System.Drawing.Point(252, 174);
            this.btnUAPPath.Name = "btnUAPPath";
            this.btnUAPPath.Size = new System.Drawing.Size(44, 20);
            this.btnUAPPath.TabIndex = 2;
            this.btnUAPPath.Text = "浏览";
            this.btnUAPPath.UseVisualStyleBackColor = true;
            this.btnUAPPath.Click += new System.EventHandler(this.btnUAPPath_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 263);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(113, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "刷新时间间隔(毫秒)";
            // 
            // txtRTime
            // 
            this.txtRTime.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtRTime.Location = new System.Drawing.Point(13, 278);
            this.txtRTime.Name = "txtRTime";
            this.txtRTime.Size = new System.Drawing.Size(283, 21);
            this.txtRTime.TabIndex = 4;
            this.txtRTime.Text = "1000";
            // 
            // btnStart
            // 
            this.btnStart.BackColor = System.Drawing.SystemColors.Control;
            this.btnStart.Location = new System.Drawing.Point(115, 325);
            this.btnStart.Name = "btnStart";
            this.btnStart.Size = new System.Drawing.Size(71, 63);
            this.btnStart.TabIndex = 5;
            this.btnStart.Text = "开始";
            this.btnStart.UseVisualStyleBackColor = false;
            this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(13, 41);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(119, 12);
            this.label3.TabIndex = 6;
            this.label3.Text = "UAP模拟数据库IP地址";
            // 
            // txtIP
            // 
            this.txtIP.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtIP.Location = new System.Drawing.Point(15, 56);
            this.txtIP.MaxLength = 15;
            this.txtIP.Name = "txtIP";
            this.txtIP.Size = new System.Drawing.Size(281, 21);
            this.txtIP.TabIndex = 7;
            // 
            // txtUAPPwd
            // 
            this.txtUAPPwd.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtUAPPwd.Location = new System.Drawing.Point(15, 136);
            this.txtUAPPwd.MaxLength = 15;
            this.txtUAPPwd.Name = "txtUAPPwd";
            this.txtUAPPwd.Size = new System.Drawing.Size(281, 21);
            this.txtUAPPwd.TabIndex = 9;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(13, 121);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(95, 12);
            this.label4.TabIndex = 8;
            this.label4.Text = "UAP模拟用户密码";
            // 
            // txtOracleSSID
            // 
            this.txtOracleSSID.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtOracleSSID.Location = new System.Drawing.Point(15, 97);
            this.txtOracleSSID.MaxLength = 15;
            this.txtOracleSSID.Name = "txtOracleSSID";
            this.txtOracleSSID.Size = new System.Drawing.Size(281, 21);
            this.txtOracleSSID.TabIndex = 11;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(13, 82);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(263, 12);
            this.label5.TabIndex = 10;
            this.label5.Text = "UAP模拟数据库实例名（服务器上的真实实例名）";
            // 
            // timer1
            // 
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // btnUAPBusiFilePath
            // 
            this.btnUAPBusiFilePath.Location = new System.Drawing.Point(252, 218);
            this.btnUAPBusiFilePath.Name = "btnUAPBusiFilePath";
            this.btnUAPBusiFilePath.Size = new System.Drawing.Size(44, 20);
            this.btnUAPBusiFilePath.TabIndex = 14;
            this.btnUAPBusiFilePath.Text = "浏览";
            this.btnUAPBusiFilePath.UseVisualStyleBackColor = true;
            this.btnUAPBusiFilePath.Click += new System.EventHandler(this.btnUAPBusiFilePath_Click);
            // 
            // txtFilePath
            // 
            this.txtFilePath.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtFilePath.Location = new System.Drawing.Point(13, 219);
            this.txtFilePath.Name = "txtFilePath";
            this.txtFilePath.ReadOnly = true;
            this.txtFilePath.Size = new System.Drawing.Size(233, 21);
            this.txtFilePath.TabIndex = 13;
            this.txtFilePath.Text = "C:\\CcNetAgent\\data\\CcNetAgent\\File";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(13, 204);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(101, 12);
            this.label6.TabIndex = 12;
            this.label6.Text = "PROP业务文件路径";
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.文件ToolStripMenuItem,
            this.帮助ToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(308, 25);
            this.menuStrip1.TabIndex = 15;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // 文件ToolStripMenuItem
            // 
            this.文件ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.打开日志ToolStripMenuItem});
            this.文件ToolStripMenuItem.Enabled = false;
            this.文件ToolStripMenuItem.Name = "文件ToolStripMenuItem";
            this.文件ToolStripMenuItem.Size = new System.Drawing.Size(44, 21);
            this.文件ToolStripMenuItem.Text = "文件";
            // 
            // 打开日志ToolStripMenuItem
            // 
            this.打开日志ToolStripMenuItem.Name = "打开日志ToolStripMenuItem";
            this.打开日志ToolStripMenuItem.Size = new System.Drawing.Size(124, 22);
            this.打开日志ToolStripMenuItem.Text = "打开日志";
            // 
            // 帮助ToolStripMenuItem
            // 
            this.帮助ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.关于UAPToolStripMenuItem});
            this.帮助ToolStripMenuItem.Name = "帮助ToolStripMenuItem";
            this.帮助ToolStripMenuItem.Size = new System.Drawing.Size(44, 21);
            this.帮助ToolStripMenuItem.Text = "帮助";
            // 
            // 关于UAPToolStripMenuItem
            // 
            this.关于UAPToolStripMenuItem.Name = "关于UAPToolStripMenuItem";
            this.关于UAPToolStripMenuItem.Size = new System.Drawing.Size(181, 22);
            this.关于UAPToolStripMenuItem.Text = "关于UAP业务模拟...";
            this.关于UAPToolStripMenuItem.Click += new System.EventHandler(this.关于UAPToolStripMenuItem_Click);
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(308, 415);
            this.Controls.Add(this.btnUAPBusiFilePath);
            this.Controls.Add(this.txtFilePath);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.txtOracleSSID);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.txtUAPPwd);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.txtIP);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.btnStart);
            this.Controls.Add(this.txtRTime);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnUAPPath);
            this.Controls.Add(this.txtUAPPath);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "frmMain";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.frmMain_Load);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtUAPPath;
        private System.Windows.Forms.Button btnUAPPath;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtRTime;
        private System.Windows.Forms.Button btnStart;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtIP;
        private System.Windows.Forms.TextBox txtUAPPwd;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtOracleSSID;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Button btnUAPBusiFilePath;
        private System.Windows.Forms.TextBox txtFilePath;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem 文件ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 打开日志ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 帮助ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 关于UAPToolStripMenuItem;
    }
}

