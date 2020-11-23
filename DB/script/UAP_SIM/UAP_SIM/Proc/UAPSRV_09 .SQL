create or replace procedure uap_sim.UAPSRV_09(retCursor  OUT SYS_REFCURSOR,
                                              AC_I_YWLSH varchar2,
                                              AC_I_KHMC varchar2,
                                              AC_I_ZJLB varchar2,
                                              AC_I_ZJDM varchar2,
                                              AC_I_YMTH varchar2,
                                              AC_I_ZHLB varchar2,
                                              AC_I_ZQZH varchar2,
                                              AC_I_KHJGDM varchar2,
                                              AC_I_KHWDDM varchar2,
                                              AC_I_SQRQ varchar2
                                              ) AS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：首次交易日查询
        用途简述：对应《账户系统数据接口规范》1.44
        输入参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '09' and svr_direct = '0';
        输出参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '09' and svr_direct = '1';
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2019-08-21  fh         根据1.44版本协议创建
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    C_YMTH UAP_SIM.Qtymtzl.YMTH%TYPE;
    N_TMP      NUMBER;
begin
/* 2019-08-21 by fh
与UAPSRV_07逻辑相同，仅仅是返回字段不同
*/
       C_RET_CODE := '0000';
       C_RET_MSG  := '处理成功';
--一码通号查询
if (AC_I_YMTH IS not NULL) OR (AC_I_ZJDM is not null) then
    IF AC_I_YMTH IS not NULL THEN
        C_YMTH := AC_I_YMTH;
    elsif AC_I_ZJDM is not null then
        select ymth into C_YMTH
          from UAP_SIM.QTYMTZL
         where  zjlb = AC_I_ZJLB and khmc = AC_I_KHMC and zjdm = AC_I_ZJDM;
    end if;
    select count(1) into N_TMP from UAP_SIM.QTZQZHZL where ymth = C_YMTH;
elsif AC_I_ZQZH is not null then
       select count(1)
         into N_TMP
         from UAP_SIM.QTZQZHZL
        where zhlb = AC_I_ZHLB
          and Zqzh = AC_I_ZQZH;
end if;

    if N_TMP = 0 then
       C_RET_CODE := '3998';
       C_RET_MSG  := '在当前条件下查找不到相应的记录.';
       GOTO RET;
    end if ;

<<RET>>
if AC_I_YMTH IS not NULL or AC_I_ZJDM is not null then
       open retCursor for
        select tt2.YWLSH,
               tt1.khmc    as KHMC,
               tt1.zjlb    as ZJLB,
               tt1.zjdm    as ZJDM,
               tt1.ymth    as YMTH,
               tt1.zhlb    as ZHLB,
               tt1.zqzh    as ZQZH,
               tt1.zqzhzt  as ZQZHZT,
               tt2.KHJGDM,
               tt2.KHWDDM,
               tt2.SQRQ,
               tt1.scjyrq,
               tt2.YWRQ, --此处默认业务日期与申请日期一致，暂不考虑节假日业务
               tt2.YWPZBS,
               tt2.JGDM,
               tt2.JGSM
          from (select t1.khmc as KHMC,
                       t1.zjlb as ZJLB,
                       t1.zjdm as ZJDM,
                       t1.ymth as YMTH,
                       t1.ymtzt as YMTZT,
                       t2.zhlb as ZHLB,
                       t2.zqzh as ZQZH,
                       t2.zqzhzt as ZQZHZT,
                       t2.khfs as KHFS,
                       t2.KHRQ as KHRQ,
                       t2.scjyrq as SCJYRQ
                  from UAP_SIM.QTYMTZL t1, UAP_SIM.QTZQZHZL t2
                 where t1.ymth = t2.ymth
                   and t1.ymth = c_ymth) tt1
         right join (select AC_I_YWLSH as YWLSH,
                            AC_I_KHMC as KHMC,
                            AC_I_ZJLB as ZJLB,
                            AC_I_ZJDM as ZJDM,
                            AC_I_YMTH as YMTH,
                            AC_I_ZHLB AS ZHLB,
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
    ELSE
      --证券账号查

               open retCursor for
        select tt2.YWLSH,
               tt1.khmc    as KHMC,
               tt1.zjlb    as ZJLB,
               tt1.zjdm    as ZJDM,
               tt1.ymth    as YMTH,
               tt1.zhlb    as ZHLB,
               tt1.zqzh    as ZQZH,
               tt1.zqzhzt  as ZQZHZT,
               tt2.KHJGDM,
               tt2.KHWDDM,
               tt2.SQRQ,
               tt1.scjyrq,
               tt2.YWRQ, --此处默认业务日期与申请日期一致，暂不考虑节假日业务
               tt2.YWPZBS,
               tt2.JGDM,
               tt2.JGSM
          from (select t1.khmc as KHMC,
                       t1.zjlb as ZJLB,
                       t1.zjdm as ZJDM,
                       t1.ymth as YMTH,
                       t1.ymtzt as YMTZT,
                       t2.zhlb as ZHLB,
                       t2.zqzh as ZQZH,
                       t2.zqzhzt as ZQZHZT,
                       t2.khfs as KHFS,
                       t2.KHRQ as KHRQ,
                       t2.scjyrq as SCJYRQ
                  from UAP_SIM.QTYMTZL t1, UAP_SIM.QTZQZHZL t2
                 where t1.ymth = t2.ymth
                   and t2.zhlb = AC_I_ZHLB
                   and t2.Zqzh = AC_I_ZQZH) tt1
         right join (select AC_I_YWLSH as YWLSH,
                            AC_I_KHMC as KHMC,
                            AC_I_ZJLB as ZJLB,
                            AC_I_ZJDM as ZJDM,
                            AC_I_YMTH as YMTH,
                            AC_I_ZHLB AS ZHLB,
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
   END IF;



end ;
/
