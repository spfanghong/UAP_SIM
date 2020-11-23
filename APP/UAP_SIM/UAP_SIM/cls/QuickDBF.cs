using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Data;

namespace UAP_SIM
{
    /// <summary>
    /// 快速DBF处理，以文件流的方式处理DBF
    /// </summary>
    class QuickDBF
    {
        //DBF文件头结构 32字节
        [StructLayoutAttribute(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
        public struct DBFHead
        {
            public Byte FileType; //0~0 文件类型，03H无备注型字段，83H有
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
            public Byte[] LastModDate; //1~3 最后的修改日期
            public Int32 RowCount; //4~7记录数
            public Int16 HeadLength;//8~9文件头长度
            public Int16 RowLength;//10~11记录长度
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
            public Byte[] UnUsed; //12~31  20个字节系统保留
        }
        //DBF字段描述32字节
        [StructLayoutAttribute(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
        public struct DBFColumnInfo
        {
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 10)]
            public string ColName;//0~9 10字节字段名
            public Byte UnKnown1;// 10~10 1字节 系统保留
            //[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 1)]
            public Char colType; // 11~11 1字节 字段类型
            public Int32 colOffset;//12~15 字段数据在单行数据中的偏移位置+1（第n个字节开始）
            public Byte colLength;//16~16 字段长度
            public Byte colPoint; //17~17 小数位数
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 14)]
            public Byte[] UnUsed; //18~31 14字节系统保留
        }
        private string strFileName = "";
        private string strModelFileName = "";
        public Dictionary<string,DBFColumnInfo> DictColomns = new Dictionary<string,DBFColumnInfo>();
        public DBFHead DBFh = new DBFHead();

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="FileName">需要进行处理的DBF文件</param>
        public QuickDBF(string FileName)
        {
            if (File.Exists(FileName))
            {
                strFileName = FileName;
                GetDBFStru();
            }
        }
        public QuickDBF(string FileName ,string ModelFileName)
        {
            if (File.Exists(ModelFileName))
            {
                strFileName = FileName;
                strModelFileName = ModelFileName;
                File.Copy(ModelFileName, strFileName, true);
                GetDBFStru();
            }
        }
        public QuickDBF(string FileName, DataTable DTStruct)
        {
            strFileName = FileName;
            //根据数据结构信息创建数据结构组
            DictColomns.Clear();
            Int32 offset = 1;
            for (int i = 0;i<DTStruct.Rows.Count;i++)
            {
                DBFColumnInfo colInfo = new DBFColumnInfo();
                colInfo.ColName = (string)DTStruct.Rows[i]["FIELD_NAME"];
                colInfo.colType = 'C'; //目前中国结算实时接口所有字段均为字符型，暂时不做处理
                colInfo.colLength = byte.Parse((string)DTStruct.Rows[i]["FIELD_LENGTH"]);
                colInfo.colOffset = offset; //第一个字段偏移从1开始 偏移0为记录删除标志

                offset = offset + colInfo.colLength; //累加计算下一个字段的偏移,最后一次执行完以后该值就是记录长度
                DictColomns.Add(colInfo.ColName, colInfo);
            }
            DBFh.FileType = 0x03;
            DBFh.LastModDate = new byte[3];
            DBFh.LastModDate[0] = (byte)(DateTime.Now.Year - 2000); //最后修改日期三个字段分别放年月日，其中年只放后两位，嗯哼，千年虫问题。
            DBFh.LastModDate[1] = (byte)(DateTime.Now.Month);
            DBFh.LastModDate[2] = (byte)(DateTime.Now.Day);
            DBFh.RowCount = 0;//初始化的时候暂不知数据量
            DBFh.HeadLength = (short)((DictColomns.Count + 1) * 32 + 1); //头的长度=头信息32字节+ 每个字段32字节 + 一个字节的结束标志
            DBFh.RowLength = (short)offset;

        }


