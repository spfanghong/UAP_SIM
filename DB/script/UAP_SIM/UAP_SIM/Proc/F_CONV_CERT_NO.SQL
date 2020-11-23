CREATE OR REPLACE FUNCTION UAP_SIM."F_CONV_CERT_NO" (AC_I_CERT_TYPE VARCHAR2,
                                                  AC_I_CERT_CODE VARCHAR2,
                                                  AC_I_FUND_FLAG VARCHAR2 DEFAULT '2')
    RETURN VARCHAR2 IS
    /******************************************************************
    项目名称：UAP_SIM 1.0
    所属用户：UAP_SIM
    概要说明：
        中文名称：证件代码转换
        用途简述：证件类型为身份证(01)，转为18位身份证号码，其他的不转
    语法信息：
        输入参数：
            AC_I_CERT_TYPE 证件类型
            AC_I_CERT_CODE 证件代码
            AC_I_FUND_FLAG 功能标志（1 原来功能行为，2 仅转换证件号码）
        输出参数：
        调用举例：
    功能修订：
        简要说明：
    修订记录：
        修订日期    修订人     修改内容简要说明
        ----------  ---------  ------------------------------
        2008-03-04  cwh        Created
        2019-06-25  fh         修改为适应中国结算UAP的证件类型字典
    ******************************************************************/
    I            NUMBER;
    NUM          NUMBER;
    SFZH18       VARCHAR2(100);
    CODENO       VARCHAR2(1);
    AC_O_CERT_NO VARCHAR2(100);
    AC_BIRTHDAY  VARCHAR2(100);
BEGIN
    NUM          := 0;
    AC_O_CERT_NO := TRIM(AC_I_CERT_CODE);
    IF AC_I_CERT_TYPE = '01' THEN
        IF LENGTH(AC_O_CERT_NO) = 15 THEN
            BEGIN
                SFZH18 := SUBSTR(AC_O_CERT_NO, 1, 6) || '19' ||
                          SUBSTR(AC_O_CERT_NO, 7, 9);
                FOR I IN REVERSE 2 .. 18 LOOP
                    NUM := NUM + MOD(POWER(2, (I - 1)), 11) *
                           TO_NUMBER(SUBSTR(SFZH18, 19 - I, 1));
                END LOOP;
                NUM := MOD(NUM, 11);
                IF NUM = 0 THEN
                    CODENO := '1';
                ELSIF NUM = 1 THEN
                    CODENO := '0';
                ELSIF NUM = 2 THEN
                    CODENO := 'X';
                ELSIF NUM = 3 THEN
                    CODENO := '9';
                ELSIF NUM = 4 THEN
                    CODENO := '8';
                ELSIF NUM = 5 THEN
                    CODENO := '7';
                ELSIF NUM = 6 THEN
                    CODENO := '6';
                ELSIF NUM = 7 THEN
                    CODENO := '5';
                ELSIF NUM = 8 THEN
                    CODENO := '4';
                ELSIF NUM = 9 THEN
                    CODENO := '3';
                ELSIF NUM = 10 THEN
                    CODENO := '2';
                END IF;
                SFZH18 := SFZH18 || CODENO;
            EXCEPTION
                WHEN OTHERS THEN
                    SFZH18 := AC_O_CERT_NO;
            END;
        ELSIF LENGTH(AC_O_CERT_NO) = 18 THEN
            --增加判断18位号码有效性
            BEGIN
                SELECT TO_CHAR(TO_DATE(SUBSTR(AC_O_CERT_NO, 7, 8), 'YYYYMMDD'),
                               'YYYYMMDD')
                  INTO AC_BIRTHDAY
                  FROM DUAL;
            EXCEPTION
                WHEN OTHERS THEN
                    IF AC_I_FUND_FLAG = '1' THEN
                        RETURN '身份证号码无效';
                    ELSE
                        RETURN AC_I_CERT_CODE;
                    END IF;
            END;
            FOR I IN REVERSE 2 .. 18 LOOP
                NUM := NUM + MOD(POWER(2, (I - 1)), 11) *
                       TO_NUMBER(SUBSTR(SUBSTR(AC_O_CERT_NO, 0, 17), 19 - I, 1));
            END LOOP;
            NUM := MOD(NUM, 11);
            IF NUM = 0 THEN
                CODENO := '1';
            ELSIF NUM = 1 THEN
                CODENO := '0';
            ELSIF NUM = 2 THEN
                CODENO := 'X';
            ELSIF NUM = 3 THEN
                CODENO := '9';
            ELSIF NUM = 4 THEN
                CODENO := '8';
            ELSIF NUM = 5 THEN
                CODENO := '7';
            ELSIF NUM = 6 THEN
                CODENO := '6';
            ELSIF NUM = 7 THEN
                CODENO := '5';
            ELSIF NUM = 8 THEN
                CODENO := '4';
            ELSIF NUM = 9 THEN
                CODENO := '3';
            ELSIF NUM = 10 THEN
                CODENO := '2';
            END IF;
            IF CODENO <> SUBSTR(AC_O_CERT_NO, -1, 1) THEN
                IF AC_I_FUND_FLAG = '1' THEN
                    RETURN '身份证号码无效';
                ELSE
                    RETURN AC_I_CERT_CODE;
                END IF;
            END IF;
            SFZH18 := AC_O_CERT_NO;
        ELSE
            IF AC_I_FUND_FLAG = '1' THEN
                SFZH18 := '身份证长度输入有误';
            ELSE
                SFZH18 := AC_I_CERT_CODE;
            END IF;
        END IF;
    ELSE
        SFZH18 := AC_O_CERT_NO;
    END IF;

    RETURN SFZH18;
EXCEPTION
  WHEN OTHERS THEN
    RETURN     '身份证号码无效';
END;
/
