REM
REM  %1:���ݿ�ʵ����
REM  %2:�����ļ�·��(���һ���ַ�Ϊ"\")
REM  %3:SYS�û�������
REM  ���þ���:main.bat ORA47 D:\ORACLE\ORADATA\ESIM60\ SYS
REM

cd UAP_SIM
CALL Create_All_object.bat SYS %3 %1 UAP_SIM %2 >..\create_all_UAP_SIM.log

cd ..
