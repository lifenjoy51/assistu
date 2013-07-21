<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>CEDA Timer</title>
</head>
<style type="text/css">
body {
	font-size: 62.5%;
} /* Set the size of 1em to 10px in all browsers */
font.mTimer {
	font-size: 4000%;
	-webkit-text-size-adjust: auto;
}

body.extraWide {
	font-size: 85%;
}

body.wide {
	font-size: 75%;
}

body.narrow {
	font-size: 50%;
}

body.extraNarrow {
	font-size: 40%;
}
</style>

<script>
	var rows = 30; //최대 저장가능 계획의 수
	var planList = new Array(rows, 2); //컬럼은 캡션, 시간 두개를 사용한다.
	var jobs = new Array(); //실행내역 저장을 위한 스택
	var jobsPtr = 0; //실행내역 포인터
	var remainTime = 0; //남은시간 (분단위)
	var discussTime = [ 1, 1 ]; //위치0이 1번째팀, 위치1이 2번재팀. 1이면 시간 있는거 0이면 없는거.

	var timerLoop; //타이머 출력을 위한 루프변수
	var orgTm = 0; //시작시간 저장을 위한 변수
	var tm = 0; //수행시간을 담은 변수

	var cnt = 0; //플랜 저장을 위한 포인터
	var planPtr = 0; //플랜을 가져오기 위한 포인터

	var blink; //깜박이 변수

	/*
	 *	수행할 시간 받아오기
	 */
	function fnGetTime(pPtr) {
		//console.log('function fnGetTime');

		var min = planList[pPtr][1];
		//tm = fnGetTotalTimeBySec(min);	//테스트버젼은 초 단위로 한다.
		tm = fnGetTotalTimeByMin(min); //실제 구동 버젼
		return min;
	}

	/*
	 *	남은시간 보이기
	 */
	function fnSetTotalTime() {
		var totalTimeObj = document.getElementById('total_time');
		var pTotalTime = remainTime;
		if (discussTime[0] == 1) {
			pTotalTime += 4;
		}
		if (discussTime[1] == 1) {
			pTotalTime += 4;
		}
		totalTimeObj.innerText = pTotalTime + ' 분 남았습니다.';
	}

	/*
	 *	실행내역 저장
	 */
	function fnSetJobs(pType, pPtr) {
		var job = new Array(pType, pPtr);
		jobs.push(job);
		jobsPtr++;
	}

	function fnUndo() {
		jobsPtr--;
		var pType = jobs[jobsPtr][0];
		var pPtr = jobs[jobsPtr][1];

		if (pType == 'timer') {
			planPtr--; //플랜 포인터 감소
			var tempMin = fnGetTime(planPtr);
			//console.log('temp min : ' + tempMin);
			remainTime += (+tempMin); //전체 시간에서 더함
			//console.log('remainTime : ' + remainTime);
		} else {
			if (pType == 'dTime1') {
				discussTime[0] = 1;
			} else if (pType == 'dTime2') {
				discussTime[1] = 1;
			} else {
			}
		}

		fnSetCaption(planList[planPtr][0]); //캡션넣기 - 어떤 행동을 하든 같은 메세지 출력(이전 포인터);

		//시간 넣기 (처음)
		var tMin = planList[planPtr][1]; //플랜 시간(분 단위)
		//console.log('minutes : ' + tMin);
		var tTm = fnGetTotalTimeByMin(tMin);
		var tSec = fnGetSecFromTime(tTm);
		var tMsec = fnGetMsecFromTime(tTm);

		fnDrawTimer(tMin, tSec, tMsec);

		//남은시간 보이기
		fnSetTotalTime();

	}

	/*
	 *	타이머 실행
	 */
	function fnTimer(pType) {
		//깜박이 중지
		clearInterval(blink);
		var timerObj = document.getElementById('mTimer');
		timerObj.style.visibility = '';

		if (pType == 'dTime1') {
			if (!discussTime[0]) {
				alert('당신의 팀은 이미 협의시간을 사용했습니다!');
				return;
			}
		} else if (pType == 'dTime2') {
			if (!discussTime[1]) {
				('당신의 팀은 이미 협의시간을 사용했습니다!');
				return;
			}
		}

		if (!confirm('타이머를 사용 하시겠습니까?')) {
			return;
		}
		//console.log('function fnTimer');

		//작동버튼 비활성화
		document.getElementById('use_btn').disabled = true;
		document.getElementById('d1_btn').disabled = true;
		document.getElementById('d2_btn').disabled = true;
		document.getElementById('undo_btn').disabled = true;
		document.getElementById('list_btn').disabled = true;

		if (pType == 'timer') {
			var tempMin = fnGetTime(planPtr);
			remainTime -= tempMin; //전체 시간에서 빼줌
			fnSetJobs('timer', planPtr); //작업내역 저장
			fnSetCaption(planList[planPtr][0]); //캡션넣기
			planPtr++; //플랜 포인터 증가
		} else {
			tm = 4 * 60 * 1000; //작전타임 4분	
			//tm = 4 * 1000;//테스트버젼은 초 단위로 한다.

			if (pType == 'dTime1') {
				fnSetJobs('dTime1', 0);
				fnSetCaption('Team1 is using Discuss Time');
				discussTime[0] = 0;
			} else if (pType == 'dTime2') {
				fnSetJobs('dTime2', 0);
				fnSetCaption('Team2 is using Discuss Time');
				discussTime[1] = 0;
			} else {
			}
		}

		var orgDt = new Date();
		var orgMin = orgDt.getMinutes();
		var orgSec = orgDt.getSeconds();
		var orgMsec = orgDt.getMilliseconds();
		orgTm = orgMsec + (orgSec * 1000) + (orgMin * 60 * 1000);

		setTimer();
		//myTimer();
	}

	function setTimer() {
		timerLoop = setInterval(function() {
			myTimer();
		}, 1);
	}

	/*
	 *	타이머 1분 안남았을때
	 */
	function fnCountDownTask() {
	}

	/*
	 *	타이머 종료시 작업
	 */
	function fnFinishTask() {
		//작동버튼 활성화
		document.getElementById('use_btn').disabled = false;
		document.getElementById('d1_btn').disabled = false;
		document.getElementById('d2_btn').disabled = false;
		document.getElementById('undo_btn').disabled = false;
		document.getElementById('list_btn').disabled = false;

		//남은시간 보이기
		fnSetTotalTime();

		//시간 넣기 (처음)
		var tMin = planList[planPtr][1]; //플랜 시간(분 단위)
		//console.log('minutes : ' + tMin);
		var tTm = fnGetTotalTimeByMin(tMin);
		var tSec = fnGetSecFromTime(tTm);
		var tMsec = fnGetMsecFromTime(tTm);

		fnDrawTimer(tMin, tSec, tMsec);

		//캡션 넣기
		fnSetCaption(planList[planPtr][0]);

		//깜박이기
		startBlink();

		//소리재생
		playSnd();

		var timerObj = document.getElementById('mTimer');
		timerObj.setAttribute('color', 'white');
	}

	/*
	 *	시간 계산
	 */
	function myTimer(callback) {
		//console.log('function myTimer');
		if (typeof callback == "function") {
			callback();
		}

		var curDt = new Date();
		var curMin = curDt.getMinutes();
		var curSec = curDt.getSeconds();
		var curMsec = curDt.getMilliseconds();
		var curTm = curMsec + (curSec * 1000) + (curMin * 60 * 1000);

		var pTm = tm - (curTm - orgTm);

		var pMin = parseInt(pTm / (1000 * 60)) % 60;
		var pSec = parseInt(pTm / 1000) % 60;
		var pMsec = pTm % 1000;

		if ((+pTm) < 60000) {
			fnDrawTimerMin(pMin, pSec, pMsec);
		} else {
			fnDrawTimer(pMin, pSec, pMsec);
		}

		if ((+pTm) < 1) {
			clearInterval(timerLoop);
			fnDrawTimer(0, 0, 0);
			fnFinishTask();
			return;
		}

	}

	/*
	 *	시간 출력
	 *  웹페이지에 시간을 출력한다.
	 */
	function fnDrawTimer(pMin, pSec, pMsec) {
		//console.log('function fnDrawTimer');
		var timerObj = document.getElementById('mTimer');
		timerObj.innerText = lpad(pMin, 2) + ':' + lpad(pSec, 2);
	}

	function fnDrawTimerMin(pMin, pSec, pMsec) {
		//console.log('function fnDrawTimerMin');

		var timerObj = document.getElementById('mTimer');
		timerObj.style.fontSize = "3500%";

		timerObj.setAttribute('color', 'red');
		timerObj.innerText = lpad(pMin, 2) + ':' + lpad(pSec, 2) + ':'
				+ lpad(pMsec, 3).substring(0, 2);
	}

	/*
	 *	왼쪽 패딩
	 */
	function lpad(value, padding) {
		var zeroes = "0";

		for ( var i = 0; i < padding; i++) {
			zeroes += "0";
		}

		return (zeroes + value).slice(padding * -1);
	}

	/*
	 *	플랜 추가
	 */
	function fnAdd() {
		//console.log('add cnt' + cnt);

		if (cnt == rows) {
			return; //최대로우 이상 입력 안되게 처리
		}

		var obj = document.getElementById('plan_list');

		var spanObj = document.createElement('span');
		spanObj.id = 'span' + cnt;

		var inObj1 = document.createElement('input');
		inObj1.setAttribute('id', 'caption_' + cnt);
		inObj1.setAttribute('style', 'width:400px');
		inObj1.type = 'text';
		spanObj.appendChild(inObj1);

		//console.log(inObj1.id);

		var inObj2 = document.createElement('input');
		inObj2.setAttribute('id', 'time_' + cnt);
		inObj2.setAttribute('style', 'width:20px');
		inObj2.type = 'text';
		spanObj.appendChild(inObj2);

		var textObj = document.createElement('span');
		//textObj.innerText = 'span'+cnt;
		textObj.innerText = '분';
		spanObj.appendChild(textObj);

		var brObj = document.createElement('br');
		spanObj.appendChild(brObj);

		obj.appendChild(spanObj);

		cnt++; //마지막 추가작업이 끝났을때 이 포인터는 실제 저장된 배열의 다음칸을 가르키고 있다. 추후 작업에 유념.
	}

	/*
	 *	플랜 삭제
	 */
	function fnDel() {
		//console.log('del cnt' + cnt);

		if (cnt > 0) {
			cnt--;
		} else {
			return;
		}

		var obj = document.getElementById('plan_list');

		var delObj = document.getElementById('span' + (cnt));

		obj.removeChild(delObj);
	}

	/*
	 * 플랜 저장
	 */
	function fnSave() {
		for (i = 0; i < cnt; i++) {
			planList[i] = new Array(2);

			var capObj = document.getElementById('caption_' + (i));
			var timeObj = document.getElementById('time_' + (i));

			//console.log('cap-'+capObj);
			//console.log('time-'+timeObj);

			planList[i][0] = capObj.value; //캡션
			planList[i][1] = timeObj.value; //시간		

			//남은시간 계산
			remainTime += (+planList[i][1]); //분단위
			//console.log('remain time : ' + remainTime);

			//console.log(planList[i][0] + ',' + planList[i][1]);
		}

		alert(cnt + ' 개의 계획이 등록되었습니다.');

		fnShowTimer();
	}

	/*
	 * 초기화
	 */
	function fnInit() {

		//변수 초기화
		rows = 30; //최대 저장가능 계획의 수
		planList = new Array(rows, 2); //컬럼은 캡션, 시간 두개를 사용한다.
		jobs = new Array(); //실행내역 저장을 위한 스택
		jobsPtr = 0; //실행내역 포인터
		remainTime = 0; //남은시간 (분단위)
		discussTime = [ 1, 1 ]; //위치0이 1번째팀, 위치1이 2번재팀. 1이면 시간 있는거 0이면 없는거.

		timerLoop; //타이머 출력을 위한 루프변수
		orgTm = 0; //시작시간 저장을 위한 변수
		tm = 0; //수행시간을 담은 변수

		cnt = 0; //플랜 저장을 위한 포인터
		planPtr = 0; //플랜을 가져오기 위한 포인터

		var dataArray = [
				[ '긍정측 첫 번째 토론자의 입론 First Affirmative Constructive', 5 ],
				[
						'부정측 두 번째 토론자의 교차 조사 Cross Examination by the Second Negative Speaker',
						3 ],
				[ '부정측 첫 번째 토론자의 입론 First Negative Constructive ', 5 ],
				[
						'긍정측 첫 번째 토론자의 교차 조사 Cross Examination by the First Affirmative Speaker',
						3 ],
				[ '긍정측 두 번째 토론자의 입론 Second Affirmative Constructive', 5 ],
				[
						'부정측 첫 번째 토론자의 교차 조사 Cross Examination by the First Negative Speaker',
						3 ],
				[ '부정측 두 번째 토론자의 입론 Second Negative Constructive', 5 ],
				[
						'긍정측 두 번째 토론자의 교차 조사 Cross Examination by the Second Affirmative Speaker',
						3 ], [ '부정측 첫 번째 토론자의 반박 First Negative Rebuttal', 3 ],
				[ '긍정측 첫 번째 토론자의 반박 First Affirmative Rebuttal', 3 ],
				[ '부정측 두 번째 토론자의 반박 Second Negative Rebuttal', 3 ],
				[ '긍정측 두 번째 토론자의 반박 Second Affirmative Rebuttal', 3 ] ];

		var dataLength = dataArray.length;

		//개수만큼 행 추가
		for (i = 0; i < dataLength; i++) {
			fnAdd();
		}

		//배열에 있는 데이터 집어넣기
		for (i = 0; i < dataLength; i++) {
			var capObj = document.getElementById('caption_' + (i));
			var timeObj = document.getElementById('time_' + (i));

			capObj.value = dataArray[i][0];
			timeObj.value = dataArray[i][1];
		}
	}

	/*
	 * 플랜 설정 화면 보이기
	 */
	function fnShowPlan() {
		var planObj = document.getElementById('plan_area');
		planObj.style.display = 'block';

		var timerObj = document.getElementById('timer_area');
		timerObj.style.display = 'none';

		var obj = document.getElementById('plan_list');
		obj.innerHTML = ''; //리스트 초기화

		fnInit();
	}

	/*
	 * 타이머 보이기
	 */
	function fnShowTimer() {
		var planObj = document.getElementById('plan_area');
		planObj.style.display = 'none';

		var timerObj = document.getElementById('timer_area');
		timerObj.style.display = 'block';

		//시간 넣기 (처음)
		var tMin = planList[0][1]; //플랜 시간(분 단위)
		//console.log('minutes : ' + tMin);
		var tTm = fnGetTotalTimeByMin(tMin);
		var tSec = fnGetSecFromTime(tTm);
		var tMsec = fnGetMsecFromTime(tTm);

		fnDrawTimer(tMin, tSec, tMsec);

		//캡션 넣기
		fnSetCaption(planList[0][0]);

		//남은시간 보이기
		fnSetTotalTime();
	}

	function fnSetCaption(val) {
		var capObj = document.getElementById('plan_caption');
		capObj.value = val; //플랜 캡션
	}

	//변환함수들
	function fnGetTotalTimeByMin(pMin) {
		return pMin * 60 * 1000;
	}

	function fnGetTotalTimeBySec(pSec) {
		return pSec * 1000;
	}

	function fnGetTotalTimeByMsec(pMsec) {
		return pMsec;
	}

	function fnGetMinFromTime(pTm) {
		return parseInt(pTm / (1000 * 60)) % 60;
	}

	function fnGetSecFromTime(pTm) {
		return parseInt(pTm / 1000) % 60;
	}

	function fnGetMsecFromTime(pTm) {
		return pTm % 1000;
	}

	function doBlink() {
		var timerObj = document.getElementById('mTimer');
		timerObj.style.visibility = timerObj.style.visibility == "" ? "hidden"
				: "";
	}

	function startBlink() {
		blink = setInterval("doBlink()", 1000); // 깜박이는 속도 
	}

	function playSnd() {
		var audio = new Audio("http://vincent.hosting.paran.com/alarm.mp3"); // 음악 파일을 읽어 들인다. 
		audio.play(); // 재생은 audio 객체의 play() 메서드를 이용한다.
	}

	function fnCancel() {
		clearInterval(timerLoop);
		fnUndo();

		//작동버튼 활성화
		document.getElementById('use_btn').disabled = false;
		document.getElementById('d1_btn').disabled = false;
		document.getElementById('d2_btn').disabled = false;
		document.getElementById('undo_btn').disabled = false;
		document.getElementById('list_btn').disabled = false;

		var timerObj = document.getElementById('mTimer');
		timerObj.setAttribute('color', 'white');
	}
