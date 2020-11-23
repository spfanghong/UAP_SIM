/*==============================================================*/
/* DBMS name:      ORACLE Version 10g                           */
/* Created on:     2019/08/19 20:39:16                          */
/*==============================================================*/


drop table UAP_SIM.CFG_CS cascade constraints;

drop table UAP_SIM.CFG_DICT cascade constraints;

drop table UAP_SIM.CFG_DLJG cascade constraints;

drop table UAP_SIM.CFG_JKINFO cascade constraints;

drop table UAP_SIM.QTHHR cascade constraints;

drop table UAP_SIM.QTSYXX cascade constraints;

drop index UAP_SIM."idx_QTYMTZL_02";

drop index UAP_SIM."idx_QTYMTZL_01";

drop table UAP_SIM.QTYMTZL cascade constraints;

drop index UAP_SIM.IDX_QTZHZL_01;

drop table UAP_SIM.QTZQZHZL cascade constraints;

drop sequence UAP_SIM.SEQ_SHZQZH;

drop sequence UAP_SIM.SEQ_SZZQZH;

drop sequence UAP_SIM.SEQ_YMTH;

create sequence UAP_SIM.SEQ_SHZQZH
start with 1
 maxvalue 9999999;

create sequence UAP_SIM.SEQ_SZZQZH
start with 1
 maxvalue 9999999;

create sequence UAP_SIM.SEQ_YMTH
start with 1
 maxvalue 999999999;

/*==============================================================*/
/* Table: CFG_CS                                                */
/*==============================================================*/
create table UAP_SIM.CFG_CS  (
   "pa_key"             varchar2(20)                    not null,
   "pa_value"           varchar2(100),
   "pa_note"            varchar2(200),
   constraint PK_CFG_CS primary key ("pa_key")
);

/*==============================================================*/
/* Table: CFG_DICT                                              */
/*==============================================================*/
create table UAP_SIM.CFG_DICT  (
   ZD_TYPE              varchar2(20)                    not null,
   ZD_CODE              varchar2(20)                    not null,
   ZD_VALUE             varchar2(100),
   ZD_NOTE              varchar2(100),
   constraint PK_CFG_DICT primary key (ZD_TYPE, ZD_CODE)
);

/*==============================================================*/
/* Table: CFG_DLJG                                              */
/*==============================================================*/
create table UAP_SIM.CFG_DLJG  (
   DLJGDM               varchar2(6)                     not null,
   DLJGMC               varchar2(26),
   constraint PK_CFG_DLJG primary key (DLJGDM)
);

/*==============================================================*/
/* Table: CFG_JKINFO                                            */
/*==============================================================*/
create table UAP_SIM.CFG_JKINFO  (
   SVR_NAME             varchar2(16)                    not null,
   SVR_TYPE             varchar2(2)                     not null,
   SVR_DIRECT           varchar2(1)                     not null,
   FIELD_ID             varchar2(5)                     not null,
   FIELD_NAME           varchar2(20)                    not null,
   FIELD_TYPE           varchar2(20),
   FIELD_LENGTH         varchar2(10),
   FIELD_TRAN           varchar2(100),
   FIELD_NOTE           varchar2(200),
   constraint PK_CFG_JKINFO primary key (SVR_NAME, SVR_TYPE, SVR_DIRECT, FIELD_ID, FIELD_NAME)
);

/*==============================================================*/
/* Table: QTHHR                                                 */
/*==============================================================*/
create table UAP_SIM.QTHHR  (
   YMTH                 varchar2(20),
   HHMC                 varchar2(120),
   HHZJLB               varchar2(2),
   HHZJDM               varchar2(40),
   HHJZRQ               varchar2(8),
   GJDQ                 varchar2(3),
   HHCDFS               varchar2(1)
);

comment on column UAP_SIM.QTHHR.HHZJLB is
'字典(ZJLB)';

comment on column UAP_SIM.QTHHR.GJDQ is
'字典(GJDM)';

comment on column UAP_SIM.QTHHR.HHCDFS is
'字典(HHCDFS)';

