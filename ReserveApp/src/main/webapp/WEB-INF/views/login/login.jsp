<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Login</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	
		<link rel="icon" href="/static/assets/img/icon.ico" type="image/x-icon"/>
	
		<script src="/static/assets/js/plugin/webfont/webfont.min.js"></script>
		<script>
			WebFont.load({
				google: {"families":["Open+Sans:300,400,600,700"]},
				custom: {"families":["Flaticon", "Font Awesome 5 Solid", "Font Awesome 5 Regular", "Font Awesome 5 Brands"], urls: ['/static/assets/css/fonts.css']},
				active: function() {
					sessionStorage.fonts = true;
				}
			});
		</script>
		
		<!-- CSS Files -->
		<link rel="stylesheet" href="/static/assets/css/bootstrap.min.css">
		<link rel="stylesheet" href="/static/assets/css/azzara.min.css">
		<link rel="stylesheet" href="/static/common/css/common.css" />
		<link rel="stylesheet" href="/static/common/css/tui/tui-date-picker.css" />
	</head>
	<body class="login">
		<div class="wrapper wrapper-login">
			<div class="container container-login animated fadeIn">
				<h3 class="text-center">로그인</h3>
					<form class="login-form" method="post" name="f" action="loginProc">
						<div class="form-group form-floating-label">
							<input id="id" name="id" type="text" class="form-control input-border-bottom" required>
							<label for="id" class="placeholder">ID</label>
						</div>
						<div class="form-group form-floating-label">
							<input id="password" name="password" type="password" class="form-control input-border-bottom" required>
							<label for="password" class="placeholder">Password</label>
							<div class="show-password">
								<i class="flaticon-interface"></i>
							</div>
						</div>
						<div class="row form-sub m-0">
							<div class="custom-control custom-checkbox" tabindex="0" data-toggle="tooltip" data-placement="bottom" title="30일간 유지됩니다.">
								<input type="checkbox" class="custom-control-input" id="rememberme" name="rememberme">
								<label class="custom-control-label" for="rememberme">로그인 유지하기</label>
							</div>
							
							<span class="link float-right" id="forgotPwdSpan" style="color:blue;cursor:pointer;">Forget Password ?</span>
						</div>
						<div id="forgotPwdDiv" style="display:none;">
							<span class="float-right" style="color:red;">관리자에게 문의 바랍니다.</span>
						</div>
						<div class="form-action mb-3">
							<button class="btn btn-secondary btn-rounded btn-login" type="submit">로그인</button>
						</div>
					</form>
					<div class="login-account">
						<a href="#" id="show-signup" class="link">회원 가입</a>
					</div>
			</div>
			
			<div class="container container-signup animated fadeIn">
				<h3 class="text-center">회원 가입</h3>
				<div class="signup-form">
					<div class="form-group form-floating-label row">
						<div class="form-group form-floating-label col-sm-8">
							<input id="id_signup" name="id_signup" type="text" class="form-control input-border-bottom" style="margin-left: 6px;" required>
							<label for="id_signup" class="placeholder" style="margin-left: 6px;">ID</label>
						</div>
						<div class="form-group form-floating-label col-sm-4 d-flex align-items-center justify-content-center">
							<button id="btn_checkId_signup" type="button" class="btn btn-secondary btn-rounded btn-sm">중복 확인</button>
						</div>
					</div>
					
					<div class="row form-sub m-0" id="div_checkId_msg" style="padding:0px;">
						<span class="float-left" id="span_checkId_msg" style="color:red;margin-left:10px;margin-bottom: 5px;"></span>
					</div>
					
					<div class="form-group form-floating-label">
						<input id="pwd_signup" name="pwd_signup" type="password" class="form-control input-border-bottom" required>
						<label for="pwd_signup" class="placeholder">비밀번호</label>
						<div class="show-password">
							<i class="flaticon-interface"></i>
						</div>
					</div>
					
					<div class="row form-sub m-0" id="div_pwdLength_msg" style="padding:0px;">
						<span class="float-left" id="span_pwdLength_msg" style="color:red;margin-left:10px"></span>
					</div>
					
					<div class="form-group form-floating-label">
						<input id="checkPwd_signup" name="checkPwd_signup" type="password" class="form-control input-border-bottom" required>
						<label for="checkPwd_signup" class="placeholder">비밀번호 재입력</label>
						<div class="show-password">
							<i class="flaticon-interface"></i>
						</div>
					</div>
					<div class="row form-sub m-0" id="div_checkPwd_msg" style="padding:0px;">
						<span class="float-left" id="span_checkPwd_msg" style="color:red;margin-left:10px"></span>
					</div>
					<div class="form-group form-floating-label">
						<input  id="name_signup" name="name_signup" type="text" class="form-control input-border-bottom" required>
						<label for="name_signup" class="placeholder">이름</label>
					</div>
					<div class="form-group form-floating-label">
						<input  id="number_signup" name="number__signup" class="form-control input-border-bottom" type="text" required>
						<label for="number_signup" class="placeholder">전화번호</label>
					</div>
					<div class="form-group form-floating-label row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">출산 예정일</label>
						</div>
						<div class="col-sm-9">
							<div class="tui-datepicker-input tui-datetime-input">
								<input type="text" id="dueDate_signup" aria-label="Date-Time">
								<span class="tui-ico-date"></span>
							</div>
							<div id="wrapper_signup" style="margin-top: -1px;"></div>
						</div>
					</div>
					<div class="form-group form-floating-label">
						<input  id="joinCode_signup" name="joinCode_signup" type="text" class="form-control input-border-bottom" required>
						<label for="joinCode_signup" class="placeholder">Code</label>
					</div>
					<div class="form-action">
						<a href="#" id="btn_cancel_signup" class="btn btn-danger btn-rounded btn-login mr-3">취소</a>
						<a href="#" id="btn_signup" class="btn btn-primary btn-rounded btn-login">회원가입</a>
					</div>
				</div>
			</div>
		</div>
	</body>
			<script src="/static/assets/js/core/jquery.3.2.1.min.js"></script>
		<script src="/static/assets/js/plugin/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
		<script src="/static/assets/js/core/popper.min.js"></script>
		<script src="/static/assets/js/core/bootstrap.min.js"></script>
		<script src="/static/assets/js/ready.js"></script>
		<script src="/static/common/js/tui/tui-date-picker.js"></script>
		<script src="/static/common/js/common.js"></script>
		<script>
		let id_check = false;		// id 확인 여부
		let pwd_check = false;		// 확인용 비밀번호 확인 여부
		let name_check = false;		// 이름 확인 여부
		let number_check = false;	// 전화번호 확인 여부
		let code_check = false;		// 가입코드 확인 여부
		
		$(document).ready(function() {
			
			const urlSearchParams = new URLSearchParams(window.location.search); 
			const params = Object.fromEntries(urlSearchParams.entries());
		
			if (params.error === 'true' && params.exception === 'Invaild Username or Password') {
				alert('ID 또는 패스워드를 확인해주세요')
			}		
			$('#forgotPwdSpan').click(function() {
				$('#forgotPwdDiv').css('display','block');
			});
			
			//Datepicker 객체(출산 예정일)
			const signupDatepicker = new tui.DatePicker('#wrapper_signup', {
					language: 'ko',
					date: '',
					input: {
						element: '#dueDate_signup',
						format: 'yyyy-MM-dd'
					}
			});
			
			$('#div_checkId_msg').hide();
			$('#div_pwdLength_msg').hide();
			$('#div_checkPwd_msg').hide();
			
			// 아이디 중복 확인 Button(회원 가입)
			$('#btn_checkId_signup').click(function(){
				let id = $('#id_signup').val();
				
				if(id == '' || id == null) {// 값이 없는 경우
					alert('ID를 입력해주세요');
					return false;
				}
				
				//아이디 정규식
				// 정규식을 사용하여 영어와 숫자로만 구성되고 최소 4자 이상인지 확인
				let idPattern = /^[A-Za-z0-9]{4,}$/;
				if(!idPattern.test(id)){
					$('#span_checkId_msg').text('영어 또는 숫자로 구성된 4자리 이상의 단어여야 합니다.');
					$('#div_checkId_msg').show();
					return false;
				} else {
					let param = {	id : $('#id_signup').val()	};
					checkId(param);
				}
			});
			
			$('#pwd_signup').blur(function(){
				let pwd = $('#pwd_signup').val().trim();
				let pwdPattern = /^.{8,}$/;
				
				if(!pwdPattern.test(pwd)){
					$('#span_pwdLength_msg').text('비밀번호는 공백을 제외하고 8자 이상입니다.');
					$('#div_pwdLength_msg').show();
				} else {
					$('#div_pwdLength_msg').css('display','none');
	// 				$('#checkPwd_signup').focus();
				}
			})
			
			$('#checkPwd_signup').blur(function(){
				let pwd = $('#pwd_signup').val().trim();
				let checkPwd = $('#checkPwd_signup').val().trim();
				
				if(checkPwd == '') {
					$('#span_checkPwd_msg').text('비밀번호를 입력해주세요.');
					$('#div_checkPwd_msg').show();
					return false;
				}
				
				if(pwd != checkPwd){
					$('#span_checkPwd_msg').text('동일한 비밀번호를 입력해주세요.');
					$('#div_checkPwd_msg').show();
					return false;
				} else {
					$('#pwd_signup').attr('disabled', true);
					$('#checkPwd_signup').attr('disabled', true);
					$('#div_checkPwd_msg').css('display', 'none');
					pwd_check = true;
				}
			})
			
			// 회원가입 Button
			$('#btn_signup').click(function(){
				console.log('id_check: ',id_check)
				console.log('pwd_check: ',pwd_check)
				//2~3자리 - 3~4자리 - 4자리
				let telPattern = /([0-9]{1}[0-9]{1})-(\d{3,4})-(\d{4})/;
				
				if(!id_check) {
					alert('아이디 중복 확인을 해주세요.');
					return false;
				} else if(!pwd_check) {
					alert('비밀번호를 입력해주세요.');
					return false;
				} else if($('#name_signup').val() == ''){
					alert('이름을 입력해주세요.');
					$('#name_signup').focus();
					return false;
				} else if($('#number_signup').val() == ''){
					alert('전화번호를 입력해주세요.');
					$('#number_signup').focus();
					return false;
				} else if(!telPattern.test($('#number_signup').val().trim())){
					alert('전화번호를 올바르게 입력해주세요.\n(예시:010-1234-5678 또는 02-1234-5678)');
					$('#number_signup').focus();
					return false;
				} else if($('#dueDate_signup').val() == ''){
					alert('출산 예정일을 입력해주세요.');
					$('#dueDate_signup').focus();
					return false;
				} else if($('#joinCode_signup').val() == '') {
					alert('가입 코드를 입력해주세요');
					$('#joinCode_signup').focus();
					return false;
				} else {
					
				}
				
				let param = {
					id			: $('#id_signup').val(),		// id
					password	: $('#pwd_signup').val(),		// 비밀번호
					name 		: $('#name_signup').val(),		// 이름
					phone_number: $('#number_signup').val(),	// 전화번호
					due_date	: signupDatepicker.getDate(),	// 출산 예정일
					join_code	: $('#joinCode_signup').val(),	// 가입 코드
				}
					
				signup(param);	//DB에 가입 정보 추가
			})
			
			//취소 Button
			$('#btn_cancel_signup').click(function(){
				location.reload();
			});
		});//$(document).ready
			
		// Ajax
		// 아이디 중복 확인
		function checkId(param) {
			//$('#div_checkId_msg').hide();
			$.doPost({
				url	 	: "/join/checkId",
				data 	: param,
				success	: function(result) {
					if(result.msg == "fail") {// 아이디 중복일 경우
						$('#span_checkId_msg').text('입력하신 아이디는 이미 사용중입니다.');
						$('#div_checkId_msg').show();
					} else if(result.msg == "success"){
						$('#span_checkId_msg').text('사용 가능한 아이디 입니다.');
						$('#span_checkId_msg').css('color',"blue");
						$('#div_checkId_msg').show();
						$('#id_signup').attr('disabled', true);
						// $("#pwd_signup").focus();
						id_check = true;	// 아이디 중복확인(완)
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.(아이디 중복)');
				}
			});
		}
		
		// 회원가입
		function signup(param){
			$.doPost({
				url	 	: "/join/signup",
				data 	: param,
				success	: function(result) {
					if(result.msg == "success") {
						alert('등록되었습니다.');
						location.reload();
					} else if(result.msg == "notFoundCode") {
						alert('가입 코드를 확인해주세요.');
						$('#joinCode_signup').val('');
						$('#joinCode_signup').focus();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
		</script>
</html>