</script>

<body onLoad='javascript:fnInit();'>
	<div id='timer_area' style='display: none'>
		<div style='border: 1px solid c3c3c3; background-color: #000000;'
			align='center'>
			<font id='mTimer' class='mTimer' color='white'> </font>
		</div>

		<input id='plan_caption' type='text' style='width: 100%;' value=''
			readonly>

		<div style='border: 1px solid c3c3c3; background-color: #343434;'>
			<font id='total_time' color='white' size='4pt'> </font>
		</div>

		<input type='button' id='d1_btn' value='긍정측 협의시간'
			onClick='javascript:fnTimer("dTime1");'> <input type='button'
			id='d2_btn' value='부정측 협의시간' onClick='javascript:fnTimer("dTime2");'>
		<input type='button' id='use_btn' value='타이머 사용'
			onClick='javascript:fnTimer("timer");'> <input type='button'
			id='undo_btn' value='사용내역 되돌리기' onClick='javascript:fnUndo();'>
		<input type='button' id='cancel_btn' value='타이머 사용 취소'
			onClick='javascript:fnCancel();'> <input type='button'
			id='list_btn' value='토론순서 조정' onClick='javascript:fnShowPlan();'>
	</div>

	<div id='plan_area'>
		<input type='button' value='추가' onClick='javascript:fnAdd();'>
		<input type='button' value='삭제' onClick='javascript:fnDel();'>
		<br />
		<div id='plan_list'></div>
		<input type='button' value='저장하고 타이머 실행'
			onClick='javascript:fnSave();'>
	</div>
</body>
</html>