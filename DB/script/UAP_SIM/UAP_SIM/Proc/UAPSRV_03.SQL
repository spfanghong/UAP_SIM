create or replace procedure uap_sim.UAPSRV_03(retCursor  OUT SYS_REFCURSOR,
                                              AC_I_YWLSH   varchar2,
                                              AC_I_YMTH   varchar2,
                                              AC_I_ZJLB   varchar2,
                                              AC_I_ZJDM   varchar2,
                                              AC_I_XKHMC   varchar2,
                                              AC_I_XGJDM   varchar2,
                                              AC_I_XZJLB   varchar2,
                                              AC_I_XZJDM   varchar2,
                                              AC_I_XJZRQ   varchar2,
                                              AC_I_XZJDZ   varchar2,
                                              AC_I_XFZZJLB   varchar2,
                                              AC_I_XFZZJDM   varchar2,
                                              AC_I_XFZJZRQ   varchar2,
                                              AC_I_XFZZJDZ   varchar2,
                                              AC_I_XCSRQ   varchar2,
                                              AC_I_XXB   varchar2,
                                              AC_I_XXLDM   varchar2,
                                              AC_I_XZYXZ   varchar2,
                                              AC_I_XMZDM   varchar2,
                                              AC_I_XJGLB   varchar2,
                                              AC_I_XZBSX   varchar2,
                                              AC_I_XGYSX   varchar2,
                                              AC_I_XJGJC   varchar2,
                                              AC_I_XYWMC   varchar2,
                                              AC_I_XGSWZ   varchar2,
                                              AC_I_XFRXM   varchar2,
                                              AC_I_XFRZJLB   varchar2,
                                              AC_I_XFRZJDM   varchar2,
                                              AC_I_XLXRXM   varchar2,
                                              AC_I_XLXRZJLB   varchar2,
                                              AC_I_XLXRZJDM   varchar2,
                                              AC_I_XYDDH   varchar2,
                                              AC_I_XGDDH   varchar2,
                                              AC_I_XCZHM   varchar2,
                                              AC_I_XLXDZ   varchar2,
                                              AC_I_XLXYB   varchar2,
                                              AC_I_XDZYX   varchar2,
                                              AC_I_XWLFWBS   varchar2,
                                              AC_I_XWLMM   varchar2,
                                              AC_I_KHJGDM   varchar2,
                                              AC_I_KHWDDM   varchar2,
                                              AC_I_SQRQ   varchar2,
                                              AC_I_BYZD1   varchar2,
                                              AC_I_BYZD2   varchar2,
                                              AC_I_BYZD3   varchar2
                         ) AS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：注册资料修改
        用途简述：对应《账户系统数据接口规范》1.44
        输入参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '03' and svr_direct = '0';
        输出参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '03' and svr_direct = '1';
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2019-08-17  fh         根据1.44版本协议创建
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    C_YMTH     UAP_SIM.QTYMTZL.YMTH%TYPE;
    C_ZJLB     UAP_SIM.QTYMTZL.ZJLB%TYPE;
    C_ZJDM     UAP_SIM.QTYMTZL.ZJDM%TYPE;
    C_KHMC     UAP_SIM.QTYMTZL.KHMC%TYPE; 

