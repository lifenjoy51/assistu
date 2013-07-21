package com.assistu.dic.pst;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.assistu.dic.mod.HanjaWord;

public interface HanjaWordMapper {
	@Select("SELECT * FROM hanja_word WHERE hanja = #{hanja}")
	HanjaWord getHanjaWord(@Param("hanja") String hanja);

	@Select("SELECT count(*) FROM hanja_word WHERE hanja like '${hanja}%' ")
	int getLikeResultCount(@Param("hanja") String hanja);

	@Select("SELECT count(*) FROM hanja_word WHERE hanja = #{hanja} ")
	int getEqualResultCount(@Param("hanja") String hanja);
}
