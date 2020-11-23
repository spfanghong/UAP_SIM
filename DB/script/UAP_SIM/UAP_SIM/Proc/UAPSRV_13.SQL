CREATE OR REPLACE PROCEDURE UAP_SIM.UAPSRV_13(RETCURSOR   OUT SYS_REFCURSOR,
                                              AC_I_YWLSH  VARCHAR2,
                                              AC_I_YWLB   VARCHAR2,
                                              AC_I_YMTH   VARCHAR2,
                                              AC_I_ZHLB   VARCHAR2,
                                              AC_I_ZQZH   VARCHAR2,
                                              AC_I_SDXLB  VARCHAR2,
                                              AC_I_QYLB   VARCHAR2,
                                              AC_I_QYRQ   VARCHAR2,
                                              AC_I_YYBBM  VARCHAR2,
                                              AC_I_KHJGDM VARCHAR2,
                                              AC_I_KHWDDM VARCHAR2,
                                              AC_I_SQRQ   VARCHAR2) AS
  /******************************************************************
  ��Ŀ���ƣ�UAP_SIM 1.0
  �����û���UAP_SIM
  ��Ҫ˵����
      �������ƣ�13)  �ʵ��Թ�����Ϣά��
      ��;��������Ӧ���˻�ϵͳ���ݽӿڹ淶��1.47
      ���������
         �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '11' and svr_direct = '0';
      ���������
         �����select * from uap_sim.cfg_jkinfo where svr_name = 'UAPSRV' and svr_type = '11' and svr_direct = '1';
      ���þ�����
  �����޶���
      ��Ҫ˵����
  �޶���¼��
      �޶�����    �޶���     �޸����ݼ�Ҫ˵��
      ----------  ---------  ------------------------------
      2020-9-9    wxp     ����1.47�汾Э�鴴��
  ******************************************************************/
  C_RET_CODE VARCHAR2(4);
  C_RET_MSG  VARCHAR2(40);
  C_YMTH     UAP_SIM.QTYMTZL.YMTH%TYPE;
  N_TMP      NUMBER;
  D_QYRQ     DATE;