C_GJDM   UAP_SIM.QTYMTZL.GJDM%TYPE;      
C_JZRQ   UAP_SIM.QTYMTZL.JZRQ%TYPE;      
C_ZJDZ   UAP_SIM.QTYMTZL.ZJDZ%TYPE;      
C_FZZJLB   UAP_SIM.QTYMTZL.FZZJLB%TYPE;  
C_FZZJDM   UAP_SIM.QTYMTZL.FZZJDM%TYPE;  
C_FZJZRQ   UAP_SIM.QTYMTZL.FZJZRQ%TYPE;  
C_FZZJDZ   UAP_SIM.QTYMTZL.FZZJDZ%TYPE;  
C_CSRQ   UAP_SIM.QTYMTZL.CSRQ%TYPE;      
C_XB   UAP_SIM.QTYMTZL.XB%TYPE;          
C_XLDM   UAP_SIM.QTYMTZL.XLDM%TYPE;      
C_ZYXZ   UAP_SIM.QTYMTZL.ZYXZ%TYPE;      
C_MZDM   UAP_SIM.QTYMTZL.MZDM%TYPE;      
C_JGLB   UAP_SIM.QTYMTZL.JGLB%TYPE;      
C_ZBSX   UAP_SIM.QTYMTZL.ZBSX%TYPE;      
C_GYSX   UAP_SIM.QTYMTZL.GYSX%TYPE;      
C_JGJC   UAP_SIM.QTYMTZL.JGJC%TYPE;      
C_YWMC   UAP_SIM.QTYMTZL.YWMC%TYPE;      
C_GSWZ   UAP_SIM.QTYMTZL.GSWZ%TYPE;      
C_FRXM   UAP_SIM.QTYMTZL.FRXM%TYPE;      
C_FRZJLB   UAP_SIM.QTYMTZL.FRZJLB%TYPE;  
C_FRZJDM   UAP_SIM.QTYMTZL.FRZJDM%TYPE;  
C_LXRXM   UAP_SIM.QTYMTZL.LXRXM%TYPE;    
C_LXRZJLB   UAP_SIM.QTYMTZL.LXRZJLB%TYPE;
C_LXRZJDM   UAP_SIM.QTYMTZL.LXRZJDM%TYPE;
C_YDDH   UAP_SIM.QTYMTZL.YDDH%TYPE;      
C_GDDH   UAP_SIM.QTYMTZL.GDDH%TYPE;      
C_CZHM   UAP_SIM.QTYMTZL.CZHM%TYPE;      
C_LXDZ   UAP_SIM.QTYMTZL.LXDZ%TYPE;      
C_LXYB   UAP_SIM.QTYMTZL.LXYB%TYPE;      
C_DZYX   UAP_SIM.QTYMTZL.DZYX%TYPE;      
C_WLFWBS   UAP_SIM.QTYMTZL.WLFWBS%TYPE;  
     
      
C_BYZD1   UAP_SIM.QTYMTZL.BYZD1%TYPE;      
C_BYZD2   UAP_SIM.QTYMTZL.BYZD2%TYPE;      
C_BYZD3   UAP_SIM.QTYMTZL.BYZD3%TYPE;      


    N_TMP      NUMBER;
begin

    C_RET_CODE := '0000';
    C_RET_MSG  := '处理成功';
--前置检查


