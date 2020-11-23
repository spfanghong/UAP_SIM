rem 下面将开始创建表空间

SQLPLUS %1/%2@%3 as sysdba @tablespace\create_tbs_pub.sql %4 %5 <nul

rem 创建表空间结束