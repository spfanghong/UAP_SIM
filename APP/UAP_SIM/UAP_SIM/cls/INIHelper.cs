using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace UAP_SIM
{
    public class INIHelper
    {
        private string newLine = "\r\n";  //换行符
        private string filePath = string.Empty; //文件名称
        private string fileContent = string.Empty; //文件内容

        public INIHelper() { }
        /// <summary>
        /// 有参构造方法，直接读取INI文件
        /// </summary>
        /// <param name="filePath"></param>
        public INIHelper(string filePath)
        {
            this.LoadINI(filePath);
        }

        /// <summary>
        /// 加载并读取INI文件
        /// </summary>
        /// <param name="fileName">文件路径</param>
        public void LoadINI(string filePath)
        {
            if (filePath.Trim().Length > 0)
            {
                this.filePath = filePath;
                ReadINIFile();
            }
            else
            {
                throw new Exception("Invalid file name!");
            }
        }

        /// <summary>
        /// 读取INI文件
        /// </summary>
        private void ReadINIFile()
        {
            if (File.Exists(this.filePath))
            {
                try
                {
                    using (StreamReader sr = new StreamReader(this.filePath))
                    {
                        this.fileContent = sr.ReadToEnd();
                        //this.fileContent = EncryptionAndDecryption(fileContent); //解密
                        //如果文件内容为空或者没有换行符，则认为是无效的INI文件。
                        //if (fileContent.Trim().Length <= 0 || !fileContent.Contains("\n"))
                        //{
                        //    throw new Exception("Invalid ini file");
                        //}
                        //else
                        {
                            //保存文件默认换行符
                            if (!fileContent.Contains(newLine))
                            {
                                this.newLine = "\n";
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("Read file error! Error Message:" + ex.Message);
                }
            }
            else
            {
                throw new Exception("File " + filePath + " not found!");
            }
        }

        /// <summary>
        /// 读取INI文件某个配置项的值 
        /// </summary>
        /// <param name="fieldName"></param>
        /// <returns></returns>
        public string GetValueByName(string fieldName,string DefaultValue = "")
        {
            fileContent = fileContent.Replace(newLine, ";");
            fileContent = fileContent.Replace(" ", "");
            fileContent = fileContent.EndsWith(";") ? fileContent : fileContent + ";";
            Regex reg = new Regex("(?<=" + fieldName + "=).*?(?=;)");
            Match m = reg.Match(fileContent);
            if (m.Value != "")
            {
                return m.Value;
            }
            else
            {
                return DefaultValue;
            }
        }

        /// <summary>
        /// 修改INI文件某个配置项的值
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="value"></param>
        public void SetValueByName(string fieldName, string value)
        {
            fileContent = fileContent.Replace(newLine, ";");
            fileContent = fileContent.Replace(" ", "");
            fileContent = fileContent.EndsWith(";") ? fileContent : fileContent + ";";
            Regex reg = new Regex("(?<=" + fieldName + "=).*?(?=;)");
            Match m = reg.Match(fileContent);
            if (m.Value != "")
            {
                string reg1 = "(?<=" + fieldName + "=).*?(?=;)";
                fileContent = Regex.Replace(fileContent, reg1, value);
            }
            else
            {
                fileContent = fileContent + fieldName + "=" + value + "\r\n";
            }

        }

        /// <summary>
        /// 保存对INI文件的修改
        /// </summary>
        public void SaveINI()
        {
            try
            {
                fileContent = fileContent.Replace(";", newLine); //替换换行符
                //fileContent = EncryptionAndDecryption(fileContent); //加密
                using (StreamWriter sw = new StreamWriter(filePath))
                {
                    sw.Write(fileContent);
                    sw.Close();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Save file error! Error Message:" + ex.Message);
            }
        }

        /// <summary>
        /// 加密解密算法，使用异或算法
        /// </summary>
        /// <param name="str"></param>
        public string EncryptionAndDecryption(string str)
        {
            byte key = 32;
            byte[] buffer = Encoding.Default.GetBytes(str);
            for (int i = 0; i < buffer.Length; i++)
            {
                buffer[i] ^= key;
            }
            return Encoding.Default.GetString(buffer);
        }
    }

}
