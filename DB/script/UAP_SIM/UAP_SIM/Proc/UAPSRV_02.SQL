create or replace procedure uap_sim.UAPSRV_02(retCursor  OUT SYS_REFCURSOR,
                                              AC_I_YWLSH   varchar2,
                                              AC_I_YMTH   varchar2,
                                              AC_I_ZHLB   varchar2,
                                              AC_I_ZJLB   varchar2,
                                              AC_I_ZJDM   varchar2,
                                              AC_I_KHFS   varchar2,
                                              AC_I_PHZQZH   varchar2,
                                              AC_I_XYJYDY   varchar2,
                                              AC_I_JSCYR   varchar2,
                                              AC_I_BYZD   varchar2,
                                              AC_I_KHJGDM   varchar2,
                                              AC_I_KHWDDM   varchar2,
                                              AC_I_SQRQ   varchar2
                                              ) AS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：证券账户开立
        用途简述：对应《账户系统数据接口规范》1.44
        输入参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '02' and svr_direct = '0';
        输出参数：
           详见：select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '02' and svr_direct = '1';
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2019-08-06  fh         根据1.44版本协议创建
        2019-08-21  fh         开户的同时直接模拟首笔交易日为开户日
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    C_YMTH     UAP_SIM.QTYMTZL.YMTH%TYPE;
    C_YMZT     UAP_SIM.QTYMTZL.YMTZT%TYPE;
    C_KHLB     UAP_SIM.QTYMTZL.KHLB%TYPE; --客户类别
    C_GJDM     UAP_SIM.QTYMTZL.GJDM%TYPE; --国家代码
    C_ZJLB     UAP_SIM.QTYMTZL.ZJLB%TYPE;

    C_ZQZH     UAP_SIM.Qtzqzhzl.ZQZH%type;
    N_TMP      NUMBER;
begin

    C_RET_CODE := '0000';
    C_RET_MSG  := '处理成功';
--前置检查
    -- 20190806 by fh: 第一期仅实现基本的检查，暂不对字段有效性、字典有效性进行检查
    -- 后续应进一步完成字段有效性检查
    select count(1)
      into N_TMP
      from UAP_SIM.QTYMTZL t
     where t.ymth = AC_I_YMTH
       and t.ymtzt = '0';

    if N_TMP <> 1  then
       C_RET_CODE := '3010';
       C_RET_MSG  := '一码通账户号码不存在或状态不正常'; --实际是分成三个错误代码检查的
       GOTO RET;
    end if;

    select t.khlb, t.gjdm ,t.zjlb,t.ymtzt,t.Ymth
      into C_KHLB, C_GJDM,C_ZJLB,C_YMZT,C_YMTH
      from UAP_SIM.QTYMTZL t
     where t.ymth = AC_I_YMTH
       and t.ymtzt = '0';

    select count(1)
      into N_TMP
      from UAP_SIM.Qtzqzhzl t
     where t.ymth = AC_I_YMTH
       and t.zhlb = AC_I_ZHLB
       and t.zqzhzt <> '04';

    if (C_GJDM not in ('CHN','HKG','MAK','CTN') and C_ZJLB not in ('01','07','08','09') and AC_I_ZHLB in( '11','21'))   --非中国国籍 不能开A股
       OR ( C_GJDM in ('CHN') and C_KHLB = '1' and AC_I_ZHLB in( '12','22' ))  --境内机构不许开B股
       then
       C_RET_CODE := '3013';
       C_RET_MSG  := '客户不能开立此类证券账户';
       GOTO RET;
    end if;

    if ( AC_I_ZHLB in( '11','13','21','23') and N_TMP >=3) or (AC_I_ZHLB not in( '11','13','21','23') and N_TMP >=1) then  --A股3个，其他1个
       C_RET_CODE := '3056';
       C_RET_MSG  := '客户开立的证券账户超过限制数量';
       GOTO RET;
    end if ;

    select count(1)
      into N_TMP
      from UAP_SIM.Qtzqzhzl t
     where t.ymth = AC_I_YMTH
       and t.glgxbs = '0' ;

    if ( N_TMP >=1) then
       C_RET_CODE := '3014';
       C_RET_MSG  := '一码通下有未确认关联关系的证券账户';
       GOTO RET;
    end if ;
    
    select count(1)
      into N_TMP
      from UAP_SIM.Qtzqzhzl t
     where t.ymth = AC_I_YMTH
       and t.zqzh = AC_I_PHZQZH
       and t.zhlb in ('11','21')  --很罪恶的偷懒，但我真的不想写详细了
       and t.zqzhzt = '00' ;
       
    if ( N_TMP <1 ) AND AC_I_ZHLB IN ('14','24') then
       C_RET_CODE := '3020';
       C_RET_MSG  := '配号证券账户号码不合法';
       GOTO RET;
    end if ;


