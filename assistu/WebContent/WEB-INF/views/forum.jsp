<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>



<!-- (1) Moot look and feel -->
<link rel="stylesheet" href="http://cdn.moot.it/1.0/moot.css" />

<!-- (4) Custom CSS -->
<style>
body {
	font-family: "myriad pro", tahoma, verdana, arial, sans-serif;
	margin: 0;
	padding: 0;
}

.moot {
	font-size: 18px;
}
</style>

<!-- (1) Moot depends on jQuery v1.7 or greater -->
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>

<!-- (1) Moot client application -->
<script src="http://cdn.moot.it/1.0/moot.min.js"></script>

<mvc:layout>

	<!--
   You can put this page on your web server and see it working on your browser.

   Follow these steps to embed this on your own page:

   1. Copy the lines starting with (1) from the HEAD section to your own page's HEAD
   2. Copy the A tag (2) from the BODY section anwhere inside your BODY
   3. Verify that the page works on your browser.
   4. Fine tune the looks with CSS. Details: http://moot.it/docs/?assistu#styling

   For more help:

   http://moot.it/docs/?assistu
   http://moot.it/forum/
-->

	<!-- (2) Placeholder for the forum. The forum will be rendered inside this element -->
	<a class="moot" href="http://api.moot.it/assistu"></a>

	<!--
         (2) Example tag for commenting, put it on a different page
         <a class="moot" href="http://api.moot.it/assistu/blog#my-blog-entry"></a>

         (2) Example tag for threaded commenting
         <a class="moot" href="http://api.moot.it/assistu/blog/my-large-blog-entry"></a>

         Moot paths are awesome: http://moot.it/docs/?assistu#path
      -->
</mvc:layout>

