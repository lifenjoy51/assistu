package com.assistu.dic.mod;

import org.springframework.stereotype.Component;

@Component
public class HanjaBasic {

	public HanjaBasic() {

	}

	public HanjaBasic(String hanja, int idx) {
		this.hanja = hanja;
		this.idx = idx;
	}

	private String hanja;
	private String hangul;
	private String radical;
	private String total_strokes;
	private String strokes;
	private String foreign_desc;
	private String hanja_desc;
	private int idx;
	private HanjaWord hanjaWord;

	public void correct() {
		if (hanja != null)
			hanja = hanja.replace(" ", "　");
		if (hanja_desc != null) {
			hanja_desc = hanja_desc.replace("  ", "　");
			
			hanja_desc = hanja_desc.replace("\n", "<br>");
		}
	}

	public String getHanja() {
		return hanja;
	}

	public void setHanja(String hanja) {
		this.hanja = hanja;
	}

	public String getHangul() {
		return hangul;
	}

	public void setHangul(String hangul) {
		this.hangul = hangul;
	}

	public String getRadical() {
		return radical;
	}

	public void setRadical(String radical) {
		this.radical = radical;
	}

	public String getTotal_strokes() {
		return total_strokes;
	}

	public void setTotal_strokes(String total_strokes) {
		this.total_strokes = total_strokes;
	}

	public String getStrokes() {
		return strokes;
	}

	public void setStrokes(String strokes) {
		this.strokes = strokes;
	}

	public String getForeign_desc() {
		return foreign_desc;
	}

	public void setForeign_desc(String foreign_desc) {
		this.foreign_desc = foreign_desc;
	}

	public String getHanja_desc() {
		return hanja_desc;
	}

	public void setHanja_desc(String hanja_desc) {
		this.hanja_desc = hanja_desc;
	}

	public HanjaWord getHanjaWord() {
		return hanjaWord;
	}

	public void setHanjaWord(HanjaWord hanjaWord) {
		this.hanjaWord = hanjaWord;
	}

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

}
