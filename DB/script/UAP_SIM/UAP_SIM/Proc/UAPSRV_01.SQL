create or replace procedure uap_sim.UAPSRV_01(retCursor  OUT SYS_REFCURSOR,
                                              AC_I_YWLSH     varchar2,
                                              AC_I_KHMC      varchar2,
                                              AC_I_KHLB      varchar2,
                                              AC_I_GJDM      varchar2,
                                              AC_I_ZJLB      varchar2,
                                              AC_I_ZJDM      varchar2,
                                              AC_I_JZRQ      varchar2,
                                              AC_I_ZJDZ      varchar2,
                                              AC_I_FZZJLB    varchar2,
                                              AC_I_FZZJDM    varchar2,
                                              AC_I_FZJZRQ    varchar2,
                                              AC_I_FZZJDZ    varchar2,
                                              AC_I_KHFS      varchar2,
                                              AC_I_CSRQ      varchar2,
                                              AC_I_XB        varchar2,
                                              AC_I_XLDM      varchar2,
                                              AC_I_ZYXZ      varchar2,
                                              AC_I_MZDM      varchar2,
                                              AC_I_JGLB      varchar2,
                                              AC_I_ZBSX      varchar2,
                                              AC_I_GYSX      varchar2,
                                              AC_I_JGJC      varchar2,
                                              AC_I_YWMC      varchar2,
                                              AC_I_GSWZ      varchar2,
                                              AC_I_FRXM      varchar2,
                                              AC_I_FRZJLB    varchar2,
                                              AC_I_FRZJDM    varchar2,
                                              AC_I_LXRXM     varchar2,
                                              AC_I_LXRZJLB   varchar2,
                                              AC_I_LXRZJDM   varchar2,
                                              AC_I_YDDH      varchar2,
                                              AC_I_GDDH      varchar2,
                                              AC_I_CZHM      varchar2,
                                              AC_I_LXDZ      varchar2,
                                              AC_I_LXYB      varchar2,
                                              AC_I_DZYX      varchar2,
                                              AC_I_DXFWBS    varchar2,
                                              AC_I_WLFWBS    varchar2,
                                              AC_I_WLMM      varchar2,
                                              AC_I_KHJGDM    varchar2,
                                              AC_I_KHWDDM    varchar2,
                                              AC_I_SQRQ      varchar2,
                                              AC_I_BYZD1     varchar2,
                                              AC_I_BYZD2     varchar2,
                                              AC_I_BYZD3     varchar2
                                              ) AS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：一码通账户开立
        用途简述：对应《账户系统数据接口规范》1.44
        输入参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '01' and svr_direct = '0';
        输出参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '01' and svr_direct = '1';
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2019-07-29  fh         根据1.44版本协议创建
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    C_YMTH     varchar2(20);
    N_TMP      NUMBER;
begin

    C_RET_CODE := '0000';
    C_RET_MSG  := '处理成功';
--前置检查
    -- 20190729 by fh: 第一期仅实现基本的检查，暂不对字段有效性、字典有效性进行检查
    -- 后续应进一步完成字段有效性检查
    select count(1) into N_TMP from UAP_SIM.QTYMTZL t where t.zjlb = AC_I_ZJLB and t.zjdm = AC_I_ZJDM and t.khmc = ac_i_khmc and t.ymtzt = '0';
    if N_TMP > 0 then
       select t.ymth into C_YMTH from UAP_SIM.QTYMTZL t where t.zjlb = AC_I_ZJLB and t.zjdm = AC_I_ZJDM and t.khmc = ac_i_khmc and t.ymtzt = '0' and rownum= 1  order by t.khrq desc;
       C_RET_CODE := '3001';
       C_RET_MSG  := '主要证件已开立' || to_char(N_TMP) || '个一码通';
       GOTO RET;
    end if;

    select count(1) into N_TMP from UAP_SIM.QTYMTZL t where t.zjlb = AC_I_FZZJLB and t.zjdm =AC_I_FZZJDM and t.khmc = AC_I_KHMC and t.ymtzt = '0';
    if N_TMP > 0 then
       select t.ymth into C_YMTH from UAP_SIM.QTYMTZL t where t.zjlb = AC_I_FZZJLB and t.zjdm = AC_I_FZZJDM and t.khmc = AC_I_KHMC and t.ymtzt = '0' and rownum= 1  order by t.khrq desc;
       C_RET_CODE := '3002';
       C_RET_MSG  := '辅助证件已开立' || to_char(N_TMP) || '个一码通';
       GOTO RET;
    end if;