--前置检查
    -- 20190817 by fh: 第一期仅实现基本的检查，暂不对字段有效性、字典有效性进行检查
    -- 后续应进一步完成字段有效性检查
    
    select count(1) into N_TMP from UAP_SIM.QTYMTZL t where t.zjlb = AC_I_ZJLB and t.zjdm = AC_I_ZJDM and  t.ymth = AC_I_YMTH and t.ymtzt = '0';
    if N_TMP = 0 then
       C_RET_CODE := '3015';
       C_RET_MSG  := '一码通号码与身份证明文件不匹配';
       GOTO RET;
    end if;
    
    select t.KHMC,t.GJDM,t.ZJLB,t.ZJDM,t.JZRQ,t.ZJDZ,t.FZZJLB,t.FZZJDM,t.FZJZRQ,t.FZZJDZ,t.CSRQ,t.XB,t.XLDM,t.ZYXZ,t.MZDM,t.JGLB,t.ZBSX,t.GYSX,t.JGJC,t.YWMC,t.GSWZ,
           t.FRXM,t.FRZJLB,t.FRZJDM,t.LXRXM,t.LXRZJLB,t.LXRZJDM,t.YDDH,t.GDDH,t.CZHM,t.LXDZ,t.LXYB,t.DZYX,
           t.WLFWBS,
           t.BYZD1,t.BYZD2,t.BYZD3
      into C_KHMC,C_GJDM,C_ZJLB,C_ZJDM,C_JZRQ,C_ZJDZ,C_FZZJLB,C_FZZJDM,C_FZJZRQ,C_FZZJDZ,C_CSRQ,C_XB,C_XLDM,C_ZYXZ,C_MZDM,C_JGLB,C_ZBSX,C_GYSX,C_JGJC,C_YWMC,C_GSWZ,
           C_FRXM,C_FRZJLB,C_FRZJDM,C_LXRXM,C_LXRZJLB,C_LXRZJDM,C_YDDH,C_GDDH,C_CZHM,C_LXDZ,C_LXYB,C_DZYX,
           C_WLFWBS,
           C_BYZD1,C_BYZD2,C_BYZD3
      from UAP_SIM.QTYMTZL t
     where t.ymth = AC_I_YMTH;
     
   
    if AC_I_XKHMC <> '' then C_KHMC := AC_I_XKHMC; end if ;
    if AC_I_XGJDM <> '' then C_GJDM := AC_I_XGJDM; end if ;
    if AC_I_XZJLB <> '' then C_ZJLB := AC_I_XZJLB; end if ;
    if AC_I_XZJDM <> '' then C_ZJDM := AC_I_XZJDM; end if ;
    if AC_I_XJZRQ <> '' then C_JZRQ := AC_I_XJZRQ; end if ;
    if AC_I_XZJDZ <> '' then C_ZJDZ := AC_I_XZJDZ; end if ;
    if AC_I_XFZZJLB <> '' then C_FZZJLB := AC_I_XFZZJLB; end if ;
    if AC_I_XFZZJDM <> '' then C_FZZJDM := AC_I_XFZZJDM; end if ;
    if AC_I_XFZJZRQ <> '' then C_FZJZRQ := AC_I_XFZJZRQ; end if ;
    if AC_I_XFZZJDZ <> '' then C_FZZJDZ := AC_I_XFZZJDZ; end if ;
    if AC_I_XCSRQ <> '' then C_CSRQ := AC_I_XCSRQ; end if ;
    if AC_I_XXB <> '' then C_XB := AC_I_XXB; end if ;
    if AC_I_XXLDM <> '' then C_XLDM := AC_I_XXLDM; end if ;
    if AC_I_XZYXZ <> '' then C_ZYXZ := AC_I_XZYXZ; end if ;
    if AC_I_XMZDM <> '' then C_MZDM := AC_I_XMZDM; end if ;
    if AC_I_XJGLB <> '' then C_JGLB := AC_I_XJGLB; end if ;
    if AC_I_XZBSX <> '' then C_ZBSX := AC_I_XZBSX; end if ;
    if AC_I_XGYSX <> '' then C_GYSX := AC_I_XGYSX; end if ;
    if AC_I_XJGJC <> '' then C_JGJC := AC_I_XJGJC; end if ;
    if AC_I_XYWMC <> '' then C_YWMC := AC_I_XYWMC; end if ;
    if AC_I_XGSWZ <> '' then C_GSWZ := AC_I_XGSWZ; end if ;
    if AC_I_XFRXM <> '' then C_FRXM := AC_I_XFRXM; end if ;
    if AC_I_XFRZJLB <> '' then C_FRZJLB := AC_I_XFRZJLB; end if ;
    if AC_I_XFRZJDM <> '' then C_FRZJDM := AC_I_XFRZJDM; end if ;
    if AC_I_XLXRXM <> '' then C_LXRXM := AC_I_XLXRXM; end if ;
    if AC_I_XLXRZJLB <> '' then C_LXRZJLB := AC_I_XLXRZJLB; end if ;
    if AC_I_XLXRZJDM <> '' then C_LXRZJDM := AC_I_XLXRZJDM; end if ;
    if AC_I_XYDDH <> '' then C_YDDH := AC_I_XYDDH; end if ;
    if AC_I_XGDDH <> '' then C_GDDH := AC_I_XGDDH; end if ;
    if AC_I_XCZHM <> '' then C_CZHM := AC_I_XCZHM; end if ;
    if AC_I_XLXDZ <> '' then C_LXDZ := AC_I_XLXDZ; end if ;
    if AC_I_XLXYB <> '' then C_LXYB := AC_I_XLXYB; end if ;
    if AC_I_XDZYX <> '' then C_DZYX := AC_I_XDZYX; end if ;
    if AC_I_XWLFWBS <> '' then C_WLFWBS := AC_I_XWLFWBS; end if ;

    if AC_I_BYZD1 <> '' then C_BYZD1 := AC_I_BYZD1; end if ;
    if AC_I_BYZD2 <> '' then C_BYZD2 := AC_I_BYZD2; end if ;
    if AC_I_BYZD3 <> '' then C_BYZD3 := AC_I_BYZD3; end if ;


    
    select count(1) into N_TMP from UAP_SIM.QTYMTZL t where t.zjlb = AC_I_XZJLB and t.zjdm = AC_I_XZJDM and t.khmc = AC_I_XKHMC and t.ymtzt = '0';
    
    if N_TMP > 0 then
       C_RET_CODE := '3001';
       C_RET_MSG  := '主要证件已开立' || to_char(N_TMP) || '个一码通';
       GOTO RET;
    end if;

    select count(1) into N_TMP from UAP_SIM.QTYMTZL t where t.zjlb = AC_I_XFZZJLB and t.zjdm =AC_I_XFZZJDM and t.khmc = AC_I_XKHMC and t.ymtzt = '0';
    if N_TMP > 0 then
       C_RET_CODE := '3002';
       C_RET_MSG  := '辅助证件已开立' || to_char(N_TMP) || '个一码通';
       GOTO RET;
    end if;
    
    select count(1) into N_TMP from UAP_SIM.QTZQZHZL t where t.ymth = AC_I_YMTH and t.glgxbs = '0' and t.zqzhzt = '00' ;
    if ( N_TMP >=1) then
       C_RET_CODE := '3014';
       C_RET_MSG  := '一码通下有未确认关联关系的证券账户';
       GOTO RET;
    end if ;


