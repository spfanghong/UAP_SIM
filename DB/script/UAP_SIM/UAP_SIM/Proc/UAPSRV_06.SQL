create or replace procedure uap_sim.UAPSRV_06(retCursor  OUT SYS_REFCURSOR,
                                              AC_I_YWLSH   varchar2,
                                              AC_I_YMTH   varchar2,
                                              AC_I_ZHLB   varchar2,
                                              AC_I_ZQZH   varchar2,
                                              AC_I_KHJGDM   varchar2,
                                              AC_I_KHWDDM   varchar2,
                                              AC_I_SQRQ   varchar2
                                              ) AS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：账户注册资料查询
        用途简述：对应《账户系统数据接口规范》1.44
        输入参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '06' and svr_direct = '0';
        输出参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '06' and svr_direct = '1';
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2019-08-19  fh         根据1.44版本协议创建
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    N_TMP      NUMBER;

    C_YMTH     UAP_SIM.Qtymtzl.YMTH%TYPE;

begin

    C_RET_CODE := '0000';
    C_RET_MSG  := '处理成功';
--前置检查

    IF  AC_I_ZQZH is not null THEN
      begin
          select t.ymth into c_ymth from uap_sim.qtzqzhzl t where t.zqzh = ac_i_zqzh and t.zhlb = AC_I_ZHLB;
      exception
          WHEN OTHERS  THEN
          c_ymth  := '';
          C_RET_CODE := '3028';
          C_RET_MSG  := '证券账户不能存在或与证券账户类型不匹配';
          goto RET;
      end;
      if AC_I_ymth is not null and c_ymth <> AC_I_ymth then
         c_ymth  := '';
         C_RET_CODE := '3029';
         C_RET_MSG  := '证券账户号码与一码通号码不匹配';
         goto RET;
      end if;
    else 
      c_ymth  := AC_I_ymth;
    end if ;

<<RET>>
    open retCursor for
      select t2.YWLSH,
             t2.YMTH,
             t2.ZHLB,
             t2.ZQZH,
             t2.KHJGDM,
             t2.KHWDDM,
             t2.SQRQ,
             t1.YMTZT,
             t1.KHRQ,
             t1.XHRQ,
             t1.KHMC,
             t1.KHLB,
             t1.GJDM,
             t1.ZJLB,
             t1.ZJDM,
             t1.JZRQ,
             t1.ZJDZ,
             t1.FZZJLB,
             t1.FZZJDM,
             t1.FZJZRQ,
             t1.FZZJDZ,
             t1.KHFS,
             t1.CSRQ,
             t1.XB,
             t1.XLDM,
             t1.ZYXZ,
             t1.MZDM,
             t1.JGLB,
             t1.ZBSX,
             t1.GYSX,
             t1.JGJC,
             t1.YWMC,
             t1.GSWZ,
             t1.FRXM,
             t1.FRZJLB,
             t1.FRZJDM,
             t1.LXRXM,
             t1.LXRZJLB,
             t1.LXRZJDM,
             t1.YDDH,
             t1.GDDH,
             t1.CZHM,
             t1.LXDZ,
             t1.LXYB,
             t1.DZYX,
             t1.DXFWBS,
             t1.WLFWBS,
             t1.CPJC,
             t1.CPDQR,
             t1.CPLB,
             t1.GLRMC,
             t1.GLRZJLB,
             t1.GLRZJDM,
             t1.TGRMC,
             t1.TGRZJLB,
             t1.TGRZJDM,
             t1.BYZD1,
             t1.BYZD2,
             t1.BYZD3,
             t2.YWRQ,
             t2.YWPZBS,
             t2.WTBS,
             t2.JGDM,
             t2.JGSM

        from (select YMTZT,
                     KHRQ,
                     XHRQ,
                     KHMC,
                     KHLB,
                     GJDM,
                     ZJLB,
                     ZJDM,
                     JZRQ,
                     ZJDZ,
                     FZZJLB,
                     FZZJDM,
                     FZJZRQ,
                     FZZJDZ,
                     KHFS,
                     CSRQ,
                     XB,
                     XLDM,
                     ZYXZ,
                     MZDM,
                     JGLB,
                     ZBSX,
                     GYSX,
                     JGJC,
                     YWMC,
                     GSWZ,
                     FRXM,
                     FRZJLB,
                     FRZJDM,
                     LXRXM,
                     LXRZJLB,
                     LXRZJDM,
                     YDDH,
                     GDDH,
                     CZHM,
                     LXDZ,
                     LXYB,
                     DZYX,
                     DXFWBS,
                     WLFWBS,
                     CPJC,
                     CPDQR,
                     CPLB,
                     GLRMC,
                     GLRZJLB,
                     GLRZJDM,
                     TGRMC,
                     TGRZJLB,
                     TGRZJDM,
                     BYZD1,
                     BYZD2,
                     BYZD3
                from UAP_SIM.QTYMTZL
               where ymth = C_YMTH) t1
       right join (select AC_I_YMTH  as YMTH,
                          AC_I_YWLSH as YWLSH,
                          AC_I_ZHLB  as ZHLB,
                          AC_I_ZQZH  as ZQZH,
                          
                          AC_I_KHJGDM as KHJGDM,
                          AC_I_KHWDDM as KHWDDM,
                          AC_I_SQRQ as SQRQ,
                          AC_I_SQRQ as YWRQ, --此处默认业务日期与申请日期一致，暂不考虑节假日业务
                          '1' as WTBS, --固定返回有委托交易关系，
                          'N' as YWPZBS,
                          C_RET_CODE as JGDM,
                          C_RET_MSG as JGSM
                     from dual) t2
          on 1 = 1;

end ;
/
