
rem µ÷ÓÃ¾ÙÀý
rem Update_All_object.bat es_dba change_on_install shine143 ea_clear /home/oracle/9i/oradata/ora64/  >create_all_ea_clear.log

call Update_Table_pub.bat %1 %2 %3 %4

call Update_Proc_pub.bat %1 %2 %3 %4

call Update_Init_pub.bat %1 %2 %3 %4

