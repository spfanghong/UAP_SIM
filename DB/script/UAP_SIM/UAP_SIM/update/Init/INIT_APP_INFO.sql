delete em_monitor.app_info;
commit;
insert into em_monitor.app_info
      select 'ESIM','新意结算平台' from dual
union select 'ICID','新意数据中心系统' from dual
union select 'ECIS','新意银证转帐系统' from dual
;
commit;