CREATE OR REPLACE PROCEDURE EM_MONITOR.P_CHK_MONITOR_STATUS(AN_O_RET_CODE   OUT NUMBER,
                                          AC_O_RET_MSG    OUT VARCHAR2,
                                          AN_MONITOR_ID   IN integer
                                          ) IS
    /******************************************************************
    项目名称：ESOMP
    所属用户：EM_MONITOR
    概要说明：
        中文名称：检查监控状态
        用    途:
              检查监控状态
    语法信息：
        输入参数：

        输出参数：
            AN_O_RET_CODE    返回的代码
            AC_O_RET_MSG     返回信息
        调用举例:
            VARIABLE AN_O_RET_CODE   NUMBER;
            VARIABLE AC_O_RET_MSG    VARCHAR2;
            EXEC P_CHK_MONITOR_STATUS(:AN_O_RET_CODE,:AC_O_RET_MSG);
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2007-08-16  fanghong        create
    ******************************************************************/
    AC_TIME CHAR(6);
    AC_RETURN_TYPE char(1);
BEGIN
    AN_O_RET_CODE := 0;
    AC_O_RET_MSG  := '操作成功';
    --获取监控项目的返回类型
    select monitor_return_type into AC_RETURN_TYPE from em_monitor.monitor_config where monitor_id = AN_MONITOR_ID;
    --无需报警的指标标记为不报警
    update em_monitor.monitor_target a
    set is_alert = '0'
    where MONITOR_ID = AN_MONITOR_ID
    --and  ALERT_CONDITION = '0'
    ;
    --commit;
    --对于所有异常状态指标标记为报警
    update em_monitor.monitor_target
    set is_alert = '1'
    where (monitor_status = '2' or monitor_status = '4') and MONITOR_ID = AN_MONITOR_ID
    ;
    --commit;
    --根据状态报警的指标
    update em_monitor.monitor_target a
    set is_alert = (case monitor_status  when  '1' then '0' when '2' then '1' when '4' then '1' else '0' end )
    where ALERT_CONDITION = '1' and MONITOR_ID = AN_MONITOR_ID
    ;
    --commit;
    --根据返回值 报警
    update em_monitor.monitor_target a
    set is_alert = (case   when to_number(monitor_data) > gate_value1  then '1'  else '0' end ),
        monitor_msg = (case   when to_number(monitor_data) > gate_value1  then '监控值大于报警阀值' else monitor_msg end )
    where ALERT_CONDITION = '2' and monitor_status = '3' and MONITOR_ID = AN_MONITOR_ID
    ;
    --commit;
    update em_monitor.monitor_target a
    set is_alert = (case   when to_number(monitor_data) < gate_value1  then '1'  else '0' end ),
        monitor_msg = (case   when to_number(monitor_data) < gate_value1  then '监控值小于报警阀值' else monitor_msg end )
    where ALERT_CONDITION = '3' and monitor_status = '3' and MONITOR_ID = AN_MONITOR_ID
    ;
    --commit;
    update em_monitor.monitor_target a
    set is_alert = (case   when to_number(monitor_data) < gate_value1 or to_number(monitor_data) > gate_value1 then '1'  else '0' end ),
        monitor_msg = (case   when to_number(monitor_data) > gate_value1  then '监控值超出报警阀值范围' else monitor_msg end )
    where ALERT_CONDITION = '4' and monitor_status = '3' and MONITOR_ID = AN_MONITOR_ID
    ;
    commit;
    --时间范围外的不报警

      select to_char(sysdate,'hh24miss') into AC_TIME from dual;

  update em_monitor.monitor_target tb
  set is_alert = '0'
  where
  exists
  (
    select monitor_id --into tmp
    from em_monitor.monitor_config ta
    where
    (
      (ta.timer_type = 1 and (AC_TIME < ta.timer_start1  or ta.timer_end1 <AC_TIME ))
      or
      (ta.timer_type = 2 and (AC_TIME < ta.timer_start1  or ta.timer_end2 <AC_TIME or (AC_TIME > ta.timer_end1 and AC_TIME < ta.timer_start2)))
    )
    and
    ta.monitor_id =tb.monitor_id -- AN_MONITOR_ID
  )
  --and
  --monitor_id = AN_MONITOR_ID
  ;
  commit;

    --插入报警记录
    --确认的错误记录
    insert into em_monitor.err_log(monitor_id,target_id,monitor_status,monitor_data,monitor_msg,return_date,return_time,err_start_time,err_end_time)
    select b.monitor_id,b.target_id,b.monitor_status,b.monitor_data,b.monitor_msg,b.last_return_date,b.last_return_time,b.err_start_time,b.err_end_time from
    (
    select monitor_id,target_id ,monitor_status,monitor_status,monitor_data,monitor_msg,last_return_date,is_alert
    from em_monitor.monitor_target
    where monitor_id = AN_MONITOR_ID
    minus
    select monitor_id,target_id ,monitor_status,monitor_status,monitor_data,monitor_msg,last_return_date,is_alert
    from em_monitor.monitor_target_tmp
    where monitor_id = AN_MONITOR_ID
    ) a ,
    em_monitor.monitor_target_tmp b
    where a.monitor_id = b.monitor_id
    and a.target_id = b.target_id
    and b.is_alert = 1
    ;
    commit;
    --更新临时表
    update em_monitor.monitor_target_tmp t
    set
    (monitor_status,monitor_data,monitor_msg ,last_return_date,last_return_time,err_start_time,err_end_time,is_alert)
    =
    (
    select
    monitor_status,
    monitor_data,monitor_msg ,
    last_return_date,
    last_return_time,
    case
    when t.is_alert <> ta.is_alert or t.last_return_date <> ta.last_return_date or t.monitor_status <> ta.monitor_status or t.monitor_data <> ta.monitor_data then  ta.last_return_time
    else t.err_start_time end
    ,
    last_return_time,
    is_alert
    from em_monitor.monitor_target ta where t.monitor_id = ta.monitor_id
          and t.target_id = ta.target_id
    )
    where exists (select 1 from em_monitor.monitor_target ta
          where
          ta.monitor_id = AN_MONITOR_ID
          and t.monitor_id = ta.monitor_id
          and t.target_id = ta.target_id)
    ;
    commit;

    --通讯异常时，日志型监控日志插入通讯异常记录
    insert into em_monitor.monitor_target_log
    select t.monitor_id,t.target_id,c.client_id,c.req_name, em_monitor.sec_monitor_log_id.nextval,
           t.monitor_status, t.monitor_data,t.monitor_msg, t.last_return_date,t.last_return_time
    from em_monitor.monitor_target t ,em_monitor.monitor_config c
    where t.monitor_id = c.monitor_id
          and t.monitor_id = AN_MONITOR_ID
          and c.is_valid = '1'
          and c.monitor_return_type = '3'
          and t.monitor_status ='4'
     ;
        commit;
    --更新监控项目最后操作时间
    update em_monitor.monitor_config
    set last_time = to_char(sysdate,'YYYYMMDDhh24miss')
    where MONITOR_ID = AN_MONITOR_ID
    ;
    commit;
EXCEPTION
    WHEN OTHERS THEN
        AN_O_RET_CODE := -1;
        AC_O_RET_MSG  := '错误代码:' || SQLCODE || CHR(13) || '错误信息:' || SQLERRM;
END P_CHK_MONITOR_STATUS;
/