/*==============================================================*/
/* Table: QTSYXX                                                */
/*==============================================================*/
create table UAP_SIM.QTSYXX  (
   YMTH                 varchar2(20),
   ZHLB                 varchar2(2)                     not null,
   ZQZH                 varchar2(20)                    not null,
   JYDY                 varchar2(6),
   YYBBM                varchar2(2),
   KHWDDM               varchar2(10),
   SYSBRQ               varchar2(8)
);

comment on column UAP_SIM.QTSYXX.ZHLB is
'字典(ZHLB)';

comment on column UAP_SIM.QTSYXX.ZQZH is
' ';

/*==============================================================*/
/* Table: QTYMTZL                                               */
/*==============================================================*/
create table UAP_SIM.QTYMTZL  (
   YMTH                 varchar2(20)                    not null,
   YMTZT                varchar2(1),
   KHRQ                 varchar2(8),
   XHRQ                 varchar2(8),
   KHFS                 varchar2(1),
   KHMC                 varchar2(120)                   not null,
   KHLB                 varchar2(1)                     not null,
   GJDM                 varchar2(3)                     not null,
   ZJLB                 varchar2(2)                     not null,
   ZJDM                 varchar2(40)                    not null,
   JZRQ                 varchar2(8)                     not null,
   ZJDZ                 varchar2(80),
   FZZJLB               varchar2(2),
   FZZJDM               varchar2(40),
   FZJZRQ               varchar2(8),
   FZZJDZ               varchar2(80),
   CSRQ                 varchar2(8),
   XB                   varchar2(1),
   XLDM                 varchar2(2),
   ZYXZ                 varchar2(2),
   MZDM                 varchar2(2),
   JGLB                 varchar2(2),
   ZBSX                 varchar2(1),
   GYSX                 varchar2(1),
   JGJC                 varchar2(20),
   YWMC                 varchar2(80),
   GSWZ                 varchar2(50),
   FRXM                 varchar2(60),
   FRZJLB               varchar2(2),
   FRZJDM               varchar2(40),
   LXRXM                varchar2(60),
   LXRZJLB              varchar2(2),
   LXRZJDM              varchar2(40),
   YDDH                 varchar2(20),
   GDDH                 varchar2(20),
   CZHM                 varchar2(20),
   LXDZ                 varchar2(120),
   LXYB                 varchar2(8),
   DZYX                 varchar2(40),
   DXFWBS               varchar2(4),
   WLFWBS               varchar2(1)                     not null,
   CPJC                 varchar2(40),
   CPDQR                varchar2(8),
   CPLB                 varchar2(2),
   GLRMC                varchar2(120),
   GLRZJLB              varchar2(2),
   GLRZJDM              varchar2(40),
   TGRMC                varchar2(120),
   TGRZJLB              varchar2(2),
   TGRZJDM              varchar2(40),
   BYZD1                varchar2(10),
   BYZD2                varchar2(10),
   BYZD3                varchar2(10),
   STD_CERT_CODE        varchar2(40)                    not null,
   KHJG                 varchar2(6),
   XHJG                 varchar2(6),
   constraint PK_QTYMTZL primary key (YMTH)
);

comment on table UAP_SIM.QTYMTZL is
'全体一码通资料';

comment on column UAP_SIM.QTYMTZL.YMTZT is
'字典(YMTZT)';

comment on column UAP_SIM.QTYMTZL.KHFS is
'字典(KHFS)';

comment on column UAP_SIM.QTYMTZL.KHLB is
'字典(KHLB)';

comment on column UAP_SIM.QTYMTZL.GJDM is
'字典(GJDM)';

comment on column UAP_SIM.QTYMTZL.ZJLB is
'字典(ZJLB)';

comment on column UAP_SIM.QTYMTZL.FZZJLB is
'字典(ZJLB)';

comment on column UAP_SIM.QTYMTZL.XB is
'字典(XB)';

comment on column UAP_SIM.QTYMTZL.XLDM is
'字典(XLDM)';

