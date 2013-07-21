package com.assistu.dic.pst;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

public interface HanjaDiffMapper {
	@Select("SELECT hanja_org FROM hanja_diff_info WHERE hanja_diff = #{hanja}")
	String getHanjaDiff(@Param("hanja") String hanja);
}
