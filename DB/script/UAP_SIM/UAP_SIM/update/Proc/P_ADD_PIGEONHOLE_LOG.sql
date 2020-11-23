CREATE OR REPLACE PROCEDURE EM_MONITOR.P_ADD_PIGEONHOLE_LOG(AN_O_RET_CODE   OUT NUMBER,--���ش���
                                              AC_O_RET_MSG    OUT VARCHAR2, -- ������Ϣ
                                              AC_I_DATE IN VARCHAR2 := '', --�鵵����
                                              AC_I_USERNAME IN VARCHAR2 := '' --����Ա
                                              ) IS
    /******************************************************************
    ��Ŀ���ƣ�ESOMP
    �����û���ESOMP
    ��Ҫ˵����
        ���ٿ���־�������־�����Ŀ����־�鵵
        ���������
         AC_I_DATE:�鵵����
         AC_I_USERNAME:����Ա
        ���������
         AC_O_RET_MSG:������Ϣ
         AN_O_RET_CODE:���ش���
    �﷨��Ϣ��
        ���þ���:

    �����޶���
        ��Ҫ˵���� ǰ̨����
    �޶���¼��
        �޶�����    �޶���     �޸����ݼ�Ҫ˵��
        ----------  ---------  ------------------------------
       2007-09-12   �½�          ����
    ******************************************************************/
    AC_DATE NUMBER(8) := TO_NUMBER(REPLACE(AC_I_DATE,'-',''));
BEGIN
    AC_O_RET_MSG  := '����ɹ�';
    AN_O_RET_CODE := 0;

    -- ��ʷ���в�������
    INSERT INTO MONITOR_TARGET_LOG_HIST SELECT * FROM MONITOR_TARGET_LOG WHERE RETURN_DATE<=AC_DATE;
    INSERT INTO ERR_LOG_HIST            SELECT * FROM ERR_LOG WHERE RETURN_DATE<=AC_DATE;
    INSERT INTO CONTROL_LOG_HIST        SELECT * FROM CONTROL_LOG WHERE CONTROL_DATE<=AC_DATE;
    
    -- ��ǰ�����Ƴ�����
    DELETE FROM MONITOR_TARGET_LOG WHERE RETURN_DATE<=AC_DATE;
    DELETE FROM ERR_LOG WHERE RETURN_DATE<=AC_DATE;
    DELETE FROM CONTROL_LOG WHERE CONTROL_DATE<=AC_DATE;
    
    -- ����鵵��־
    INSERT INTO EM_MONITOR.PIGEONHOLE_LOG (PIGEONHOLE_DATE, USER_NAME, DEAL_DATE) VALUES (AC_DATE,AC_I_USERNAME,SYSDATE);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        AN_O_RET_CODE := -1;
        AC_O_RET_MSG  := '�������:' || SQLCODE || CHR(13) || '������Ϣ:' || SQLERRM;
END P_ADD_PIGEONHOLE_LOG;
/