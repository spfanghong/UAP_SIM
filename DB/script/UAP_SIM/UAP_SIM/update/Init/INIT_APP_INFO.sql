delete em_monitor.app_info;
commit;
insert into em_monitor.app_info
      select 'ESIM','�������ƽ̨' from dual
union select 'ICID','������������ϵͳ' from dual
union select 'ECIS','������֤ת��ϵͳ' from dual
;
commit;