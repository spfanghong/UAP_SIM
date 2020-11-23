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
    ��Ŀ���ƣ�UAP_SIM 1.0
    �����û���UAP_SIM
    ��Ҫ˵����
        �������ƣ��״ν����ղ�ѯ
        ��;��������Ӧ���˻�ϵͳ���ݽӿڹ淶��1.44
        ���������
           �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '09' and svr_direct = '0';
        ���������
           �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '09' and svr_direct = '1';
        ���þ�����
    �����޶���
        ��Ҫ˵����
    �޶���¼��
        �޶�����    �޶���     �޸����ݼ�Ҫ˵��
        ----------  ---------  ------------------------------
        2019-08-21  fh         ����1.44�汾Э�鴴��
    ******************************************************************/
    C_RET_CODE varchar2(4);
    C_RET_MSG  varchar2(40);
    C_YMTH UAP_SIM.Qtymtzl.YMTH%TYPE;
    N_TMP      NUMBER;
begin
/* 2019-08-21 by fh
��UAPSRV_07�߼���ͬ�������Ƿ����ֶβ�ͬ
*/
       C_RET_CODE := '0000';
       C_RET_MSG  := '�����ɹ�';
--һ��ͨ�Ų�ѯ
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
       C_RET_MSG  := '�ڵ�ǰ�����²��Ҳ�����Ӧ�ļ�¼.';
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
               tt2.YWRQ, --�˴�Ĭ��ҵ����������������һ�£��ݲ����ǽڼ���ҵ��
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
                            AC_I_SQRQ as YWRQ, --�˴�Ĭ��ҵ����������������һ�£��ݲ����ǽڼ���ҵ��
                            'N' as YWPZBS,
                            C_RET_CODE as JGDM,
                            C_RET_MSG as JGSM
                       from dual) tt2
            on 1 = 1;
    ELSE
      --֤ȯ�˺Ų�

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
               tt2.YWRQ, --�˴�Ĭ��ҵ����������������һ�£��ݲ����ǽڼ���ҵ��
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
                            AC_I_SQRQ as YWRQ, --�˴�Ĭ��ҵ����������������һ�£��ݲ����ǽڼ���ҵ��
                            'N' as YWPZBS,
                            C_RET_CODE as JGDM,
                            C_RET_MSG as JGSM
                       from dual) tt2
            on 1 = 1;
   END IF;



end ;
/