comment on column UAP_SIM.QTYMTZL.ZYXZ is
'字典(ZYXZ)';

comment on column UAP_SIM.QTYMTZL.MZDM is
'字典(MZDM)';

comment on column UAP_SIM.QTYMTZL.JGLB is
'字典(JGLB)';

comment on column UAP_SIM.QTYMTZL.ZBSX is
'字典(ZBSX)';

comment on column UAP_SIM.QTYMTZL.GYSX is
'字典(GYSX)';

comment on column UAP_SIM.QTYMTZL.FRZJLB is
'字典(ZJLB)';

comment on column UAP_SIM.QTYMTZL.LXRZJLB is
'字典(ZJLB)';

comment on column UAP_SIM.QTYMTZL.DXFWBS is
'保留字段';

comment on column UAP_SIM.QTYMTZL.WLFWBS is
'字典(WLFWBS)';

comment on column UAP_SIM.QTYMTZL.CPJC is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.CPDQR is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.CPLB is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.GLRMC is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.GLRZJLB is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.GLRZJDM is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.TGRMC is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.TGRZJLB is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.TGRZJDM is
'客户类别为“产品客户”时不为空';

comment on column UAP_SIM.QTYMTZL.BYZD1 is
'机构类别为“25”（私募基金管理人）时，本字段内容为一码通账户对应的私募基金管理人编码';

comment on column UAP_SIM.QTYMTZL.BYZD2 is
'保留字段';

comment on column UAP_SIM.QTYMTZL.BYZD3 is
'保留字段';

comment on column UAP_SIM.QTYMTZL.STD_CERT_CODE is
'对于十五位身份证转换成18位身份证，其他的直接复制';

/*==============================================================*/
/* Index: "idx_QTYMTZL_01"                                      */
/*==============================================================*/
create unique index UAP_SIM."idx_QTYMTZL_01" on UAP_SIM.QTYMTZL (
   ZJDM ASC,
   KHMC ASC,
   ZJLB ASC
);

/*==============================================================*/
/* Index: "idx_QTYMTZL_02"                                      */
/*==============================================================*/
create index UAP_SIM."idx_QTYMTZL_02" on UAP_SIM.QTYMTZL (
   STD_CERT_CODE ASC
);

/*==============================================================*/
/* Table: QTZQZHZL                                              */
/*==============================================================*/
create table UAP_SIM.QTZQZHZL  (
   YMTH                 varchar2(20),
   YMTZT                varchar2(1),
   ZHLB                 varchar2(2)                     not null,
   ZQZH                 varchar2(20)                    not null,
   ZQZHZT               varchar2(2),
   KHFS                 varchar2(1),
   KHRQ                 varchar2(8),
   GLGXBS               varchar2(1),
   BYZD                 varchar2(10),
   XHRQ                 varchar2(8),
   KHJG                 varchar2(6),
   XHJG                 varchar2(6),
   GLJG                 varchar2(6),
   GZBS                 varchar2(1),
   BHGBS                varchar2(1),
   BHGJYXZ              varchar2(1),
   BHGYYLB              varchar2(1),
   GGTBS                varchar2(1),
   SCJYRQ               varchar2(8),
   constraint PK_QTZQZHZL primary key (ZHLB, ZQZH)
);

comment on column UAP_SIM.QTZQZHZL.YMTZT is
'字典(YMTZT)';

comment on column UAP_SIM.QTZQZHZL.ZHLB is
'字典(ZHLB)';

comment on column UAP_SIM.QTZQZHZL.ZQZH is
' ';

comment on column UAP_SIM.QTZQZHZL.ZQZHZT is
'字典(ZQZHZT)';

comment on column UAP_SIM.QTZQZHZL.KHFS is
'字典(KHFS)';

comment on column UAP_SIM.QTZQZHZL.GLGXBS is
'字典(GLGXBS)';

/*==============================================================*/
/* Index: IDX_QTZHZL_01                                         */
/*==============================================================*/
create index UAP_SIM.IDX_QTZHZL_01 on UAP_SIM.QTZQZHZL (
   YMTH ASC
);

