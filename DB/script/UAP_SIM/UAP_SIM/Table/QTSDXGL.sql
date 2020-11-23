-- Create table
create table UAP_SIM.QTSDXGL
(
  ymth   VARCHAR2(20),
  zhlb   VARCHAR2(2),
  zqzh   VARCHAR2(20),
  qyrq   VARCHAR2(8),
  sdxlb  VARCHAR2(1),
  yybbm  VARCHAR2(2),
  qylb   VARCHAR2(1),
  qyjgdm VARCHAR2(6),
  qywddm VARCHAR2(10)
)
tablespace TBS_UAP_SIM
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 256K
    next 256K
    minextents 1
    maxextents unlimited
    pctincrease 0
  )
nologging;
-- Create/Recreate indexes 
create index UAP_SIM.IDX_QTSDXGL_01 on UAP_SIM.QTSDXGL (ZQZH, ZHLB, SDXLB)
  tablespace TBS_UAP_SIM
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 256K
    next 256K
    minextents 1
    maxextents unlimited
    pctincrease 0
  )
  nologging;