BEGIN

  C_RET_CODE := '0000';
  C_RET_MSG  := '�����ɹ�';
  -- ǰ�ü��
  --1001 %s����Ϊ��
  IF AC_I_YWLSH IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'YWLSH����Ϊ��';
    GOTO RET;
  ELSIF AC_I_YWLB IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'YWLB����Ϊ��';
    GOTO RET;
  ELSIF AC_I_ZHLB IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'ZHLB����Ϊ��';
    GOTO RET;
  ELSIF AC_I_ZQZH IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'ZQZH����Ϊ��';
    GOTO RET;
  ELSIF AC_I_SDXLB IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'SDXLB����Ϊ��';
    GOTO RET;
  ELSIF AC_I_KHJGDM IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'KHJGDM����Ϊ��';
    GOTO RET;
  ELSIF AC_I_KHWDDM IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'KHWDDM����Ϊ��';
    GOTO RET;
  ELSIF AC_I_SQRQ IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'SQRQ����Ϊ��';
    GOTO RET;
  END IF;

  --YWLB ҵ�����  01���ʵ��Թ�����Ϣ������02���ʵ��Թ�����Ϣ������03���ʵ��Թ�����Ϣ��ѯ
  --SDXLB �ʵ������ 1-��ҵ�� 2-�ƴ���
  /*1055  �ʵ�����𲻺Ϸ�
  1056  ǩԼ��𲻺Ϸ�
  1057  ǩԼ���ڲ��Ϸ�
  1058  ǩԼӪҵ�����벻�Ϸ�
  */
  IF AC_I_SDXLB NOT IN ('1', '2') THEN
    C_RET_CODE := '1055';
    C_RET_MSG  := '�ʵ�����𲻺Ϸ�';
    GOTO RET;
  END IF;
  IF AC_I_YWLB = '01' AND AC_I_SDXLB = '1' THEN
    IF AC_I_QYLB IS NULL THEN
      C_RET_CODE := '1001';
      C_RET_MSG  := 'QYLB����Ϊ��';
      GOTO RET;
    ELSIF AC_I_QYLB <> 'N' THEN
      C_RET_CODE := '1056';
      C_RET_MSG  := 'ǩԼ��𲻺Ϸ�';
      GOTO RET;
    END IF;
  END IF;
  IF AC_I_YWLB = '01' AND AC_I_QYRQ IS NULL THEN
    C_RET_CODE := '1001';
    C_RET_MSG  := 'QYRQ����Ϊ��';
    GOTO RET;
  ELSIF AC_I_YWLB = '01' THEN
    BEGIN
      SELECT TO_DATE(AC_I_QYRQ, 'YYYYMMDD') INTO D_QYRQ FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        C_RET_CODE := '1057';
        C_RET_MSG  := 'ǩԼ���ڲ��Ϸ�';
        GOTO RET;
    END;
  END IF;

  SELECT COUNT(1)
    INTO N_TMP
    FROM UAP_SIM.QTZQZHZL T
   WHERE T.ZHLB = AC_I_ZHLB
     AND T.ZQZH = AC_I_ZQZH;
  IF N_TMP = 0 THEN
    C_RET_CODE := '3028';
    C_RET_MSG  := '֤ȯ�˻������ڻ�֤ȯ�˻����˻����ƥ��';
    GOTO RET;
  END IF;
  SELECT YMTH
    INTO C_YMTH
    FROM UAP_SIM.QTZQZHZL T
   WHERE T.ZHLB = AC_I_ZHLB
     AND T.ZQZH = AC_I_ZQZH;

  --ҵ����
  SELECT COUNT(1)
    INTO N_TMP
    FROM UAP_SIM.QTSDXGL T
   WHERE T.ZQZH = AC_I_ZQZH
     AND T.ZHLB = AC_I_ZHLB
     AND T.SDXLB = AC_I_SDXLB
     AND T.QYWDDM = AC_I_KHWDDM;
  IF AC_I_YWLB = '01' THEN
    --���� 
    IF N_TMP > 0 THEN
      C_RET_CODE := '3999';
      C_RET_MSG  := '�ظ�����';
      GOTO RET;
    END IF;
    BEGIN
      INSERT INTO UAP_SIM.QTSDXGL
        (YMTH, ZHLB, ZQZH, QYRQ, SDXLB, YYBBM, QYLB, QYJGDM, QYWDDM)
        SELECT C_YMTH,
               AC_I_ZHLB,
               AC_I_ZQZH,
               AC_I_QYRQ,
               AC_I_SDXLB,
               AC_I_YYBBM,
               AC_I_QYLB,
               AC_I_KHJGDM,
               AC_I_KHWDDM
          FROM DUAL;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        C_RET_CODE := '0999';
        C_RET_MSG  := '�������������ʵ�����Ϣ' || SQLCODE || '-' || SQLERRM;
    END;
  
  ELSIF AC_I_YWLB = '02' THEN
    --���� 
    IF N_TMP = 0 THEN
      C_RET_CODE := '3998';
      C_RET_MSG  := '��¼������';
      GOTO RET;
    END IF;
    BEGIN
      DELETE FROM UAP_SIM.QTSDXGL T
       WHERE T.ZQZH = AC_I_ZQZH
         AND T.ZHLB = AC_I_ZHLB
         AND T.QYWDDM = AC_I_KHWDDM;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        C_RET_CODE := '0999';
        C_RET_MSG  := '�������󣺳����ʵ�����Ϣ' || SQLCODE || '-' || SQLERRM;
    END;
  ELSIF AC_I_YWLB = '03' THEN
    --��ѯ 
    IF N_TMP = 0 THEN
      C_RET_CODE := '3998';
      C_RET_MSG  := '��¼������';
      GOTO RET;
    END IF;
  END IF;

  <<RET>>

  OPEN RETCURSOR FOR
    SELECT TT2.YWLSH,
           TT2.YWLB,
           C_YMTH AS YMTH,
           TT2.ZHLB,
           TT2.ZQZH,
           TT1.SDXLB,
           TT1.QYLB,
           TT1.QYRQ,
           TT1.YYBBM,
           TT1.KHJGDM,
           TT1.KHWDDM,
           TT2.SQRQ,
           TT2.YWRQ,
           TT2.YWPZBS,
           TT2.JGDM,
           TT2.JGSM
      FROM (SELECT T2.YYBBM,
                   T2.SDXLB,
                   T2.QYLB,
                   T2.QYRQ,
                   T2.QYJGDM AS KHJGDM,
                   T2.QYWDDM AS KHWDDM
              FROM UAP_SIM.QTSDXGL T2
             WHERE T2.ZQZH = AC_I_ZQZH
               AND T2.ZHLB = AC_I_ZHLB
               AND T2.SDXLB = AC_I_SDXLB) TT1
     RIGHT JOIN (SELECT AC_I_YWLSH AS YWLSH,
                        AC_I_YWLB AS YWLB,
                        AC_I_YMTH AS YMTH,
                        AC_I_ZHLB AS ZHLB,
                        AC_I_ZQZH AS ZQZH,
                        AC_I_SDXLB AS SDXLB,
                        AC_I_QYLB AS QYLB,
                        AC_I_QYRQ AS QYRQ,
                        AC_I_YYBBM AS YYBBM,
                        AC_I_KHJGDM AS KHJGDM,
                        AC_I_KHWDDM AS KHWDDM,
                        AC_I_SQRQ AS SQRQ,
                        AC_I_SQRQ AS YWRQ,
                        'N' AS YWPZBS,
                        C_RET_CODE AS JGDM,
                        C_RET_MSG AS JGSM
                   FROM DUAL) TT2
        ON 1 = 1;

END;
/