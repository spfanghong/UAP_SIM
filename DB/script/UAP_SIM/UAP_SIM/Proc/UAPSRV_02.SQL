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
    ��Ŀ���ƣ�UAP_SIM 1.0
    �����û���UAP_SIM
    ��Ҫ˵����
        �������ƣ�֤ȯ�˻�����
        ��;��������Ӧ���˻�ϵͳ���ݽӿڹ淶��1.44
        ���������
           �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '02' and svr_direct = '0';
        ���������
           �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '02' and svr_direct = '1';
        ���þ�����
    �����޶���
        ��Ҫ˵����
    �޶���¼��
        �޶�����    �޶���     �޸����ݼ�Ҫ˵��
        ----------  ---------  ------------------------------
        2019-08-06  fh         ����1.44�汾Э�鴴��
        2019-08-21  fh         ������ͬʱֱ��ģ���ױʽ�����Ϊ������
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    C_YMTH     UAP_SIM.QTYMTZL.YMTH%TYPE;
    C_YMZT     UAP_SIM.QTYMTZL.YMTZT%TYPE;
    C_KHLB     UAP_SIM.QTYMTZL.KHLB%TYPE; --�ͻ����
    C_GJDM     UAP_SIM.QTYMTZL.GJDM%TYPE; --���Ҵ���
    C_ZJLB     UAP_SIM.QTYMTZL.ZJLB%TYPE;

    C_ZQZH     UAP_SIM.Qtzqzhzl.ZQZH%type;
    N_TMP      NUMBER;
begin

    C_RET_CODE := '0000';
    C_RET_MSG  := '�����ɹ�';
--ǰ�ü��
    -- 20190806 by fh: ��һ�ڽ�ʵ�ֻ����ļ�飬�ݲ����ֶ���Ч�ԡ��ֵ���Ч�Խ��м��
    -- ����Ӧ��һ������ֶ���Ч�Լ��
    select count(1)
      into N_TMP
      from UAP_SIM.QTYMTZL t
     where t.ymth = AC_I_YMTH
       and t.ymtzt = '0';

    if N_TMP <> 1  then
       C_RET_CODE := '3010';
       C_RET_MSG  := 'һ��ͨ�˻����벻���ڻ�״̬������'; --ʵ���Ƿֳ���������������
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

    if (C_GJDM not in ('CHN','HKG','MAK','CTN') and C_ZJLB not in ('01','07','08','09') and AC_I_ZHLB in( '11','21'))   --���й����� ���ܿ�A��
       OR ( C_GJDM in ('CHN') and C_KHLB = '1' and AC_I_ZHLB in( '12','22' ))  --���ڻ���������B��
       then
       C_RET_CODE := '3013';
       C_RET_MSG  := '�ͻ����ܿ�������֤ȯ�˻�';
       GOTO RET;
    end if;

    if ( AC_I_ZHLB in( '11','13','21','23') and N_TMP >=3) or (AC_I_ZHLB not in( '11','13','21','23') and N_TMP >=1) then  --A��3��������1��
       C_RET_CODE := '3056';
       C_RET_MSG  := '�ͻ�������֤ȯ�˻�������������';
       GOTO RET;
    end if ;

    select count(1)
      into N_TMP
      from UAP_SIM.Qtzqzhzl t
     where t.ymth = AC_I_YMTH
       and t.glgxbs = '0' ;

    if ( N_TMP >=1) then
       C_RET_CODE := '3014';
       C_RET_MSG  := 'һ��ͨ����δȷ�Ϲ�����ϵ��֤ȯ�˻�';
       GOTO RET;
    end if ;
    
    select count(1)
      into N_TMP
      from UAP_SIM.Qtzqzhzl t
     where t.ymth = AC_I_YMTH
       and t.zqzh = AC_I_PHZQZH
       and t.zhlb in ('11','21')  --������͵����������Ĳ���д��ϸ��
       and t.zqzhzt = '00' ;
       
    if ( N_TMP <1 ) AND AC_I_ZHLB IN ('14','24') then
       C_RET_CODE := '3020';
       C_RET_MSG  := '���֤ȯ�˻����벻�Ϸ�';
       GOTO RET;
    end if ;


--����֤ȯ�˺�
    if substr(AC_I_ZHLB,1,1) = '1' then
       select lpad( uap_sim.seq_shzqzh.nextval,8,'0') into C_ZQZH from dual;
    else
       select lpad( uap_sim.seq_sZzqzh.nextval,8,'0') into C_ZQZH from dual;
    end if ;

    if AC_I_ZHLB  = '11' and C_KHLB = '0' and C_GJDM  in ('CHN','HKG','MAK','CTN') then --�Ϻ�����һ����� A��
       C_ZQZH := 'A0' || C_ZQZH;
    elsif AC_I_ZHLB  = '11' and C_KHLB = '1' and C_GJDM = 'CHN' then --�Ϻ�����һ�����A��
       C_ZQZH := 'B0' || C_ZQZH;
    elsif AC_I_ZHLB  = '12' and C_KHLB = '0' and C_GJDM = 'CHN' then --�Ϻ����ڸ���B��
       C_ZQZH := 'C1' || C_ZQZH;
    elsif AC_I_ZHLB  = '12' and C_KHLB = '0' and C_GJDM <> 'CHN' then --�Ϻ��������B��
       C_ZQZH := 'C91' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '12' and C_KHLB = '1' and C_GJDM <> 'CHN' then --�Ϻ��������B��
       C_ZQZH := 'C99' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '13'  then --�Ϻ����ʽ����
       C_ZQZH := 'F0' || C_ZQZH;
    elsif AC_I_ZHLB  = '14'  then --�Ϻ�����
       C_ZQZH := 'E0' || C_ZQZH;
    elsif AC_I_ZHLB  = '15'  then --�Ϻ�����Ʒ
       C_ZQZH := AC_I_PHZQZH || '888' ;
    elsif AC_I_ZHLB  = '21' and C_KHLB = '0' and C_GJDM  in ('CHN','HKG','MAK','CTN') then --���ھ���һ����� A��
       C_ZQZH := '01' || C_ZQZH;
    elsif AC_I_ZHLB  = '21' and C_KHLB = '1' and C_GJDM = 'CHN' then --���ھ���һ�����A��
       C_ZQZH := '08' || C_ZQZH;
    elsif AC_I_ZHLB  = '22' and C_KHLB = '0' and C_GJDM = 'CHN' then --���ھ��ڸ���B��
       C_ZQZH := '201' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '22' and C_KHLB = '0' and C_GJDM <> 'CHN' then --���ھ������B��
       C_ZQZH := '270' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '22' and C_KHLB = '1' and C_GJDM <> 'CHN' then --���ھ������B��
       C_ZQZH := '287' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '23'  then --���ڷ��ʽ����
       C_ZQZH := '05' || C_ZQZH;
    elsif AC_I_ZHLB  = '24' and C_KHLB = '0' then --�������ø���
       C_ZQZH := '060' || substr(C_ZQZH,2,7);
    elsif AC_I_ZHLB  = '24' and C_KHLB = '1' then --�������û���
       C_ZQZH := '068' || substr(C_ZQZH,2,7);
    else
       C_ZQZH := 'ERR' || substr(C_ZQZH,2,7);   --����û���ǵ��Ļ�
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
      C_RET_MSG  := '������������֤ȯ�˻�' || SQLCODE || '-' || SQLERRM;
    end;
--��֯��������

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