        /// <summary>
        /// 获取DBF文件格式
        /// </summary>
        /// <returns></returns>
        private void GetDBFStru()
        {
            try
            {
                //开启文件
                FileStream Reader = new FileStream(strFileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite) ;//
                //获取DBF文件头
                Byte[] ReadBuffer = new Byte[32];
                Reader.Read(ReadBuffer, 0, ReadBuffer.Length); //读取前32个字节文件头部
     
                object DBFhType = DBFh;//装箱处理，将结构体变成引用类型
                ByteArrayToStructure(ReadBuffer, ref DBFhType, 0);
                DBFh = (DBFHead)DBFhType;//拆箱 

                //获取DBF文件字段集合
                DBFColumnInfo DBFc = new DBFColumnInfo();
                long ColumnCount = (DBFh.HeadLength - 1 - 32) / 32;//DBF字段数等于头总长减去1（头部结束标志符 0x0D）再减去DBF信息数据块的32个字节，然后每个字段信息32个字节
                DictColomns.Clear(); //清空
                for (int i = 0; i < ColumnCount; i++)
                {
                    Reader.Read(ReadBuffer, 0, ReadBuffer.Length); //逐个读取字段信息
                    DBFhType = DBFc; //装箱
                    ByteArrayToStructure(ReadBuffer, ref DBFhType, 0);
                    DBFc = (DBFColumnInfo)DBFhType;//拆箱
                    DictColomns.Add(DBFc.ColName, DBFc);
                }

                Reader.Close();
            }
            catch(Exception ex)
            {
                
                Log.writelog(ex.Message);
                MessageBox.Show("DBF文件处理错误" + ex.Message);
            }
        }

        /// <summary>
        /// 根据条件集合在数据中检索
        /// </summary>
        /// <param name="StartRecord">检索开始的记录数，从1开始计数</param>
        /// <param name="Conditions"></param>
        /// <param name="ReturnData"></param>
        /// <returns>返回匹配的数量</returns>
        public void FiltData( Dictionary<string,string> Conditions,ref List<Dictionary<string,string>> ReturnData , long StartRecord = 1 )
        {   
            try
            {
                //开启文件
                FileStream Reader = new FileStream(strFileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);//
                //确定开始检索的位置;
                Reader.Position = DBFh.HeadLength + (StartRecord - 1) * DBFh.RowLength;
                //确定需要检索的数据行数
                long SearchCount = DBFh.RowCount - StartRecord + 1;
                if (SearchCount < 1)
                {
                    return ;
                }
                else
                {
                    Byte[] dataBuffer = new Byte[DBFh.RowLength];
                    for (long i = 0;i< SearchCount; i++ )
                    {
                        Reader.Read(dataBuffer, 0, dataBuffer.Length);
                        Dictionary<string, string> DictRow = Bytes2Dict(dataBuffer);
                        int yesCount = 0;
                        foreach (string key in Conditions.Keys)
                        {
                            if (Conditions[key] == DictRow[key]) yesCount++;
                        }
                        if (yesCount == Conditions.Count)
                        {
                            DictRow.Add("ROWID", (StartRecord + i).ToString()); //如果完全匹配，则加上这行所在的行号 
                            ReturnData.Add(DictRow);
                        }

                    }
                }
                Reader.Close();
            }
            catch (Exception ex)
            {
                Log.writelog(ex.Message);
                MessageBox.Show("DBF文件数据检索错误" + ex.Message);
                return ;
            }
        }