--新增证券账号
    if substr(AC_I_ZHLB,1,1) = '1' then
       select lpad( uap_sim.seq_shzqzh.nextval,8,'0') into C_ZQZH from dual;
    else
       select lpad( uap_sim.seq_sZzqzh.nextval,8,'0') into C_ZQZH from dual;
    end if ;

    if AC_I_ZHLB  = '11' and C_KHLB = '0' and C_GJDM  in ('CHN','HKG','MAK','CTN') then --上海境内一般个人 A股
       C_ZQZH := 'A0' || C_ZQZH;
    elsif AC_I_ZHLB  = '11' and C_KHLB = '1' and C_GJDM = 'CHN' then --上海境内一般机构A股
       C_ZQZH := 'B0' || C_ZQZH;
    elsif AC_I_ZHLB  = '12' and C_KHLB = '0' and C_GJDM = 'CHN' then --上海境内个人B股
       C_ZQZH := 'C1' || C_ZQZH;
    elsif AC_I_ZHLB  = '12' and C_KHLB = '0' and C_GJDM <> 'CHN' then --上海境外个人B股
       C_ZQZH := 'C91' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '12' and C_KHLB = '1' and C_GJDM <> 'CHN' then --上海境外机构B股
       C_ZQZH := 'C99' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '13'  then --上海封闭式基金
       C_ZQZH := 'F0' || C_ZQZH;
    elsif AC_I_ZHLB  = '14'  then --上海信用
       C_ZQZH := 'E0' || C_ZQZH;
    elsif AC_I_ZHLB  = '15'  then --上海衍生品
       C_ZQZH := AC_I_PHZQZH || '888' ;
    elsif AC_I_ZHLB  = '21' and C_KHLB = '0' and C_GJDM  in ('CHN','HKG','MAK','CTN') then --深圳境内一般个人 A股
       C_ZQZH := '01' || C_ZQZH;
    elsif AC_I_ZHLB  = '21' and C_KHLB = '1' and C_GJDM = 'CHN' then --深圳境内一般机构A股
       C_ZQZH := '08' || C_ZQZH;
    elsif AC_I_ZHLB  = '22' and C_KHLB = '0' and C_GJDM = 'CHN' then --深圳境内个人B股
       C_ZQZH := '201' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '22' and C_KHLB = '0' and C_GJDM <> 'CHN' then --深圳境外个人B股
       C_ZQZH := '270' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '22' and C_KHLB = '1' and C_GJDM <> 'CHN' then --深圳境外机构B股
       C_ZQZH := '287' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '23'  then --深圳封闭式基金
       C_ZQZH := '05' || C_ZQZH;
    elsif AC_I_ZHLB  = '24' and C_KHLB = '0' then --深圳信用个人
       C_ZQZH := '060' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '24' and C_KHLB = '1' then --深圳信用机构
       C_ZQZH := '068' || substr(C_ZQZH,2,7);
    else
       C_ZQZH := 'ERR' || substr(C_ZQZH,2,7);   --其他没考虑到的户
    end if;

    begin
      insert into UAP_SIM.QTZQZHZL (ymth, ymtzt,
                                   zhlb,zqzh,zqzhzt,khfs,khrq,glgxbs,
                                   khjg,gljg,gzbs,
                                   bhgbs,SCJYRQ)
      select C_YMTH,C_YMZT,
             AC_I_ZHLB,C_ZQZH,'00',AC_I_KHFS,AC_I_SQRQ,'1',
             AC_I_KHJGDM,AC_I_KHJGDM,'0',
             '0',AC_I_SQRQ
      FROM DUAL;
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
              AC_I_ZHLB as ZHLB,
              AC_I_ZJLB as ZJLB,
              AC_I_ZJDM as ZJDM,
              AC_I_KHFS as KHFS,
              AC_I_PHZQZH as PHZQZH,
              AC_I_XYJYDY as XYJYDY,
              AC_I_JSCYR as JSCYR,
              AC_I_BYZD as BYZD,
              AC_I_KHJGDM as KHJGDM,
              AC_I_KHWDDM as KHWDDM,
              AC_I_SQRQ as SQRQ,
              C_ZQZH as ZQZH,
             to_char(sysdate, 'YYYYMMDD')as YWRQ,
             'N' as YWPZBS,
             C_RET_CODE as JGDM,
             C_RET_MSG as JGSM
      from dual;
    end ;

end ;
/
