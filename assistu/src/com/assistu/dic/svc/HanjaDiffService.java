package com.assistu.dic.svc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.assistu.dic.pst.HanjaDiffMapper;

@Service
public class HanjaDiffService {
	Logger log = LoggerFactory.getLogger(HanjaDiffService.class);

	@Autowired
	HanjaDiffMapper hanjaDiffMapper;

	/*
	 * 이체자변환
	 */
	public String translateDifferentCharacters(String inputText) {
		log.debug("이체자 변경 전 {}", inputText);

		// 이체자 임의로 수정. 로직없음.
		for (int i = 0; i < inputText.length(); i++) {
			String hanja = inputText.substring(i, i + 1);
			String diffHanja = hanjaDiffMapper.getHanjaDiff(hanja);
			if (diffHanja != null && diffHanja != "") {
				inputText = inputText.replace(hanja, diffHanja);
			}

		}

		// 특수기호 변환
		inputText = inputText.replace("\'", "＇").replace("\"", "〃");

		log.debug("이체자 변경 후 {}", inputText);

		return inputText;
	}

}