        //将datatable 数据插入DBF末端。
        public void CreateData2DBF(DataTable DT)
        {

            try
            {
                             

                //开启文件
                FileStream Reader = new FileStream(strFileName, FileMode.Create, FileAccess.Write, FileShare.None);
                //计算记录数
                DBFh.RowCount = DBFh.RowCount + DT.Rows.Count;
                //写入头信息
                Reader.Seek(0, SeekOrigin.Begin);
                Reader.Write(StructToBytes(DBFh), 0, 32);
                //写入字段信息
                foreach (string key in DictColomns.Keys)
                {
                    Reader.Write(StructToBytes(DictColomns[key]), 0, 32);
                }
                //写入文件头结束标志
                Reader.WriteByte(0x0D);

                //定位数据的最后位置
                Reader.Seek((DBFh.RowCount - DT.Rows.Count) * DBFh.RowLength + DBFh.HeadLength, SeekOrigin.Begin);
                // 写入新增的行
                for (int i = 0; i < DT.Rows.Count; i++)
                {
                    byte[] ArrayROW = Enumerable.Repeat((byte)0x20, DBFh.RowLength).ToArray(); //单行数据，用空格填充
                    for (int j = 0; j < DT.Columns.Count; j++)
                    {
                        if (!(DT.Rows[i][j] is DBNull))
                        {
                            byte[] byteArray = System.Text.Encoding.Default.GetBytes((string)DT.Rows[i][j]); //取字段值，转换为数组
                            Buffer.BlockCopy(byteArray, 0, ArrayROW, DictColomns[DT.Columns[j].Caption].colOffset, byteArray.Length); //拼接到数据里
                        }
                    }
                    Reader.Write(ArrayROW, 0, ArrayROW.Length);
                }
                //写入文件结束标志
                Reader.WriteByte(0x1A);


                Reader.Flush();
                Reader.Close();

            }
            catch(Exception ex)
            {
                Log.writelog("数据文件生成错误：" + strFileName + "\r\n" + ex.Message);
            }
        }

