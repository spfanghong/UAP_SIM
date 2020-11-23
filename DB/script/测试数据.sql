delete from uap_sim.qtzqzhzl where ymth = '181018895588';
delete from uap_sim.Qtymtzl where ymth = '181018895588';

insert into UAP_SIM.Qtymtzl (YMTH, YMTZT, KHRQ, XHRQ, KHFS, KHMC, KHLB, GJDM, ZJLB, ZJDM, JZRQ, ZJDZ, FZZJLB, FZZJDM, FZJZRQ, FZZJDZ, CSRQ, XB, XLDM, ZYXZ, MZDM, JGLB, ZBSX, GYSX, JGJC, YWMC, GSWZ, FRXM, FRZJLB, FRZJDM, LXRXM, LXRZJLB, LXRZJDM, YDDH, GDDH, CZHM, LXDZ, LXYB, DZYX, DXFWBS, WLFWBS, CPJC, CPDQR, CPLB, GLRMC, GLRZJLB, GLRZJDM, TGRMC, TGRZJLB, TGRZJDM, BYZD1, BYZD2, BYZD3, STD_CERT_CODE, KHJG, XHJG)
values ('181018895588', '0', '20190801', '', '0', '张帅气', '0', 'CHN', '01', '350402198001010026', '30001231', '测试证件地址', '', '', '', '', '19800101', '1', '04', '04', 'HA', '', '', '', '', '', '', '', '', '', '赵美丽', '', '', '13812345678', '', '', '测试证件地址', '200000', '', '0', '0', '', '', '', '', '', '', '', '', '', '', '', '', '350402198001010026', '12222', '');
         

insert into uap_sim.qtzqzhzl(ymth,ymtzt,zhlb,zqzh,zqzhzt,khfs,khrq,glgxbs)
          select '181018895588','0','11','A123456789','00','0','20190708','1' from dual
union all select '181018895588','0','21','0123456789','00','0','20190708','1' from dual 
;

commit;


