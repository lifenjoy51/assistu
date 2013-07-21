package com.assistu.dic.mod;

public class WordFinder {
	public WordFinder(String text, int totPtr) {
		this.text = text;
		this.totPtr = totPtr;
		this.frontPtr = 0;
		this.endPtr = 1;
	}

	String text;
	int frontPtr;
	int endPtr;
	int totPtr;
	HanjaWord hanjaWord;

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public int getFrontPtr() {
		return frontPtr;
	}

	public void setFrontPtr(int frontPtr) {
		this.frontPtr = frontPtr;
	}

	public int getEndPtr() {
		return endPtr;
	}

	public void setEndPtr(int endPtr) {
		this.endPtr = endPtr;
	}

	public int getTotPtr() {
		return totPtr;
	}

	public void setTotPtr(int totPtr) {
		this.totPtr = totPtr;
	}

	public void increasePtr() {
		this.endPtr++;
	}

	public HanjaWord getHanjaWord() {
		return hanjaWord;
	}

	public void setHanjaWord(HanjaWord hanjaWord) {
		this.hanjaWord = hanjaWord;
	}

}
