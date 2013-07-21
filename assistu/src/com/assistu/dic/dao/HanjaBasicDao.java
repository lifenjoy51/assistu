package com.assistu.dic.dao;

import org.springframework.stereotype.Repository;

import com.assistu.dic.mod.HanjaBasic;
import com.assistu.dic.pst.HanjaBasicMapper;

@Repository
public class HanjaBasicDao {
	private HanjaBasicMapper hanjaBasicMapper;
	HanjaBasic hanjaBasic;

	public HanjaBasicMapper getHanjaBasicMapper() {
		return hanjaBasicMapper;
	}

	public void setHanjaBasicMapper(HanjaBasicMapper hanjaBasicMapper) {
		this.hanjaBasicMapper = hanjaBasicMapper;
	}

	public HanjaBasic getHanjaBasic() {
		return hanjaBasic;
	}

	public void setHanjaBasic(HanjaBasic hanjaBasic) {
		this.hanjaBasic = hanjaBasic;
	}

}
