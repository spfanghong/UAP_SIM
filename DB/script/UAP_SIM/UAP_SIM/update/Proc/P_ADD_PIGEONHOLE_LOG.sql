CREATE OR REPLACE PROCEDURE EM_MONITOR.P_ADD_PIGEONHOLE_LOG(AN_O_RET_CODE   OUT NUMBER,--返回代码
                                              AC_O_RET_MSG    OUT VARCHAR2, -- 返回信息
                                              AC_I_DATE IN VARCHAR2 := '', --归档日期
                                              AC_I_USERNAME IN VARCHAR2 := '' --操作员
                                              ) IS
    /******************************************************************
    项目名称：ESOMP
    所属用户：ESOMP
    概要说明：
        将操控日志、监控日志、监控目标日志归档
        输入参数：
         AC_I_DATE:归档日期
         AC_I_USERNAME:操作员
        输出参数：
         AC_O_RET_MSG:返回信息
         AN_O_RET_CODE:返回代码
    语法信息：
        调用举例:

    功能修订：
        简要说明： 前台调用
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
       2007-09-12   陈金发          创建
    ******************************************************************/
    AC_DATE NUMBER(8) := TO_NUMBER(REPLACE(AC_I_DATE,'-',''));
BEGIN
    AC_O_RET_MSG  := '保存成功';
    AN_O_RET_CODE := 0;

    -- 历史表中插入数据
    INSERT INTO MONITOR_TARGET_LOG_HIST SELECT * FROM MONITOR_TARGET_LOG WHERE RETURN_DATE<=AC_DATE;
    INSERT INTO ERR_LOG_HIST            SELECT * FROM ERR_LOG WHERE RETURN_DATE<=AC_DATE;
    INSERT INTO CONTROL_LOG_HIST        SELECT * FROM CONTROL_LOG WHERE CONTROL_DATE<=AC_DATE;
    
    -- 当前表中移除数据
    DELETE FROM MONITOR_TARGET_LOG WHERE RETURN_DATE<=AC_DATE;
    DELETE FROM ERR_LOG WHERE RETURN_DATE<=AC_DATE;
    DELETE FROM CONTROL_LOG WHERE CONTROL_DATE<=AC_DATE;
    
    -- 插入归档日志
    INSERT INTO EM_MONITOR.PIGEONHOLE_LOG (PIGEONHOLE_DATE, USER_NAME, DEAL_DATE) VALUES (AC_DATE,AC_I_USERNAME,SYSDATE);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        AN_O_RET_CODE := -1;
        AC_O_RET_MSG  := '错误代码:' || SQLCODE || CHR(13) || '错误信息:' || SQLERRM;
END P_ADD_PIGEONHOLE_LOG;
/