create or replace procedure uap_sim.UAPSRV_11(retCursor  OUT SYS_REFCURSOR,
                                              AC_I_YWLSH   varchar2,
                                              AC_I_YWLB   varchar2,
                                              AC_I_YMTH   varchar2,
                                              AC_I_ZHLB   varchar2,
                                              AC_I_ZQZH   varchar2,
                                              AC_I_ZJLB   varchar2,
                                              AC_I_ZJDM   varchar2,
                                              AC_I_JYDY   varchar2,
                                              AC_I_YYBBM   varchar2,
                                              AC_I_KHJGDM   varchar2,
                                              AC_I_KHWDDM   varchar2,
                                              AC_I_SQRQ   varchar2
                                              ) AS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：证券账户使用信息维护
        用途简述：对应《账户系统数据接口规范》1.44
        输入参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '11' and svr_direct = '0';
        输出参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '11' and svr_direct = '1';
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2019-08-22  fh         根据1.44版本协议创建
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    C_YMTH UAP_SIM.Qtymtzl.YMTH%TYPE;
    N_TMP      NUMBER;
begin

       C_RET_CODE := '0000';
       C_RET_MSG  := '处理成功';
-- 前置检查
    select count(1) into N_TMP from UAP_SIM.Qtzqzhzl t where t.zhlb = AC_I_ZHLB and t.zqzh = AC_I_ZQZH  ;
    if N_TMP  = 0 then
       C_RET_CODE := '3028';
       C_RET_MSG  := '证券账户不存在或证券账户与账户类别不匹配';
       goto RET;
    end if;
    
    select ymth into C_YMTH from  UAP_SIM.Qtzqzhzl t where t.zhlb = AC_I_ZHLB and t.zqzh = AC_I_ZQZH;
    
    if AC_I_YWLB in( '01','02') then 
       select count(1)
         into N_TMP
         from uap_sim.qtymtzl t1,
              uap_sim.qtzqzhzl t2
        where t1.ymth = t2.ymth
          and t1.zjlb = AC_I_ZJLB
          and t1.zjdm = AC_I_ZJDM
          and t2.zhlb = AC_I_ZHLB
          and t2.zqzh = AC_I_ZQZH;
       if N_TMP  = 0 then
           C_RET_CODE := '3024';
           C_RET_MSG  := '证券账户与身份证明文件不匹配';
           goto RET;
       end if;
    end if ;

--业务处理
    if AC_I_YWLB = '01' then --新增
       select count(1) into N_TMP from UAP_SIM.Qtsyxx t where t.zhlb = AC_I_ZHLB and t.zqzh = AC_I_ZQZH and t.khwddm = AC_I_KHWDDM;
       if N_TMP > 0 then
          C_RET_CODE := '3999';
          C_RET_MSG  := '重复报送';
          goto RET;
       end if ;
       begin
           insert into UAP_SIM.Qtsyxx(ymth, zhlb,zqzh, jydy, yybbm, khwddm, sysbrq)
           select C_YMTH,AC_I_ZHLB,AC_I_ZQZH,AC_I_JYDY, AC_I_YYBBM,AC_I_KHWDDM,to_char(sysdate, 'YYYYMMDD') from dual;
           commit;
       exception
           WHEN OTHERS  THEN
           C_RET_CODE := '0999';
           C_RET_MSG  := '其他错误：新增使用信息' || SQLCODE || '-' || SQLERRM;
       end;

    elsif AC_I_YWLB = '02' then --撤销
       select count(1) into N_TMP from UAP_SIM.Qtsyxx t where t.zhlb = AC_I_ZHLB and t.zqzh = AC_I_ZQZH and t.khwddm = AC_I_KHWDDM;
       if N_TMP = 0 then
          C_RET_CODE := '3998';
          C_RET_MSG  := '记录不存在';
          goto RET;
       end if ;
       begin
           delete from UAP_SIM.Qtsyxx t
            where t.zhlb = AC_I_ZHLB
              and t.zqzh = AC_I_ZQZH
              and t.yybbm = AC_I_KHWDDM;
           commit;
       exception
           WHEN OTHERS  THEN
           C_RET_CODE := '0999';
           C_RET_MSG  := '其他错误：撤销使用信息' || SQLCODE || '-' || SQLERRM;
       end;
    elsif AC_I_YWLB = '03' then --查询
       select count(1) into N_TMP from UAP_SIM.Qtsyxx t where t.zhlb = AC_I_ZHLB and t.zqzh = AC_I_ZQZH and t.khwddm = AC_I_KHWDDM;
       if N_TMP = 0 then
          C_RET_CODE := '3998';
          C_RET_MSG  := '记录不存在';
          goto RET;
       end if ;
    end if;

<<RET>>


               open retCursor for
        select  tt2.YWLSH,
                tt2.YWLB,
                C_YMTH as YMTH,
                tt2.ZHLB,
                tt2.ZQZH,
                tt1.ZJLB,
                tt1.ZJDM,
                tt1.JYDY,
                tt1.YYBBM,
                tt1.KHJGDM,
                tt1.KHWDDM,
                tt1.KHJGMC,
                tt1.KHWDMC,
                tt1.ZDJGMC,
                tt1.SYSBRQ,
                tt2.SQRQ,
                tt2.YWRQ,
                tt2.YWPZBS,
                tt2.JGDM,
                tt2.JGSM
          from (select t1.ymth,
                       t1.zjlb,
                       t1.zjdm,
                       t2.jydy,
                       t2.yybbm,
                       t3.khjg as KHJGDM,
                       UAP_SIM.F_GET_DICT('KHDLJG', t3.khjg) as KHJGMC,
                       t3.khjg || '0SIM' as KHWDDM,
                       '模拟开户网点名称' as KHWDMC,
                       UAP_SIM.F_GET_DICT('KHDLJG', t3.khjg) as ZDJGMC,
                       t2.sysbrq
                  from UAP_SIM.QTYMTZL t1, UAP_SIM.Qtsyxx t2,uap_sim.qtzqzhzl t3
                 where t1.ymth = t2.ymth
                       and t3.ymth = t2.ymth
                       and t3.zqzh =AC_I_ZQZH
                       and t3.zhlb = AC_I_ZHLB
                       and t2.zhlb = AC_I_ZHLB and t2.zqzh = AC_I_ZQZH) tt1
         right join (select AC_I_YWLSH as YWLSH,
                            AC_I_YWLB as YWLB,
                            AC_I_YMTH as YMTH,
                            AC_I_ZHLB as ZHLB,
                            AC_I_ZQZH as ZQZH,
                            AC_I_KHJGDM as KHJGDM,
                            AC_I_KHWDDM as KHWDDM,
                            AC_I_SQRQ as SQRQ,
                            AC_I_SQRQ as YWRQ, --此处默认业务日期与申请日期一致，暂不考虑节假日业务
                            'N' as YWPZBS,
                            C_RET_CODE as JGDM,
                            C_RET_MSG as JGSM
                       from dual) tt2
            on 1 = 1;



end ;
/
