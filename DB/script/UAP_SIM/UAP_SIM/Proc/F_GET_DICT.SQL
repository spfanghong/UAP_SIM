CREATE OR REPLACE FUNCTION UAP_SIM."F_GET_DICT" (AC_I_DICT_TYPE VARCHAR2,
                                                 AC_I_DICT_CODE VARCHAR2
                                                  )
    RETURN Varchar2 IS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：获取字典值
        用途简述：根据字典类型和字典代码返回字典中文说明
    语法信息：
        输入参数：
            AC_I_DICT_TYPE 字典类型
            AC_I_DICT_CODE 字典代码
        输出参数：
        调用举例：
            select UAP_SIM.F_GET_DICT('KHDLJG','100087') from dual
            select UAP_SIM.F_GET_DICT('KHDLJG','233333') from dual
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
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
    RETURN     '我仿得太真，你数据太假';
END;
/
