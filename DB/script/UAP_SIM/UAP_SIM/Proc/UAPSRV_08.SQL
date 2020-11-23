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
    ��Ŀ���ƣ�UAP_SIM 1.0
    �����û���UAP_SIM
    ��Ҫ˵����
        �������ƣ�һ��ͨ�˻���ѯ
        ��;��������Ӧ���˻�ϵͳ���ݽӿڹ淶��1.44
        ���������
           �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '08' and svr_direct = '0';
        ���������
           �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '08' and svr_direct = '1';
        ���þ�����
    �����޶���
        ��Ҫ˵����
    �޶���¼��
        �޶�����    �޶���     �޸����ݼ�Ҫ˵��
        ----------  ---------  ------------------------------
        2019-07-30  fh         ����1.44�汾Э�鴴��
        2019-07-31  fh         ��ѯΪ�ղ��ܷ��ؿռ�¼�������뷵����ˮ�źͽ���ȡ�
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    N_TMP      NUMBER;
begin

    C_RET_CODE := '0000';
    C_RET_MSG  := '�����ɹ�';
--ǰ�ü��
    -- ������Ϣ��Ϊ���飬һ�ǿͻ����ơ���Ҫ����֤���ļ������Ҫ����֤���ļ����룬����һ��ͨ�˻����룻
    -- ������Ϣ������һ�鲻��Ϊ�գ�
    -- ������Ϣ����Ϊ��ʱ���걨��һ��ͨ�˻�����Ӧ�����걨�Ŀͻ�(���û�м�飬�Ժ��п�����)��

IF AC_I_YMTH IS not NULL THEN
    select count(1) into N_TMP from UAP_SIM.QTYMTZL where ymth = AC_I_YMTH;
    if N_TMP = 0 then
       C_RET_CODE := '3051';
       C_RET_MSG  := 'һ��ͨ���벻����';
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
                        AC_I_SQRQ as YWRQ, --�˴�Ĭ��ҵ����������������һ�£��ݲ����ǽڼ���ҵ��
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
       C_RET_MSG  := 'һ��ͨ���벻����';
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
                        AC_I_SQRQ as YWRQ, --�˴�Ĭ��ҵ����������������һ�£��ݲ����ǽڼ���ҵ��
                        'N' as YWPZBS,
                        C_RET_CODE as JGDM,
                        cast(C_RET_MSG as varchar2(40)) as JGSM
                   from dual) t2
        on 1 = 1;
END IF;

end ;
/