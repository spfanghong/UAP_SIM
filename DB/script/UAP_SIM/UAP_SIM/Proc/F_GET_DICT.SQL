CREATE OR REPLACE FUNCTION UAP_SIM."F_GET_DICT" (AC_I_DICT_TYPE VARCHAR2,
                                                 AC_I_DICT_CODE VARCHAR2
                                                  )
    RETURN Varchar2 IS
    /******************************************************************
    ��Ŀ���ƣ�UAP_SIM 1.0
    �����û���UAP_SIM
    ��Ҫ˵����
        �������ƣ���ȡ�ֵ�ֵ
        ��;�����������ֵ����ͺ��ֵ���뷵���ֵ�����˵��
    �﷨��Ϣ��
        ���������
            AC_I_DICT_TYPE �ֵ�����
            AC_I_DICT_CODE �ֵ����
        ���������
        ���þ�����
            select UAP_SIM.F_GET_DICT('KHDLJG','100087') from dual
            select UAP_SIM.F_GET_DICT('KHDLJG','233333') from dual
    �����޶���
        ��Ҫ˵����
    �޶���¼��
        �޶�����    �޶���     �޸����ݼ�Ҫ˵��
        ----------  ---------  ------------------------------
        2019-07-10  fh         Created
    ******************************************************************/
    Ret            varchar2(100);

BEGIN              
    Ret          := '';
    if AC_I_DICT_CODE is not null  then
       select t.zd_value into Ret  from UAP_SIM.Cfg_Dict t where t.zd_type = ac_i_dict_type and t.zd_code = ac_i_dict_code;
    end if ;
    RETURN Ret;
EXCEPTION
  WHEN OTHERS THEN
    RETURN     '�ҷµ�̫�棬������̫��';
END;
/