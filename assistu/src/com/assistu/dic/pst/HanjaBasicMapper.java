package com.assistu.dic.pst;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.assistu.dic.mod.HanjaBasic;

public interface HanjaBasicMapper {
	@Select("SELECT * FROM hanja_basic WHERE hanja = #{hanja}")
	HanjaBasic getHanjaBasic(@Param("hanja") String hanja);
}
