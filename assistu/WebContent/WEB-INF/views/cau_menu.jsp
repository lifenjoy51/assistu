<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Bootstrap -->
<link href='/resources/css/bootstrap.min.css'
	rel='stylesheet'>
<link
	href='/resources/css/bootstrap-responsive.css'
	rel='stylesheet'>

</head>
<body>
	<div class="container">

		<div class="row-fluid show-grid">
			<div class="span12 text-center">
				<H1>흑석동에서 밥 고르는 방법!</H1>
			</div>
		</div>
		<div class="row-fluid show-grid  text-center">
			<div class="span12 ">
				<img id="img_url" src="" class="img-polaroid">
			</div>
			<div class="row-fluid show-grid">
				<div class="span12"></div>
			</div>
			<div class="row-fluid show-grid">
				<div class="span6 offset3">
					<h1 id="comment"></h1>
					<div class="row-fluid show-grid">
						<div class="span12"></div>
					</div>
					<div class="row-fluid show-grid">
						<div class="span6">
							<a class="btn btn-large btn-primary" href="#"
								onclick="fnDoYes();">Yes!</a>
						</div>
						<div class="span6">
							<a class="btn btn-large" href="#" onclick="fnDoNo();">No..</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

<script src="http://code.jquery.com/jquery.js"></script>
<script src='/resources/js/bootstrap.min.js'></script>
<script type="text/javascript">
	//현재 선택중인 아이템 초기값 0
	var curPtr = 0;
	var todaysChoice;

	var data = [ {
		CD : 'S0',
		COMMENT : '배가고프다',
		YES : 'Q0',
		NO : 'M0',
		URL : '/resources/img/cau/S0.jpg'
	}, {
		CD : 'Q0',
		COMMENT : '건강한게 땡긴다!',
		YES : 'R0',
		NO : 'Q1',
		URL : '/resources/img/cau/Q0.jpg'
	}, {
		CD : 'R0',
		COMMENT : '라이트업',
		YES : 'EN',
		NO : 'R1',
		URL : '/resources/img/cau/R0.jpg'
	}, {
		CD : 'R1',
		COMMENT : '베트남 쌀국수',
		YES : 'EN',
		NO : 'R2',
		URL : '/resources/img/cau/R1.jpg'
	}, {
		CD : 'R2',
		COMMENT : '유가네',
		YES : 'EN',
		NO : 'R3',
		URL : '/resources/img/cau/R2.jpg'
	}, {
		CD : 'R3',
		COMMENT : '워싱턴 샌드위치',
		YES : 'EN',
		NO : 'R4',
		URL : '/resources/img/cau/R3.jpg'
	}, {
		CD : 'R4',
		COMMENT : '핫바&만두',
		YES : 'EN',
		NO : 'R5',
		URL : '/resources/img/cau/R4.jpg'
	}, {
		CD : 'R5',
		COMMENT : '월남쌈',
		YES : 'EN',
		NO : 'R6',
		URL : '/resources/img/cau/R5.jpg'
	}, {
		CD : 'R6',
		COMMENT : '키친 오브 블랙덕',
		YES : 'EN',
		NO : 'R7',
		URL : '/resources/img/cau/R6.jpg'
	}, {
		CD : 'R7',
		COMMENT : '모모치',
		YES : 'EN',
		NO : 'R8',
		URL : '/resources/img/cau/R7.jpg'
	}, {
		CD : 'R8',
		COMMENT : '타피오카 팩토리',
		YES : 'EN',
		NO : 'S1',
		URL : '/resources/img/cau/R8.jpg'
	}, {
		CD : 'M0',
		COMMENT : '거짓말 하지마!',
		YES : 'S0',
		NO : 'S0',
		URL : '/resources/img/cau/M0.jpg'
	}, {
		CD : 'Q1',
		COMMENT : '기름진게 땡긴다',
		YES : 'R9',
		NO : 'Q2',
		URL : '/resources/img/cau/Q1.jpg'
	}, {
		CD : 'R9',
		COMMENT : '엉터리',
		YES : 'EN',
		NO : 'R2',
		URL : '/resources/img/cau/R9.jpg'
	}, {
		CD : 'Q2',
		COMMENT : '밀가루가 땡긴다',
		YES : 'R10',
		NO : 'Q3',
		URL : '/resources/img/cau/Q2.jpg'
	}, {
		CD : 'R10',
		COMMENT : '홍콩반점',
		YES : 'EN',
		NO : 'R3',
		URL : '/resources/img/cau/R10.jpg'
	}, {
		CD : 'Q3',
		COMMENT : '대충 먹고싶다',
		YES : 'R11',
		NO : 'Q4',
		URL : '/resources/img/cau/Q3.jpg'
	}, {
		CD : 'R11',
		COMMENT : '간짬뽕',
		YES : 'EN',
		NO : 'R4',
		URL : '/resources/img/cau/R11.jpg'
	}, {
		CD : 'Q4',
		COMMENT : '완전 차려먹고싶다!',
		YES : 'R12',
		NO : 'Q5',
		URL : '/resources/img/cau/Q4.jpg'
	}, {
		CD : 'R12',
		COMMENT : 'C.C',
		YES : 'EN',
		NO : 'R5',
		URL : '/resources/img/cau/R12.jpg'
	}, {
		CD : 'Q5',
		COMMENT : '느끼한게 먹고싶다',
		YES : 'R13',
		NO : 'Q6',
		URL : '/resources/img/cau/Q5.jpg'
	}, {
		CD : 'R13',
		COMMENT : '미스터 피자',
		YES : 'EN',
		NO : 'R6',
		URL : '/resources/img/cau/R13.jpg'
	}, {
		CD : 'Q6',
		COMMENT : '밥이 땡긴다',
		YES : 'R14',
		NO : 'S1',
		URL : '/resources/img/cau/Q6.jpg'
	}, {
		CD : 'R14',
		COMMENT : '미사랑',
		YES : 'EN',
		NO : 'R7',
		URL : '/resources/img/cau/R14.jpg'
	}, {
		CD : 'S1',
		COMMENT : '배가 부르다',
		YES : 'R15',
		NO : 'S0',
		URL : '/resources/img/cau/S1.jpg'
	}, {
		CD : 'R15',
		COMMENT : '맥도날드',
		YES : 'EN',
		NO : 'R8',
		URL : '/resources/img/cau/R15.jpg'
	}, {
		CD : 'Q7',
		COMMENT : '만족스럽나요?^^',
		YES : 'M1',
		NO : 'M2',
		URL : '/resources/img/cau/Q7.jpg'
	}, {
		CD : 'M1',
		COMMENT : '♥',
		YES : 'S0',
		NO : 'S0',
		URL : '/resources/img/cau/M1.jpg'
	}, {
		CD : 'M2',
		COMMENT : '다시해라',
		YES : 'S0',
		NO : 'S0',
		URL : '/resources/img/cau/M2.jpg'
	} ];

	var fnDraw = function(cd) {
		fnSearch(cd);
		fnSetData();
	};
	var fnComplete = function() {
		//음식점 선택완료
		alert('오늘의 메뉴는 ' + data[curPtr].COMMENT + "!");
		todaysChoice = data[curPtr].CD;
		//하드코딩 Q7=만족도설문
		fnDraw('Q7');
	};
	var fnSearch = function(cd) {
		if (cd == 'EN') {
			fnComplete();
			return;
		}

		for (x in data) {
			if (data[x].CD == cd) {
				curPtr = x;
				console.log('current pointer is ' + curPtr + '=' + x);
			}
		}
	};
	var fnDoYes = function() {
		fnDraw(data[curPtr].YES);
	};

	var fnDoNo = function() {
		fnDraw(data[curPtr].NO);
	};

	var fnSetData = function() {
		var comment = data[curPtr].COMMENT;
		var url = data[curPtr].URL.replace('/lg', '');
		$('#comment').text(comment);
		$('#img_url').attr('src', url);
	}

	$(document).ready(function() {
		fnSetData();
	});
</script>
</html>