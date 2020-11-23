create or replace procedure uap_sim.UAPSRV_08(retCursor  OUT SYS_REFCURSOR,
                                              AC_I_YWLSH     varchar2,
                                              AC_I_KHMC   varchar2,
                                              AC_I_ZJLB   varchar2,
                                              AC_I_ZJDM   varchar2,
                                              AC_I_YMTH   varchar2,
                                              AC_I_KHJGDM   varchar2,
                                              AC_I_KHWDDM   varchar2,
                                              AC_I_SQRQ   varchar2
                                              ) AS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：一码通账户查询
        用途简述：对应《账户系统数据接口规范》1.44
        输入参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '08' and svr_direct = '0';
        输出参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '08' and svr_direct = '1';
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2019-07-30  fh         根据1.44版本协议创建
        2019-07-31  fh         查询为空不能返回空记录集，必须返回流水号和结果等。
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    N_TMP      NUMBER;
begin

    C_RET_CODE := '0000';
    C_RET_MSG  := '处理成功';
--前置检查
    -- 请求信息分为两组，一是客户名称、主要身份证明文件类别、主要身份证明文件代码，二是一码通账户号码；
    -- 两组信息中至少一组不能为空，
    -- 两组信息都不为空时，申报的一码通账户号码应属于申报的客户(这个没有检查，以后有空再做)。

IF AC_I_YMTH IS not NULL THEN
    select count(1) into N_TMP from UAP_SIM.QTYMTZL where ymth = AC_I_YMTH;
    if N_TMP = 0 then
       C_RET_CODE := '3051';
       C_RET_MSG  := '一码通号码不存在';
    end if ;
    open retCursor for
    select t2.ywlsh  as YWLSH,
           t1.khmc   as KHMC,
           t1.zjlb   as ZJLB,
           t1.zjdm   as ZJDM,
           t2.ymth   as YMTH,
           t1.ymtzt  as YMTZT,
           t1.khfs   as KHFS,
           t1.khrq   as KHRQ,
           t1.khjgmc as KHJGMC,
           t1.xhjgmc as XHRQ,
           t1.xhjgmc as XHJGMC,
           t2.khjgdm as KHJGDM,
           t2.khwddm as KHWDDM,
           t2.sqrq   as SQRQ,
           t2.sqrq   as YWRQ,
           t2.ywpzbs as ywpzbs,
           t2.jgdm   as JGDM,
           t2.jgsm   as JGSM
      from (select khmc,
                   zjlb,
                   zjdm,
                   ymtzt,
                   khfs,
                   khrq,
                   UAP_SIM.F_GET_DICT('KHDLJG', khjg) as KHJGMC,
                   xhrq,
                   UAP_SIM.F_GET_DICT('KHDLJG', xhjg) as XHJGMC
              from UAP_SIM.QTYMTZL
             where ymth = AC_I_YMTH) t1
      right join (select AC_I_YMTH as ymth,
                        AC_I_YWLSH as YWLSH,
                        AC_I_KHJGDM as KHJGDM,
                        AC_I_KHWDDM as KHWDDM,
                        AC_I_SQRQ as SQRQ,
                        AC_I_SQRQ as YWRQ, --此处默认业务日期与申请日期一致，暂不考虑节假日业务
                        'N' as YWPZBS,
                        C_RET_CODE as JGDM,
                        cast(C_RET_MSG as varchar2(40)) as JGSM
                   from dual) t2
        on 1 = 1;


ELSif AC_I_ZJDM is not null then
    select count(1)
      into N_TMP
     from UAP_SIM.QTYMTZL
     where zjlb = AC_I_ZJLB
       and khmc = AC_I_KHMC
       and zjdm = AC_I_ZJDM;
    if N_TMP = 0 then
       C_RET_CODE := '3051';
       C_RET_MSG  := '一码通号码不存在';
    end if ;
    open retCursor for
    select t2.ywlsh  as YWLSH,
           t2.khmc   as KHMC,
           t2.zjlb   as ZJLB,
           t2.zjdm   as ZJDM,
           t1.ymth   as YMTH,
           t1.ymtzt  as YMTZT,
           t1.khfs   as KHFS,
           t1.khrq   as KHRQ,
           t1.khjgmc as KHJGMC,
           t1.xhjgmc as XHRQ,
           t1.xhjgmc as XHJGMC,
           t2.khjgdm as KHJGDM,
           t2.khwddm as KHWDDM,
           t2.sqrq   as SQRQ,
           t2.sqrq   as YWRQ,
           t2.ywpzbs as ywpzbs,
           t2.jgdm   as JGDM,
           t2.jgsm   as JGSM
      from (select ymth,
                   ymtzt,
                   khfs,
                   khrq,
                   UAP_SIM.F_GET_DICT('KHDLJG', khjg) as KHJGMC,
                   xhrq,
                   UAP_SIM.F_GET_DICT('KHDLJG', xhjg) as XHJGMC
              from UAP_SIM.QTYMTZL
             where zjlb = AC_I_ZJLB
                   and khmc = AC_I_KHMC
                   and zjdm = AC_I_ZJDM ) t1
      right join (select
                   AC_I_KHMC as KHMC,
                   AC_I_ZJLB as ZJLB,
                   AC_I_ZJDM as ZJDM,
                        AC_I_YWLSH as YWLSH,
                        AC_I_KHJGDM as KHJGDM,
                        AC_I_KHWDDM as KHWDDM,
                        AC_I_SQRQ as SQRQ,
                        AC_I_SQRQ as YWRQ, --此处默认业务日期与申请日期一致，暂不考虑节假日业务
                        'N' as YWPZBS,
                        C_RET_CODE as JGDM,
                        cast(C_RET_MSG as varchar2(40)) as JGSM
                   from dual) t2
        on 1 = 1;
END IF;

end ;
/
