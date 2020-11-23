CREATE OR REPLACE FUNCTION UAP_SIM."F_CHECK_DICT" (AC_I_DICT_TYPE VARCHAR2,
                                                  AC_I_DICT_CODE VARCHAR2
                                                  )
    RETURN Number IS
    /******************************************************************
    ��Ŀ���ƣ�UAP_SIM 1.0
    �����û���UAP_SIM
    ��Ҫ˵����
        �������ƣ��ֵ�ֵ����
        ��;������ȷ������ֵ�Ƿ����ֵ�ֵ��Χ�ڣ�����1�ɹ�������0����
    �﷨��Ϣ��
        ���������
            AC_I_DICT_TYPE �ֵ�����
            AC_I_DICT_CODE �ֵ����
        ���������
        ���þ�����
    �����޶���
        ��Ҫ˵����
    �޶���¼��
        �޶�����    �޶���     �޸����ݼ�Ҫ˵��
        ----------  ---------  ------------------------------
        2019-06-25  fh         Created
    ******************************************************************/
    I            NUMBER;

BEGIN
    I          := 0;
    select count(1) into I  from UAP_SIM.Cfg_Dict t where t.zd_type = ac_i_dict_type and t.zd_code = ac_i_dict_code;

    RETURN I;
EXCEPTION
  WHEN OTHERS THEN
    RETURN     0;
END;
/