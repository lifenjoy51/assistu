package com.assistu.dic.mod;

public class HanjaWord {
	public HanjaWord() {
		this.hanja = "";
	}

	public HanjaWord(String hanja) {
		this.hanja = hanja;
	}

	String hanja;
	String hangul;
	String word_desc;

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

	public String getWord_desc() {
		return word_desc;
	}

	public void setWord_desc(String word_desc) {
		this.word_desc = word_desc;
	}

}
