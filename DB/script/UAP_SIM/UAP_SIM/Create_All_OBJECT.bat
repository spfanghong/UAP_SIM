
rem µ÷ÓÃ¾ÙÀý
rem Create_All_object.bat es_dba change_on_install shine143 ET_WF /home/oracle/9i/oradata/ora64/  >create_all_ET_WF.log

call Create_TableSpace_pub.bat %1 %2 %3 %4 %5

call Create_User_pub.bat %1 %2 %3 %4

call Create_Table_pub.bat %1 %2 %3 %4

call Create_Proc_pub.bat %1 %2 %3 %4

call Create_Init_pub.bat %1 %2 %3 %4

