CREATE OR REPLACE FUNCTION UAP_SIM."F_CHECK_DICT" (AC_I_DICT_TYPE VARCHAR2,
                                                  AC_I_DICT_CODE VARCHAR2
                                                  )
    RETURN Number IS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：字典值检验
        用途简述：确认输入值是否在字典值范围内，返回1成功，返回0错误
    语法信息：
        输入参数：
            AC_I_DICT_TYPE 字典类型
            AC_I_DICT_CODE 字典代码
        输出参数：
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
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
