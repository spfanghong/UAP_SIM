REM
REM  %1:数据库实例名
REM  %2:数据文件路径(最后一个字符为"\")
REM  %3:SYS用户的密码
REM  调用举例:main.bat ORA47 D:\ORACLE\ORADATA\ESIM60\ SYS
REM

cd UAP_SIM
CALL Create_All_object.bat SYS %3 %1 UAP_SIM %2 >..\create_all_UAP_SIM.log

cd ..
