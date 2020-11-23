DECLARE i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_TABLESPACES WHERE TABLESPACE_NAME = 'TBS_UAP_SIM';
    IF i > 0 THEN
        EXECUTE IMMEDIATE 'DROP TABLESPACE TBS_UAP_SIM INCLUDING CONTENTS AND DATAFILES';
    END IF;
    
    EXECUTE IMMEDIATE 'CREATE TABLESPACE TBS_UAP_SIM NOLOGGING DATAFILE ''&2.TBS_UAP_SIM.ORA'' SIZE 20M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL UNIFORM SIZE 256K SEGMENT SPACE MANAGEMENT AUTO';

END;
/