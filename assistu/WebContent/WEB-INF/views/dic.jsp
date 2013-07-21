<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<mvc:layout>

	<div class="container">

		<!-- 입력상태에서 나오는 부분 -->
		<div class="row-fluid show-grid">

			<!-- 입력부분 -->
			<div id="input_area" class="span12">
				<textarea id="text_input" name="text_input" class="hanja_input">1. 여기에 한자 원문을 입력해주세요.
	
2. 키보드 화살표를 이용해서 좌우로 이동할 수 있습니다. 화살표버튼을 클릭하셔도 됩니다.</textarea>
			</div>
		</div>
		<div class="row-fluid">
			<!-- 버튼 -->
			<div class="span4 offset9 btn_area">
				<div id="outputStatus" class="span6">
					<a id="show_btn" class="btn " href="#" onClick="fnShowTextArea();">보기</a>
					<a id="previous_btn" class="btn btn-info" href="#"
						onClick="fnDrawWord(cPnt-1);">◀</a> <a id="next_btn"
						class="btn btn-info" href="#" onClick="fnDrawWord(cPnt+1);">▶</a>
					<!-- 
						<span id="next_btn"
						class='arrow-primary arrow_btn' rel='90' style="cursor: pointer;"
						onclick=""></span>
						 -->
				</div>
				<div id="inputStatus" class="span6">
					<a id="hide_btn" class="btn " href="#" onClick="fnHideTextArea();">숨김</a>
					<a id="dic_btn" class="btn  btn-success " href="#"
						onClick="fnMain();">실행</a>
				</div>
			</div>

		</div>

		<!-- 검색내용 출력부분 -->
		<div class="row-fluid show-grid">

			<!-- 출력부분 -->
			<div id="text_area" class="span12 text_area"></div>

			<!-- 프로그레스바 -->
			<div id="ajax_load_indicator" class="text-center">
				<img src='/resources/img/processing.gif' />
			</div>

		</div>

		<!-- 한자/단어정보 출력부분 -->
		<div class="row-fluid show-grid">
			<!-- 한자/단어정보 -->
			<div id="info_area" class="span12">
				<div id="word_info" class="span6 word_info"></div>
				<div id="hanja_info" class="span6 hanja_info"></div>
			</div>
		</div>

	</div>
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
					if(obj.hanja=='\n'){
					$('<p/>', {
						'id' : 'hanja_' + obj.idx
					}).appendTo('#text_area');
					}else{
					$('<span/>', {
						'id' : 'hanja_' + obj.idx,
						'class' : 'hanja',
						html : obj.hanja
					}).appendTo('#text_area');
					}
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