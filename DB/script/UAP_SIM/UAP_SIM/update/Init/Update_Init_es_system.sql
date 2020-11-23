INSERT INTO ES_SYSTEM.UPDATE_LOG
    (ID, APP_ID, UP_DATE, UP_TIME, UP_VERSION, UP_DESC, NOTE, UP_TYPE)
    SELECT ES_SYSTEM.S_UPDATE_LOG.NEXTVAL,
           '5',
           TO_CHAR(SYSDATE, 'YYYYMMDD'),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           'E-SOMP 1.0.0.0',
           'E-SOMP 1.0.0.0 Éý¼¶°æ',
           '',
           '1'
      FROM DUAL;
COMMIT;