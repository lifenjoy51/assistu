package com.assistu.dic.dao;

import org.springframework.stereotype.Repository;

import com.assistu.dic.mod.HanjaWord;

@Repository
public class HanjaWordDao {
	HanjaWord hanjaWord;

	public int getLikeResultCount(String word) {
		// 임시로 만듬
		if (word.equals("大")) {
			return 470;
		} else if (word.equals("大乘")) {
			return 3;
		} else if (word.equals("大乘者")) {
			return 0;
		} else if (word.equals("乘")) {
			return 45;
		} else if (word.equals("乘者")) {
			return 0;
		} else if (word.equals("者")) {
			return 3;
		} else if (word.equals("者 ")) {
			return 0;
		} else if (word.equals(" ")) {
			return 0;
		} else if (word.equals("昇")) {
			return 20;
		} else if (word.equals("昇穆")) {
			return 0;
		} else if (word.equals("穆")) {
			return 10;
		} else if (word.equals("穆七")) {
			return 0;
		} else if (word.equals("七")) {
			return 111;
		} else if (word.equals("七情")) {
			return 1;
		} else if (word.equals("穆")) {
			return 68;
		} else {
			return 0;
		}
	}
	
	public int getEqualResultCount(String word){
		if (word.equals("大乘")) {
			return 1;
		} else if (word.equals("七情")) {
			return 1;
		} else {
			return 0;
		}
	}
}
