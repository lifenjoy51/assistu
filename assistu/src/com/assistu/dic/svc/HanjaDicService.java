package com.assistu.dic.svc;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.assistu.dic.mod.HanjaBasic;
import com.assistu.dic.mod.HanjaWord;
import com.assistu.dic.mod.WordFinder;
import com.assistu.dic.pst.HanjaBasicMapper;
import com.assistu.dic.pst.HanjaWordMapper;

@Service
public class HanjaDicService {

	@Autowired
	HanjaDiffService hanjaDiffService;

	@Autowired
	HanjaBasicMapper hanjaBasicMapper;

	@Autowired
	HanjaWordMapper hanjaWordMapper;

	Logger log = LoggerFactory.getLogger(HanjaDicService.class);

	public void hanjaDic(Model model) {

		// 입력문장
		String inputText = model.asMap().get("inputText").toString();
		int inputTextLength = inputText.length();

		// 이체자 변환 로직
		inputText = hanjaDiffService.translateDifferentCharacters(inputText);

		// 리스트에 한자 저장
		List<HanjaBasic> hanjaList = new ArrayList<HanjaBasic>();
		for (int i = 0; i < inputTextLength; i++) {
			HanjaBasic hanjaBasic;
			String hanja = inputText.substring(i, i + 1);
			hanjaBasic = hanjaBasicMapper.getHanjaBasic(hanja);
			if (hanjaBasic == null) {
				hanjaBasic = new HanjaBasic(hanja, i);
			} else {
				hanjaBasic.setIdx(i);
				hanjaBasic.correct();
			}

			hanjaList.add(hanjaBasic);
		}

		// 검색
		WordFinder wordFinder = new WordFinder(inputText, inputTextLength);

		for (HanjaBasic hanjaBasic : hanjaList) {
			wordFinder.setFrontPtr(hanjaBasic.getIdx());
			wordFinder.setEndPtr(hanjaBasic.getIdx() + 1);
			wordFinder.setHanjaWord(null);
			findWord(wordFinder);
			if (wordFinder.getHanjaWord() != null) {
				hanjaBasic.setHanjaWord(wordFinder.getHanjaWord());
			} else {
				hanjaBasic.setHanjaWord(new HanjaWord());
			}
		}

		// 모델에 넣기
		model.addAttribute("jsonData", hanjaList);
	}

	/*
	 * 단어찾기
	 */
	public void findWord(WordFinder wordFinder) {

		String searchWord;
		if (wordFinder.getEndPtr() <= wordFinder.getTotPtr()) {
			searchWord = wordFinder.getText().substring(
					wordFinder.getFrontPtr(), wordFinder.getEndPtr());
		} else {
			return;
		}

		int likeResultCount = hanjaWordMapper.getLikeResultCount(searchWord);
		// log.debug("finding word now {}, {}", searchWord, likeResultCount);
		if (likeResultCount == 0) {
			return; // 없음
		} else if (likeResultCount >= 1) {
			// 더 검색
			wordFinder.increasePtr();
			findWord(wordFinder);
			// 검색하다가 더이상 안나오면 일치하는단어 검색
			int equalResultCount = hanjaWordMapper
					.getEqualResultCount(searchWord);
			if (equalResultCount >= 1) {
				// 발견
				HanjaWord hanjaWord;
				hanjaWord = hanjaWordMapper.getHanjaWord(searchWord);
				wordFinder.setHanjaWord(hanjaWord);
			}
		}

	}
}