--新增一码通信息
    select lpad( uap_sim.seq_ymth.nextval,10,'0') into C_YMTH from dual;
    if AC_I_KHLB = '0' then
       C_YMTH := '18' || C_YMTH;
    else
       C_YMTH := '19' || C_YMTH;
    end if;
    begin
      insert into UAP_SIM.QTYMTZL (ymth,ymtzt, khrq, xhrq, khfs, khmc, khlb, gjdm, zjlb, zjdm, jzrq, zjdz, fzzjlb, fzzjdm, fzjzrq, fzzjdz, csrq, xb, xldm, zyxz, mzdm,
                                   jglb,zbsx, gysx, jgjc, ywmc, gswz, frxm, frzjlb, frzjdm,
                                   lxrxm, lxrzjlb, lxrzjdm, yddh, gddh, czhm, lxdz, lxyb,dzyx,
                                   dxfwbs, wlfwbs,
                                   --cpjc, cpdqr, cplb, glrmc, glrzjlb, glrzjdm, tgrmc, tgrzjlb, tgrzjdm,
                                   byzd1, byzd2, byzd3,
                                   std_cert_code,khjg)
      select C_YMTH,'0', to_char(SYSDATE,'YYYYMMDD'),'',AC_I_KHFS ,AC_I_KHMC,AC_I_KHLB,AC_I_GJDM,AC_I_ZJLB,AC_I_ZJDM,AC_I_JZRQ,AC_I_ZJDZ,AC_I_FZZJLB,AC_I_FZZJDM,AC_I_FZJZRQ,AC_I_FZZJDZ,AC_I_CSRQ,AC_I_XB,AC_I_XLDM,AC_I_ZYXZ,AC_I_MZDM,
             AC_I_JGLB,AC_I_ZBSX,AC_I_GYSX,AC_I_JGJC,AC_I_YWMC,AC_I_GSWZ,AC_I_FRXM,AC_I_FRZJLB,AC_I_FRZJDM,
             AC_I_LXRXM,AC_I_LXRZJLB,AC_I_LXRZJDM,AC_I_YDDH,AC_I_GDDH,AC_I_CZHM,AC_I_LXDZ,AC_I_LXYB,AC_I_DZYX,
             AC_I_DXFWBS,AC_I_WLFWBS,
             --AC_I_CPJC,AC_I_CPDQR,AC_I_CPLB,AC_I_GLRMC,AC_I_GLRZJLB,AC_I_GLRZJDM,AC_I_TGRMC,AC_I_TGRZJLB,AC_I_TGRZJDM,
             AC_I_BYZD1,AC_I_BYZD2,AC_I_BYZD3,
             UAP_SIM.F_CONV_CERT_NO(AC_I_ZJLB, AC_I_ZJDM),AC_I_KHJGDM
      FROM DUAL;
    exception
      WHEN OTHERS  THEN
      C_RET_CODE := '0999';
      C_RET_MSG  := '其他错误：新增一码通' || SQLCODE || '-' || SQLERRM;
    end;
    commit;
--组织返回数据

<<RET>>
    begin
      open retCursor for
      select AC_I_YWLSH as YWLSH,AC_I_KHMC as KHMC,AC_I_KHLB as KHLB,AC_I_GJDM as GJDM,AC_I_ZJLB as ZJLB,AC_I_ZJDM as ZJDM,AC_I_JZRQ as JZRQ,AC_I_ZJDZ as ZJDZ,AC_I_FZZJLB as FZZJLB,
             AC_I_FZZJDM as FZZJDM,AC_I_FZJZRQ as FZJZRQ,AC_I_FZZJDZ as FZZJDZ,AC_I_KHFS as KHFS,AC_I_CSRQ as CSRQ,AC_I_XB as XB,AC_I_XLDM as XLDM,AC_I_ZYXZ as ZYXZ,AC_I_MZDM as MZDM,AC_I_JGLB as JGLB,
             AC_I_ZBSX as ZBSX,AC_I_GYSX as GYSX,AC_I_JGJC as JGJC,AC_I_YWMC as YWMC,AC_I_GSWZ as GSWZ,AC_I_FRXM as FRXM,AC_I_FRZJLB as FRZJLB,AC_I_FRZJDM as FRZJDM,AC_I_LXRXM as LXRXM,
             AC_I_LXRZJLB as LXRZJLB,AC_I_LXRZJDM as LXRZJDM,AC_I_YDDH as YDDH,AC_I_GDDH as GDDH,AC_I_CZHM as CZHM,AC_I_LXDZ as LXDZ,AC_I_LXYB as LXYB,AC_I_DZYX as DZYX,AC_I_DXFWBS as DXFWBS,
             AC_I_WLFWBS as WLFWBS,AC_I_WLMM as WLMM,AC_I_KHJGDM as KHJGDM,AC_I_KHWDDM as KHWDDM,AC_I_SQRQ as SQRQ,AC_I_BYZD1 as BYZD1,AC_I_BYZD2 as BYZD2,AC_I_BYZD3 as BYZD3,
             C_YMTH as YMTH,
             to_char(sysdate, 'YYYYMMDD')as YWRQ,
             'N' as YWPZBS,
             C_RET_CODE as JGDM,
             C_RET_MSG as JGSM
      from dual;
    end ;

end ;
/
