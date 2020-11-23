CREATE OR REPLACE FUNCTION UAP_SIM."F_CONV_CERT_NO" (AC_I_CERT_TYPE VARCHAR2,
                                                  AC_I_CERT_CODE VARCHAR2,
                                                  AC_I_FUND_FLAG VARCHAR2 DEFAULT '2')
    RETURN VARCHAR2 IS
    /******************************************************************
    ��Ŀ���ƣ�UAP_SIM 1.0
    �����û���UAP_SIM
    ��Ҫ˵����
        �������ƣ�֤������ת��
        ��;������֤������Ϊ����֤(01)��תΪ18λ����֤���룬�����Ĳ�ת
    �﷨��Ϣ��
        ���������
            AC_I_CERT_TYPE ֤������
            AC_I_CERT_CODE ֤������
            AC_I_FUND_FLAG ���ܱ�־��1 ԭ��������Ϊ��2 ��ת��֤�����룩
        ���������
        ���þ�����
    �����޶���
        ��Ҫ˵����
    �޶���¼��
        �޶�����    �޶���     �޸����ݼ�Ҫ˵��
        ----------  ---------  ------------------------------
        2008-03-04  cwh        Created
        2019-06-25  fh         �޸�Ϊ��Ӧ�й�����UAP��֤�������ֵ�
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
            --�����ж�18λ������Ч��
            BEGIN
                SELECT TO_CHAR(TO_DATE(SUBSTR(AC_O_CERT_NO, 7, 8), 'YYYYMMDD'),
                               'YYYYMMDD')
                  INTO AC_BIRTHDAY
                  FROM DUAL;
            EXCEPTION
                WHEN OTHERS THEN
                    IF AC_I_FUND_FLAG = '1' THEN
                        RETURN '����֤������Ч';
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
                    RETURN '����֤������Ч';
                ELSE
                    RETURN AC_I_CERT_CODE;
                END IF;
            END IF;
            SFZH18 := AC_O_CERT_NO;
        ELSE
            IF AC_I_FUND_FLAG = '1' THEN
                SFZH18 := '����֤������������';
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
    RETURN     '����֤������Ч';
END;
/