        //将单条记录字典结构插入DBF末端。
        public void insertDict2DBF(Dictionary<string,string> DT)
        {

            try
            {
                //开启文件
                FileStream Reader = new FileStream(strFileName, FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
                //计算记录数
                DBFh.RowCount = DBFh.RowCount + 1;
                //写入头信息
                Reader.Seek(0, SeekOrigin.Begin);
                Reader.Write(StructToBytes(DBFh), 0, 32);
                //写入字段信息
                foreach (string key in DictColomns.Keys)
                {
                    Reader.Write(StructToBytes(DictColomns[key]), 0, 32);
                }
                //写入文件头结束标志
                Reader.WriteByte(0x0D);

                //定位数据的最后位置
                Reader.Seek((DBFh.RowCount - 1) * DBFh.RowLength + DBFh.HeadLength, SeekOrigin.Begin);
                // 写入新增的行
                    byte[] ArrayROW = Enumerable.Repeat((byte)0x20, DBFh.RowLength).ToArray(); //单行数据，用空格填充
                    foreach (string key in DT.Keys)
                    {
                            byte[] byteArray = System.Text.Encoding.Default.GetBytes(DT[key]); //取字段值，转换为数组
                            Buffer.BlockCopy(byteArray, 0, ArrayROW, DictColomns[key].colOffset, byteArray.Length); //拼接到数据里
                    }
                    Reader.Write(ArrayROW, 0, ArrayROW.Length);
                
                //写入文件结束标志
                Reader.WriteByte(0x1A);


                Reader.Flush();
                Reader.Close();

            }
            catch (Exception ex)
            {
                Log.writelog("插入数据错误：" + strFileName + "\r\n" + ex.Message);
            }
        }

        //更新行。
        public void updateDBF(int Rowid, Dictionary<string, string> DT)
        {

            try
            {
                //开启文件
                FileStream Reader = new FileStream(strFileName, FileMode.Open, FileAccess.ReadWrite, FileShare.ReadWrite);


                //定位数据行的位置
                Reader.Seek(( Rowid-1) * DBFh.RowLength + DBFh.HeadLength, SeekOrigin.Begin);

                // 把这行取出来
                byte[] ArrayROW = new byte[DBFh.RowLength];
                Reader.Read(ArrayROW, 0, ArrayROW.Length);
                foreach (string key in DT.Keys)
                {
                    byte[] byteArray = System.Text.Encoding.Default.GetBytes(DT[key]); //取字段值，转换为数组
                    Buffer.BlockCopy(byteArray, 0, ArrayROW, DictColomns[key].colOffset, byteArray.Length); //拼接到数据里
                }
                //定位数据行的位置
                Reader.Seek(( Rowid-1) * DBFh.RowLength + DBFh.HeadLength, SeekOrigin.Begin);
                //回写
                Reader.Write(ArrayROW, 0, ArrayROW.Length);

                Reader.Flush();
                Reader.Close();

            }
            catch (Exception ex)
            {
                Log.writelog("更新数据错误：" + strFileName + "\r\n" + ex.Message);
            }
        }

        private Dictionary<string,string> Bytes2Dict(Byte[] dataBuffer)
        {
            Dictionary<string, string> Ret = new Dictionary<string, string>();
            foreach (string key in DictColomns.Keys)
            {
                string v = System.Text.UnicodeEncoding.Default.GetString(dataBuffer, (DictColomns[key].colOffset), DictColomns[key].colLength).Trim();
                Ret.Add(key, v);
            }
            return Ret;
        }

        /// <summary>
        /// 字节数组转结构体(按小端模式)
        /// </summary>
        /// <param name="bytearray">字节数组</param>
        /// <param name="obj">目标结构体</param>
        /// <param name="startoffset">bytearray内的起始位置</param>
        public static void ByteArrayToStructure(byte[] bytearray, ref object obj, int startoffset)
        {
            int len = Marshal.SizeOf(obj);
            IntPtr i = Marshal.AllocHGlobal(len);
            // 从结构体指针构造结构体
            obj = Marshal.PtrToStructure(i, obj.GetType());
            try
            {
                // 将字节数组复制到结构体指针
                Marshal.Copy(bytearray, startoffset, i, len);
            }
            catch (Exception ex) { Console.WriteLine("ByteArrayToStructure FAIL: error " + ex.ToString()); }
            obj = Marshal.PtrToStructure(i, obj.GetType());
            Marshal.FreeHGlobal(i);  //释放内存，与 AllocHGlobal() 对应

        }

        /// <summary>
        /// 字节数组转结构体(按大端模式)
        /// </summary>
        /// <param name="bytearray">字节数组</param>
        /// <param name="obj">目标结构体</param>
        /// <param name="startoffset">bytearray内的起始位置</param>
        public static void ByteArrayToStructureEndian(byte[] bytearray, ref object obj, int startoffset)
        {
            int len = Marshal.SizeOf(obj);
            IntPtr i = Marshal.AllocHGlobal(len);
            byte[] temparray = (byte[])bytearray.Clone();
            // 从结构体指针构造结构体
            obj = Marshal.PtrToStructure(i, obj.GetType());
            // 做大端转换
            object thisBoxed = obj;
            Type test = thisBoxed.GetType();
            int reversestartoffset = startoffset;
            // 列举结构体的每个成员，并Reverse
            foreach (var field in test.GetFields())
            {
                object fieldValue = field.GetValue(thisBoxed); // Get value

                TypeCode typeCode = Type.GetTypeCode(fieldValue.GetType());  //Get Type
                if (typeCode != TypeCode.Object)  //如果为值类型
                {
                    Array.Reverse(temparray, reversestartoffset, Marshal.SizeOf(fieldValue));
                    reversestartoffset += Marshal.SizeOf(fieldValue);
                }
                else  //如果为引用类型
                {
                    reversestartoffset += ((byte[])fieldValue).Length;
                }
            }
            try
            {
                //将字节数组复制到结构体指针
                Marshal.Copy(temparray, startoffset, i, len);
            }
            catch (Exception ex) { Console.WriteLine("ByteArrayToStructure FAIL: error " + ex.ToString()); }
            obj = Marshal.PtrToStructure(i, obj.GetType());
            Marshal.FreeHGlobal(i);  //释放内存
        }


        /// <summary>
        /// 结构体转byte数组
        /// </summary>
        /// <param name="structObj">要转换的结构体</param>
        /// <returns>转换后的byte数组</returns>
        public static byte[] StructToBytes(object structObj)
        {
            //得到结构体的大小
            int size = Marshal.SizeOf(structObj);
            //创建byte数组
            byte[] bytes = new byte[size];
            //分配结构体大小的内存空间
            IntPtr structPtr = Marshal.AllocHGlobal(size);
            //将结构体拷到分配好的内存空间
            Marshal.StructureToPtr(structObj, structPtr, false);
            //从内存空间拷到byte数组
            Marshal.Copy(structPtr, bytes, 0, size);
            //释放内存空间
            Marshal.FreeHGlobal(structPtr);
            //返回byte数组
            return bytes;
        }
    }
}
