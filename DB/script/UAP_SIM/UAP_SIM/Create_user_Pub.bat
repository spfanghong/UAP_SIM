rem 下面将创建用户

SQLPLUS %1/%2@%3 as sysdba @user\create_user_pub.sql %4 <nul

rem 创建用户结束