<script type="text/javascript">
	var rCnt = 0; //전체한자개수
	var cPnt = -1; //현재위치 기억
	var hanjaBasic = new Array(); //한자정보저장객체

	$(document).ready(function() {
		document.onkeydown = keyControl;

		//숨김처리
		$('#ajax_load_indicator').css("display", "none");
		$('#outputStatus').css("display", "none");

	});

	/**
	 * 키보드입력 처리
	 */
	function keyControl(e) {
		var event = e || window.event;
		if (event.keyCode == '37') { //◁37
			fnDrawWord(cPnt - 1);
		} else if (event.keyCode == '39') { //▷39
			fnDrawWord(cPnt + 1);
		} else if (event.keyCode == '38') { //△38
			//fnSetPnt(+1);
		} else if (event.keyCode == '40') { //▽40
			//fnSetPnt(+rCnt);
		} else {
			console.log(event.keyCode);
		}
	}

	/*
	 * 한자를 클릭했을 때(class로 선택함) 설명이 바뀌게 하는 이벤트 설정하기
	 */
	function fnSetClickEvent() {
		$('.hanja').click(function() {
			var pId = $(this).attr('id');
			var pCnt = pId.substring(6, pId.length); //현재 클릭한 한자 포인터
			fnDrawWord(+pCnt); //현재포인터 지정
		});
	}

	/*
	 * 텍스트입력 검증하기
	 */
	function fnValInputText() {
		var txt = $('#text_input').val(); //입력문장
		if (txt == '') {
			return false; //공백이면 나가기
		} else {
			return true;
		}
	}

	/*
	 * 사전정보 요청
	 */
	function fnMain() {
		rCnt = 0; //전체한자개수 카운터 초기화
		cPnt = -1; //현재위치 포인터 초기화
		fnInitArea(); //이전 한자정보 초기화

		//입력문장 확인
		if (!fnValInputText())
			return;

		//요청
		$.ajax({
			url : "/dic.do",
			type : 'post',
			dataType : 'json',
			data : 'text_input=' + $('#text_input').val(),

			beforeSend : function() {
				$('#text_area').empty(); //이전 출력영역 지우기
				$('#ajax_load_indicator').show(0); //프로그레스 바 노출
			},

			success : function(data) {
				$.each(data.list, function(i, obj) {
					hanjaBasic[i] = obj; //객체저장
					rCnt = i; //전체개수 카운트

					//id지정해서 한자출력
					$('<span/>', {
						'id' : 'hanja_' + obj.idx,
						'class' : 'hanja',
						html : obj.hanja
					}).appendTo('#text_area');
				});

				//출력부분에 클릭이벤트 지정
				fnSetClickEvent();

				//테스트
				$.each(hanjaBasic, function(i) {
					//alert(hanjaBasicArray[i].hanjaWord.hanja);
				});

				fnHideTextArea(); //입력부분 숨기기
			},

			error : function(data, status, err) {
				alert('서버와의 통신이 실패했습니다. ' + ' Data : ' + data + 'Error : '
						+ err + ' Status : ' + status);
			},

			complete : function() {
				$('#ajax_load_indicator').hide(500);
			}

		});
	}

	/*
	 * 한자+단어정보 출력
	 */
	function fnDrawWord(pCpnt) {
		//조건안맞으면 리턴
		if (pCpnt > rCnt || pCpnt < 0)
			return;

		//이전정보 초기화
		fnInitArea();
		if (cPnt >= 0)
			$('#hanja_' + cPnt).toggleClass('selected');//이전글자를 일반글자로

		console.log('parameter is =' + pCpnt); //현재 위치 표시
		cPnt = (+pCpnt); //현재위치정보 포인터를 변경
		console.log(cPnt + '=' + hanjaBasic[cPnt].hanja); //현재 위치 표시

		$('#hanja_' + cPnt).toggleClass('selected');//현재선택한 글자의 스타일 변경

		//한자뜻풀이 보이기
		$('<ui/>', {
			'class' : 'hanja_desc',
			html : hanjaBasic[cPnt].hanja_desc
		}).appendTo('#hanja_info');

		//한자기본정보 보이기
		var hanjaBasicInfo = null;
		if (hanjaBasic[cPnt].hangul != '')
			hanjaBasicInfo = $('<h1/>', {
				'class' : 'hanja_info',
				html : hanjaBasic[cPnt].hanja
			}).append($('<small/>', {
				html : hanjaBasic[cPnt].hangul
			})); //한자

		if (hanjaBasic[cPnt].radical != undefined) {

			var hanjaBasicInfoRadical = $('<ui/>', {
				'class' : 'hanja_radical',
				html : '　' + '부수 ' + hanjaBasic[cPnt].radical + ' '
						+ hanjaBasic[cPnt].strokes + '획'
			}); //한자
			hanjaBasicInfo.append(hanjaBasicInfoRadical);
		}
		hanjaBasicInfo.appendTo('#word_info');

		//단어설명 보이기
		if (hanjaBasic[cPnt].hanjaWord.hanja != '') {
			$('<h2/>', {
				'class' : 'hanja_word_info',
				html : hanjaBasic[cPnt].hanjaWord.hanja
			}).append($('<small/>', {
				html : hanjaBasic[cPnt].hanjaWord.hangul
			})).appendTo('#word_info'); //단어한자+한글
			$('<ui/>', {
				'class' : 'hanja_word_desc',
				html : hanjaBasic[cPnt].hanjaWord.word_desc
			}).appendTo('#word_info'); //단어설명
		}
	}

	//지우기
	function fnInitArea() {
		$('#hanja_info').empty(); //한자뜻풀이영역 지우기
		$('#word_info').empty(); //한자기본정보+단어정보영역 지우기
	}

	//입력제한
	$(function() {
		$('#text_input').keyup(function() {
			limitCharacters('text_input', 500); //글자수제한 500자
		});
	});

	//입력부분 보이기
	function fnShowTextArea() {
		$('#input_area').css("display", "block");

		//$('#text_input').show();
		$('#inputStatus').css("display", "block");
		$('#outputStatus').css("display", "none");
		/*
		$('#hide_btn').show();
		$('#dic_btn').show();
		$('#show_btn').hide();
		$('#next_btn').hide();
		 */
	}

	//입력부분 숨기기
	function fnHideTextArea() {
		$('#input_area').css("display", "none");

		//$('#text_input').hide();

		$('#inputStatus').css("display", "none");
		$('#outputStatus').css("display", "block");

		/*

		$('#hide_btn').hide();
		$('#dic_btn').hide();
		$('#show_btn').show();
		$('#next_btn').show();
		 */

	}
</script>