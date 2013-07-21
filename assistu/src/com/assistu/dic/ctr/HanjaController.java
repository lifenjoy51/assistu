package com.assistu.dic.ctr;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import com.assistu.dic.mod.HanjaBasic;
import com.assistu.dic.svc.HanjaDicService;

@Controller
public class HanjaController {
	private static final Logger log = LoggerFactory
			.getLogger(HanjaController.class);

	@Autowired
	HanjaDicService hanjaDicService;

	@Autowired
	@Qualifier(value = "jsonView")
	private View jsonView;

	@RequestMapping(value = "/home.do")
	public String main(HttpServletRequest request) {
		// 사전페이지로 이동
		log.info(new Date() + " main "
				+ request.getRemoteAddr());
		return "dic";
	}

	@RequestMapping(value = "/text.do")
	public String text(HttpServletRequest request) {
		// 한사강정보 이동
		log.info(new Date() + " text "
				+ request.getRemoteAddr());
		return "2013-1_text";
	}

	@RequestMapping(value = "/cau.do")
	public String cau(HttpServletRequest request) {
		// 흑석동 맛집안내 이동
		log.info(new Date() + " cau "
				+ request.getRemoteAddr());
		return "cau_menu";
	}

	@RequestMapping(value = "/timer.do")
	public String timer(HttpServletRequest request) {
		// CEDA 타이머 이동
		log.info(new Date() + " timer "
				+ request.getRemoteAddr());
		return "timer";
	}

	@RequestMapping(value = "/forum.do")
	public String forum(HttpServletRequest request) {
		// 낙서장 이동
		log.info(new Date() + " forum "
				+ request.getRemoteAddr());
		return "forum";
	}

	// @RequestMapping(value = "/dic", method = RequestMethod.POST)
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dic.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public View getDicData(Model model,
			@RequestParam(value = "text_input") String inputText,
			HttpServletRequest request) {
		model.addAttribute("inputText", inputText);
		hanjaDicService.hanjaDic(model);

		log.debug("{}", model.containsAttribute("jsonData"));
		log.debug("한자 {}", ((HanjaBasic) ((List) model.asMap().get("jsonData"))
				.get(0)).getHanja());
		log.info("@"+new Date() + " dictionary "
				+ request.getRemoteAddr() + " " + inputText);
		return jsonView;
	}
}