--修改一码通注册资料

    begin 
      update UAP_SIM.QTYMTZL t
      set  (
           t.KHMC,t.GJDM,t.ZJLB,t.ZJDM,t.JZRQ,t.ZJDZ,t.FZZJLB,t.FZZJDM,t.FZJZRQ,t.FZZJDZ,t.CSRQ,t.XB,t.XLDM,t.ZYXZ,t.MZDM,t.JGLB,t.ZBSX,t.GYSX,t.JGJC,t.YWMC,t.GSWZ,
           t.FRXM,t.FRZJLB,t.FRZJDM,t.LXRXM,t.LXRZJLB,t.LXRZJDM,t.YDDH,t.GDDH,t.CZHM,t.LXDZ,t.LXYB,t.DZYX,
           t.WLFWBS,
           t.BYZD1,t.BYZD2,t.BYZD3
           )
          =(select 
           C_KHMC,C_GJDM,C_ZJLB,C_ZJDM,C_JZRQ,C_ZJDZ,C_FZZJLB,C_FZZJDM,C_FZJZRQ,C_FZZJDZ,C_CSRQ,C_XB,C_XLDM,C_ZYXZ,C_MZDM,C_JGLB,C_ZBSX,C_GYSX,C_JGJC,C_YWMC,C_GSWZ,
           C_FRXM,C_FRZJLB,C_FRZJDM,C_LXRXM,C_LXRZJLB,C_LXRZJDM,C_YDDH,C_GDDH,C_CZHM,C_LXDZ,C_LXYB,C_DZYX,
           C_WLFWBS,
           C_BYZD1,C_BYZD2,C_BYZD3
           from dual)
      where t.ymth = AC_I_YMTH;
      commit;
    exception
      WHEN OTHERS  THEN
      C_RET_CODE := '0999';
      C_RET_MSG  := '其他错误：新增证券账户' || SQLCODE || '-' || SQLERRM;
    end;
--组织返回数据

<<RET>>
    begin
      open retCursor for
      select AC_I_YWLSH as YWLSH,
      AC_I_YMTH as YMTH,
      AC_I_ZJLB as ZJLB,
      AC_I_ZJDM as ZJDM,
      AC_I_XKHMC as XKHMC,
      AC_I_XGJDM as XGJDM,
      AC_I_XZJLB as XZJLB,
      AC_I_XZJDM as XZJDM,
      AC_I_XJZRQ as XJZRQ,
      AC_I_XZJDZ as XZJDZ,
      AC_I_XFZZJLB as XFZZJLB,
      AC_I_XFZZJDM as XFZZJDM,
      AC_I_XFZJZRQ as XFZJZRQ,
      AC_I_XFZZJDZ as XFZZJDZ,
      AC_I_XCSRQ as XCSRQ,
      AC_I_XXB as XXB,
      AC_I_XXLDM as XXLDM,
      AC_I_XZYXZ as XZYXZ,
      AC_I_XMZDM as XMZDM,
      AC_I_XJGLB as XJGLB,
      AC_I_XZBSX as XZBSX,
      AC_I_XGYSX as XGYSX,
      AC_I_XJGJC as XJGJC,
      AC_I_XYWMC as XYWMC,
      AC_I_XGSWZ as XGSWZ,
      AC_I_XFRXM as XFRXM,
      AC_I_XFRZJLB as XFRZJLB,
      AC_I_XFRZJDM as XFRZJDM,
      AC_I_XLXRXM as XLXRXM,
      AC_I_XLXRZJLB as XLXRZJLB,
      AC_I_XLXRZJDM as XLXRZJDM,
      AC_I_XYDDH as XYDDH,
      AC_I_XGDDH as XGDDH,
      AC_I_XCZHM as XCZHM,
      AC_I_XLXDZ as XLXDZ,
      AC_I_XLXYB as XLXYB,
      AC_I_XDZYX as XDZYX,
      AC_I_XWLFWBS as XWLFWBS,
      AC_I_XWLMM as XWLMM,
      AC_I_KHJGDM as KHJGDM,
      AC_I_KHWDDM as KHWDDM,
      AC_I_SQRQ as SQRQ,
      AC_I_BYZD1 as BYZD1,
      AC_I_BYZD2 as BYZD2,
      AC_I_BYZD3 as BYZD3,
             to_char(sysdate, 'YYYYMMDD')as YWRQ,
             'N' as YWPZBS,
             C_RET_CODE as JGDM,
             C_RET_MSG as JGSM
      from dual;
    end ;

end ;
/
