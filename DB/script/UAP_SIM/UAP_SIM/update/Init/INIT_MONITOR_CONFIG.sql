--select * from em_monitor.monitor_config;
delete em_monitor.monitor_config where monitor_id in(26,27);
commit;
insert into em_monitor.monitor_config
--Ӱ��ϵͳ
      select 26,'Ӱ��ͨѶ��������״̬',  '0','',      ''      ,'','',10,'1','10.168.189.89' ,10020, 'CIMC','0',   '1','Comm_Status',    'Ӱ��ϵͳ�쳣.wav','2','20070101090000' from dual
union select 27,'Ӱ���ļ���������״̬',  '0','',      ''      ,'','',10,'1','10.168.189.89' ,10020, 'CIMC','0',   '1','File_Status',    'Ӱ��ϵͳ�쳣.wav','2','20070101090000' from dual
;
commit;
--select * from em_monitor.monitor_TARGET;
delete em_monitor.monitor_TARGET where monitor_id in(26,27) ;
commit;
insert into em_monitor.monitor_TARGET
--Ӱ��ϵͳ
      select 26,1,'ͨѶ��������״̬',      1,null,null,'','','',20070101,'090000','0' from dual
union select 27,1,'�ļ���������״̬',      1,null,null,'','','',20070101,'090000','0' from dual
union select 27,2,'�ļ�����ʣ��ռ�(M)',   3,2048,null,'','','',20070101,'090000','0' from dual
;
commit;
--select * from  em_monitor.control_config
delete from em_monitor.control_config where control_id in(19,20);
commit;
insert into em_monitor.control_config
      select 19,'Ӱ��ϵͳͨѶ�������',  '10.168.189.52','12345','1','090000','20070101' from dual
union select 20,'Ӱ��ϵͳ�ļ��������',    '10.168.189.52','12345','1','090000','20070101' from dual
;
commit;
--select * from em_monitor.control_target
delete from em_monitor.control_target where control_id in(19,20);
commit;
insert into em_monitor.control_target(control_id,control_target_id,control_target_name,process_name,process_path,process_start,process_kill,kill_type)
--jboss
      select 19,1,'Ӱ��ϵͳͨѶ�������',  'SsmsServer.exe',  'C:\ECIMC\ECIMCServer\SsmsServer.exe',   'C:\ECIMC\ECIMCServer\SsmsServer.exe',             '','1'from dual
union select 20,1,'Ӱ��ϵͳ�ļ��������',  'SsmsSwitch.exe',  'C:\FileServer\SsmsSwitch.exe',          'C:\FileServer\SsmsSwitch.exe',                    '','1'from dual
;
commit;
--������ʱ�м��
truncate table EM_MONITOR.MONITOR_TARGET_TMP;
--select * from EM_MONITOR.MONITOR_TARGET_TMP
insert into EM_MONITOR.MONITOR_TARGET_TMP(monitor_id,target_id,monitor_status,monitor_data,monitor_msg,last_return_date,last_return_time,is_alert,err_start_time,err_end_time)
select a.monitor_id,a.target_id,a.monitor_status,a.monitor_data,a.monitor_msg,a.last_return_date,a.last_return_time,a.is_alert,a.last_return_time,a.last_return_time
from em_monitor.monitor_TARGET a;
commit;