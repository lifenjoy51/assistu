<%@ tag language="java" pageEncoding="UTF-8"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang='ko'>
<head>
<meta charset='utf-8'>
<title>Assistu</title>
<meta name='viewport' content='width=device-width, initial-scale=1.0'>
<meta name='description' content='dictionary for cau historian'>
<meta name='author' content='lifenjoy51'>

<!-- Le styles -->
<link href='/resources/css/assistu.css' rel='stylesheet'>
<link href='/resources/css/bootstrap.css' rel='stylesheet'>
<link href='/resources/css/bootstrap-arrows.css' rel='stylesheet'>
<link href='/resources/css/bootstrap-responsive.css' rel='stylesheet'>
<link href='/resources/css/bootstrap-responsive.css' rel='stylesheet'>

<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
      <script src='/resources/js/html5.js'></script>
    <![endif]-->
</head>

<body>

	<div class='navbar navbar-inverse navbar-fixed-top'>
		<div class='navbar-inner'>
			<div class='container'>
				<a class='btn btn-navbar' data-toggle='collapse'
					data-target='.nav-collapse'> <span class='icon-bar'></span> <span
					class='icon-bar'></span> <span class='icon-bar'></span>
				</a> <a class='brand' href='/home.do'><i
					class="icon-home icon-white"></i> 한자사전</a>

				<div class='nav-collapse'>
					<ul class='nav'>
						<li class='active'><a href='http://lifenjoys.cafe24.com/'>답사정보</a></li>
						<li class='active'><a href='#'
							onclick="window.open('/text.do')">2013-1 한사강자료</a></li>
						<li class='active'><a href='#'
							onclick="window.open('/cau.do')">흑석동 메뉴고르기</a></li>
						<li class='active'><a href='#'
							onclick="window.open('/timer.do')">CEDA 타이머</a></li>
						<li class='active'><a href='/forum.do'>낙서장</a></li>
						<!-- <li class='active'><a href='/dic'>사전</a></li> -->

					</ul>
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</div>

	<div class='container'>

		<jsp:doBody />

		<hr>
		<footer style="text-align: center;">
			<p>lifenjoy51</p>
		</footer>

	</div>

	<!-- Le javascript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src='/resources/js/jquery.js'></script>
	<script src='/resources/js/bootstrap-transition.js'></script>
	<script src='/resources/js/bootstrap-alert.js'></script>
	<script src='/resources/js/bootstrap-modal.js'></script>
	<script src='/resources/js/bootstrap-dropdown.js'></script>
	<script src='/resources/js/bootstrap-scrollspy.js'></script>
	<script src='/resources/js/bootstrap-tab.js'></script>
	<script src='/resources/js/bootstrap-tooltip.js'></script>
	<script src='/resources/js/bootstrap-popover.js'></script>
	<script src='/resources/js/bootstrap-button.js'></script>
	<script src='/resources/js/bootstrap-collapse.js'></script>
	<script src='/resources/js/bootstrap-carousel.js'></script>
	<script src='/resources/js/bootstrap-typeahead.js'></script>
	<script src='/resources/js/bootstrap-arrows.js'></script>
	<script src='/resources/js/common.js'></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('.arrow, [class^=arrow-]').bootstrapArrows(); //bootstrap-arrow 초기화
		});
	</script>
</body>
</html>